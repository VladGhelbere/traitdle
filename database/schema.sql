-- ============================================================================
-- TRAITDLE - Complete Database Schema
-- ============================================================================
-- Run this entire file in your Supabase SQL Editor to set up the database.
-- This includes all tables, functions, views, policies, and sample data.
-- ============================================================================

-- ============================================================================
-- PART 1: EXTENSIONS & CORE TABLES
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Puzzles table - one puzzle per category per day
CREATE TABLE IF NOT EXISTS puzzles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  date DATE NOT NULL,
  category VARCHAR(50) NOT NULL CHECK (category IN ('jobs', 'movies', 'games')),
  answer VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(date, category)
);

-- Traits table - the 5 keywords for each puzzle (can be pre-set or voted)
CREATE TABLE IF NOT EXISTS traits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  puzzle_id UUID NOT NULL REFERENCES puzzles(id) ON DELETE CASCADE,
  slot_position INT NOT NULL CHECK (slot_position >= 1 AND slot_position <= 5),
  keyword VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(puzzle_id, slot_position)
);

-- Synonyms table - alternative accepted words for traits
CREATE TABLE IF NOT EXISTS synonyms (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  trait_id UUID NOT NULL REFERENCES traits(id) ON DELETE CASCADE,
  word VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(trait_id, word)
);

-- Game results table - tracks all played games
CREATE TABLE IF NOT EXISTS game_results (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  puzzle_id UUID NOT NULL REFERENCES puzzles(id) ON DELETE CASCADE,
  player_id VARCHAR(64),
  mode VARCHAR(50) NOT NULL CHECK (mode IN ('normal', 'hard')),
  guesses JSONB NOT NULL,
  time_spent INT NOT NULL,
  won BOOLEAN NOT NULL,
  incorrect_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Legacy votes table (kept for compatibility)
CREATE TABLE IF NOT EXISTS votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  puzzle_id UUID NOT NULL REFERENCES puzzles(id) ON DELETE CASCADE,
  word_a VARCHAR(255) NOT NULL,
  word_b VARCHAR(255) NOT NULL,
  chosen_word VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- PART 2: VOTING SYSTEM TABLES
-- ============================================================================

-- Candidate traits - pool of 10-15 traits per puzzle that users vote on
CREATE TABLE IF NOT EXISTS candidate_traits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  puzzle_id UUID NOT NULL REFERENCES puzzles(id) ON DELETE CASCADE,
  word VARCHAR(255) NOT NULL,
  vote_count INT DEFAULT 0,
  is_selected BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(puzzle_id, word)
);

-- Trait votes - individual vote records
CREATE TABLE IF NOT EXISTS trait_votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  puzzle_id UUID NOT NULL REFERENCES puzzles(id) ON DELETE CASCADE,
  winner_trait_id UUID NOT NULL REFERENCES candidate_traits(id) ON DELETE CASCADE,
  loser_trait_id UUID NOT NULL REFERENCES candidate_traits(id) ON DELETE CASCADE,
  player_id VARCHAR(64),
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- PART 3: INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_puzzles_date ON puzzles(date);
CREATE INDEX IF NOT EXISTS idx_puzzles_category ON puzzles(category);
CREATE INDEX IF NOT EXISTS idx_traits_puzzle_id ON traits(puzzle_id);
CREATE INDEX IF NOT EXISTS idx_synonyms_trait_id ON synonyms(trait_id);
CREATE INDEX IF NOT EXISTS idx_game_results_puzzle_id ON game_results(puzzle_id);
CREATE INDEX IF NOT EXISTS idx_game_results_created_at ON game_results(created_at);
CREATE INDEX IF NOT EXISTS idx_game_results_won ON game_results(won);
CREATE INDEX IF NOT EXISTS idx_game_results_player_id ON game_results(player_id);
CREATE INDEX IF NOT EXISTS idx_votes_puzzle_id ON votes(puzzle_id);
CREATE INDEX IF NOT EXISTS idx_candidate_traits_puzzle_id ON candidate_traits(puzzle_id);
CREATE INDEX IF NOT EXISTS idx_candidate_traits_vote_count ON candidate_traits(vote_count DESC);
CREATE INDEX IF NOT EXISTS idx_trait_votes_puzzle_id ON trait_votes(puzzle_id);
CREATE INDEX IF NOT EXISTS idx_trait_votes_winner ON trait_votes(winner_trait_id);

-- ============================================================================
-- PART 4: ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE puzzles ENABLE ROW LEVEL SECURITY;
ALTER TABLE traits ENABLE ROW LEVEL SECURITY;
ALTER TABLE synonyms ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_traits ENABLE ROW LEVEL SECURITY;
ALTER TABLE trait_votes ENABLE ROW LEVEL SECURITY;

-- Public read access
DROP POLICY IF EXISTS "Allow public read" ON puzzles;
CREATE POLICY "Allow public read" ON puzzles FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow public read" ON traits;
CREATE POLICY "Allow public read" ON traits FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow public read" ON synonyms;
CREATE POLICY "Allow public read" ON synonyms FOR SELECT USING (true);

DROP POLICY IF EXISTS "Anyone can view candidate traits" ON candidate_traits;
CREATE POLICY "Anyone can view candidate traits" ON candidate_traits FOR SELECT USING (true);

-- Game results policies
DROP POLICY IF EXISTS "Anyone can view game results" ON game_results;
DROP POLICY IF EXISTS "Anyone can insert game results" ON game_results;
CREATE POLICY "Anyone can view game results" ON game_results FOR SELECT USING (true);
CREATE POLICY "Anyone can insert game results" ON game_results FOR INSERT WITH CHECK (true);

-- Votes policies
DROP POLICY IF EXISTS "Allow read votes" ON votes;
DROP POLICY IF EXISTS "Allow insert votes" ON votes;
CREATE POLICY "Allow read votes" ON votes FOR SELECT USING (true);
CREATE POLICY "Allow insert votes" ON votes FOR INSERT WITH CHECK (true);

-- Trait votes policies
DROP POLICY IF EXISTS "Anyone can view trait votes" ON trait_votes;
DROP POLICY IF EXISTS "Anyone can insert trait votes" ON trait_votes;
CREATE POLICY "Anyone can view trait votes" ON trait_votes FOR SELECT USING (true);
CREATE POLICY "Anyone can insert trait votes" ON trait_votes FOR INSERT WITH CHECK (true);

-- ============================================================================
-- PART 5: VIEWS
-- ============================================================================

