// Share service - generates shareable results

import { Category, GameMode, PlayerGuess } from '../types';

export interface ShareData {
  puzzleNumber: number;
  category: Category;
  mode: GameMode;
  won: boolean;
  incorrectCount: number;
  guesses: PlayerGuess[];
  maxGuesses: number;
}

export const shareService = {
  /**
   * Calculate puzzle number based on a start date
   */
  getPuzzleNumber(): number {
    const startDate = new Date('2026-01-01'); // Game launch date
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    startDate.setHours(0, 0, 0, 0);
    const diffTime = today.getTime() - startDate.getTime();
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
    return diffDays + 1;
  },

  /**
   * Get category emoji
   */
  getCategoryEmoji(category: Category): string {
    switch (category) {
      case 'jobs': return '💼';
      case 'movies': return '🎬';
      case 'games': return '🎮';
      default: return '🎯';
    }
  },

  /**
   * Get feedback emoji - using more compatible emojis
   */
  getFeedbackEmoji(feedback: string): string {
    switch (feedback) {
      case 'correct': return '🟩';
      case 'partial': return '🟨';
      case 'incorrect': return '⬛'; // Using black square instead of white - more compatible
      default: return '⬛';
    }
  },

  /**
   * Generate full share text
   */
  generateShareText(data: ShareData): string {
    const puzzleNum = this.getPuzzleNumber();
    const categoryEmoji = this.getCategoryEmoji(data.category);
    // After swap: 'normal' is now seeing traits and guessing answer (easier)
    const modeLabel = data.mode === 'hard' ? ' (Hard)' : '';
    const result = data.won ? `${data.incorrectCount}/5` : 'X/5';
    
    let text = `Traitdle #${puzzleNum} ${categoryEmoji}${modeLabel} ${result}\n`;
    
    // Generate emoji row from guesses
    const emojis = data.guesses.map(g => this.getFeedbackEmoji(g.feedback));
    text += emojis.join('');
    
    text += '\n\nhttps://traitdle.com';
    
    return text;
  },

  /**
   * Copy text to clipboard
   */
  async copyToClipboard(text: string): Promise<boolean> {
    try {
      if (navigator.clipboard && navigator.clipboard.writeText) {
        await navigator.clipboard.writeText(text);
        return true;
      }
      
      // Fallback for older browsers
      const textArea = document.createElement('textarea');
      textArea.value = text;
      textArea.style.position = 'fixed';
      textArea.style.left = '-999999px';
      textArea.style.top = '-999999px';
      document.body.appendChild(textArea);
      textArea.focus();
      textArea.select();
      
      const success = document.execCommand('copy');
      document.body.removeChild(textArea);
      return success;
    } catch (error) {
      console.error('Failed to copy to clipboard:', error);
      return false;
    }
  },

  /**
   * Share using Web Share API if available, otherwise copy to clipboard
   */
  async share(data: ShareData): Promise<{ success: boolean; method: 'share' | 'clipboard' }> {
    const text = this.generateShareText(data);
    
    // Try Web Share API first (mobile)
    if (navigator.share) {
      try {
        await navigator.share({
          text: text
        });
        return { success: true, method: 'share' };
      } catch (error) {
        // User cancelled or share failed, fall back to clipboard
        if ((error as Error).name !== 'AbortError') {
          console.error('Share failed:', error);
        }
      }
    }
    
    // Fall back to clipboard
    const success = await this.copyToClipboard(text);
    return { success, method: 'clipboard' };
  }
};
