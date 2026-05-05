import React from 'react';

interface HelpModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const HelpModal: React.FC<HelpModalProps> = ({ isOpen, onClose }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-lg w-full p-6 relative max-h-[90vh] overflow-y-auto">
        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
        >
          <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <h2 className="text-2xl font-bold mb-6 text-center dark:text-white">How to Play</h2>

        {/* Game concept */}
        <div className="mb-6">
          <h3 className="font-bold text-lg mb-2 dark:text-white">🎯 The Goal</h3>
          <p className="text-gray-600 dark:text-gray-300">
            Each puzzle shows you 5 <strong>traits</strong> (adjectives/qualities). Guess what job, movie, or game they describe!
          </p>
        </div>

        {/* EXTREME mode */}
        <div className="mb-6">
          <h3 className="font-bold text-lg mb-2 dark:text-white">🔥 EXTREME Mode</h3>
          <p className="text-gray-600 dark:text-gray-300 mb-2">
            Want a challenge? Toggle <strong className="text-red-500">EXTREME</strong> in the header to flip the game:
          </p>
          <div className="space-y-2 text-gray-600 dark:text-gray-300 text-sm">
            <div className="p-2 bg-gray-50 dark:bg-gray-700 rounded">
              <strong>Normal:</strong> See 5 traits → Guess the answer
            </div>
            <div className="p-2 bg-red-50 dark:bg-red-900/30 rounded border border-red-200 dark:border-red-800">
              <strong className="text-red-600 dark:text-red-400">EXTREME:</strong> See the answer → Guess all 5 traits
            </div>
          </div>
        </div>

        {/* Feedback explanation */}
        <div className="mb-6">
          <h3 className="font-bold text-lg mb-3 dark:text-white">🎨 Feedback Colors</h3>
          <div className="space-y-3">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center text-white font-bold text-xl">
                🟩
              </div>
              <div className="text-gray-600 dark:text-gray-300">
                <strong className="text-green-600 dark:text-green-400">Green</strong> - Exact match! You found the correct trait.
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-yellow-500 rounded-lg flex items-center justify-center text-white font-bold text-xl">
                🟨
              </div>
              <div className="text-gray-600 dark:text-gray-300">
                <strong className="text-yellow-600 dark:text-yellow-400">Yellow</strong> - Close! You guessed a synonym. Try the exact word.
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-gray-500 rounded-lg flex items-center justify-center text-white font-bold text-xl">
                ⬛
              </div>
              <div className="text-gray-600 dark:text-gray-300">
                <strong className="text-gray-600 dark:text-gray-400">Gray</strong> - Not a trait for this answer.
              </div>
            </div>
          </div>
        </div>

        {/* Rules */}
        <div className="mb-6">
          <h3 className="font-bold text-lg mb-2 dark:text-white">📋 Rules</h3>
          <ul className="list-disc list-inside text-gray-600 dark:text-gray-300 space-y-1">
            <li>You have 5 incorrect guesses before game over</li>
            <li>Correct guesses don't count against you</li>
            <li>Synonyms (yellow) give you a hint but don't fill slots</li>
            <li>Win = locked out for the day. Lose = you can retry!</li>
            <li>A new puzzle is available every day at midnight</li>
          </ul>
        </div>

        {/* Example */}
        <div className="mb-6 p-4 bg-blue-50 dark:bg-blue-900/30 rounded-lg">
          <h3 className="font-bold text-lg mb-2 dark:text-white">💡 Example</h3>
          <p className="text-gray-600 dark:text-gray-300 text-sm mb-3">
            You see these 5 traits:
          </p>
          <div className="flex flex-wrap gap-2 mb-3">
            <span className="px-2 py-1 bg-blue-500 text-white rounded text-sm">brave</span>
            <span className="px-2 py-1 bg-blue-500 text-white rounded text-sm">strong</span>
            <span className="px-2 py-1 bg-blue-500 text-white rounded text-sm">calm</span>
            <span className="px-2 py-1 bg-blue-500 text-white rounded text-sm">selfless</span>
            <span className="px-2 py-1 bg-blue-500 text-white rounded text-sm">quick</span>
          </div>
          <p className="text-gray-500 dark:text-gray-400 text-sm">
            Answer: <strong>FIREFIGHTER</strong> 🚒
          </p>
        </div>

        {/* Categories */}
        <div className="mb-6">
          <h3 className="font-bold text-lg mb-2 dark:text-white">📂 Categories</h3>
          <div className="flex gap-4 justify-center">
            <div className="text-center">
              <div className="text-3xl mb-1">💼</div>
              <div className="text-sm text-gray-600 dark:text-gray-300">Jobs</div>
              <div className="text-xs text-gray-400">Traits needed for the job</div>
            </div>
            <div className="text-center">
              <div className="text-3xl mb-1">🎬</div>
              <div className="text-sm text-gray-600 dark:text-gray-300">Movies</div>
              <div className="text-xs text-gray-400">Adjectives describing the film</div>
            </div>
            <div className="text-center">
              <div className="text-3xl mb-1">🎮</div>
              <div className="text-sm text-gray-600 dark:text-gray-300">Games</div>
              <div className="text-xs text-gray-400">Adjectives describing the game</div>
            </div>
          </div>
        </div>

        <button
          onClick={onClose}
          className="w-full py-3 bg-blue-600 text-white rounded-lg font-bold hover:bg-blue-700 transition-colors"
        >
          Got it!
        </button>
      </div>
    </div>
  );
};
