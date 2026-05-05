# Deployment Guide

## Prerequisites

- GitHub repository connected
- Supabase project created
- Vercel and hosting provider accounts

## Database Deployment (Supabase)

1. **Create Supabase Project**
   - Go to https://supabase.com
   - Click "New Project"
   - Fill in project details
   - Wait for project initialization

2. **Run Migrations**
   - Go to SQL Editor in Supabase dashboard
   - Click "New Query"
   - Copy content of `database/migrations/001_initial_schema.sql`
   - Click Run
   - Repeat for `002_sample_data.sql` and `003_rls_policies.sql`

3. **Get Credentials**
   - Go to Settings → API
   - Copy "Project URL" (SUPABASE_URL)
   - Copy "Anon Key" (VITE_SUPABASE_ANON_KEY)
   - Create Service Role Key (SUPABASE_KEY)

## Backend Deployment (Render or Railway)

### Using Render

1. **Connect Repository**
   - Go to https://render.com
   - Click "New +" → "Web Service"
   - Connect GitHub repo
   - Select `backend` directory

2. **Configure**
   - Name: `traitdle-backend`
   - Environment: Node
   - Build Command: `npm install && npm run build`
   - Start Command: `npm start`

3. **Environment Variables**
   - Add from `.env`:
     - `SUPABASE_URL`
     - `SUPABASE_KEY`
     - `PORT=3001`
     - `NODE_ENV=production`

4. **Deploy**
   - Click "Create Web Service"
   - Get your service URL (e.g., `https://traitdle-backend.onrender.com`)

### Using Railway

1. Connect GitHub repo
2. Configure environment variables
3. Select `backend` as root directory
4. Deploy

## Frontend Deployment (Vercel)

1. **Connect Repository**
   - Go to https://vercel.com
   - Click "Add New..." → "Project"
   - Import GitHub repo
   - Select `frontend` as root directory

2. **Configure Build**
   - Framework: `Vite`
   - Build Command: `npm run build`
   - Output Directory: `dist`

3. **Environment Variables**
   - Add from `.env`:
     - `VITE_API_URL=https://traitdle-backend.onrender.com` (your backend URL)
     - `VITE_SUPABASE_URL=your_supabase_url`
     - `VITE_SUPABASE_ANON_KEY=your_supabase_anon_key`

4. **Deploy**
   - Click "Deploy"
   - Get your frontend URL (e.g., `https://traitdle.vercel.app`)

## Post-Deployment

### Update Backend Configuration

Backend needs to know frontend URL for CORS:

```typescript
// backend/src/index.ts
const app = express();
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));
```

Add to backend `.env`:
```
FRONTEND_URL=https://traitdle.vercel.app
```

### Update Frontend API URL

In Vercel dashboard:
- Go to Settings → Environment Variables
- Update `VITE_API_URL` to your backend URL

## Continuous Deployment

### Automatic Deployments

1. **Frontend (Vercel)**
   - Automatically deploys on push to `main`
   - Preview deployments for PRs

2. **Backend (Render)**
   - Automatically deploys on push to `main`
   - Set in Settings → Deploy

### Manual Deployments

If needed:
```bash
# Render CLI
render login
render deploy

# Vercel CLI
vercel
```

## Monitoring

### Vercel Analytics
- Frontend performance metrics
- Error tracking

### Render Logs
- Check backend logs: Dashboard → Logs

### Supabase Monitoring
- Database query performance
- Connection logs

## Troubleshooting

### "CORS Error"
- Check `FRONTEND_URL` in backend .env
- Verify CORS configuration in Express
- Test with `curl -H "Origin: ..." http://backend-url`

### "Cannot connect to Supabase"
- Verify `SUPABASE_URL` and `SUPABASE_KEY`
- Check RLS policies are set correctly
- Test SQL query in Supabase dashboard

### "Backend not found from frontend"
- Verify `VITE_API_URL` is correct
- Check backend is running: `curl http://backend-url/health`
- Check firewall/networking issues

### "Deployment failed"
- Check build logs for errors
- Ensure all environment variables are set
- Verify package.json scripts exist

## Database Backups

### Supabase Backup
- Automatic daily backups (7-day retention)
- Manual backups available
- Export data from SQL Editor: `SELECT * FROM table` → Download

## Custom Domain

### Frontend (Vercel)
1. Go to Settings → Domains
2. Add custom domain
3. Update DNS records
4. Verify

### Backend (Render)
1. Go to Settings → Custom Domain
2. Add domain and DNS records

## Scale Considerations

- **Database**: Supabase auto-scales
- **Backend**: Upgrade Render plan if needed
- **Frontend**: Vercel handles auto-scaling
- **CDN**: Vercel includes global CDN

## Rollback

If deployment has issues:

### Vercel
- Go to Deployments
- Click previous deployment
- Click "Redeploy"

### Render
- Go to Events → Deploys
- Restart previous deployment

### Database
- Supabase: Manual backups can be restored
- Run previous migration if schema changed
