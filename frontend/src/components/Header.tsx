import React, { useState } from 'react';
import { soundService } from '../lib/soundService';
import traitdleLogo from '../assets/traitdle-logo.png';

interface HeaderProps {
  onStatsClick?: () => void;
  onHelpClick?: () => void;
  onTitleClick?: () => void;
  darkMode?: boolean;
  onToggleDarkMode?: () => void;
  extremeMode?: boolean;
  onToggleExtremeMode?: () => void;
}

export const Header: React.FC<HeaderProps> = ({ 
  onStatsClick, 
  onHelpClick,
  onTitleClick,
  darkMode,
  onToggleDarkMode,
  extremeMode,
  onToggleExtremeMode
}) => {
  const [soundEnabled, setSoundEnabled] = useState(soundService.isEnabled());

  const toggleSound = () => {
    const newState = soundService.toggle();
    setSoundEnabled(newState);
  };

  return (
    <header className="bg-gradient-to-r from-blue-600 to-purple-600 text-white shadow-lg">
      <div className="max-w-6xl mx-auto px-4 py-3 flex items-center justify-between">
        <button 
          onClick={onTitleClick}
          className="text-left hover:opacity-80 transition-opacity flex items-center gap-3"
        >
          <img 
            src={traitdleLogo} 
            alt="Traitdle" 
            className="h-12 sm:h-14 w-auto"
            onError={(e) => {
              // Fallback to text if image fails to load
              e.currentTarget.style.display = 'none';
              e.currentTarget.nextElementSibling?.classList.remove('hidden');
            }}
          />
          <span className="hidden text-3xl sm:text-4xl font-bold">Traitdle</span>
        </button>
        
        <div className="flex items-center gap-1 sm:gap-2">
          {/* EXTREME mode toggle */}
          {onToggleExtremeMode && (
            <button
              onClick={onToggleExtremeMode}
              className={`px-2 py-1 text-xs font-bold rounded transition-all ${
                extremeMode 
                  ? 'bg-red-500 text-white animate-pulse' 
                  : 'bg-white/20 text-white/70 hover:bg-white/30'
              }`}
              aria-label={extremeMode ? "Disable extreme mode" : "Enable extreme mode"}
              title={extremeMode ? "EXTREME mode ON - Guess traits from the answer" : "Enable EXTREME mode"}
            >
              {extremeMode ? '🔥 EXTREME' : 'EXTREME'}
            </button>
          )}

          {/* Sound toggle */}
          <button
            onClick={toggleSound}
            className="p-2 hover:bg-white/20 rounded-lg transition-colors"
            aria-label={soundEnabled ? "Mute sounds" : "Enable sounds"}
            title={soundEnabled ? "Mute sounds" : "Enable sounds"}
          >
            {soundEnabled ? (
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
              </svg>
            ) : (
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2" />
              </svg>
            )}
          </button>

          {/* Help button */}
          {onHelpClick && (
            <button
              onClick={onHelpClick}
              className="p-2 hover:bg-white/20 rounded-lg transition-colors"
              aria-label="How to play"
              title="How to play"
            >
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </button>
          )}
          
          {/* Stats button */}
          {onStatsClick && (
            <button
              onClick={onStatsClick}
              className="p-2 hover:bg-white/20 rounded-lg transition-colors"
              aria-label="Statistics"
              title="Statistics"
            >
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </button>
          )}
          
          {/* Dark mode toggle */}
          {onToggleDarkMode && (
            <button
              onClick={onToggleDarkMode}
              className="p-2 hover:bg-white/20 rounded-lg transition-colors"
              aria-label="Toggle dark mode"
              title="Toggle dark mode"
            >
              {darkMode ? (
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              ) : (
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                </svg>
              )}
            </button>
          )}
        </div>
      </div>
    </header>
  );
};
