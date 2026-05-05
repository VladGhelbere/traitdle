// Statistics service - stores game stats in localStorage

export interface GameStats {
  gamesPlayed: number;
  gamesWon: number;
  currentStreak: number;
  maxStreak: number;
  guessDistribution: number[]; // Index 0 = won with 0 incorrect, index 4 = won with 4 incorrect
  lastPlayedDate: string | null;
  lastCompletedCategories: string[]; // Categories completed today
}

const STATS_KEY = 'traitdle_stats';

const defaultStats: GameStats = {
  gamesPlayed: 0,
  gamesWon: 0,
  currentStreak: 0,
  maxStreak: 0,
  guessDistribution: [0, 0, 0, 0, 0],
  lastPlayedDate: null,
  lastCompletedCategories: []
};

export const statsService = {
  getStats(): GameStats {
    try {
      const stored = localStorage.getItem(STATS_KEY);
      if (!stored) return { ...defaultStats };
      
      const stats = JSON.parse(stored) as GameStats;
      
      // Reset daily categories if it's a new day
      const today = new Date().toISOString().split('T')[0];
      if (stats.lastPlayedDate !== today) {
        stats.lastCompletedCategories = [];
      }
      
      return stats;
    } catch {
      return { ...defaultStats };
    }
  },

  saveStats(stats: GameStats): void {
    localStorage.setItem(STATS_KEY, JSON.stringify(stats));
  },

  recordGame(won: boolean, incorrectCount: number, category: string): GameStats {
    const stats = this.getStats();
    const today = new Date().toISOString().split('T')[0];
    
    // Check if this category was already WON today (losses can retry)
    if (stats.lastPlayedDate === today && stats.lastCompletedCategories.includes(category)) {
      // Already won this category today, don't record again
      return stats;
    }
    
    stats.gamesPlayed++;
    
    if (won) {
      stats.gamesWon++;
      stats.guessDistribution[incorrectCount]++;
      
      // Update streak
      if (stats.lastPlayedDate === today || stats.lastPlayedDate === this.getYesterday()) {
        stats.currentStreak++;
      } else if (stats.lastPlayedDate !== today) {
        stats.currentStreak = 1;
      }
      
      stats.maxStreak = Math.max(stats.maxStreak, stats.currentStreak);
      
      // Only mark category as completed on WIN (prevents double-counting)
      if (!stats.lastCompletedCategories.includes(category)) {
        stats.lastCompletedCategories.push(category);
      }
    } else {
      // Lost - reset streak (but don't mark category as completed, allowing retry)
      stats.currentStreak = 0;
    }
    
    // Update last played date
    stats.lastPlayedDate = today;
    
    this.saveStats(stats);
    return stats;
  },

  getYesterday(): string {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    return yesterday.toISOString().split('T')[0];
  },

  getWinPercentage(stats: GameStats): number {
    if (stats.gamesPlayed === 0) return 0;
    return Math.round((stats.gamesWon / stats.gamesPlayed) * 100);
  },

  hasWonToday(category: string): boolean {
    // Returns true only if the player has WON this category today
    // (losses don't count - player can retry)
    const stats = this.getStats();
    const today = new Date().toISOString().split('T')[0];
    return stats.lastPlayedDate === today && stats.lastCompletedCategories.includes(category);
  },

  resetStats(): void {
    localStorage.removeItem(STATS_KEY);
  }
};
