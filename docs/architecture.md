# Architecture & Design

## System Architecture

```
┌─────────────────┐
│   React App     │ (Vite + TypeScript + Tailwind)
│   (Frontend)    │
└────────┬────────┘
         │
         │ HTTP/REST
         │
┌────────┴────────┐
│   Express API   │ (Node.js + TypeScript)
│   (Backend)     │
└────────┬────────┘
         │
         │ SQL
         │
┌────────┴────────────┐
│  PostgreSQL         │ (Supabase)
│  (Database)         │
└─────────────────────┘
```

## Game Flow

### Normal Mode
```
1. Player sees 5 random traits
2. Player guesses the job/movie/game
3. Each correct guess fills a slot:
   - Exact match → Green (🟩)
   - Synonym → Yellow (🟨)
   - Wrong → Gray (⬜)
4. After 5 correct guesses → Victory
5. Vote on word preferences
```

### Hard Mode
```
1. Player sees the job/movie/game name
2. Player guesses 5 traits that define it
3. Feedback same as normal mode
4. After guessing all 5 → Victory
5. Vote on word preferences
```

## Data Flow

### Guess Validation
```
Frontend Input
     ↓
GET /puzzles/validate
     ↓
Backend: Compare against traits + synonyms
     ↓
Return feedback (correct/partial/incorrect)
     ↓
Frontend: Update UI with feedback
```

### Daily Puzzle Selection
```
Frontend: User selects category
     ↓
GET /puzzles/daily?category=jobs
     ↓
Backend: Query database for today's puzzle
     ↓
Return 5 traits and target name/description
     ↓
Frontend: Display based on game mode
```

### Vote Submission
```
Frontend: User votes word A vs B
     ↓
POST /votes
     ↓
Backend: Insert vote into database
     ↓
GET /votes/:puzzleId/stats
     ↓
Return vote statistics
```

## Key Components

### Trait Matching Algorithm

```typescript
// Step 1: Try exact match
if (guess === trait.word) return 'correct';

// Step 2: Check synonyms
for (const synonym of trait.synonyms) {
  if (guess === synonym.word) {
    return 'partial'; // Yellow feedback
  }
}

// Step 3: No match
return 'incorrect'; // Gray feedback
```

### Daily Puzzle Generation

- One puzzle per category per day
- Traits selected to be interesting/diverse
- Difficulty varied across the 5 traits
- Can be automated or manually curated

### Synonym Confidence

- **0.9-1.0**: Very strong synonym (near exact)
- **0.7-0.9**: Good synonym
- **0.5-0.7**: Weak synonym (context-dependent)
- **<0.5**: Not considered a match

## Database Schema

### Tables

| Table | Purpose |
|-------|---------|
| traits | Core trait vocabulary |
| synonyms | Alternative trait words |
| daily_puzzles | Puzzle metadata by date/category |
| puzzle_traits | Links puzzles to 5 traits |
| game_results | Player game history |
| votes | Post-game word preference votes |

### Relationships

```
traits (1) ──→ (many) synonyms
traits (1) ──→ (many) puzzle_traits
daily_puzzles (1) ──→ (5) puzzle_traits
daily_puzzles (1) ──→ (many) game_results
daily_puzzles (1) ──→ (many) votes
game_results (many) ←── player_id (optional)
```

## Security

### Row Level Security (RLS)

- Public read access to puzzles and traits
- Anonymous vote/game result submission
- No authentication required for MVP

### Future Improvements

- User authentication for stats
- Moderation for manual puzzle creation
- Vote tampering prevention

## Scaling Considerations

### Current Limitations

- Daily puzzle generation is manual
- No user accounts
- Limited analytics

### To Scale

1. **Automation**: Daily puzzle generation script
2. **Authentication**: Add user accounts for streak tracking
3. **Caching**: Cache daily puzzles (24-hour TTL)
4. **Analytics**: Track voting patterns, design future puzzles
5. **Moderation**: Admin panel for puzzle approval
6. **Localization**: Support multiple languages

## Technology Choices

| Technology | Reason |
|-----------|--------|
| React | Fast, component-based UI |
| TypeScript | Type safety, better DX |
| Tailwind | Rapid styling, customizable |
| Express | Lightweight, flexible API |
| Supabase | Managed PostgreSQL, auto API |
| Vercel | Easy frontend deployment |

## Future Features

### Phase 2
- User authentication
- Streak tracking
- Leaderboards
- Custom puzzles

### Phase 3
- Multiplayer mode
- Difficulty rankings
- Hint system
- Mobile app

### Phase 4
- AI-generated puzzles
- Community voting on puzzle difficulty
- Accessibility features
