# Getting Started Checklist

## Pre-Development Setup

- [ ] Clone repository
- [ ] Set up GitHub account and configure git
- [ ] Create Supabase project
- [ ] Node.js 18+ installed
- [ ] VS Code or preferred editor

## Initial Configuration

- [ ] Copy `frontend/.env.example` to `frontend/.env`
- [ ] Copy `backend/.env.example` to `backend/.env`
- [ ] Fill in Supabase credentials in both `.env` files
- [ ] Run database migrations in Supabase dashboard

## Local Development Setup

- [ ] Install frontend dependencies: `cd frontend && npm install`
- [ ] Install backend dependencies: `cd backend && npm install`
- [ ] Start backend: `npm run dev` (port 3001)
- [ ] Start frontend: `npm run dev` (port 5173)
- [ ] Test at http://localhost:5173

## Features to Verify

- [ ] Game loads successfully
- [ ] Can select category (Jobs/Movies/Games)
- [ ] Can select game mode (Normal/Hard)
- [ ] Game board displays with traits/target
- [ ] Trait input accepts guesses
- [ ] Feedback displays correctly (🟩/🟨/⬜)
- [ ] Victory condition works (5 correct guesses)
- [ ] Voting panel appears after victory
- [ ] Can vote and submit
- [ ] Results screen displays

## Database Setup

- [ ] Login to Supabase console
- [ ] Run `001_initial_schema.sql` migration
- [ ] Run `002_sample_data.sql` migration
- [ ] Run `003_rls_policies.sql` migration
- [ ] Verify sample data in SQL editor

## Optional Setup

- [ ] Configure linting: `npm run lint`
- [ ] Test build: `npm run build`
- [ ] Set up VS Code extensions (ESLint, Prettier)
- [ ] Configure git pre-commit hooks

## Deployment

- [ ] Create Render account
- [ ] Create Vercel account
- [ ] Deploy backend to Render
- [ ] Deploy frontend to Vercel
- [ ] Update environment variables on hosting
- [ ] Test live deployment

## Troubleshooting

If you encounter issues:

1. **Dependencies not found**: Run `npm install`
2. **Port conflicts**: Change PORT in .env or kill process
3. **Database errors**: Verify migrations ran successfully
4. **Supabase connection fails**: Check credentials
5. **Frontend won't load**: Clear browser cache, restart dev server

For more help, see:
- [Configuration Guide](configuration.md)
- [Development Guide](development.md)
- [Deployment Guide](deployment.md)
