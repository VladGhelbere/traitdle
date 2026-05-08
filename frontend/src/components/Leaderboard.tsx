import React, { useState, useEffect } from 'react';
import { gameService } from '../lib/gameService';
import { playerService } from '../lib/playerService';
import { Category } from '../types';

interface DistributionStats {
  totalPlayers: number;
  winRate: number;
  averageTime: number;
  averageIncorrect: number;
  distribution: number[]; // Percentage of players at each mistake level (0-5)
}

interface LeaderboardProps {
  puzzleId?: string;
  category?: Category;
  isOpen: boolean;
  onClose: () => void;
}

export const Leaderboard: React.FC<LeaderboardProps> = ({ puzzleId, category, isOpen, onClose }) => {
  const [stats, setStats] = useState<DistributionStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [userResult, setUserResult] = useState<{ incorrectCount: number; won: boolean } | null>(null);

  useEffect(() => {
    if (isOpen) {
      loadDistributionStats();
    }
  }, [isOpen, puzzleId, category]);

  const loadDistributionStats = async () => {
    setLoading(true);
    try {
      // Load distribution stats
      const distributionData = await gameService.getDistributionStats(category);
      setStats(distributionData);

      // Get current user's result for today
      const playerId = playerService.getPlayerId();
      const userResultData = await gameService.getUserTodayResult(playerId, category);
      setUserResult(userResultData);
    } catch (error) {
      console.error('Failed to load distribution stats:', error);
    } finally {
      setLoading(false);
    }
  };

  if (!isOpen) return null;

  const getCategoryEmoji = () => {
    switch (category) {
      case 'jobs': return '💼';
      case 'movies': return '🎬';
      case 'games': return '🎮';
      default: return '🎯';
    }
  };

  const getBarLabel = (index: number): string => {
    if (index === 5) return 'Lost';
    return `${index} mistake${index !== 1 ? 's' : ''}`;
  };

  const getBarColor = (index: number, isUserResult: boolean): string => {
    if (isUserResult) {
      return index === 5 ? 'bg-red-500' : 'bg-blue-500';
    }
    if (index === 5) return 'bg-red-400 dark:bg-red-600';
    if (index === 0) return 'bg-green-500 dark:bg-green-600';
    if (index <= 2) return 'bg-green-400 dark:bg-green-500';
    return 'bg-yellow-400 dark:bg-yellow-500';
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
          {getCategoryEmoji()} Today's Results
        </h2>
        <p className="text-center text-gray-500 dark:text-gray-400 text-sm mb-4">
          How players performed today
        </p>

        {loading ? (
          <div className="text-center py-8">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          </div>
        ) : !stats || stats.totalPlayers === 0 ? (
          <div className="text-center py-8 text-gray-500 dark:text-gray-400">
            <p>No players yet today!</p>
            <p className="text-sm mt-1">Be the first to complete the puzzle.</p>
          </div>
        ) : (
          <>
            {/* Summary stats */}
            <div className="grid grid-cols-4 gap-2 mb-6 p-3 bg-gray-100 dark:bg-gray-700 rounded-lg">
              <div className="text-center">
                <div className="text-lg font-bold dark:text-white">{stats.totalPlayers}</div>
                <div className="text-xs text-gray-500 dark:text-gray-400">Players</div>
              </div>
              <div className="text-center">
                <div className="text-lg font-bold text-green-600 dark:text-green-400">{stats.winRate}%</div>
                <div className="text-xs text-gray-500 dark:text-gray-400">Win Rate</div>
              </div>
              <div className="text-center">
                <div className="text-lg font-bold dark:text-white">{stats.averageTime}s</div>
                <div className="text-xs text-gray-500 dark:text-gray-400">Avg Time</div>
              </div>
              <div className="text-center">
                <div className="text-lg font-bold dark:text-white">{stats.averageIncorrect}</div>
                <div className="text-xs text-gray-500 dark:text-gray-400">Avg Wrong</div>
              </div>
            </div>

            {/* Distribution bars */}
            <h3 className="font-bold mb-3 dark:text-white text-sm">Player Distribution</h3>
            <div className="space-y-2">
              {stats.distribution.map((percentage, index) => {
                const isUserResult = userResult && (
                  (userResult.won && userResult.incorrectCount === index) ||
                  (!userResult.won && index === 5)
                );
                
                return (
                  <div key={index} className="flex items-center gap-2">
                    <div className="w-20 text-xs font-medium dark:text-white text-right">
                      {getBarLabel(index)}
                    </div>
                    <div className="flex-1 h-7 bg-gray-200 dark:bg-gray-700 rounded overflow-hidden relative">
                      <div
                        className={`h-full flex items-center justify-end px-2 text-white text-xs font-bold transition-all ${getBarColor(index, !!isUserResult)} ${isUserResult ? 'ring-2 ring-offset-1 ring-blue-400' : ''}`}
                        style={{ width: `${Math.max(percentage, percentage > 0 ? 8 : 0)}%` }}
                      >
                        {percentage > 0 && (
                          isUserResult ? `⭐${percentage}%` : `${percentage}%`
                        )}
                      </div>
                    </div>
                    {isUserResult && (
                      <span className="text-xs text-gray-600 dark:text-gray-300 whitespace-nowrap">
                        You
                      </span>
                    )}
                  </div>
                );
              })}
            </div>

            <p className="text-xs text-gray-400 dark:text-gray-500 text-center mt-4">
              Shows percentage of players at each mistake level
            </p>
          </>
        )}
      </div>
    </div>
  );
};
