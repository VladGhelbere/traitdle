import React from 'react';

interface WordBankProps {
  words: string[];
  selectedWords: string[];
  correctWords: string[];
  incorrectWords: string[];
  onWordClick: (word: string) => void;
  disabled: boolean;
}

export const WordBank: React.FC<WordBankProps> = ({
  words,
  selectedWords,
  correctWords,
  incorrectWords,
  onWordClick,
  disabled
}) => {
  const getWordState = (word: string): 'default' | 'correct' | 'incorrect' | 'disabled' => {
    if (correctWords.includes(word)) return 'correct';
    if (incorrectWords.includes(word)) return 'incorrect';
    if (selectedWords.includes(word)) return 'disabled';
    return 'default';
  };

  const getWordStyles = (state: 'default' | 'correct' | 'incorrect' | 'disabled'): string => {
    const baseStyles = 'px-3 py-2 rounded-lg text-sm font-medium transition-all duration-200 capitalize';
    
    switch (state) {
      case 'correct':
        return `${baseStyles} bg-green-500 text-white cursor-default scale-95`;
      case 'incorrect':
        return `${baseStyles} bg-red-400 text-white cursor-default opacity-50 line-through scale-95`;
      case 'disabled':
        return `${baseStyles} bg-gray-300 dark:bg-gray-600 text-gray-500 dark:text-gray-400 cursor-default opacity-50`;
      default:
        return `${baseStyles} bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200 hover:bg-blue-200 dark:hover:bg-blue-800 cursor-pointer hover:scale-105 active:scale-95`;
    }
  };

  return (
    <div className="w-full">
      <div className="mb-3 text-center">
        <p className="text-sm text-gray-600 dark:text-gray-400">
          Select the 5 traits that match • <span className="text-green-600 dark:text-green-400 font-medium">{correctWords.length}/5 found</span>
        </p>
      </div>
      
      <div className="flex flex-wrap gap-2 justify-center p-4 bg-gray-50 dark:bg-gray-700/50 rounded-lg max-h-64 overflow-y-auto">
        {words.map((word, index) => {
          const state = getWordState(word);
          const isClickable = state === 'default' && !disabled;
          
          return (
            <button
              key={`${word}-${index}`}
              onClick={() => isClickable && onWordClick(word)}
              disabled={!isClickable}
              className={getWordStyles(state)}
              title={state === 'correct' ? 'Correct!' : state === 'incorrect' ? 'Wrong guess' : 'Click to guess'}
            >
              {word}
            </button>
          );
        })}
      </div>
      
      <p className="text-xs text-gray-500 dark:text-gray-400 text-center mt-2">
        💡 Click on words you think are traits of this answer
      </p>
    </div>
  );
};
