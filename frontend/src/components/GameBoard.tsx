import React, { useState, useEffect } from 'react';
import { GameMode, Puzzle, PlayerGuess, FeedbackType } from '../types';
import { gameService } from '../lib/gameService';
import { soundService } from '../lib/soundService';
import { Toast } from './Toast';
import { WordBank } from './WordBank';

interface TraitInputProps {
  onSubmit: (guess: string) => void;
  isDisabled: boolean;
  mode: GameMode;
}

const TraitInput: React.FC<TraitInputProps> = ({ onSubmit, isDisabled, mode }) => {
  const [input, setInput] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (input.trim()) {
      onSubmit(input.toLowerCase());
      setInput('');
    }
  };

  // SWAPPED: normal = guess answer, hard = guess traits
  const placeholder = mode === 'normal' ? 'Enter the job/movie/game...' : 'Enter a trait...';

  return (
    <form onSubmit={handleSubmit} className="w-full max-w-md mx-auto">
      <div className="flex gap-2">
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          disabled={isDisabled}
          placeholder={placeholder}
          className="flex-1 min-w-0 px-3 sm:px-4 py-3 border-2 border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:text-white text-base sm:text-lg"
          autoFocus
        />
        <button
          type="submit"
          disabled={isDisabled || !input.trim()}
          className="px-4 sm:px-6 py-3 bg-blue-500 text-white rounded-lg hover:bg-blue-600 disabled:opacity-50 font-semibold transition-colors whitespace-nowrap flex-shrink-0"
        >
          Guess
        </button>
      </div>
    </form>
  );
};

interface GameBoardProps {
  puzzle: Puzzle;
  mode: GameMode;
  onGuess: (guess: string) => void;
  onGameOver: (won: boolean, filledSlots: (string | null)[], incorrectCount: number, guesses: PlayerGuess[]) => void;
}