-- Daily puzzle stats
CREATE OR REPLACE VIEW daily_puzzle_stats AS
SELECT 
  p.id as puzzle_id,
  p.date,
  p.category,
  p.answer,
  COUNT(gr.id) as total_plays,
  COUNT(CASE WHEN gr.won = true THEN 1 END) as total_wins,
  ROUND(
    COUNT(CASE WHEN gr.won = true THEN 1 END)::numeric / 
    NULLIF(COUNT(gr.id), 0) * 100, 
    1
  ) as win_rate,
  ROUND(AVG(CASE WHEN gr.won = true THEN gr.time_spent END)::numeric, 1) as avg_win_time,
  ROUND(AVG(CASE WHEN gr.won = true THEN gr.incorrect_count END)::numeric, 2) as avg_incorrect
FROM puzzles p
LEFT JOIN game_results gr ON p.id = gr.puzzle_id
GROUP BY p.id, p.date, p.category, p.answer;

-- Puzzle leaderboard
CREATE OR REPLACE VIEW puzzle_leaderboard AS
SELECT 
  gr.id,
  gr.puzzle_id,
  gr.player_id,
  gr.mode,
  gr.time_spent,
  gr.incorrect_count,
  gr.created_at,
  p.date as puzzle_date,
  p.category,
  ROW_NUMBER() OVER (
    PARTITION BY gr.puzzle_id 
    ORDER BY gr.incorrect_count ASC, gr.time_spent ASC
  ) as rank
FROM game_results gr
JOIN puzzles p ON gr.puzzle_id = p.id
WHERE gr.won = true;

-- Upcoming puzzles with vote status
CREATE OR REPLACE VIEW upcoming_puzzle_votes AS
SELECT 
  p.id as puzzle_id,
  p.date,
  p.category,
  p.answer,
  COUNT(ct.id) as total_candidates,
  COALESCE(SUM(ct.vote_count), 0) as total_votes,
  COUNT(CASE WHEN ct.is_selected THEN 1 END) as selected_count,
  p.date - CURRENT_DATE as days_until_live
FROM puzzles p
LEFT JOIN candidate_traits ct ON p.id = ct.puzzle_id
WHERE p.date > CURRENT_DATE
GROUP BY p.id, p.date, p.category, p.answer
ORDER BY p.date;

-- Candidate traits ranked by votes
CREATE OR REPLACE VIEW candidate_traits_ranked AS
SELECT 
  ct.id,
  ct.puzzle_id,
  p.answer,
  p.date as puzzle_date,
  ct.word,
  ct.vote_count,
  ct.is_selected,
  ROW_NUMBER() OVER (PARTITION BY ct.puzzle_id ORDER BY ct.vote_count DESC) as rank
FROM candidate_traits ct
JOIN puzzles p ON ct.puzzle_id = p.id
ORDER BY p.date, ct.vote_count DESC;

-- ============================================================================
-- PART 6: FUNCTIONS
-- ============================================================================

-- Get today's leaderboard
CREATE OR REPLACE FUNCTION get_todays_leaderboard(
  p_category VARCHAR DEFAULT NULL,
  p_limit INT DEFAULT 20
)
RETURNS TABLE (
  id UUID,
  player_id VARCHAR,
  mode VARCHAR,
  time_spent INT,
  incorrect_count INT,
  created_at TIMESTAMP,
  rank BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    pl.id,
    pl.player_id,
    pl.mode,
    pl.time_spent,
    pl.incorrect_count,
    pl.created_at,
    pl.rank
  FROM puzzle_leaderboard pl
  WHERE pl.puzzle_date = CURRENT_DATE
    AND (p_category IS NULL OR pl.category = p_category)
  ORDER BY pl.rank
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Get daily stats
CREATE OR REPLACE FUNCTION get_daily_stats(
  p_date DATE DEFAULT CURRENT_DATE,
  p_category VARCHAR DEFAULT NULL
)
RETURNS TABLE (
  puzzle_id UUID,
  category VARCHAR,
  answer VARCHAR,
  total_plays BIGINT,
  total_wins BIGINT,
  win_rate NUMERIC,
  avg_win_time NUMERIC,
  avg_incorrect NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    dps.puzzle_id,
    dps.category,
    dps.answer,
    dps.total_plays,
    dps.total_wins,
    dps.win_rate,
    dps.avg_win_time,
    dps.avg_incorrect
  FROM daily_puzzle_stats dps
  WHERE dps.date = p_date
    AND (p_category IS NULL OR dps.category = p_category);
END;
$$ LANGUAGE plpgsql;

-- Get random trait pair for voting (only future puzzles!)
CREATE OR REPLACE FUNCTION get_trait_pair_for_voting(p_player_id VARCHAR DEFAULT NULL)
RETURNS TABLE (
  puzzle_id UUID,
  answer VARCHAR,
  category VARCHAR,
  puzzle_date DATE,
  trait_a_id UUID,
  trait_a_word VARCHAR,
  trait_a_votes INT,
  trait_b_id UUID,
  trait_b_word VARCHAR,
  trait_b_votes INT
) AS $$
DECLARE
  v_puzzle_id UUID;
  v_answer VARCHAR;
  v_category VARCHAR;
  v_puzzle_date DATE;
BEGIN
  -- Find an upcoming puzzle (TOMORROW or later - excludes today!)
  SELECT p.id, p.answer, p.category, p.date
  INTO v_puzzle_id, v_answer, v_category, v_puzzle_date
  FROM puzzles p
  WHERE p.date > CURRENT_DATE
    AND p.date <= CURRENT_DATE + INTERVAL '30 days'
    AND EXISTS (SELECT 1 FROM candidate_traits ct WHERE ct.puzzle_id = p.id)
  ORDER BY p.date ASC, RANDOM()
  LIMIT 1;

  IF v_puzzle_id IS NULL THEN
    RETURN;
  END IF;

  RETURN QUERY
  WITH random_traits AS (
    SELECT ct.id, ct.word, ct.vote_count
    FROM candidate_traits ct
    WHERE ct.puzzle_id = v_puzzle_id
    ORDER BY RANDOM()
    LIMIT 2
  )
  SELECT 
    v_puzzle_id,
    v_answer,
    v_category,
    v_puzzle_date,
    (SELECT id FROM random_traits LIMIT 1 OFFSET 0),
    (SELECT word FROM random_traits LIMIT 1 OFFSET 0),
    (SELECT vote_count FROM random_traits LIMIT 1 OFFSET 0),
    (SELECT id FROM random_traits LIMIT 1 OFFSET 1),
    (SELECT word FROM random_traits LIMIT 1 OFFSET 1),
    (SELECT vote_count FROM random_traits LIMIT 1 OFFSET 1);
END;
$$ LANGUAGE plpgsql;

-- Submit a trait vote
CREATE OR REPLACE FUNCTION submit_trait_vote(
  p_puzzle_id UUID,
  p_winner_trait_id UUID,
  p_loser_trait_id UUID,
  p_player_id VARCHAR DEFAULT NULL
)
RETURNS BOOLEAN AS $$
BEGIN
  INSERT INTO trait_votes (puzzle_id, winner_trait_id, loser_trait_id, player_id)
  VALUES (p_puzzle_id, p_winner_trait_id, p_loser_trait_id, p_player_id);
  
  UPDATE candidate_traits
  SET vote_count = vote_count + 1
  WHERE id = p_winner_trait_id;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Finalize puzzle traits (optional - game auto-selects top 5)
CREATE OR REPLACE FUNCTION finalize_puzzle_traits(p_puzzle_id UUID)
RETURNS VOID AS $$
DECLARE
  v_trait RECORD;
  v_slot INT := 1;
BEGIN
  DELETE FROM traits WHERE puzzle_id = p_puzzle_id;
  UPDATE candidate_traits SET is_selected = FALSE WHERE puzzle_id = p_puzzle_id;
  
  FOR v_trait IN 
    SELECT id, word 
    FROM candidate_traits 
    WHERE puzzle_id = p_puzzle_id
    ORDER BY vote_count DESC, RANDOM()
    LIMIT 5
  LOOP
    INSERT INTO traits (puzzle_id, slot_position, keyword)
    VALUES (p_puzzle_id, v_slot, v_trait.word);
    
    UPDATE candidate_traits SET is_selected = TRUE WHERE id = v_trait.id;
    v_slot := v_slot + 1;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- PART 7: SAMPLE DATA - May 7, 2026 (with fixed traits)
-- ============================================================================

INSERT INTO puzzles (date, category, answer) VALUES
('2026-05-07', 'jobs', 'FIREFIGHTER'),
('2026-05-07', 'movies', 'INCEPTION'),
('2026-05-07', 'games', 'ZELDA')
ON CONFLICT (date, category) DO NOTHING;

-- FIREFIGHTER traits
INSERT INTO traits (puzzle_id, slot_position, keyword) 
SELECT id, 1, 'brave' FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword) 
SELECT id, 2, 'strong' FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword) 
SELECT id, 3, 'calm' FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword) 
SELECT id, 4, 'selfless' FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword) 
SELECT id, 5, 'quick' FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07' ON CONFLICT DO NOTHING;

