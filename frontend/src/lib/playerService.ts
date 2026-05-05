// Player service - manages anonymous player identity

const PLAYER_ID_KEY = 'traitdle_player_id';

export const playerService = {
  /**
   * Get or create a unique player ID
   * This is stored in localStorage for anonymous tracking
   */
  getPlayerId(): string {
    let playerId = localStorage.getItem(PLAYER_ID_KEY);
    
    if (!playerId) {
      // Generate a random ID
      playerId = this.generatePlayerId();
      localStorage.setItem(PLAYER_ID_KEY, playerId);
    }
    
    return playerId;
  },

  /**
   * Generate a random player ID
   */
  generatePlayerId(): string {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < 16; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  },

  /**
   * Get a display-friendly version of the player ID
   */
  getDisplayId(playerId?: string): string {
    const id = playerId || this.getPlayerId();
    return id.slice(0, 6).toUpperCase();
  }
};
