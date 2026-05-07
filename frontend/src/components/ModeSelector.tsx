import React from 'react';
import { GameMode } from '../types';

interface ModeSelectorProps {
  onSelect: (mode: GameMode) => void;
  onBack: () => void;
}

export const ModeSelector: React.FC<ModeSelectorProps> = ({ onSelect, onBack }) => {
  // SWAPPED: Normal mode is now guessing the answer from traits (easier)
  // Hard mode is now guessing all 5 traits (harder)
  const modes: { value: GameMode; label: string; description: string; emoji: string; difficulty: string }[] = [
    {
      value: 'normal',
      label: 'Normal Mode',
      description: 'See 5 traits → Guess the job/movie/game',
      emoji: '🎯',
      difficulty: 'Easier'
    },
    {
      value: 'hard',
      label: 'Hard Mode',
      description: 'See the job/movie/game → Guess all 5 traits',
      emoji: '🔥',
      difficulty: 'Harder'
    }
  ];

  return (
    <div className="w-full max-w-2xl mx-auto p-4 sm:p-6 bg-white dark:bg-gray-800 rounded-lg shadow-lg animate-fade-in">
      <h2 className="text-xl sm:text-2xl font-bold mb-2 text-center dark:text-white">Select Difficulty</h2>
      <p className="text-gray-500 dark:text-gray-400 text-center text-sm mb-6">Choose your challenge</p>
      
      <div className="space-y-3 sm:space-y-4">
        {modes.map((mode) => (
          <button
            key={mode.value}
            onClick={() => onSelect(mode.value)}
            className="w-full p-4 sm:p-6 text-left bg-gradient-to-r from-purple-50 to-pink-50 dark:from-purple-900/30 dark:to-pink-900/30 hover:from-purple-100 hover:to-pink-100 dark:hover:from-purple-800/40 dark:hover:to-pink-800/40 rounded-lg transition-all transform hover:scale-[1.02] active:scale-[0.98] flex items-center gap-4"
          >
            <div className="text-4xl">{mode.emoji}</div>
            <div className="flex-1">
              <div className="flex items-center gap-2">
                <h3 className="text-lg font-bold dark:text-white">{mode.label}</h3>
                <span className={`text-xs px-2 py-0.5 rounded ${
                  mode.value === 'hard' 
                    ? 'bg-red-200 dark:bg-red-800 text-red-700 dark:text-red-300' 
                    : 'bg-green-200 dark:bg-green-800 text-green-700 dark:text-green-300'
                }`}>
                  {mode.difficulty}
                </span>
              </div>
              <p className="text-gray-600 dark:text-gray-400 text-sm mt-1">{mode.description}</p>
            </div>
            <svg className="w-6 h-6 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
          </button>
        ))}
      </div>
      
      <button
        onClick={onBack}
        className="w-full mt-4 py-2 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 text-sm"
      >
        ← Back to categories
      </button>
    </div>
  );
};