-- INCEPTION traits
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 1, 'complex' FROM puzzles WHERE answer = 'INCEPTION' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 2, 'surreal' FROM puzzles WHERE answer = 'INCEPTION' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 3, 'thrilling' FROM puzzles WHERE answer = 'INCEPTION' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 4, 'cerebral' FROM puzzles WHERE answer = 'INCEPTION' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 5, 'ambitious' FROM puzzles WHERE answer = 'INCEPTION' AND date = '2026-05-07' ON CONFLICT DO NOTHING;

-- ZELDA traits
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 1, 'adventurous' FROM puzzles WHERE answer = 'ZELDA' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 2, 'magical' FROM puzzles WHERE answer = 'ZELDA' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 3, 'challenging' FROM puzzles WHERE answer = 'ZELDA' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 4, 'nostalgic' FROM puzzles WHERE answer = 'ZELDA' AND date = '2026-05-07' ON CONFLICT DO NOTHING;
INSERT INTO traits (puzzle_id, slot_position, keyword)
SELECT id, 5, 'epic' FROM puzzles WHERE answer = 'ZELDA' AND date = '2026-05-07' ON CONFLICT DO NOTHING;

-- Synonyms for FIREFIGHTER
INSERT INTO synonyms (trait_id, word)
SELECT t.id, s.word FROM traits t, (VALUES ('courageous'), ('fearless'), ('heroic')) AS s(word)
WHERE t.keyword = 'brave' AND t.puzzle_id = (SELECT id FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07')
ON CONFLICT DO NOTHING;

INSERT INTO synonyms (trait_id, word)
SELECT t.id, s.word FROM traits t, (VALUES ('powerful'), ('fit'), ('athletic')) AS s(word)
WHERE t.keyword = 'strong' AND t.puzzle_id = (SELECT id FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07')
ON CONFLICT DO NOTHING;

INSERT INTO synonyms (trait_id, word)
SELECT t.id, s.word FROM traits t, (VALUES ('composed'), ('collected'), ('steady')) AS s(word)
WHERE t.keyword = 'calm' AND t.puzzle_id = (SELECT id FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07')
ON CONFLICT DO NOTHING;

INSERT INTO synonyms (trait_id, word)
SELECT t.id, s.word FROM traits t, (VALUES ('altruistic'), ('generous')) AS s(word)
WHERE t.keyword = 'selfless' AND t.puzzle_id = (SELECT id FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07')
ON CONFLICT DO NOTHING;

INSERT INTO synonyms (trait_id, word)
SELECT t.id, s.word FROM traits t, (VALUES ('fast'), ('agile'), ('swift')) AS s(word)
WHERE t.keyword = 'quick' AND t.puzzle_id = (SELECT id FROM puzzles WHERE answer = 'FIREFIGHTER' AND date = '2026-05-07')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- PART 8: 30 DAYS OF PUZZLES (May 8 - June 6, 2026)
-- ============================================================================


-- JOBS PUZZLES
INSERT INTO puzzles (date, category, answer) VALUES
('2026-05-08', 'jobs', 'NURSE'),
('2026-05-09', 'jobs', 'PILOT'),
('2026-05-10', 'jobs', 'CHEF'),
('2026-05-11', 'jobs', 'TEACHER'),
('2026-05-12', 'jobs', 'DETECTIVE'),
('2026-05-13', 'jobs', 'SURGEON'),
('2026-05-14', 'jobs', 'ASTRONAUT'),
('2026-05-15', 'jobs', 'LAWYER'),
('2026-05-16', 'jobs', 'ARCHITECT'),
('2026-05-17', 'jobs', 'JOURNALIST'),
('2026-05-18', 'jobs', 'VETERINARIAN'),
('2026-05-19', 'jobs', 'ELECTRICIAN'),
('2026-05-20', 'jobs', 'PSYCHOLOGIST'),
('2026-05-21', 'jobs', 'PARAMEDIC'),
('2026-05-22', 'jobs', 'SCIENTIST'),
('2026-05-23', 'jobs', 'MUSICIAN'),
('2026-05-24', 'jobs', 'PHOTOGRAPHER'),
('2026-05-25', 'jobs', 'PLUMBER'),
('2026-05-26', 'jobs', 'ACCOUNTANT'),
('2026-05-27', 'jobs', 'LIFEGUARD'),
('2026-05-28', 'jobs', 'MECHANIC'),
('2026-05-29', 'jobs', 'DENTIST'),
('2026-05-30', 'jobs', 'BARTENDER'),
('2026-05-31', 'jobs', 'FARMER'),
('2026-06-01', 'jobs', 'ACTOR'),
('2026-06-02', 'jobs', 'LIBRARIAN'),
('2026-06-03', 'jobs', 'COACH'),
('2026-06-04', 'jobs', 'PROGRAMMER'),
('2026-06-05', 'jobs', 'THERAPIST'),
('2026-06-06', 'jobs', 'SOLDIER')
ON CONFLICT (date, category) DO NOTHING;

-- MOVIES PUZZLES
INSERT INTO puzzles (date, category, answer) VALUES
('2026-05-08', 'movies', 'TITANIC'),
('2026-05-09', 'movies', 'JAWS'),
('2026-05-10', 'movies', 'AVATAR'),
('2026-05-11', 'movies', 'FROZEN'),
('2026-05-12', 'movies', 'MATRIX'),
('2026-05-13', 'movies', 'GLADIATOR'),
('2026-05-14', 'movies', 'INTERSTELLAR'),
('2026-05-15', 'movies', 'JOKER'),
('2026-05-16', 'movies', 'PSYCHO'),
('2026-05-17', 'movies', 'ROCKY'),
('2026-05-18', 'movies', 'ALIEN'),
('2026-05-19', 'movies', 'SHREK'),
('2026-05-20', 'movies', 'GRAVITY'),
('2026-05-21', 'movies', 'COCO'),
('2026-05-22', 'movies', 'JUNO'),
('2026-05-23', 'movies', 'WHIPLASH'),
('2026-05-24', 'movies', 'ARRIVAL'),
('2026-05-25', 'movies', 'PARASITE'),
('2026-05-26', 'movies', 'SPOTLIGHT'),
('2026-05-27', 'movies', 'DUNKIRK'),
('2026-05-28', 'movies', 'MOONLIGHT'),
('2026-05-29', 'movies', 'HEREDITARY'),
('2026-05-30', 'movies', 'RATATOUILLE'),
('2026-05-31', 'movies', 'MEMENTO'),
('2026-06-01', 'movies', 'AMELIE'),
('2026-06-02', 'movies', 'OLDBOY'),
('2026-06-03', 'movies', 'DRIVE'),
('2026-06-04', 'movies', 'ZODIAC'),
('2026-06-05', 'movies', 'CASINO'),
('2026-06-06', 'movies', 'HEAT')
ON CONFLICT (date, category) DO NOTHING;

-- GAMES PUZZLES
INSERT INTO puzzles (date, category, answer) VALUES
('2026-05-08', 'games', 'MINECRAFT'),
('2026-05-09', 'games', 'FORTNITE'),
('2026-05-10', 'games', 'TETRIS'),
('2026-05-11', 'games', 'MARIO'),
('2026-05-12', 'games', 'SKYRIM'),
('2026-05-13', 'games', 'HALO'),
('2026-05-14', 'games', 'PORTAL'),
('2026-05-15', 'games', 'DOOM'),
('2026-05-16', 'games', 'SIMS'),
('2026-05-17', 'games', 'POKEMON'),
('2026-05-18', 'games', 'BIOSHOCK'),
('2026-05-19', 'games', 'OVERWATCH'),
('2026-05-20', 'games', 'WITCHER'),
('2026-05-21', 'games', 'UNDERTALE'),
('2026-05-22', 'games', 'CELESTE'),
('2026-05-23', 'games', 'CUPHEAD'),
('2026-05-24', 'games', 'STARDEW'),
('2026-05-25', 'games', 'TERRARIA'),
('2026-05-26', 'games', 'VALORANT'),
('2026-05-27', 'games', 'APEX'),
('2026-05-28', 'games', 'SEKIRO'),
('2026-05-29', 'games', 'BLOODBORNE'),
('2026-05-30', 'games', 'HOLLOW'),
('2026-05-31', 'games', 'HADES'),
('2026-06-01', 'games', 'FACTORIO'),
('2026-06-02', 'games', 'RIMWORLD'),
('2026-06-03', 'games', 'SUBNAUTICA'),
('2026-06-04', 'games', 'RUST'),
('2026-06-05', 'games', 'TARKOV'),
('2026-06-06', 'games', 'ELDENRING')
ON CONFLICT (date, category) DO NOTHING;

-- ============================================================================
-- PART 9: CANDIDATE TRAITS FOR JOBS
-- ============================================================================

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['caring', 'patient', 'compassionate', 'skilled', 'attentive', 'dedicated', 'empathetic', 'calm', 'knowledgeable', 'resilient', 'gentle', 'organized', 'tireless', 'nurturing'])
FROM puzzles WHERE answer = 'NURSE' AND date = '2026-05-08' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['focused', 'calm', 'precise', 'confident', 'skilled', 'alert', 'responsible', 'decisive', 'trained', 'composed', 'professional', 'sharp', 'reliable', 'steady'])
FROM puzzles WHERE answer = 'PILOT' AND date = '2026-05-09' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'passionate', 'precise', 'organized', 'fast', 'skilled', 'artistic', 'dedicated', 'perfectionist', 'innovative', 'disciplined', 'tasteful', 'intense', 'hardworking'])
FROM puzzles WHERE answer = 'CHEF' AND date = '2026-05-10' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'inspiring', 'knowledgeable', 'caring', 'dedicated', 'creative', 'encouraging', 'organized', 'passionate', 'understanding', 'supportive', 'adaptable', 'motivating', 'wise'])
FROM puzzles WHERE answer = 'TEACHER' AND date = '2026-05-11' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['observant', 'analytical', 'persistent', 'clever', 'intuitive', 'thorough', 'patient', 'logical', 'curious', 'determined', 'sharp', 'methodical', 'skeptical', 'resourceful'])
FROM puzzles WHERE answer = 'DETECTIVE' AND date = '2026-05-12' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'steady', 'focused', 'skilled', 'calm', 'confident', 'meticulous', 'dedicated', 'intelligent', 'composed', 'decisive', 'disciplined', 'tireless', 'perfectionist'])
FROM puzzles WHERE answer = 'SURGEON' AND date = '2026-05-13' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'intelligent', 'disciplined', 'adventurous', 'resilient', 'calm', 'curious', 'fit', 'dedicated', 'fearless', 'skilled', 'adaptable', 'pioneering', 'determined'])
FROM puzzles WHERE answer = 'ASTRONAUT' AND date = '2026-05-14' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'analytical', 'articulate', 'sharp', 'confident', 'logical', 'thorough', 'strategic', 'knowledgeable', 'argumentative', 'persistent', 'clever', 'professional', 'ambitious'])
FROM puzzles WHERE answer = 'LAWYER' AND date = '2026-05-15' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'visionary', 'precise', 'artistic', 'technical', 'innovative', 'detail-oriented', 'imaginative', 'practical', 'skilled', 'patient', 'analytical', 'aesthetic', 'ambitious'])
FROM puzzles WHERE answer = 'ARCHITECT' AND date = '2026-05-16' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'persistent', 'objective', 'articulate', 'brave', 'investigative', 'ethical', 'observant', 'quick', 'resourceful', 'skeptical', 'dedicated', 'informed', 'tenacious'])
FROM puzzles WHERE answer = 'JOURNALIST' AND date = '2026-05-17' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['compassionate', 'gentle', 'patient', 'skilled', 'caring', 'knowledgeable', 'calm', 'dedicated', 'loving', 'observant', 'empathetic', 'thorough', 'nurturing', 'kind'])
FROM puzzles WHERE answer = 'VETERINARIAN' AND date = '2026-05-18' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'careful', 'precise', 'knowledgeable', 'practical', 'reliable', 'technical', 'patient', 'methodical', 'safety-conscious', 'experienced', 'logical', 'handy', 'focused'])
FROM puzzles WHERE answer = 'ELECTRICIAN' AND date = '2026-05-19' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['empathetic', 'patient', 'insightful', 'understanding', 'analytical', 'compassionate', 'observant', 'calm', 'wise', 'supportive', 'perceptive', 'thoughtful', 'trustworthy', 'caring'])
FROM puzzles WHERE answer = 'PSYCHOLOGIST' AND date = '2026-05-20' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['quick', 'calm', 'skilled', 'brave', 'decisive', 'compassionate', 'resilient', 'focused', 'trained', 'dedicated', 'strong', 'alert', 'composed', 'heroic'])
FROM puzzles WHERE answer = 'PARAMEDIC' AND date = '2026-05-21' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'analytical', 'methodical', 'intelligent', 'patient', 'precise', 'innovative', 'dedicated', 'logical', 'observant', 'thorough', 'skeptical', 'persistent', 'brilliant'])
FROM puzzles WHERE answer = 'SCIENTIST' AND date = '2026-05-22' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'passionate', 'talented', 'expressive', 'dedicated', 'artistic', 'disciplined', 'emotional', 'skilled', 'imaginative', 'sensitive', 'rhythmic', 'inspired', 'gifted'])
FROM puzzles WHERE answer = 'MUSICIAN' AND date = '2026-05-23' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'observant', 'artistic', 'patient', 'technical', 'passionate', 'detail-oriented', 'imaginative', 'skilled', 'perceptive', 'adventurous', 'visual', 'dedicated', 'aesthetic'])
FROM puzzles WHERE answer = 'PHOTOGRAPHER' AND date = '2026-05-24' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'practical', 'reliable', 'patient', 'experienced', 'handy', 'problem-solving', 'knowledgeable', 'hardworking', 'thorough', 'technical', 'resourceful', 'strong', 'dedicated'])
FROM puzzles WHERE answer = 'PLUMBER' AND date = '2026-05-25' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'organized', 'analytical', 'detail-oriented', 'methodical', 'reliable', 'thorough', 'logical', 'patient', 'accurate', 'trustworthy', 'professional', 'meticulous', 'focused'])
FROM puzzles WHERE answer = 'ACCOUNTANT' AND date = '2026-05-26' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['alert', 'fit', 'brave', 'quick', 'responsible', 'vigilant', 'strong', 'trained', 'calm', 'athletic', 'watchful', 'decisive', 'heroic', 'dedicated'])
FROM puzzles WHERE answer = 'LIFEGUARD' AND date = '2026-05-27' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'practical', 'knowledgeable', 'patient', 'technical', 'experienced', 'handy', 'problem-solving', 'thorough', 'reliable', 'dedicated', 'precise', 'hardworking', 'resourceful'])
FROM puzzles WHERE answer = 'MECHANIC' AND date = '2026-05-28' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'gentle', 'patient', 'skilled', 'calm', 'meticulous', 'professional', 'steady', 'caring', 'thorough', 'knowledgeable', 'reassuring', 'detail-oriented', 'dedicated'])
FROM puzzles WHERE answer = 'DENTIST' AND date = '2026-05-29' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['friendly', 'quick', 'social', 'skilled', 'attentive', 'charming', 'patient', 'creative', 'observant', 'personable', 'entertaining', 'reliable', 'multitasking', 'charismatic'])
FROM puzzles WHERE answer = 'BARTENDER' AND date = '2026-05-30' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['hardworking', 'patient', 'dedicated', 'resilient', 'practical', 'knowledgeable', 'early-rising', 'strong', 'resourceful', 'persistent', 'weathered', 'traditional', 'nurturing', 'independent'])
FROM puzzles WHERE answer = 'FARMER' AND date = '2026-05-31' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['expressive', 'creative', 'emotional', 'charismatic', 'versatile', 'dedicated', 'confident', 'talented', 'dramatic', 'passionate', 'imaginative', 'bold', 'captivating', 'transformative'])
FROM puzzles WHERE answer = 'ACTOR' AND date = '2026-06-01' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'quiet', 'knowledgeable', 'helpful', 'patient', 'bookish', 'detail-oriented', 'resourceful', 'calm', 'intellectual', 'dedicated', 'curious', 'methodical', 'welcoming'])
FROM puzzles WHERE answer = 'LIBRARIAN' AND date = '2026-06-02' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['motivating', 'inspiring', 'dedicated', 'strategic', 'patient', 'encouraging', 'disciplined', 'passionate', 'supportive', 'demanding', 'experienced', 'wise', 'energetic', 'competitive'])
FROM puzzles WHERE answer = 'COACH' AND date = '2026-06-03' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['logical', 'analytical', 'patient', 'creative', 'detail-oriented', 'problem-solving', 'focused', 'persistent', 'technical', 'curious', 'methodical', 'innovative', 'dedicated', 'precise'])
FROM puzzles WHERE answer = 'PROGRAMMER' AND date = '2026-06-04' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['empathetic', 'patient', 'understanding', 'compassionate', 'calm', 'supportive', 'insightful', 'trustworthy', 'caring', 'wise', 'perceptive', 'gentle', 'non-judgmental', 'dedicated'])
FROM puzzles WHERE answer = 'THERAPIST' AND date = '2026-06-05' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'disciplined', 'loyal', 'strong', 'dedicated', 'courageous', 'resilient', 'trained', 'patriotic', 'selfless', 'tough', 'obedient', 'fearless', 'honorable'])
FROM puzzles WHERE answer = 'SOLDIER' AND date = '2026-06-06' ON CONFLICT DO NOTHING;


