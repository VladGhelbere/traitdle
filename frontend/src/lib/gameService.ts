import { supabase } from './client.js';
import { Puzzle, Category, GameMode, FeedbackType } from '../types.js';
import { playerService } from './playerService.js';

export const gameService = {
  async getDailyPuzzle(category: Category, _mode: GameMode): Promise<Puzzle> {
    const today = new Date().toISOString().split('T')[0];
    
    console.log('Loading puzzle for:', category, today);
    
    // First, try to load puzzle with existing traits
    const { data, error } = await supabase
      .from('puzzles')
      .select(`
        id,
        date,
        category,
        answer,
        traits (
          id,
          puzzle_id,
          slot_position,
          keyword,
          synonyms (
            id,
            trait_id,
            word
          )
        )
      `)
      .eq('category', category)
      .eq('date', today)
      .maybeSingle();

    if (error) {
      console.error('Supabase error:', error);
      throw new Error(`Failed to load puzzle: ${error.message}`);
    }
    
    if (!data) {
      throw new Error(`No puzzle found for ${category} on ${today}. Have you run the migrations in Supabase SQL Editor?`);
    }
    
    // If no traits exist, get top 5 from candidate_traits (voted traits)
    if (!data.traits || data.traits.length === 0) {
      console.log('No traits found, loading from candidate_traits...');
      
      const { data: candidateData, error: candidateError } = await supabase
        .from('candidate_traits')
        .select('id, word, vote_count')
        .eq('puzzle_id', data.id)
        .order('vote_count', { ascending: false })
        .order('created_at', { ascending: true })
        .limit(5);
      
      if (candidateError) {
        console.error('Error loading candidate traits:', candidateError);
      } else if (candidateData && candidateData.length > 0) {
        // Convert candidate_traits to traits format
        data.traits = candidateData.map((ct, index) => ({
          id: ct.id,
          puzzle_id: data.id,
          slot_position: index + 1,
          keyword: ct.word,
          synonyms: [] // No synonyms for voted traits
        }));
        console.log('Loaded traits from candidate_traits:', data.traits);
      }
    }
    
    console.log('Puzzle loaded:', data);
    return data;
  },

  validateGuess(puzzle: Puzzle, guess: string): { 
    feedback: FeedbackType; 
    slotPosition?: number;
    relatedSlot?: number;
  } {
    const guessLower = guess.toLowerCase().trim();
    
    if (!puzzle.traits) return { feedback: 'incorrect' };

    // First pass: check all keywords for exact matches
    for (const trait of puzzle.traits) {
      if (trait.keyword.toLowerCase() === guessLower) {
        return { 
          feedback: 'correct', 
          slotPosition: trait.slot_position 
        };
      }
    }

    // Second pass: only if no keyword matched, check synonyms
    for (const trait of puzzle.traits) {
      const synonyms = (trait as any).synonyms || [];
      for (const syn of synonyms) {
        if (syn.word.toLowerCase() === guessLower) {
          return { 
            feedback: 'partial',
            relatedSlot: trait.slot_position
          };
        }
      }
    }

    return { feedback: 'incorrect' };
  },

  async submitGameResult(puzzleId: string, result: {
    mode: GameMode;
    filledSlots: (string | null)[];
    incorrectCount: number;
    timeSpent: number;
    won: boolean;
  }) {
    const playerId = playerService.getPlayerId();
    
    const { data, error } = await supabase
      .from('game_results')
      .insert([
        {
          puzzle_id: puzzleId,
          player_id: playerId,
          mode: result.mode,
          guesses: JSON.stringify(result.filledSlots),
          time_spent: result.timeSpent,
          won: result.won,
          incorrect_count: result.incorrectCount,
          created_at: new Date().toISOString()
        }
      ])
      .select();

    if (error) throw error;
    return data[0];
  },

  async submitVote(puzzleId: string, wordA: string, wordB: string, chosen: string) {
    const { data, error } = await supabase
      .from('votes')
      .insert([
        {
          puzzle_id: puzzleId,
          word_a: wordA,
          word_b: wordB,
          chosen_word: chosen,
          created_at: new Date().toISOString()
        }
      ])
      .select();

    if (error) throw error;
    return data[0];
  },

  async getLeaderboard(puzzleId?: string, category?: Category, limit: number = 20) {
    const today = new Date().toISOString().split('T')[0];
    
    let query = supabase
      .from('game_results')
      .select(`
        id,
        player_id,
        mode,
        time_spent,
        incorrect_count,
        created_at,
        puzzle:puzzles!inner(id, date, category)
      `)
      .eq('won', true)
      .eq('puzzles.date', today)
      .order('incorrect_count', { ascending: true })
      .order('time_spent', { ascending: true })
      .limit(limit);

    if (puzzleId) {
      query = query.eq('puzzle_id', puzzleId);
    }
    
    if (category) {
      query = query.eq('puzzles.category', category);
    }

    const { data, error } = await query;

    if (error) {
      console.error('Leaderboard error:', error);
      return [];
    }

    return data || [];
  },

  async getDailyStats(category?: Category) {
    const today = new Date().toISOString().split('T')[0];
    
    let query = supabase
      .from('game_results')
      .select(`
        won,
        time_spent,
        incorrect_count,
        puzzle:puzzles!inner(date, category)
      `)
      .eq('puzzles.date', today);

    if (category) {
      query = query.eq('puzzles.category', category);
    }

    const { data, error } = await query;

    if (error) {
      console.error('Stats error:', error);
      return null;
    }

    if (!data || data.length === 0) {
      return {
        totalPlayers: 0,
        winRate: 0,
        averageTime: 0,
        averageIncorrect: 0
      };
    }

    const wins = data.filter(r => r.won);
    
    return {
      totalPlayers: data.length,
      winRate: Math.round((wins.length / data.length) * 100),
      averageTime: wins.length > 0 
        ? Math.round(wins.reduce((sum, r) => sum + r.time_spent, 0) / wins.length)
        : 0,
      averageIncorrect: wins.length > 0
        ? Number((wins.reduce((sum, r) => sum + r.incorrect_count, 0) / wins.length).toFixed(1))
        : 0
    };
  },

  async getDistributionStats(category?: Category) {
    const today = new Date().toISOString().split('T')[0];
    
    let query = supabase
      .from('game_results')
      .select(`
        won,
        time_spent,
        incorrect_count,
        puzzle:puzzles!inner(date, category)
      `)
      .eq('puzzles.date', today);

    if (category) {
      query = query.eq('puzzles.category', category);
    }

    const { data, error } = await query;

    if (error) {
      console.error('Distribution stats error:', error);
      return null;
    }

    if (!data || data.length === 0) {
      return {
        totalPlayers: 0,
        winRate: 0,
        averageTime: 0,
        averageIncorrect: 0,
        distribution: [0, 0, 0, 0, 0, 0] // 0-4 mistakes + lost
      };
    }

    const totalPlayers = data.length;
    const wins = data.filter(r => r.won);
    const losses = data.filter(r => !r.won);

    // Calculate distribution: index 0-4 = wins with that many mistakes, index 5 = losses
    const distribution = [0, 0, 0, 0, 0, 0];
    
    wins.forEach(r => {
      const mistakes = Math.min(r.incorrect_count, 4);
      distribution[mistakes]++;
    });
    
    distribution[5] = losses.length;

    // Convert to percentages
    const distributionPercentages = distribution.map(count => 
      Math.round((count / totalPlayers) * 100)
    );

    return {
      totalPlayers,
      winRate: Math.round((wins.length / totalPlayers) * 100),
      averageTime: wins.length > 0 
        ? Math.round(wins.reduce((sum, r) => sum + r.time_spent, 0) / wins.length)
        : 0,
      averageIncorrect: wins.length > 0
        ? Number((wins.reduce((sum, r) => sum + r.incorrect_count, 0) / wins.length).toFixed(1))
        : 0,
      distribution: distributionPercentages
    };
  },

  async getUserTodayResult(playerId: string, category?: Category) {
    const today = new Date().toISOString().split('T')[0];
    
    let query = supabase
      .from('game_results')
      .select(`
        won,
        incorrect_count,
        puzzle:puzzles!inner(date, category)
      `)
      .eq('puzzles.date', today)
      .eq('player_id', playerId);

    if (category) {
      query = query.eq('puzzles.category', category);
    }

    const { data, error } = await query.maybeSingle();

    if (error || !data) {
      return null;
    }

    return {
      won: data.won,
      incorrectCount: data.incorrect_count
    };
  }
};
