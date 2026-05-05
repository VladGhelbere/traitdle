# Configuration Guide

## Environment Setup

### Frontend (.env)

```bash
VITE_API_URL=http://localhost:3001
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Backend (.env)

```bash
DATABASE_URL=postgresql://user:password@localhost:5432/traitdle
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
PORT=3001
NODE_ENV=development
```

## Supabase Setup

1. Create a new Supabase project at https://supabase.com

2. Get your credentials:
   - Go to Settings → API
   - Copy Project URL and Anon Key for frontend
   - Create a Service Role Key for backend

3. Run migrations:
   - Go to SQL Editor in Supabase dashboard
   - Run `database/migrations/001_initial_schema.sql`
   - Run `database/migrations/002_sample_data.sql`
   - Run `database/migrations/003_rls_policies.sql`

4. Enable Row Level Security on tables:
   - Navigate to Authentication → Policies
   - Verify policies are in place

## Database Schema

See `database/README.md` for full schema documentation.

## Daily Puzzle Generation

Puzzles are generated daily for each category (jobs, movies, games). To create new puzzles:

```sql
INSERT INTO daily_puzzles (date, category, target_name, target_description, difficulty)
VALUES (CURRENT_DATE, 'jobs', 'Software Engineer', 'Develops and maintains software', 'hard');

-- Insert 5 traits for this puzzle
INSERT INTO puzzle_traits (puzzle_id, trait_id, position)
VALUES 
  ((SELECT id FROM daily_puzzles WHERE date = CURRENT_DATE AND target_name = 'Software Engineer'), trait_id_1, 1),
  ((SELECT id FROM daily_puzzles WHERE date = CURRENT_DATE AND target_name = 'Software Engineer'), trait_id_2, 2),
  ...
```

## Synonym Management

Add synonyms for traits to improve player experience:

```sql
INSERT INTO synonyms (trait_id, synonym, confidence)
SELECT id, 'management', 0.95 FROM traits WHERE word = 'leadership'
```

The confidence score (0-1) determines feedback:
- **1.0** (exact match) → Green feedback 🟩
- **0.5-0.99** (synonym) → Yellow feedback 🟨
- **0.0** (no match) → Gray feedback ⬜

## API Configuration

The frontend proxies `/api` requests to the backend. Update `frontend/vite.config.ts` if needed:

```typescript
proxy: {
  '/api': {
    target: 'http://localhost:3001',
    changeOrigin: true,
    rewrite: (path) => path.replace(/^\/api/, '')
  }
}
```

## Deployment

### Frontend (Vercel)

1. Push to GitHub
2. Connect repo to Vercel
3. Set environment variables in Vercel dashboard
4. Deploy

### Backend (Render/Railway)

1. Create app from GitHub repo
2. Set environment variables
3. Set build command: `npm run build`
4. Set start command: `npm start`

## Troubleshooting

**"Cannot connect to Supabase"**
- Check SUPABASE_URL and SUPABASE_KEY are correct
- Verify RLS policies allow public access

**"Puzzle not found"**
- Run sample data migration: `002_sample_data.sql`
- Check that today's date matches puzzle date in database

**"Synonyms not matching"**
- Verify synonyms are linked to correct trait_id
- Check confidence score is > 0.5