-- ============================================================================
-- PART 10: CANDIDATE TRAITS FOR MOVIES
-- ============================================================================

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['romantic', 'tragic', 'epic', 'emotional', 'dramatic', 'beautiful', 'heartbreaking', 'lavish', 'sweeping', 'iconic', 'timeless', 'devastating', 'grand', 'tearful'])
FROM puzzles WHERE answer = 'TITANIC' AND date = '2026-05-08' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['terrifying', 'suspenseful', 'thrilling', 'iconic', 'tense', 'scary', 'gripping', 'classic', 'intense', 'menacing', 'legendary', 'nerve-wracking', 'chilling', 'masterful'])
FROM puzzles WHERE answer = 'JAWS' AND date = '2026-05-09' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['visually-stunning', 'immersive', 'epic', 'colorful', 'groundbreaking', 'fantastical', 'beautiful', 'ambitious', 'spectacular', 'alien', 'lush', 'revolutionary', 'breathtaking', 'imaginative'])
FROM puzzles WHERE answer = 'AVATAR' AND date = '2026-05-10' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['magical', 'heartwarming', 'musical', 'enchanting', 'colorful', 'emotional', 'family-friendly', 'catchy', 'beautiful', 'sisterly', 'icy', 'uplifting', 'animated', 'charming'])
FROM puzzles WHERE answer = 'FROZEN' AND date = '2026-05-11' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['mind-bending', 'revolutionary', 'philosophical', 'action-packed', 'stylish', 'iconic', 'futuristic', 'thought-provoking', 'groundbreaking', 'dark', 'cyberpunk', 'innovative', 'complex', 'cool'])
FROM puzzles WHERE answer = 'MATRIX' AND date = '2026-05-12' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['epic', 'brutal', 'emotional', 'powerful', 'heroic', 'dramatic', 'intense', 'vengeful', 'grand', 'violent', 'inspiring', 'tragic', 'triumphant', 'historical'])
FROM puzzles WHERE answer = 'GLADIATOR' AND date = '2026-05-13' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['epic', 'emotional', 'mind-bending', 'ambitious', 'beautiful', 'thought-provoking', 'scientific', 'heartfelt', 'grand', 'complex', 'stunning', 'profound', 'cosmic', 'tearful'])
FROM puzzles WHERE answer = 'INTERSTELLAR' AND date = '2026-05-14' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['dark', 'disturbing', 'intense', 'psychological', 'gritty', 'unsettling', 'powerful', 'tragic', 'raw', 'haunting', 'provocative', 'bleak', 'compelling', 'twisted'])
FROM puzzles WHERE answer = 'JOKER' AND date = '2026-05-15' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['terrifying', 'suspenseful', 'iconic', 'shocking', 'psychological', 'classic', 'twisted', 'masterful', 'chilling', 'groundbreaking', 'disturbing', 'tense', 'legendary', 'noir'])
FROM puzzles WHERE answer = 'PSYCHO' AND date = '2026-05-16' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['inspiring', 'underdog', 'emotional', 'triumphant', 'gritty', 'motivating', 'heartfelt', 'classic', 'powerful', 'uplifting', 'determined', 'iconic', 'raw', 'hopeful'])
FROM puzzles WHERE answer = 'ROCKY' AND date = '2026-05-17' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['terrifying', 'claustrophobic', 'suspenseful', 'iconic', 'dark', 'intense', 'atmospheric', 'groundbreaking', 'scary', 'tense', 'masterful', 'chilling', 'sci-fi', 'horrifying'])
FROM puzzles WHERE answer = 'ALIEN' AND date = '2026-05-18' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['funny', 'irreverent', 'heartwarming', 'clever', 'animated', 'satirical', 'charming', 'witty', 'family-friendly', 'entertaining', 'colorful', 'hilarious', 'subversive', 'lovable'])
FROM puzzles WHERE answer = 'SHREK' AND date = '2026-05-19' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['intense', 'breathtaking', 'claustrophobic', 'stunning', 'tense', 'immersive', 'terrifying', 'beautiful', 'gripping', 'visceral', 'survival', 'isolating', 'spectacular', 'harrowing'])
FROM puzzles WHERE answer = 'GRAVITY' AND date = '2026-05-20' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['heartwarming', 'colorful', 'emotional', 'beautiful', 'musical', 'touching', 'family-oriented', 'vibrant', 'tearful', 'cultural', 'magical', 'uplifting', 'animated', 'memorable'])
FROM puzzles WHERE answer = 'COCO' AND date = '2026-05-21' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['quirky', 'heartfelt', 'witty', 'charming', 'indie', 'touching', 'funny', 'honest', 'sweet', 'clever', 'relatable', 'warm', 'offbeat', 'genuine'])
FROM puzzles WHERE answer = 'JUNO' AND date = '2026-05-22' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['intense', 'gripping', 'relentless', 'powerful', 'musical', 'driven', 'brutal', 'perfectionist', 'tense', 'exhausting', 'brilliant', 'obsessive', 'demanding', 'electrifying'])
FROM puzzles WHERE answer = 'WHIPLASH' AND date = '2026-05-23' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['thought-provoking', 'emotional', 'intelligent', 'beautiful', 'cerebral', 'mysterious', 'profound', 'slow-burn', 'atmospheric', 'touching', 'philosophical', 'haunting', 'poetic', 'mind-bending'])
FROM puzzles WHERE answer = 'ARRIVAL' AND date = '2026-05-24' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brilliant', 'twisty', 'dark', 'satirical', 'suspenseful', 'shocking', 'clever', 'unpredictable', 'masterful', 'social', 'gripping', 'intense', 'layered', 'provocative'])
FROM puzzles WHERE answer = 'PARASITE' AND date = '2026-05-25' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['gripping', 'important', 'investigative', 'powerful', 'sobering', 'compelling', 'journalistic', 'intense', 'true', 'disturbing', 'riveting', 'impactful', 'serious', 'necessary'])
FROM puzzles WHERE answer = 'SPOTLIGHT' AND date = '2026-05-26' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['intense', 'immersive', 'tense', 'visceral', 'epic', 'harrowing', 'survival', 'atmospheric', 'relentless', 'stunning', 'gripping', 'historical', 'masterful', 'overwhelming'])
FROM puzzles WHERE answer = 'DUNKIRK' AND date = '2026-05-27' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['beautiful', 'intimate', 'poetic', 'emotional', 'quiet', 'powerful', 'tender', 'profound', 'lyrical', 'touching', 'understated', 'heartbreaking', 'artistic', 'moving'])
FROM puzzles WHERE answer = 'MOONLIGHT' AND date = '2026-05-28' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['terrifying', 'disturbing', 'unsettling', 'dread-filled', 'psychological', 'horrifying', 'intense', 'dark', 'traumatic', 'shocking', 'atmospheric', 'nightmarish', 'haunting', 'devastating'])
FROM puzzles WHERE answer = 'HEREDITARY' AND date = '2026-05-29' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['charming', 'heartwarming', 'delicious', 'inspiring', 'animated', 'creative', 'funny', 'beautiful', 'uplifting', 'artistic', 'whimsical', 'touching', 'colorful', 'culinary'])
FROM puzzles WHERE answer = 'RATATOUILLE' AND date = '2026-05-30' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['mind-bending', 'confusing', 'clever', 'noir', 'innovative', 'psychological', 'twisty', 'fragmented', 'mysterious', 'gripping', 'dark', 'brilliant', 'disorienting', 'complex'])
FROM puzzles WHERE answer = 'MEMENTO' AND date = '2026-05-31' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['whimsical', 'charming', 'romantic', 'quirky', 'colorful', 'magical', 'heartwarming', 'french', 'delightful', 'imaginative', 'playful', 'enchanting', 'sweet', 'artistic'])
FROM puzzles WHERE answer = 'AMELIE' AND date = '2026-06-01' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['shocking', 'brutal', 'twisted', 'intense', 'dark', 'revenge-driven', 'disturbing', 'violent', 'gripping', 'mysterious', 'unforgettable', 'stylish', 'devastating', 'provocative'])
FROM puzzles WHERE answer = 'OLDBOY' AND date = '2026-06-02' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['stylish', 'cool', 'violent', 'atmospheric', 'quiet', 'neon', 'intense', 'moody', 'sleek', 'brutal', 'hypnotic', 'minimalist', 'retro', 'tense'])
FROM puzzles WHERE answer = 'DRIVE' AND date = '2026-06-03' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['obsessive', 'meticulous', 'unsettling', 'procedural', 'gripping', 'atmospheric', 'haunting', 'slow-burn', 'mysterious', 'chilling', 'detailed', 'frustrating', 'compelling', 'dark'])
FROM puzzles WHERE answer = 'ZODIAC' AND date = '2026-06-04' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['glamorous', 'violent', 'epic', 'stylish', 'excessive', 'dramatic', 'flashy', 'intense', 'corrupt', 'lavish', 'brutal', 'ambitious', 'decadent', 'gripping'])
FROM puzzles WHERE answer = 'CASINO' AND date = '2026-06-05' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['intense', 'epic', 'stylish', 'professional', 'gripping', 'atmospheric', 'methodical', 'tense', 'masterful', 'cool', 'dramatic', 'violent', 'iconic', 'riveting'])
FROM puzzles WHERE answer = 'HEAT' AND date = '2026-06-06' ON CONFLICT DO NOTHING;


