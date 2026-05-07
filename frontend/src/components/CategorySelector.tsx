import React from 'react';
import { Category } from '../types';

interface CategorySelectorProps {
  onSelect: (category: Category) => void;
}

// Helper to check completion status (same logic as App.tsx)
const getTodayKey = () => new Date().toISOString().split('T')[0];
const getCompletedCategories = (): Record<string, { won: boolean }> => {
  try {
    const data = localStorage.getItem(`traitdle_completed_${getTodayKey()}`);
    return data ? JSON.parse(data) : {};
  } catch {
    return {};
  }
};

export const CategorySelector: React.FC<CategorySelectorProps> = ({ onSelect }) => {
  const categories: { value: Category; label: string; emoji: string; description: string }[] = [
    { value: 'jobs', label: 'Jobs', emoji: '💼', description: 'Guess traits of professions' },
    { value: 'movies', label: 'Movies', emoji: '🎬', description: 'Guess traits of films' },
    { value: 'games', label: 'Games', emoji: '🎮', description: 'Guess traits of video games' }
  ];

  const completed = getCompletedCategories();

  return (
    <div className="w-full max-w-2xl mx-auto p-4 sm:p-6 bg-white dark:bg-gray-800 rounded-lg shadow-lg animate-fade-in">
      <h2 className="text-xl sm:text-2xl font-bold mb-2 text-center dark:text-white">Choose a Category</h2>
      <p className="text-gray-500 dark:text-gray-400 text-center text-sm mb-6">Pick today's puzzle</p>
      
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 sm:gap-4">
        {categories.map((cat) => {
          const result = completed[cat.value];
          const played = !!result;
          
          return (
            <button
              key={cat.value}
              onClick={() => onSelect(cat.value)}
              className={`p-4 sm:p-6 rounded-lg font-semibold text-lg transition-all transform hover:scale-105 active:scale-95 ${
                played 
                  ? result.won
                    ? 'bg-green-100 dark:bg-green-900/30 border-2 border-green-500'
                    : 'bg-orange-50 dark:bg-orange-900/20 border-2 border-orange-400 hover:bg-orange-100 dark:hover:bg-orange-900/30'
                  : 'bg-gradient-to-br from-blue-50 to-blue-100 dark:from-blue-900/30 dark:to-purple-900/30 hover:from-blue-100 hover:to-blue-200 dark:hover:from-blue-800/40 dark:hover:to-purple-800/40'
              }`}
            >
              <div className="text-4xl sm:text-5xl mb-2">{cat.emoji}</div>
              <div className="dark:text-white">{cat.label}</div>
              <div className="text-xs text-gray-500 dark:text-gray-400 mt-1">{cat.description}</div>
              {played && (
                <div className={`text-xs mt-2 flex items-center justify-center gap-1 ${
                  result.won 
                    ? 'text-green-600 dark:text-green-400' 
                    : 'text-orange-600 dark:text-orange-400'
                }`}>
                  {result.won ? (
                    <>
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                      </svg>
                      Completed
                    </>
                  ) : (
                    <>
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                      </svg>
                      Try Again
                    </>
                  )}
                </div>
              )}
            </button>
          );
        })}
      </div>
    </div>
  );
};
