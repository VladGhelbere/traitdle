import React from 'react';
import { GameStats, statsService } from '../lib/statsService';

interface StatsModalProps {
  isOpen: boolean;
  onClose: () => void;
  stats: GameStats;
}

export const StatsModal: React.FC<StatsModalProps> = ({ isOpen, onClose, stats }) => {
  if (!isOpen) return null;

  const winPercentage = statsService.getWinPercentage(stats);
  const maxDistribution = Math.max(...stats.guessDistribution, 1);

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-md w-full p-6 relative">
        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
        >
          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <h2 className="text-2xl font-bold mb-6 text-center dark:text-white">Statistics</h2>

        {/* Main stats */}
        <div className="grid grid-cols-4 gap-4 mb-8">
          <div className="text-center">
            <div className="text-3xl font-bold dark:text-white">{stats.gamesPlayed}</div>
            <div className="text-xs text-gray-600 dark:text-gray-400">Played</div>
          </div>
          <div className="text-center">
            <div className="text-3xl font-bold dark:text-white">{winPercentage}</div>
            <div className="text-xs text-gray-600 dark:text-gray-400">Win %</div>
          </div>
          <div className="text-center">
            <div className="text-3xl font-bold dark:text-white">{stats.currentStreak}</div>
            <div className="text-xs text-gray-600 dark:text-gray-400">Current Streak</div>
          </div>
          <div className="text-center">
            <div className="text-3xl font-bold dark:text-white">{stats.maxStreak}</div>
            <div className="text-xs text-gray-600 dark:text-gray-400">Max Streak</div>
          </div>
        </div>

        {/* Guess distribution */}
        <h3 className="font-bold mb-3 dark:text-white">Guess Distribution</h3>
        <div className="space-y-2">
          {stats.guessDistribution.map((count, index) => (
            <div key={index} className="flex items-center gap-2">
              <div className="w-4 text-sm font-medium dark:text-white">{index}</div>
              <div className="flex-1 h-6 bg-gray-200 dark:bg-gray-700 rounded overflow-hidden">
                <div
                  className={`h-full flex items-center justify-end px-2 text-white text-sm font-medium transition-all ${
                    count > 0 ? 'bg-green-500' : 'bg-gray-300 dark:bg-gray-600'
                  }`}
                  style={{ width: `${Math.max((count / maxDistribution) * 100, count > 0 ? 10 : 0)}%` }}
                >
                  {count > 0 && count}
                </div>
              </div>
            </div>
          ))}
        </div>

        <p className="text-xs text-gray-500 dark:text-gray-400 mt-4 text-center">
          Distribution shows wins by number of incorrect guesses (0-4)
        </p>
      </div>
    </div>
  );
};
