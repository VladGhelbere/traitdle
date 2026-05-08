import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/client';
import { soundService } from '../lib/soundService';
import { playerService } from '../lib/playerService';

interface TraitPair {
  puzzleId: string;
  answer: string;
  category: string;
  puzzleDate: string;
  traitA: { id: string; word: string; votes: number };
  traitB: { id: string; word: string; votes: number };
}

interface VotingPanelProps {
  puzzleId: string; // Current game's puzzle (for context, not used in voting)
  onVoteSubmitted: () => void;
}

export const VotingPanel: React.FC<VotingPanelProps> = ({
  puzzleId: _puzzleId, // Current game's puzzle (for context, not used in voting)
  onVoteSubmitted
}) => {
  const [traitPair, setTraitPair] = useState<TraitPair | null>(null);
  const [voted, setVoted] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    loadTraitPairForVoting();
  }, []);

  const loadTraitPairForVoting = async () => {
    setLoading(true);
    try {
      const playerId = playerService.getPlayerId();
      
      // Call the database function to get a random trait pair
      const { data, error } = await supabase
        .rpc('get_trait_pair_for_voting', { p_player_id: playerId });

      if (error) {
        console.error('Error loading trait pair:', error);
        setTraitPair(null);
        setLoading(false);
        return;
      }

      if (!data || data.length === 0 || !data[0].trait_a_id) {
        // No upcoming puzzles with candidate traits
        setTraitPair(null);
        setLoading(false);
        return;
      }

      const row = data[0];
      setTraitPair({
        puzzleId: row.puzzle_id,
        answer: row.answer,
        category: row.category,
        puzzleDate: row.puzzle_date,
        traitA: {
          id: row.trait_a_id,
          word: row.trait_a_word,
          votes: row.trait_a_votes
        },
        traitB: {
          id: row.trait_b_id,
          word: row.trait_b_word,
          votes: row.trait_b_votes
        }
      });
    } catch (error) {
      console.error('Failed to load trait pair:', error);
      setTraitPair(null);
    } finally {
      setLoading(false);
    }
  };

  const handleVote = async (winnerId: string, loserId: string) => {
    if (!traitPair) return;
    
    soundService.playClick();
    setSubmitting(true);
    setVoted(winnerId);
    
    try {
      const playerId = playerService.getPlayerId();
      
      await supabase.rpc('submit_trait_vote', {
        p_puzzle_id: traitPair.puzzleId,
        p_winner_trait_id: winnerId,
        p_loser_trait_id: loserId,
        p_player_id: playerId
      });
      
      setTimeout(onVoteSubmitted, 800);
    } catch (error) {
      console.error('Vote submission failed:', error);
      // Still proceed even if vote fails
      setTimeout(onVoteSubmitted, 500);
    } finally {
      setSubmitting(false);
    }
  };

  const handleSkip = () => {
    soundService.playClick();
    onVoteSubmitted();
  };

  const getCategoryLabel = (category: string): string => {
    switch (category) {
      case 'jobs': return 'job';
      case 'movies': return 'movie';
      case 'games': return 'game';
      default: return category;
    }
  };

  const formatDate = (dateStr: string): string => {
    const date = new Date(dateStr);
    const today = new Date();
    // Reset time parts for accurate day comparison
    today.setHours(0, 0, 0, 0);
    const puzzleDate = new Date(date);
    puzzleDate.setHours(0, 0, 0, 0);
    
    const diffDays = Math.ceil((puzzleDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
    
    if (diffDays === 1) return 'tomorrow';
    if (diffDays <= 7) return `in ${diffDays} days`;
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  if (loading) {
    return (
      <div className="w-full max-w-md mx-auto p-6 bg-white dark:bg-gray-800 rounded-lg shadow-lg text-center">
        <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!traitPair) {
    // No traits to vote on, skip voting
    setTimeout(onVoteSubmitted, 100);
    return null;
  }

  return (
    <div className="w-full max-w-md mx-auto p-4 sm:p-6 bg-white dark:bg-gray-800 rounded-lg shadow-lg">
      <h3 className="text-lg font-bold mb-2 text-center dark:text-white">
        Help shape a future puzzle!
      </h3>
      <p className="text-sm text-gray-500 dark:text-gray-400 text-center mb-2">
        Which trait better describes{' '}
        <span className="font-semibold text-blue-600 dark:text-blue-400">
          {traitPair.answer}
        </span>
        ?
      </p>
      <p className="text-xs text-gray-400 dark:text-gray-500 text-center mb-4">
        {getCategoryLabel(traitPair.category)} puzzle coming {formatDate(traitPair.puzzleDate)}
      </p>
      
      <div className="grid grid-cols-2 gap-3 sm:gap-4">
        <button
          onClick={() => handleVote(traitPair.traitA.id, traitPair.traitB.id)}
          disabled={submitting || voted !== null}
          className={`p-4 sm:p-6 rounded-lg font-semibold text-lg transition-all transform hover:scale-105 active:scale-95 ${
            voted === traitPair.traitA.id
              ? 'bg-blue-500 text-white ring-4 ring-blue-300'
              : voted === traitPair.traitB.id
              ? 'bg-gray-200 dark:bg-gray-700 text-gray-400 dark:text-gray-500 opacity-50'
              : 'bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 dark:text-white'
          }`}
        >
          {traitPair.traitA.word}
          {voted === traitPair.traitA.id && (
            <div className="mt-2">
              <svg className="w-6 h-6 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
            </div>
          )}
        </button>
        
        <button
          onClick={() => handleVote(traitPair.traitB.id, traitPair.traitA.id)}
          disabled={submitting || voted !== null}
          className={`p-4 sm:p-6 rounded-lg font-semibold text-lg transition-all transform hover:scale-105 active:scale-95 ${
            voted === traitPair.traitB.id
              ? 'bg-blue-500 text-white ring-4 ring-blue-300'
              : voted === traitPair.traitA.id
              ? 'bg-gray-200 dark:bg-gray-700 text-gray-400 dark:text-gray-500 opacity-50'
              : 'bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 dark:text-white'
          }`}
        >
          {traitPair.traitB.word}
          {voted === traitPair.traitB.id && (
            <div className="mt-2">
              <svg className="w-6 h-6 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
            </div>
          )}
        </button>
      </div>

      {voted && (
        <p className="text-center text-sm text-green-600 dark:text-green-400 mt-4 animate-fade-in">
          Thanks for voting! Your input shapes future puzzles 🙏
        </p>
      )}

      {!voted && (
        <button
          onClick={handleSkip}
          className="w-full mt-4 py-2 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 text-sm"
        >
          Skip →
        </button>
      )}
    </div>
  );
};
