// Game types
export type GameMode = 'normal' | 'hard';
export type Category = 'jobs' | 'movies' | 'games';
export type FeedbackType = 'correct' | 'partial' | 'incorrect';

export interface Trait {
  id: string;
  puzzle_id: string;
  slot_position: number;
  keyword: string;
}

export interface Synonym {
  id: string;
  trait_id: string;
  word: string;
}

export interface Puzzle {
  id: string;
  date: string;
  category: Category;
  answer: string;
  traits?: Trait[];
}

export interface PlayerGuess {
  word: string;
  feedback: FeedbackType;
  matched_slot?: number;
}

export interface GameState {
  puzzle: Puzzle;
  mode: GameMode;
  filledSlots: (string | null)[]; // 5 slots, null if empty
  guesses: PlayerGuess[]; // History of all guesses
  incorrectCount: number; // 0-5, game over at 5
  completed: boolean;
  won: boolean;
  startTime: number;
}

export interface Vote {
  id: string;
  puzzle_id: string;
  word_a: string;
  word_b: string;
  chosen_word: string;
  created_at: string;
}
