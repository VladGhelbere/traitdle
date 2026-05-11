# Traitdle

A daily puzzle game inspired by Wordle where players guess traits that define jobs, movies, or games.

## 🎮 How to Play

### Categories
Choose from three daily categories:
- **Jobs** - Guess traits a professional needs (e.g., FIREFIGHTER → brave, strong, calm)
- **Movies** - Guess adjectives describing a film (e.g., INCEPTION → complex, surreal, thrilling)
- **Games** - Guess adjectives describing a game (e.g., ZELDA → adventurous, magical, epic)

### Game Modes

| Mode | How It Works |
|------|--------------|
| **Normal** (default) | See 5 traits → Guess the job/movie/game. If you lose, you can try again! |
| **🔥 EXTREME** | See the answer → Select the 5 correct traits from a word bank of 30 options. No retries if you lose! |

Toggle EXTREME mode using the button in the header for a harder challenge!

### Feedback System
- 🟩 **Green** - Correct trait!
- 🟨 **Yellow** - Close! You guessed a synonym (try the exact word) - Normal mode only
- ⬛ **Incorrect** - Not a trait for this answer

### Rules
- 5 incorrect guesses = Game Over
- One puzzle per category per day
- **Normal mode**: Win locks you out, loss lets you retry
- **EXTREME mode**: Win OR loss locks you out (no retries!) - missed traits are shown at the end
- New puzzles at midnight
- Separate leaderboards for Normal and EXTREME modes

## ✨ Features

### Core Gameplay
- Daily puzzles for 3 categories
- Normal and Hard modes
- Real-time trait validation with synonym support
- Toast notifications for feedback

### Statistics & Sharing
- Track your streaks and win rate
- Guess distribution histogram
- Share results with emoji grid
- Countdown timer to next puzzle
- **Separate leaderboards for Normal and EXTREME modes**

### Social Features
- Daily leaderboard (ranked by fewest mistakes, then fastest time)
- Anonymous player tracking
- Community voting system

### Polish
- 🌙 Dark mode
- 🔊 Sound effects (toggleable)
- 🎊 Confetti celebration on wins
- 📱 Mobile-optimized UI
- ❓ Tutorial for new players

## 🗳️ Voting System

After winning a game, players help crowdsource traits for **future puzzles**:

1. Each upcoming puzzle has 10-15 candidate traits
2. Players vote: "Which trait better describes NURSE: **caring** or **resilient**?"
3. Votes accumulate over days
4. When the puzzle goes live, the **top 5 voted traits** are automatically selected

This means the community decides which traits best represent each answer!