-- ============================================================================
-- PART 11: CANDIDATE TRAITS FOR GAMES
-- ============================================================================

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'blocky', 'endless', 'relaxing', 'addictive', 'sandbox', 'pixelated', 'imaginative', 'survival', 'peaceful', 'building', 'exploratory', 'open-world', 'crafting'])
FROM puzzles WHERE answer = 'MINECRAFT' AND date = '2026-05-08' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['competitive', 'colorful', 'fast-paced', 'social', 'building', 'chaotic', 'trendy', 'addictive', 'cartoonish', 'intense', 'popular', 'dynamic', 'strategic', 'youthful'])
FROM puzzles WHERE answer = 'FORTNITE' AND date = '2026-05-09' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['addictive', 'simple', 'classic', 'satisfying', 'timeless', 'puzzle', 'hypnotic', 'challenging', 'iconic', 'minimalist', 'relaxing', 'strategic', 'endless', 'retro'])
FROM puzzles WHERE answer = 'TETRIS' AND date = '2026-05-10' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['colorful', 'fun', 'classic', 'platforming', 'cheerful', 'iconic', 'family-friendly', 'challenging', 'nostalgic', 'adventurous', 'timeless', 'joyful', 'creative', 'legendary'])
FROM puzzles WHERE answer = 'MARIO' AND date = '2026-05-11' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['epic', 'immersive', 'vast', 'open-world', 'fantasy', 'adventurous', 'atmospheric', 'modded', 'legendary', 'exploration', 'freedom', 'medieval', 'magical', 'endless'])
FROM puzzles WHERE answer = 'SKYRIM' AND date = '2026-05-12' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['epic', 'sci-fi', 'iconic', 'multiplayer', 'legendary', 'action-packed', 'futuristic', 'competitive', 'heroic', 'intense', 'cinematic', 'strategic', 'immersive', 'classic'])
FROM puzzles WHERE answer = 'HALO' AND date = '2026-05-13' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['clever', 'puzzle', 'witty', 'innovative', 'mind-bending', 'funny', 'short', 'brilliant', 'unique', 'satisfying', 'dark-humored', 'creative', 'challenging', 'memorable'])
FROM puzzles WHERE answer = 'PORTAL' AND date = '2026-05-14' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brutal', 'fast', 'intense', 'violent', 'iconic', 'metal', 'relentless', 'gory', 'adrenaline', 'classic', 'demonic', 'powerful', 'aggressive', 'legendary'])
FROM puzzles WHERE answer = 'DOOM' AND date = '2026-05-15' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'addictive', 'life-simulation', 'relaxing', 'social', 'customizable', 'endless', 'quirky', 'sandbox', 'entertaining', 'domestic', 'humorous', 'detailed', 'escapist'])
FROM puzzles WHERE answer = 'SIMS' AND date = '2026-05-16' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['nostalgic', 'collecting', 'colorful', 'adventurous', 'strategic', 'iconic', 'cute', 'addictive', 'friendly', 'exploration', 'battling', 'legendary', 'charming', 'timeless'])
FROM puzzles WHERE answer = 'POKEMON' AND date = '2026-05-17' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['atmospheric', 'philosophical', 'immersive', 'dark', 'narrative', 'underwater', 'dystopian', 'thought-provoking', 'haunting', 'artistic', 'mysterious', 'intense', 'unique', 'memorable'])
FROM puzzles WHERE answer = 'BIOSHOCK' AND date = '2026-05-18' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['colorful', 'team-based', 'competitive', 'fast-paced', 'diverse', 'strategic', 'polished', 'chaotic', 'hero-based', 'social', 'dynamic', 'stylish', 'accessible', 'intense'])
FROM puzzles WHERE answer = 'OVERWATCH' AND date = '2026-05-19' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['epic', 'narrative', 'dark', 'immersive', 'mature', 'fantasy', 'atmospheric', 'complex', 'beautiful', 'choice-driven', 'vast', 'legendary', 'emotional', 'detailed'])
FROM puzzles WHERE answer = 'WITCHER' AND date = '2026-05-20' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['heartfelt', 'quirky', 'emotional', 'retro', 'unique', 'funny', 'touching', 'subversive', 'memorable', 'charming', 'indie', 'creative', 'surprising', 'wholesome'])
FROM puzzles WHERE answer = 'UNDERTALE' AND date = '2026-05-21' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['challenging', 'emotional', 'precise', 'beautiful', 'inspiring', 'difficult', 'heartfelt', 'pixel-art', 'rewarding', 'touching', 'tight', 'indie', 'uplifting', 'frustrating'])
FROM puzzles WHERE answer = 'CELESTE' AND date = '2026-05-22' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['challenging', 'beautiful', 'retro', 'artistic', 'difficult', 'stylish', 'frustrating', 'unique', 'hand-drawn', 'boss-focused', 'jazzy', 'nostalgic', 'punishing', 'gorgeous'])
FROM puzzles WHERE answer = 'CUPHEAD' AND date = '2026-05-23' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['relaxing', 'charming', 'addictive', 'cozy', 'farming', 'peaceful', 'wholesome', 'nostalgic', 'satisfying', 'pixel-art', 'heartwarming', 'indie', 'calming', 'rewarding'])
FROM puzzles WHERE answer = 'STARDEW' AND date = '2026-05-24' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['exploration', 'crafting', 'pixelated', 'endless', 'adventure', 'building', 'boss-fighting', 'sandbox', 'addictive', 'colorful', 'challenging', 'creative', 'vast', 'rewarding'])
FROM puzzles WHERE answer = 'TERRARIA' AND date = '2026-05-25' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['competitive', 'tactical', 'precise', 'team-based', 'strategic', 'intense', 'skill-based', 'fast-paced', 'polished', 'ability-based', 'esports', 'addictive', 'challenging', 'stylish'])
FROM puzzles WHERE answer = 'VALORANT' AND date = '2026-05-26' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['fast-paced', 'team-based', 'movement', 'competitive', 'polished', 'dynamic', 'intense', 'strategic', 'fluid', 'chaotic', 'skill-based', 'diverse', 'addictive', 'exciting'])
FROM puzzles WHERE answer = 'APEX' AND date = '2026-05-27' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['challenging', 'precise', 'punishing', 'rewarding', 'japanese', 'beautiful', 'intense', 'difficult', 'satisfying', 'ninja', 'atmospheric', 'demanding', 'masterful', 'unforgiving'])
FROM puzzles WHERE answer = 'SEKIRO' AND date = '2026-05-28' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['dark', 'gothic', 'challenging', 'atmospheric', 'horrifying', 'punishing', 'beautiful', 'mysterious', 'intense', 'lovecraftian', 'rewarding', 'nightmarish', 'aggressive', 'masterful'])
FROM puzzles WHERE answer = 'BLOODBORNE' AND date = '2026-05-29' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['atmospheric', 'beautiful', 'challenging', 'exploration', 'dark', 'mysterious', 'rewarding', 'artistic', 'vast', 'melancholic', 'precise', 'indie', 'haunting', 'masterful'])
FROM puzzles WHERE answer = 'HOLLOW' AND date = '2026-05-30' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['addictive', 'stylish', 'fast-paced', 'narrative', 'replayable', 'polished', 'challenging', 'beautiful', 'roguelike', 'satisfying', 'mythological', 'charming', 'dynamic', 'rewarding'])
FROM puzzles WHERE answer = 'HADES' AND date = '2026-05-31' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['addictive', 'complex', 'satisfying', 'automation', 'optimization', 'endless', 'strategic', 'time-consuming', 'rewarding', 'logical', 'detailed', 'challenging', 'engineering', 'obsessive'])
FROM puzzles WHERE answer = 'FACTORIO' AND date = '2026-06-01' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['storytelling', 'complex', 'addictive', 'survival', 'colony', 'emergent', 'challenging', 'dark', 'strategic', 'detailed', 'unpredictable', 'sandbox', 'brutal', 'rewarding'])
FROM puzzles WHERE answer = 'RIMWORLD' AND date = '2026-06-02' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['immersive', 'beautiful', 'terrifying', 'exploration', 'underwater', 'survival', 'atmospheric', 'mysterious', 'isolating', 'stunning', 'tense', 'alien', 'vast', 'breathtaking'])
FROM puzzles WHERE answer = 'SUBNAUTICA' AND date = '2026-06-03' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brutal', 'survival', 'competitive', 'unforgiving', 'social', 'intense', 'pvp', 'addictive', 'harsh', 'building', 'chaotic', 'time-consuming', 'stressful', 'rewarding'])
FROM puzzles WHERE answer = 'RUST' AND date = '2026-06-04' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['hardcore', 'realistic', 'intense', 'punishing', 'tactical', 'stressful', 'immersive', 'complex', 'unforgiving', 'rewarding', 'detailed', 'brutal', 'atmospheric', 'addictive'])
FROM puzzles WHERE answer = 'TARKOV' AND date = '2026-06-05' ON CONFLICT DO NOTHING;

INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['epic', 'challenging', 'vast', 'beautiful', 'open-world', 'dark', 'rewarding', 'atmospheric', 'punishing', 'masterful', 'exploration', 'legendary', 'immersive', 'difficult'])
FROM puzzles WHERE answer = 'ELDENRING' AND date = '2026-06-06' ON CONFLICT DO NOTHING;

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
