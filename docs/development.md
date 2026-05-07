# Development Guide

## Project Structure

```
traitdle/
├── frontend/                 # React + TypeScript + Tailwind
│   ├── src/
│   │   ├── components/      # React components
│   │   ├── lib/             # Utilities, API clients
│   │   ├── types.ts         # TypeScript types
│   │   ├── App.tsx          # Main app
│   │   └── main.tsx         # Entry point
│   ├── package.json
│   └── README.md
│
├── backend/                  # Node.js + Express
│   ├── src/
│   │   ├── routes/          # API endpoints
│   │   ├── lib/             # Services
│   │   ├── types.ts         # TypeScript types
│   │   └── index.ts         # Server entry
│   ├── package.json
│   └── README.md
│
├── database/                 # PostgreSQL/Supabase
│   ├── migrations/
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_sample_data.sql
│   │   └── 003_rls_policies.sql
│   └── README.md
│
└── docs/
    ├── configuration.md
    ├── development.md
    └── hardware.md
```

## Getting Started

### Prerequisites

- Node.js 18+
- npm or yarn
- Git
- Supabase account

### Setup

1. **Clone repo**
```bash
cd c:\GitHub\traitdle
```

2. **Frontend setup**
```bash
cd frontend
npm install
cp .env.example .env
# Edit .env with your Supabase credentials
npm run dev
```

3. **Backend setup**
```bash
cd ../backend
npm install
cp .env.example .env
# Edit .env with your Supabase credentials
npm run dev
```

4. **Database setup**
   - Go to Supabase dashboard SQL Editor
   - Run migrations from `database/migrations/`

## Development Workflow

### Adding a New Feature

1. **Create a new branch**
```bash
git checkout -b feature/my-feature
```

2. **Make changes**
   - Frontend: Update React components in `frontend/src/`
   - Backend: Update API routes in `backend/src/routes/`
   - Database: Create migration in `database/migrations/`

3. **Test locally**
```bash
# Terminal 1: Backend
cd backend && npm run dev

# Terminal 2: Frontend
cd frontend && npm run dev
```

4. **Commit and push**
```bash
git add .
git commit -m "feat: add new feature"
git push origin feature/my-feature
```

5. **Create Pull Request**

### Adding a New Puzzle Category

1. Add traits to database:
```sql
INSERT INTO traits (word, category, difficulty)
VALUES ('word1', 'new_category', 'easy'),
       ('word2', 'new_category', 'medium'),
       ...;
```

2. Update frontend types in `frontend/src/types.ts`:
```typescript
export type Category = 'jobs' | 'movies' | 'games' | 'new_category';
```

3. Update category selector in `frontend/src/components/CategorySelector.tsx`

### Adding Synonym Support

1. Insert synonyms in database:
```sql
INSERT INTO synonyms (trait_id, synonym, confidence)
SELECT id, 'alternative_word', 0.8 FROM traits WHERE word = 'original_word';
```

2. Update `backend/src/lib/puzzleService.ts` to handle synonyms

3. Test in-game feedback colors

## API Documentation

### Puzzle Routes

**GET /puzzles/daily**
- Query: `?category=jobs&mode=normal`
- Response: Daily puzzle object

**POST /puzzles/validate**
- Body: `{ puzzle_id, guess }`
- Response: `{ feedback: 'correct'|'partial'|'incorrect', matched_trait_id }`

### Game Routes

**POST /games/results**
- Body: `{ puzzle_id, mode, guesses, timeSpent, won }`
- Response: Game result object

**GET /games/stats**
- Response: Player statistics

### Vote Routes

**POST /votes**
- Body: `{ puzzle_id, word_a, word_b, player_vote: 'a'|'b' }`
- Response: Vote object

**GET /votes/:puzzleId/stats**
- Response: Vote statistics for puzzle

## Testing

### Frontend Testing

```bash
cd frontend
npm run lint  # Run ESLint
npm run build # Build for production
```

### Backend Testing

```bash
cd backend
npm run build # TypeScript compilation check
```

## Component Architecture

### Frontend Components

- **Header** - Navigation and branding
- **CategorySelector** - Choose puzzle category
- **ModeSelector** - Choose game mode
- **GameBoard** - Main game UI with trait input
- **VotingPanel** - Post-game voting interface

### Backend Services

- **puzzleService** - Puzzle queries and validation
- **voteService** - Vote submission and stats
- **gameService** - Game result tracking

## Database Queries

### Get Today's Puzzle
```sql
SELECT dp.*, array_agg(t.word) as traits
FROM daily_puzzles dp
JOIN puzzle_traits pt ON dp.id = pt.puzzle_id
JOIN traits t ON pt.trait_id = t.id
WHERE dp.date = CURRENT_DATE AND dp.category = 'jobs'
GROUP BY dp.id;
```

### Get Player Stats
```sql
SELECT 
  COUNT(*) as total_games,
  COUNT(CASE WHEN won THEN 1 END) as wins,
  AVG(time_spent) as avg_time
FROM game_results
WHERE DATE(created_at) = CURRENT_DATE;
```

## Debugging

### Frontend Debug
- Open browser DevTools (F12)
- Check Console for errors
- Use React DevTools extension

### Backend Debug
- Check terminal logs
- Add `console.log()` statements
- Monitor network requests in browser

### Database Debug
- Use Supabase SQL Editor
- Query tables directly
- Check RLS policies

## Performance Tips

1. **Pagination** - Implement for vote/result queries with large datasets
2. **Caching** - Cache daily puzzles (only changes once per day)
3. **Indexes** - Already in schema for common queries
4. **Lazy loading** - Load voting panel only when needed

## Common Issues

**"Cannot find module"** - Run `npm install`

**Port already in use** - Change PORT in .env or kill process

**Supabase connection fails** - Check credentials and RLS policies

**Tailwind CSS not working** - Run `npm run build` or restart dev server
