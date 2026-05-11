import { useState, useEffect } from 'react';
import './index.css';
import { Header } from './components/Header';
import { CategorySelector } from './components/CategorySelector';
import { GameBoard } from './components/GameBoard';
import { VotingPanel } from './components/VotingPanel';
import { StatsModal } from './components/StatsModal';
import { HelpModal } from './components/HelpModal';
import { ShareButton } from './components/ShareButton';
import { CountdownTimer } from './components/CountdownTimer';
import { Leaderboard } from './components/Leaderboard';
import { Confetti } from './components/Confetti';
import { Category, GameMode, Puzzle, PlayerGuess } from './types';
import { gameService } from './lib/gameService';
import { statsService, GameStats } from './lib/statsService';
import { soundService } from './lib/soundService';

type AppState = 'category' | 'playing' | 'voting' | 'results' | 'noPuzzle' | 'alreadyPlayed';

// Helper functions for tracking daily completion
const getTodayKey = () => new Date().toISOString().split('T')[0];

const getCompletedCategories = (): Record<string, { won: boolean; incorrectCount: number; timeSpent: number; answer: string; mode: GameMode }> => {
  try {
    const data = localStorage.getItem(`traitdle_completed_${getTodayKey()}`);
    return data ? JSON.parse(data) : {};
  } catch {
    return {};
  }
};

const markCategoryCompleted = (category: Category, result: { won: boolean; incorrectCount: number; timeSpent: number; answer: string; mode: GameMode }) => {
  const completed = getCompletedCategories();
  completed[category] = result;
  localStorage.setItem(`traitdle_completed_${getTodayKey()}`, JSON.stringify(completed));
};

const getCategoryResult = (category: Category) => {
  return getCompletedCategories()[category] || null;
};