**Note**: You can only vote on puzzles that are tomorrow or later (not today's puzzle).

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | React 18 + TypeScript + Vite |
| Styling | Tailwind CSS |
| Database | Supabase (PostgreSQL) |
| Auth | Anonymous player IDs (localStorage) |
| Audio | Web Audio API |

## 📁 Project Structure

```
traitdle/
├── frontend/
│   ├── src/
│   │   ├── assets/         # Images (logo)
│   │   ├── components/     # React components
│   │   │   ├── GameBoard.tsx
│   │   │   ├── CategorySelector.tsx
│   │   │   ├── VotingPanel.tsx
│   │   │   ├── Leaderboard.tsx
│   │   │   ├── StatsModal.tsx
│   │   │   ├── HelpModal.tsx
│   │   │   ├── ShareButton.tsx
│   │   │   ├── CountdownTimer.tsx
│   │   │   ├── Header.tsx
│   │   │   ├── Toast.tsx
│   │   │   └── Confetti.tsx
│   │   ├── lib/            # Services & utilities
│   │   │   ├── gameService.ts
│   │   │   ├── statsService.ts
│   │   │   ├── shareService.ts
│   │   │   ├── soundService.ts
│   │   │   ├── playerService.ts
│   │   │   └── client.ts
│   │   ├── types.ts        # TypeScript types
│   │   ├── App.tsx         # Main app component
│   │   └── index.css       # Global styles & animations
│   └── package.json
└── database/
    └── schema.sql          # Complete database schema
```

## 🚀 Setup

### Prerequisites
- Node.js 18+
- Supabase account

### 1. Database Setup

1. Create a new Supabase project
2. Go to SQL Editor
3. Run the contents of `database/schema.sql`

### 2. Frontend Setup

```bash
cd frontend
npm install

# Create .env.local with your Supabase credentials
echo "VITE_SUPABASE_URL=your-project-url" > .env.local
echo "VITE_SUPABASE_ANON_KEY=your-anon-key" >> .env.local

npm run dev
```

### 3. Add Puzzles

The schema includes 30 days of puzzles (May 8 - June 6, 2026) with candidate traits.

To add more puzzles:
```sql
-- Add a puzzle
INSERT INTO puzzles (date, category, answer) 
VALUES ('2026-06-07', 'jobs', 'DOCTOR');

-- Add candidate traits (10-15 per puzzle)
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['caring', 'intelligent', 'patient', 'skilled', 'dedicated', 'calm', 'knowledgeable', 'compassionate', 'precise', 'resilient'])
FROM puzzles WHERE answer = 'DOCTOR' AND date = '2026-06-07';
```

## 📊 Database Schema

### Tables

| Table | Purpose |
|-------|---------|
| `puzzles` | Daily puzzles (date, category, answer) |
| `traits` | Fixed traits for a puzzle (keyword, slot_position) |
| `synonyms` | Alternative words for traits |
| `candidate_traits` | Voteable traits for upcoming puzzles |
| `trait_votes` | Individual votes on candidate traits |
| `game_results` | Player game history |
| `votes` | Legacy voting table |

### Key Functions

| Function | Purpose |
|----------|---------|
| `get_trait_pair_for_voting()` | Get random trait pair from future puzzle |
| `submit_trait_vote()` | Record a vote and increment count |
| `get_puzzle_with_top_traits()` | Get puzzle with top 5 voted traits |

## 🎯 Game Flow

```
┌─────────────────┐
│ Select Category │ (Jobs / Movies / Games)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Play Game     │ (EXTREME toggle in header)
└────────┬────────┘
         ▼
    ┌────┴────┐
    │  Won?   │
    └────┬────┘
    Yes  │  No
    ▼    ▼
┌───────┐ ┌─────────────────────────┐
│ Vote  │ │ Mode?                   │
└───┬───┘ └───────────┬─────────────┘
    │         Normal  │  EXTREME
    │            ▼    ▼
    │     ┌──────────┐ ┌──────────────────┐
    │     │Try Again │ │ Show missed      │
    │     └────┬─────┘ │ traits, no retry │
    │          │       └────────┬─────────┘
    ▼          ▼                ▼
┌─────────────────────────────────────────┐
│    Results (Stats, Share, Leaderboard)  │
└─────────────────────────────────────────┘

Note: Winning always locks you out for the day.
      Losing in Normal mode lets you retry.
      Losing in EXTREME mode locks you out (shows missed traits).
```

## 📝 Adding Content

### Trait Guidelines

Traits should be **adjectives or qualities**, not nouns or related words:

| Category | Good ✅ | Bad ❌ |
|----------|---------|--------|
| Jobs | brave, patient, skilled | emergency, hospital, uniform |
| Movies | thrilling, emotional, epic | action, drama, actor |
| Games | challenging, immersive, fun | controller, multiplayer, boss |

### Example: Adding a new job

```sql
-- 1. Create the puzzle
INSERT INTO puzzles (date, category, answer) 
VALUES ('2026-06-07', 'jobs', 'DOCTOR');

-- 2. Add 10-15 candidate traits for voting
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY[
  'caring',
  'intelligent', 
  'patient',
  'skilled',
  'dedicated',
  'calm',
  'knowledgeable',
  'compassionate',
  'precise',
  'resilient',
  'thorough',
  'empathetic'
])
FROM puzzles WHERE answer = 'DOCTOR' AND date = '2026-06-07';
```

The top 5 voted traits will automatically be used when the puzzle goes live!

## 📄 License

MIT
