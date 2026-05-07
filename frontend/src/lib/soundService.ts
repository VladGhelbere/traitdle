// Sound service - plays game sounds

class SoundService {
  private enabled: boolean = true;
  private audioContext: AudioContext | null = null;

  constructor() {
    // Load preference from localStorage
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('traitdle_sound');
      this.enabled = saved !== 'false';
    }
  }

  private getAudioContext(): AudioContext {
    if (!this.audioContext) {
      this.audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();
    }
    return this.audioContext;
  }

  isEnabled(): boolean {
    return this.enabled;
  }

  toggle(): boolean {
    this.enabled = !this.enabled;
    localStorage.setItem('traitdle_sound', String(this.enabled));
    return this.enabled;
  }

  private playTone(frequency: number, duration: number, type: OscillatorType = 'sine', volume: number = 0.3) {
    if (!this.enabled) return;

    try {
      const ctx = this.getAudioContext();
      const oscillator = ctx.createOscillator();
      const gainNode = ctx.createGain();

      oscillator.connect(gainNode);
      gainNode.connect(ctx.destination);

      oscillator.frequency.value = frequency;
      oscillator.type = type;

      gainNode.gain.setValueAtTime(volume, ctx.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + duration);

      oscillator.start(ctx.currentTime);
      oscillator.stop(ctx.currentTime + duration);
    } catch (error) {
      console.warn('Sound playback failed:', error);
    }
  }

  playCorrect() {
    // Happy ascending tone
    this.playTone(523.25, 0.1); // C5
    setTimeout(() => this.playTone(659.25, 0.1), 100); // E5
    setTimeout(() => this.playTone(783.99, 0.15), 200); // G5
  }

  playPartial() {
    // Neutral double beep
    this.playTone(440, 0.1); // A4
    setTimeout(() => this.playTone(440, 0.1), 150);
  }

  playIncorrect() {
    // Low buzz
    this.playTone(200, 0.2, 'square', 0.15);
  }

  playWin() {
    // Victory fanfare
    const notes = [523.25, 659.25, 783.99, 1046.50]; // C5, E5, G5, C6
    notes.forEach((freq, i) => {
      setTimeout(() => this.playTone(freq, 0.2), i * 150);
    });
  }

  playLose() {
    // Sad descending tone
    this.playTone(392, 0.2); // G4
    setTimeout(() => this.playTone(349.23, 0.2), 200); // F4
    setTimeout(() => this.playTone(293.66, 0.3), 400); // D4
  }

  playClick() {
    this.playTone(800, 0.05, 'sine', 0.1);
  }
}

export const soundService = new SoundService();