function App() {
  const [state, setState] = useState<AppState>('category');
  const [category, setCategory] = useState<Category | null>(null);
  const [mode, setMode] = useState<GameMode | null>(null);
  const [puzzle, setPuzzle] = useState<Puzzle | null>(null);
  const [loading, setLoading] = useState(false);
  const [startTime, setStartTime] = useState<number>(0);
  const [gameResult, setGameResult] = useState<{
    won: boolean;
    filledSlots: (string | null)[];
    incorrectCount: number;
    timeSpent: number;
    guesses: PlayerGuess[];
  } | null>(null);
  
  // Stats
  const [stats, setStats] = useState<GameStats>(statsService.getStats());
  const [showStats, setShowStats] = useState(false);
  const [showHelp, setShowHelp] = useState(false);
  const [showLeaderboard, setShowLeaderboard] = useState(false);
  const [showConfetti, setShowConfetti] = useState(false);
  
  // Dark mode
  const [darkMode, setDarkMode] = useState(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('traitdle_darkMode');
      if (saved !== null) return saved === 'true';
      return window.matchMedia('(prefers-color-scheme: dark)').matches;
    }
    return false;
  });

  // EXTREME mode (hard mode toggle)
  const [extremeMode, setExtremeMode] = useState(() => {
    if (typeof window !== 'undefined') {
      return localStorage.getItem('traitdle_extremeMode') === 'true';
    }
    return false;
  });

  // Show help on first visit
  useEffect(() => {
    const hasSeenHelp = localStorage.getItem('traitdle_hasSeenHelp');
    if (!hasSeenHelp) {
      setShowHelp(true);
      localStorage.setItem('traitdle_hasSeenHelp', 'true');
    }
  }, []);

  // Apply dark mode class to document
  useEffect(() => {
    if (darkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
    localStorage.setItem('traitdle_darkMode', String(darkMode));
  }, [darkMode]);

  // Save extreme mode preference
  useEffect(() => {
    localStorage.setItem('traitdle_extremeMode', String(extremeMode));
  }, [extremeMode]);

  const handleCategorySelect = async (selected: Category) => {
    soundService.playClick();
    setCategory(selected);
    
    // Check if already completed this category today
    // - Wins always block retry (both modes)
    // - Losses block retry only in extreme/hard mode
    const existingResult = getCategoryResult(selected);
    if (existingResult && (existingResult.won || existingResult.mode === 'hard')) {
      // Already completed (won, or lost in extreme mode) - show results
      setMode(existingResult.mode);
      setGameResult({
        won: existingResult.won,
        filledSlots: [],
        incorrectCount: existingResult.incorrectCount,
        timeSpent: existingResult.timeSpent,
        guesses: []
      });
      // Load puzzle just for the answer display
      try {
        const dailyPuzzle = await gameService.getDailyPuzzle(selected, existingResult.mode);
        setPuzzle(dailyPuzzle);
      } catch {
        setPuzzle({ id: '', date: '', category: selected, answer: existingResult.answer, traits: [] } as Puzzle);
      }
      setState('alreadyPlayed');
      return;
    }
    
    // Determine mode based on extreme toggle
    const gameMode: GameMode = extremeMode ? 'hard' : 'normal';
    setMode(gameMode);
    
    // Load puzzle directly (skip mode selection)
    setLoading(true);
    try {
      const dailyPuzzle = await gameService.getDailyPuzzle(selected, gameMode);
      setPuzzle(dailyPuzzle);
      setStartTime(Date.now());
      setState('playing');
    } catch (error) {
      console.error('Failed to load puzzle:', error);
      // Check if it's a "no puzzle" error vs a network error
      const errorMessage = error instanceof Error ? error.message : '';
      if (errorMessage.includes('No puzzle found')) {
        setState('noPuzzle');
      } else {
        alert('Failed to load puzzle. Please check your connection and try again.');
        setState('category');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleGameOver = async (
    won: boolean, 
    filledSlots: (string | null)[], 
    incorrectCount: number,
    guesses: PlayerGuess[]
  ) => {
    if (!puzzle || !mode || !category) return;

    const timeSpent = Math.floor((Date.now() - startTime) / 1000);
    
    // Mark this category as completed for today
    markCategoryCompleted(category, {
      won,
      incorrectCount,
      timeSpent,
      answer: puzzle.answer,
      mode
    });
    
    // Record stats
    const updatedStats = statsService.recordGame(won, incorrectCount, category);
    setStats(updatedStats);
    
    // Show confetti on win
    if (won) {
      setShowConfetti(true);
      setTimeout(() => setShowConfetti(false), 3000);
    }
    
    try {
      await gameService.submitGameResult(puzzle.id, {
        mode,
        filledSlots,
        incorrectCount,
        timeSpent,
        won
      });
      
      setGameResult({ won, filledSlots, incorrectCount, timeSpent, guesses });
      
      if (won) {
        setState('voting');
      } else {
        setState('results');
      }
    } catch (error) {
      console.error('Failed to save result:', error);
      setGameResult({ won, filledSlots, incorrectCount, timeSpent, guesses });
      setState('results');
    }
  };

  const handleVoteComplete = () => {
    setState('results');
  };

  const handlePlayAgain = () => {
    soundService.playClick();
    setState('category');
    setCategory(null);
    setMode(null);
    setPuzzle(null);
    setGameResult(null);
  };

  const handleGoHome = () => {
    soundService.playClick();
    setState('category');
    setCategory(null);
    setMode(null);
    setPuzzle(null);
    setGameResult(null);
  };

  const toggleDarkMode = () => {
    setDarkMode(prev => !prev);
  };

  const toggleExtremeMode = () => {
    soundService.playClick();
    setExtremeMode(prev => !prev);
  };

  return (
    <div className={`min-h-screen transition-colors ${darkMode ? 'dark bg-gray-900' : 'bg-gradient-to-b from-gray-50 to-gray-100'}`}>
      <Header 
        onStatsClick={() => setShowStats(true)}
        onHelpClick={() => setShowHelp(true)}
        onTitleClick={handleGoHome}
        darkMode={darkMode}
        onToggleDarkMode={toggleDarkMode}
        extremeMode={extremeMode}
        onToggleExtremeMode={toggleExtremeMode}
      />
      
      <main className="max-w-6xl mx-auto px-4 py-6 sm:py-12">
        {state === 'category' && <CategorySelector onSelect={handleCategorySelect} />}

        {state === 'noPuzzle' && (
          <div className="text-center max-w-md mx-auto bg-white dark:bg-gray-800 p-8 rounded-lg shadow-lg animate-fade-in">
            <div className="text-6xl mb-4">📅</div>
            <h2 className="text-2xl font-bold mb-4 dark:text-white">No Puzzle Today</h2>
            <p className="text-gray-600 dark:text-gray-300 mb-4">
              There's no {category} puzzle available for today yet.
            </p>
            <p className="text-gray-500 dark:text-gray-400 text-sm mb-6">
              New puzzles are added regularly. Check back soon or try a different category!
            </p>
            
            {/* Countdown to next day */}
            <div className="mb-6">
              <CountdownTimer />
            </div>
            
            <button
              onClick={handleGoHome}
              className="px-6 py-3 bg-blue-600 text-white rounded-lg font-bold hover:bg-blue-700 transition-colors"
            >
              Try Another Category
            </button>
          </div>
        )}

        {state === 'alreadyPlayed' && gameResult && (
          <div className="text-center max-w-2xl mx-auto bg-white dark:bg-gray-800 p-6 sm:p-8 rounded-lg shadow-lg animate-fade-in">
            <div className="text-5xl mb-4">{gameResult.won ? '✅' : '💥'}</div>
            <h2 className="text-2xl font-bold mb-2 dark:text-white">
              {gameResult.won ? 'Already Played!' : 'Already Attempted!'}
            </h2>
            <p className="text-gray-600 dark:text-gray-300 mb-6">
              You've already {gameResult.won ? 'completed' : 'attempted'} today's <span className="font-semibold capitalize">{category}</span> puzzle
              {!gameResult.won && mode === 'hard' && ' in Extreme mode'}.
            </p>
            
            {/* Previous result summary */}
            <div className="p-4 bg-gray-100 dark:bg-gray-700 rounded-lg mb-6">
              <p className="text-lg dark:text-white mb-2">
                {gameResult.won ? '🎉 You won!' : '💥 You lost'}
              </p>
              <p className="text-gray-600 dark:text-gray-300 text-sm">
                Answer: <span className="font-bold">{puzzle?.answer}</span>
              </p>
              {/* Show missed traits for extreme mode losses */}
              {!gameResult.won && mode === 'hard' && puzzle?.traits && (
                <div className="mt-3 pt-3 border-t border-gray-200 dark:border-gray-600">
                  <p className="text-sm font-semibold text-red-600 dark:text-red-400 mb-2">
                    Traits you missed:
                  </p>
                  <div className="flex flex-wrap gap-2 justify-center">
                    {puzzle.traits.map((trait, i) => (
                      <span
                        key={i}
                        className="px-2 py-1 bg-red-100 dark:bg-red-800 text-red-800 dark:text-red-200 rounded text-xs font-medium"
                      >
                        {trait.keyword}
                      </span>
                    ))}
                  </div>
                </div>
              )}
              <p className="text-gray-600 dark:text-gray-300 text-sm mt-2">
                Time: {gameResult.timeSpent}s • Mistakes: {gameResult.incorrectCount}/5
              </p>
              <p className="text-gray-500 dark:text-gray-400 text-xs mt-1">
                Mode: {mode === 'hard' ? '🔥 EXTREME' : 'Normal'}
              </p>
            </div>

            {/* Countdown to next puzzle */}
            <div className="mb-6">
              <p className="text-sm text-gray-500 dark:text-gray-400 mb-2">Next puzzle in:</p>
              <CountdownTimer />
            </div>
            
            {/* Action buttons */}
            <div className="flex flex-col sm:flex-row gap-3 justify-center">
              <button
                onClick={() => setShowLeaderboard(true)}
                className="px-6 py-3 bg-purple-600 text-white rounded-lg font-bold hover:bg-purple-700 transition-colors flex items-center justify-center gap-2"
              >
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
                Leaderboard
              </button>
              
              <button
                onClick={handleGoHome}
                className="px-6 py-3 bg-blue-600 text-white rounded-lg font-bold hover:bg-blue-700 transition-colors"
              >
                Try Another Category
              </button>
            </div>
          </div>
        )}

        {state === 'playing' && puzzle && !loading && (
          <GameBoard
            puzzle={puzzle}
            mode={mode!}
            onGuess={() => {}}
            onGameOver={handleGameOver}
          />
        )}

        {state === 'voting' && puzzle && gameResult?.won && (
          <div className="animate-fade-in">
            <h2 className="text-2xl font-bold mb-4 text-center dark:text-white">Great job! 🎉</h2>
            <VotingPanel
              puzzleId={puzzle.id}
              onVoteSubmitted={handleVoteComplete}
            />
          </div>
        )}

        {state === 'results' && gameResult && (
          <div className="text-center max-w-2xl mx-auto bg-white dark:bg-gray-800 p-6 sm:p-8 rounded-lg shadow-lg animate-fade-in">
            {gameResult.won ? (
              <>
                <h2 className="text-3xl font-bold mb-4 dark:text-white">🎉 You Won!</h2>
                <p className="text-lg text-gray-600 dark:text-gray-300 mb-2">
                  Time: {gameResult.timeSpent}s
                </p>
                <p className="text-lg text-gray-600 dark:text-gray-300 mb-6">
                  Incorrect guesses: {gameResult.incorrectCount}/5
                </p>
              </>
            ) : (
              <>
                <h2 className="text-3xl font-bold mb-4 dark:text-white">💥 Game Over</h2>
                {mode === 'hard' ? (
                  // EXTREME mode: Show answer and missed traits, no retry
                  <>
                    <p className="text-lg text-gray-600 dark:text-gray-300 mb-2">
                      The answer was: <span className="font-bold">{puzzle?.answer}</span>
                    </p>
                    {/* Show missed traits in extreme mode */}
                    {puzzle?.traits && (
                      <div className="mt-4 mb-6 p-4 bg-red-50 dark:bg-red-900/20 rounded-lg">
                        <p className="text-sm font-semibold text-red-700 dark:text-red-300 mb-2">
                          Traits you missed:
                        </p>
                        <div className="flex flex-wrap gap-2 justify-center">
                          {puzzle.traits
                            .filter(trait => !gameResult.filledSlots.includes(trait.keyword))
                            .map((trait, i) => (
                              <span
                                key={i}
                                className="px-3 py-1 bg-red-100 dark:bg-red-800 text-red-800 dark:text-red-200 rounded-full text-sm font-medium"
                              >
                                {trait.keyword}
                              </span>
                            ))}
                        </div>
                      </div>
                    )}
                  </>
                ) : (
                  // Normal mode: Don't show answer, allow retry
                  <p className="text-lg text-gray-600 dark:text-gray-300 mb-6">
                    Better luck next time! You can try again.
                  </p>
                )}
              </>
            )}
            
            {/* Stats summary */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-6 p-4 bg-gray-100 dark:bg-gray-700 rounded-lg">
              <div className="text-center">
                <div className="text-2xl font-bold dark:text-white">{stats.currentStreak}</div>
                <div className="text-xs text-gray-600 dark:text-gray-400">Streak</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold dark:text-white">{stats.maxStreak}</div>
                <div className="text-xs text-gray-600 dark:text-gray-400">Best</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold dark:text-white">{stats.gamesWon}</div>
                <div className="text-xs text-gray-600 dark:text-gray-400">Wins</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold dark:text-white">{statsService.getWinPercentage(stats)}%</div>
                <div className="text-xs text-gray-600 dark:text-gray-400">Win Rate</div>
              </div>
            </div>

            {/* Countdown to next puzzle */}
            <div className="mb-6">
              <CountdownTimer />
            </div>
            
            {/* Action buttons */}
            <div className="flex flex-col sm:flex-row gap-3 justify-center">
              {gameResult.won && category && mode && (
                <ShareButton
                  shareData={{
                    puzzleNumber: 1,
                    category,
                    mode,
                    won: gameResult.won,
                    incorrectCount: gameResult.incorrectCount,
                    guesses: gameResult.guesses,
                    maxGuesses: 5
                  }}
                />
              )}
              
              <button
                onClick={() => setShowLeaderboard(true)}
                className="px-6 py-3 bg-purple-600 text-white rounded-lg font-bold text-lg hover:bg-purple-700 transition-colors flex items-center justify-center gap-2"
              >
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
                Leaderboard
              </button>
              
              {/* Only show Play Again for normal mode losses, or for wins */}
              {(gameResult.won || mode === 'normal') && (
                <button
                  onClick={handlePlayAgain}
                  className="px-6 py-3 bg-blue-600 text-white rounded-lg font-bold text-lg hover:bg-blue-700 transition-colors"
                >
                  {gameResult.won ? 'Play Again' : 'Try Again'}
                </button>
              )}
            </div>
          </div>
        )}

        {loading && (
          <div className="text-center">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">Loading puzzle...</p>
          </div>
        )}
      </main>
      
      {/* Modals */}
      <StatsModal 
        isOpen={showStats} 
        onClose={() => setShowStats(false)} 
        stats={stats}
      />
      
      <HelpModal
        isOpen={showHelp}
        onClose={() => setShowHelp(false)}
      />
      
      <Leaderboard
        isOpen={showLeaderboard}
        onClose={() => setShowLeaderboard(false)}
        puzzleId={puzzle?.id}
        category={category || undefined}
        currentMode={mode || undefined}
      />
      
      {/* Confetti celebration */}
      <Confetti active={showConfetti} />
    </div>
  );
}

export default App;
