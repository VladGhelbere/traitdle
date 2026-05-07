# Frontend - Traitdle

React + TypeScript + Tailwind CSS frontend for the Traitdle game.

## Setup

```bash
npm install
```

## Development

```bash
npm run dev
```

Server runs on `http://localhost:5173`

## Build

```bash
npm run build
```

## Environment Variables

Create `.env` file from `.env.example`:

```
VITE_API_URL=http://localhost:3001
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Project Structure

- `src/components/` - React components
- `src/lib/` - Utilities and API clients
- `src/types.ts` - TypeScript type definitions
- `src/App.tsx` - Main application
