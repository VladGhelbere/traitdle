# Traitdle Database

## Setup

1. Create a new Supabase project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor**
3. Copy and paste the entire contents of `schema.sql`
4. Click **Run**

That's it! The schema includes:
- All tables and indexes
- Row Level Security policies
- Views and functions
- 30 days of puzzles with candidate traits (May 7 - June 6, 2026)

## Schema Overview

### Core Tables

| Table | Description |
|-------|-------------|
| `puzzles` | Daily puzzles (date, category, answer) |
| `traits` | The 5 keywords for each puzzle |
| `synonyms` | Alternative accepted words for traits |
| `game_results` | Player game history |

### Voting System Tables

| Table | Description |
|-------|-------------|
| `candidate_traits` | Pool of 10-15 traits per puzzle for voting |
| `trait_votes` | Individual vote records |

### Key Functions

| Function | Description |
|----------|-------------|
| `get_trait_pair_for_voting()` | Get random trait pair from future puzzle |
| `submit_trait_vote()` | Record a vote and increment count |
| `get_todays_leaderboard()` | Get today's top players |
| `get_daily_stats()` | Get aggregated stats for a day |

## How Voting Works

1. Each puzzle has 10-15 candidate traits
2. Users vote on pairs: "Which trait better describes NURSE?"
3. Votes accumulate over days
4. When the puzzle goes live, the game automatically uses the **top 5 voted traits**

**Important**: Users can only vote on puzzles that are **tomorrow or later** - not today's puzzle.

## Adding New Puzzles

```sql
-- 1. Create the puzzle
INSERT INTO puzzles (date, category, answer) 
VALUES ('2026-06-07', 'jobs', 'DOCTOR');

-- 2. Add 10-15 candidate traits
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY[
  'caring', 'intelligent', 'patient', 'skilled', 
  'dedicated', 'calm', 'knowledgeable', 'compassionate', 
  'precise', 'resilient', 'thorough', 'empathetic'
])
FROM puzzles WHERE answer = 'DOCTOR' AND date = '2026-06-07';
```

## Useful Queries

```sql
-- See upcoming puzzles and their vote counts
SELECT * FROM upcoming_puzzle_votes;

-- See ranked traits for a specific puzzle
SELECT * FROM candidate_traits_ranked 
WHERE puzzle_date = '2026-05-08';

-- Get today's leaderboard
SELECT * FROM get_todays_leaderboard('jobs', 10);

-- Get daily stats
SELECT * FROM get_daily_stats();
```
