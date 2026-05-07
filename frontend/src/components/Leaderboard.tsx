import React, { useState, useEffect } from 'react';
import { gameService } from '../lib/gameService';
import { playerService } from '../lib/playerService';
import { Category } from '../types';

interface LeaderboardEntry {
  id: string;
  player_id: string;
  mode: string;
  time_spent: number;
  incorrect_count: number;
  created_at: string;
}

interface DailyStats {
  totalPlayers: number;
  winRate: number;
  averageTime: number;
  averageIncorrect: number;
}

interface LeaderboardProps {
  puzzleId?: string;
  category?: Category;
  isOpen: boolean;
  onClose: () => void;
}

export const Leaderboard: React.FC<LeaderboardProps> = ({ puzzleId, category, isOpen, onClose }) => {
  const [entries, setEntries] = useState<LeaderboardEntry[]>([]);
  const [dailyStats, setDailyStats] = useState<DailyStats | null>(null);
  const [loading, setLoading] = useState(true);
  const currentPlayerId = playerService.getPlayerId();

  useEffect(() => {
    if (isOpen) {
      loadLeaderboard();
    }
  }, [isOpen, puzzleId, category]);

  const loadLeaderboard = async () => {
    setLoading(true);
    try {
      // Load leaderboard entries
      const leaderboardData = await gameService.getLeaderboard(puzzleId, category, 20);
      setEntries(leaderboardData);

      // Load daily stats
      const stats = await gameService.getDailyStats(category);
      setDailyStats(stats);
    } catch (error) {
      console.error('Failed to load leaderboard:', error);
    } finally {
      setLoading(false);
    }
  };

  if (!isOpen) return null;

  const formatTime = (seconds: number): string => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return mins > 0 ? `${mins}m ${secs}s` : `${secs}s`;
  };

  const getCategoryEmoji = () => {
    switch (category) {
      case 'jobs': return '💼';
      case 'movies': return '🎬';
      case 'games': return '🎮';
      default: return '🎯';
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-md w-full p-6 relative max-h-[90vh] overflow-y-auto">
        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
        >
          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <h2 className="text-2xl font-bold mb-2 text-center dark:text-white">
          {getCategoryEmoji()} Leaderboard
        </h2>
        <p className="text-center text-gray-500 dark:text-gray-400 text-sm mb-4">
          Today's top players
        </p>

        {/* Daily stats */}
        {dailyStats && (
          <div className="grid grid-cols-4 gap-2 mb-6 p-3 bg-gray-100 dark:bg-gray-700 rounded-lg">
            <div className="text-center">
              <div className="text-lg font-bold dark:text-white">{dailyStats.totalPlayers}</div>
              <div className="text-xs text-gray-500 dark:text-gray-400">Players</div>
            </div>
            <div className="text-center">
              <div className="text-lg font-bold text-green-600 dark:text-green-400">{dailyStats.winRate}%</div>
              <div className="text-xs text-gray-500 dark:text-gray-400">Win Rate</div>
            </div>
            <div className="text-center">
              <div className="text-lg font-bold dark:text-white">{formatTime(dailyStats.averageTime)}</div>
              <div className="text-xs text-gray-500 dark:text-gray-400">Avg Time</div>
            </div>
            <div className="text-center">
              <div className="text-lg font-bold dark:text-white">{dailyStats.averageIncorrect}</div>
              <div className="text-xs text-gray-500 dark:text-gray-400">Avg Wrong</div>
            </div>
          </div>
        )}

        {/* Leaderboard list */}
        {loading ? (
          <div className="text-center py-8">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          </div>
        ) : entries.length === 0 ? (
          <div className="text-center py-8 text-gray-500 dark:text-gray-400">
            <p>No winners yet today!</p>
            <p className="text-sm mt-1">Be the first to complete the puzzle.</p>
          </div>
        ) : (
          <div className="space-y-2">
            {entries.map((entry, index) => {
              const isCurrentPlayer = entry.player_id === currentPlayerId;
              
              return (
                <div
                  key={entry.id}
                  className={`flex items-center gap-3 p-3 rounded-lg ${
                    isCurrentPlayer ? 'bg-blue-100 dark:bg-blue-900/40 ring-2 ring-blue-500' :
                    index === 0 ? 'bg-yellow-100 dark:bg-yellow-900/30' :
                    index === 1 ? 'bg-gray-200 dark:bg-gray-600' :
                    index === 2 ? 'bg-orange-100 dark:bg-orange-900/30' :
                    'bg-gray-50 dark:bg-gray-700'
                  }`}
                >
                  {/* Rank */}
                  <div className="w-8 h-8 flex items-center justify-center font-bold text-lg">
                    {index === 0 ? '🥇' : index === 1 ? '🥈' : index === 2 ? '🥉' : `${index + 1}`}
                  </div>
                  
                  {/* Stats */}
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <span className="text-sm font-medium dark:text-white">
                        {isCurrentPlayer ? '⭐ You' : `Player #${playerService.getDisplayId(entry.player_id)}`}
                      </span>
                      {entry.mode === 'hard' && (
                        <span className="text-xs px-1.5 py-0.5 bg-purple-200 dark:bg-purple-800 text-purple-700 dark:text-purple-300 rounded">
                          Hard
                        </span>
                      )}
                    </div>
                    <div className="text-xs text-gray-500 dark:text-gray-400">
                      {formatTime(entry.time_spent)} • {entry.incorrect_count} wrong
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        <p className="text-xs text-gray-400 dark:text-gray-500 text-center mt-4">
          Ranked by fewest wrong guesses, then fastest time
        </p>
      </div>
    </div>
  );
};