export const GameBoard: React.FC<GameBoardProps> = ({ puzzle, mode, onGuess, onGameOver }) => {
  const [filledSlots, setFilledSlots] = useState<(string | null)[]>([null, null, null, null, null]);
  const [guesses, setGuesses] = useState<PlayerGuess[]>([]);
  const [incorrectCount, setIncorrectCount] = useState(0);
  const [gameOver, setGameOver] = useState(false);
  const [animatingSlot, setAnimatingSlot] = useState<number | null>(null);
  const [shakeInput, setShakeInput] = useState(false);
  const [showHint, setShowHint] = useState(false);
  
  // Word bank state for extreme mode
  const [wordBankOptions, setWordBankOptions] = useState<string[]>([]);
  const [wordBankLoading, setWordBankLoading] = useState(false);
  const [correctWordBankWords, setCorrectWordBankWords] = useState<string[]>([]);
  const [incorrectWordBankWords, setIncorrectWordBankWords] = useState<string[]>([]);
  
  // Toast state
  const [toast, setToast] = useState<{ message: string; type: FeedbackType } | null>(null);

  // Load word bank options for extreme mode
  useEffect(() => {
    if (mode === 'hard' && puzzle?.id) {
      loadWordBankOptions();
    }
  }, [mode, puzzle?.id]);

  const loadWordBankOptions = async () => {
    setWordBankLoading(true);
    try {
      const options = await gameService.getWordBankOptions(puzzle.id, puzzle.category);
      setWordBankOptions(options);
    } catch (error) {
      console.error('Failed to load word bank options:', error);
    } finally {
      setWordBankLoading(false);
    }
  };

  // Show hint after 2 incorrect guesses
  useEffect(() => {
    if (incorrectCount >= 2 && !showHint && !gameOver) {
      setShowHint(true);
    }
  }, [incorrectCount, showHint, gameOver]);

  // Generate a hint based on the puzzle
  const getHint = (): string => {
    if (!puzzle) return '';
    
    const answer = puzzle.answer.toUpperCase();
    const category = puzzle.category;
    
    // Different hint strategies
    const hints: string[] = [];
    
    // Hint 1: First letter
    hints.push(`The answer starts with "${answer[0]}"`);
    
    // Hint 2: Word length
    hints.push(`The answer has ${answer.length} letters`);
    
    // Hint 3: Category-specific hints
    if (category === 'jobs') {
      hints.push(`Think about professions that match these traits`);
    } else if (category === 'movies') {
      hints.push(`Think about famous films with these characteristics`);
    } else if (category === 'games') {
      hints.push(`Think about popular video games with these qualities`);
    }
    
    // Return first letter + length hint combined
    return `💡 Hint: Starts with "${answer[0]}" and has ${answer.length} letters`;
  };

  // Clear animation states after animation completes
  useEffect(() => {
    if (animatingSlot !== null) {
      const timer = setTimeout(() => setAnimatingSlot(null), 600);
      return () => clearTimeout(timer);
    }
  }, [animatingSlot]);

  useEffect(() => {
    if (shakeInput) {
      const timer = setTimeout(() => setShakeInput(false), 500);
      return () => clearTimeout(timer);
    }
  }, [shakeInput]);

  const getFeedbackColor = (feedback: FeedbackType): string => {
    switch (feedback) {
      case 'correct':
        return 'bg-green-500 text-white';
      case 'partial':
        return 'bg-yellow-500 text-white';
      case 'incorrect':
        return 'bg-gray-400 text-white';
    }
  };

  const getFeedbackEmoji = (feedback: FeedbackType): string => {
    switch (feedback) {
      case 'correct':
        return '🟩';
      case 'partial':
        return '🟨';
      case 'incorrect':
        return '⬛';
    }
  };

  const showToast = (message: string, type: FeedbackType) => {
    setToast({ message, type });
  };

  const handleGuess = (guess: string) => {
    if (gameOver) return;

    let result;
    let newGuess: PlayerGuess;

    // SWAPPED: normal mode = guess the answer (easier), hard mode = guess traits (harder)
    if (mode === 'normal') {
      // Normal mode: guess the answer (job/movie/game) from traits shown
      const isCorrect = guess.toLowerCase().trim() === puzzle.answer.toLowerCase();
      result = isCorrect ? { feedback: 'correct' as FeedbackType } : { feedback: 'incorrect' as FeedbackType };
      
      newGuess = {
        word: guess,
        feedback: result.feedback,
        matched_slot: undefined
      };

      const newGuesses = [...guesses, newGuess];
      setGuesses(newGuesses);

      if (result.feedback === 'correct') {
        soundService.playWin();
        const newSlots = [puzzle.answer, puzzle.answer, puzzle.answer, puzzle.answer, puzzle.answer];
        setFilledSlots(newSlots);
        setGameOver(true);
        // Immediately trigger game over - no message needed
        onGameOver(true, newSlots, incorrectCount, newGuesses);
      } else {
        soundService.playIncorrect();
        setShakeInput(true);
        showToast('Not the answer', 'incorrect');
        const newIncorrectCount = incorrectCount + 1;
        setIncorrectCount(newIncorrectCount);

        if (newIncorrectCount >= 5) {
          soundService.playLose();
          setGameOver(true);
          // Immediately trigger game over - no message needed
          onGameOver(false, filledSlots, newIncorrectCount, newGuesses);
        }
      }
    } else {
      // Hard mode: guess traits (need to find all 5)
      result = gameService.validateGuess(puzzle, guess);
      newGuess = {
        word: guess,
        feedback: result.feedback,
        matched_slot: result.slotPosition
      };

      const newGuesses = [...guesses, newGuess];
      setGuesses(newGuesses);

      if (result.feedback === 'correct' && result.slotPosition) {
        soundService.playCorrect();
        setAnimatingSlot(result.slotPosition - 1);
        showToast('Trait found!', 'correct');
        
        // Track correct word for word bank
        setCorrectWordBankWords(prev => [...prev, guess.toLowerCase()]);
        
        const newSlots = [...filledSlots];
        newSlots[result.slotPosition - 1] = guess;
        setFilledSlots(newSlots);

        if (newSlots.every(slot => slot !== null)) {
          soundService.playWin();
          setGameOver(true);
          // Small delay to let the last slot animate, then trigger game over
          setTimeout(() => {
            onGameOver(true, newSlots, incorrectCount, newGuesses);
          }, 400);
        }
      } else if (result.feedback === 'partial') {
        soundService.playPartial();
        // Show which slot the partial match relates to
        if (result.relatedSlot) {
          setAnimatingSlot(result.relatedSlot - 1);
          showToast(`Close! Synonym for slot ${result.relatedSlot}`, 'partial');
        } else {
          showToast('Close! Try the exact word', 'partial');
        }
        // Track as incorrect for word bank (partial matches don't count)
        setIncorrectWordBankWords(prev => [...prev, guess.toLowerCase()]);
      } else if (result.feedback === 'incorrect') {
        soundService.playIncorrect();
        setShakeInput(true);
        showToast('Not a trait', 'incorrect');
        
        // Track incorrect word for word bank
        setIncorrectWordBankWords(prev => [...prev, guess.toLowerCase()]);
        
        const newIncorrectCount = incorrectCount + 1;
        setIncorrectCount(newIncorrectCount);

        if (newIncorrectCount >= 5) {
          soundService.playLose();
          setGameOver(true);
          // Immediately trigger game over - no message needed
          onGameOver(false, filledSlots, newIncorrectCount, newGuesses);
        }
      }
    }

    onGuess(guess);
  };

  return (
    <div className="w-full max-w-2xl mx-auto p-4 sm:p-6 bg-white dark:bg-gray-800 rounded-lg shadow-lg">
      {/* Toast notification */}
      <Toast
        message={toast?.message || ''}
        type={toast?.type || 'incorrect'}
        isVisible={toast !== null}
        onHide={() => setToast(null)}
        duration={1500}
      />

      <div className="mb-6 sm:mb-8 text-center">
        {/* SWAPPED: normal shows "Guess the Answer", hard shows the answer */}
        <h2 className="text-xl sm:text-2xl font-bold dark:text-white">
          {mode === 'hard' ? puzzle.answer : 'Guess the Answer'}
        </h2>
        {mode === 'normal' && (
          <p className="text-gray-600 dark:text-gray-400 mt-1">
            Guess the {puzzle.category === 'jobs' ? 'job' : puzzle.category === 'movies' ? 'movie' : 'game'} from these traits
          </p>
        )}
        {mode === 'hard' && (
          <p className="text-gray-600 dark:text-gray-400 mt-1">
            Select the 5 traits that define this {puzzle.category === 'jobs' ? 'job' : puzzle.category === 'movies' ? 'movie' : 'game'} from the word bank below
          </p>
        )}
      </div>

      {/* Trait slots - show traits in normal mode, show numbers in hard mode */}
      <div className="grid grid-cols-5 gap-1 sm:gap-2 mb-6 sm:mb-8">
        {filledSlots.map((slot, i) => {
          const traitAtPosition = puzzle.traits?.find(t => t.slot_position === i + 1);
          // SWAPPED: normal mode shows traits, hard mode shows slot numbers until filled
          const displayText = slot || (mode === 'normal' ? traitAtPosition?.keyword : `${i + 1}`);
          const isAnimating = animatingSlot === i;
          
          return (
            <div
              key={i}
              className={`aspect-square flex items-center justify-center rounded-lg border-2 font-semibold text-xs sm:text-sm text-center p-1 overflow-hidden transition-all duration-300 ${
                slot
                  ? 'bg-green-500 text-white border-green-600 scale-100'
                  : 'border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 dark:text-gray-300'
              } ${isAnimating ? 'animate-bounce ring-4 ring-yellow-400' : ''}`}
            >
              <span className="break-words leading-tight">{displayText}</span>
            </div>
          );
        })}
      </div>

      {/* Status info */}
      <div className="flex justify-between mb-4 sm:mb-6 text-sm font-semibold">
        {mode === 'hard' && (
          <div className="text-blue-600 dark:text-blue-400">
            Filled: {filledSlots.filter(s => s !== null).length}/5
          </div>
        )}
        {mode === 'normal' && (
          <div className="text-blue-600 dark:text-blue-400">
            Attempts: {guesses.length}
          </div>
        )}
        <div className={`flex items-center gap-1 ${incorrectCount >= 4 ? 'text-red-600 dark:text-red-400' : 'text-orange-600 dark:text-orange-400'}`}>
          <span>Incorrect:</span>
          <div className="flex gap-0.5">
            {[0, 1, 2, 3, 4].map(i => (
              <span key={i} className={`w-3 h-3 rounded-full ${i < incorrectCount ? 'bg-red-500' : 'bg-gray-300 dark:bg-gray-600'}`} />
            ))}
          </div>
        </div>
      </div>

      {/* Hint display - shows after 2 incorrect guesses in normal mode */}
      {showHint && mode === 'normal' && !gameOver && (
        <div className="mb-4 p-3 bg-yellow-100 dark:bg-yellow-900/30 border border-yellow-300 dark:border-yellow-700 rounded-lg text-center animate-fade-in">
          <p className="text-yellow-800 dark:text-yellow-200 text-sm font-medium">
            {getHint()}
          </p>
        </div>
      )}

      {/* Input - Text input for normal mode, Word Bank for extreme mode */}
      {mode === 'normal' ? (
        <div className={`mb-6 sm:mb-8 ${shakeInput ? 'animate-shake' : ''}`}>
          <TraitInput onSubmit={handleGuess} isDisabled={gameOver} mode={mode} />
        </div>
      ) : (
        <div className={`mb-6 sm:mb-8 ${shakeInput ? 'animate-shake' : ''}`}>
          {wordBankLoading ? (
            <div className="text-center py-4">
              <div className="inline-block animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
              <p className="text-sm text-gray-500 dark:text-gray-400 mt-2">Loading word bank...</p>
            </div>
          ) : wordBankOptions.length > 0 ? (
            <WordBank
              words={wordBankOptions}
              selectedWords={[...correctWordBankWords, ...incorrectWordBankWords]}
              correctWords={correctWordBankWords}
              incorrectWords={incorrectWordBankWords}
              onWordClick={handleGuess}
              disabled={gameOver}
            />
          ) : (
            // Fallback to text input if word bank fails to load
            <TraitInput onSubmit={handleGuess} isDisabled={gameOver} mode={mode} />
          )}
        </div>
      )}

      {/* Guess history - only show for normal mode since word bank shows state visually */}
      {guesses.length > 0 && mode === 'normal' && (
        <div className="mt-6 sm:mt-8">
          <h3 className="font-bold mb-3 text-sm dark:text-white">Guess History:</h3>
          <div className="flex flex-wrap gap-2">
            {guesses.map((guess, i) => (
              <div
                key={i}
                className={`px-3 py-1 rounded text-sm font-semibold text-white transition-all ${getFeedbackColor(guess.feedback)}`}
                title={guess.matched_slot ? `Matched slot ${guess.matched_slot}` : undefined}
              >
                {guess.word} {getFeedbackEmoji(guess.feedback)}
                {guess.matched_slot && <span className="ml-1 text-xs opacity-75">#{guess.matched_slot}</span>}
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
