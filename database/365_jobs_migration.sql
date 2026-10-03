-- ============================================================================
-- TRAITDLE - 365 Jobs Migration (Cycling Yearly)
-- ============================================================================
-- This script clears existing puzzle data and creates 365 jobs puzzles,
-- one for each day of the year (day_of_year 1-365).
-- The app will cycle through these based on day-of-year, repeating each year.
-- ============================================================================

-- ============================================================================
-- PART 1: CLEAR EXISTING DATA
-- ============================================================================

-- Delete in correct order due to foreign key constraints
DELETE FROM trait_votes;
DELETE FROM votes;
DELETE FROM game_results;
DELETE FROM synonyms;
DELETE FROM traits;
DELETE FROM candidate_traits;
DELETE FROM puzzles;

-- ============================================================================
-- PART 2: ADD day_of_year COLUMN TO PUZZLES TABLE
-- ============================================================================

-- Add day_of_year column if it doesn't exist
ALTER TABLE puzzles ADD COLUMN IF NOT EXISTS day_of_year INT;

-- Allow NULL values in date column (since we're using day_of_year now)
ALTER TABLE puzzles ALTER COLUMN date DROP NOT NULL;

-- Create index for efficient day_of_year lookups
CREATE INDEX IF NOT EXISTS idx_puzzles_day_of_year ON puzzles(day_of_year);

-- Drop the unique constraint on (date, category) and add one for (day_of_year, category)
ALTER TABLE puzzles DROP CONSTRAINT IF EXISTS puzzles_date_category_key;
ALTER TABLE puzzles ADD CONSTRAINT puzzles_day_category_key UNIQUE (day_of_year, category);

-- ============================================================================
-- PART 3: INSERT 365 JOBS PUZZLES (Days 1-365)
-- ============================================================================

INSERT INTO puzzles (day_of_year, category, answer) VALUES
(1, 'jobs', 'FIREFIGHTER'),
(2, 'jobs', 'NURSE'),
(3, 'jobs', 'PILOT'),
(4, 'jobs', 'CHEF'),
(5, 'jobs', 'TEACHER'),
(6, 'jobs', 'DOCTOR'),
(7, 'jobs', 'POLICE OFFICER'),
(8, 'jobs', 'LAWYER'),
(9, 'jobs', 'ARCHITECT'),
(10, 'jobs', 'ENGINEER'),
(11, 'jobs', 'ACCOUNTANT'),
(12, 'jobs', 'DENTIST'),
(13, 'jobs', 'VETERINARIAN'),
(14, 'jobs', 'PHARMACIST'),
(15, 'jobs', 'JOURNALIST'),
(16, 'jobs', 'PHOTOGRAPHER'),
(17, 'jobs', 'MUSICIAN'),
(18, 'jobs', 'ACTOR'),
(19, 'jobs', 'DANCER'),
(20, 'jobs', 'PAINTER'),
(21, 'jobs', 'SCULPTOR'),
(22, 'jobs', 'WRITER'),
(23, 'jobs', 'POET'),
(24, 'jobs', 'DIRECTOR'),
(25, 'jobs', 'PRODUCER'),
(26, 'jobs', 'ASTRONAUT'),
(27, 'jobs', 'SCIENTIST'),
(28, 'jobs', 'BIOLOGIST'),
(29, 'jobs', 'CHEMIST'),
(30, 'jobs', 'PHYSICIST'),
(31, 'jobs', 'MATHEMATICIAN'),
(32, 'jobs', 'PROGRAMMER'),
(33, 'jobs', 'DATA SCIENTIST'),
(34, 'jobs', 'SURGEON'),
(35, 'jobs', 'PSYCHOLOGIST'),
(36, 'jobs', 'THERAPIST'),
(37, 'jobs', 'PSYCHIATRIST'),
(38, 'jobs', 'PARAMEDIC'),
(39, 'jobs', 'LIFEGUARD'),
(40, 'jobs', 'DETECTIVE'),
(41, 'jobs', 'SPY'),
(42, 'jobs', 'SOLDIER'),
(43, 'jobs', 'SAILOR'),
(44, 'jobs', 'MARINE'),
(45, 'jobs', 'GENERAL'),
(46, 'jobs', 'DIPLOMAT'),
(47, 'jobs', 'AMBASSADOR'),
(48, 'jobs', 'POLITICIAN'),
(49, 'jobs', 'MAYOR'),
(50, 'jobs', 'GOVERNOR');

INSERT INTO puzzles (day_of_year, category, answer) VALUES
(51, 'jobs', 'JUDGE'),
(52, 'jobs', 'PROSECUTOR'),
(53, 'jobs', 'PARALEGAL'),
(54, 'jobs', 'REALTOR'),
(55, 'jobs', 'BROKER'),
(56, 'jobs', 'BANKER'),
(57, 'jobs', 'TRADER'),
(58, 'jobs', 'ECONOMIST'),
(59, 'jobs', 'ANALYST'),
(60, 'jobs', 'CONSULTANT'),
(61, 'jobs', 'MANAGER'),
(62, 'jobs', 'CEO'),
(63, 'jobs', 'ENTREPRENEUR'),
(64, 'jobs', 'INVENTOR'),
(65, 'jobs', 'DESIGNER'),
(66, 'jobs', 'ILLUSTRATOR'),
(67, 'jobs', 'ANIMATOR'),
(68, 'jobs', 'CARTOONIST'),
(69, 'jobs', 'COMEDIAN'),
(70, 'jobs', 'MAGICIAN'),
(71, 'jobs', 'CLOWN'),
(72, 'jobs', 'ACROBAT'),
(73, 'jobs', 'STUNTMAN'),
(74, 'jobs', 'BODYGUARD'),
(75, 'jobs', 'BOUNCER'),
(76, 'jobs', 'SECURITY GUARD'),
(77, 'jobs', 'PRIVATE INVESTIGATOR'),
(78, 'jobs', 'FORENSIC SCIENTIST'),
(79, 'jobs', 'CORONER'),
(80, 'jobs', 'MORTICIAN'),
(81, 'jobs', 'FLORIST'),
(82, 'jobs', 'GARDENER'),
(83, 'jobs', 'LANDSCAPER'),
(84, 'jobs', 'FARMER'),
(85, 'jobs', 'RANCHER'),
(86, 'jobs', 'BEEKEEPER'),
(87, 'jobs', 'FISHERMAN'),
(88, 'jobs', 'HUNTER'),
(89, 'jobs', 'ZOOKEEPER'),
(90, 'jobs', 'DOG TRAINER'),
(91, 'jobs', 'JOCKEY'),
(92, 'jobs', 'COACH'),
(93, 'jobs', 'REFEREE'),
(94, 'jobs', 'ATHLETE'),
(95, 'jobs', 'BOXER'),
(96, 'jobs', 'WRESTLER'),
(97, 'jobs', 'GYMNAST'),
(98, 'jobs', 'SWIMMER'),
(99, 'jobs', 'DIVER'),
(100, 'jobs', 'SKIER');

INSERT INTO puzzles (day_of_year, category, answer) VALUES
(101, 'jobs', 'GOLFER'),
(102, 'jobs', 'TENNIS PLAYER'),
(103, 'jobs', 'SOCCER PLAYER'),
(104, 'jobs', 'BASKETBALL PLAYER'),
(105, 'jobs', 'BASEBALL PLAYER'),
(106, 'jobs', 'HOCKEY PLAYER'),
(107, 'jobs', 'RACE CAR DRIVER'),
(108, 'jobs', 'PILOT'),
(109, 'jobs', 'FLIGHT ATTENDANT'),
(110, 'jobs', 'AIR TRAFFIC CONTROLLER'),
(111, 'jobs', 'SHIP CAPTAIN'),
(112, 'jobs', 'CRUISE DIRECTOR'),
(113, 'jobs', 'TOUR GUIDE'),
(114, 'jobs', 'TRAVEL AGENT'),
(115, 'jobs', 'HOTEL MANAGER'),
(116, 'jobs', 'CONCIERGE'),
(117, 'jobs', 'BELLHOP'),
(118, 'jobs', 'HOUSEKEEPER'),
(119, 'jobs', 'JANITOR'),
(120, 'jobs', 'CUSTODIAN'),
(121, 'jobs', 'PLUMBER'),
(122, 'jobs', 'ELECTRICIAN'),
(123, 'jobs', 'CARPENTER'),
(124, 'jobs', 'MASON'),
(125, 'jobs', 'ROOFER'),
(126, 'jobs', 'PAINTER'),
(127, 'jobs', 'WELDER'),
(128, 'jobs', 'MECHANIC'),
(129, 'jobs', 'MACHINIST'),
(130, 'jobs', 'BLACKSMITH'),
(131, 'jobs', 'LOCKSMITH'),
(132, 'jobs', 'JEWELER'),
(133, 'jobs', 'WATCHMAKER'),
(134, 'jobs', 'TAILOR'),
(135, 'jobs', 'SEAMSTRESS'),
(136, 'jobs', 'FASHION DESIGNER'),
(137, 'jobs', 'MODEL'),
(138, 'jobs', 'MAKEUP ARTIST'),
(139, 'jobs', 'HAIRDRESSER'),
(140, 'jobs', 'BARBER'),
(141, 'jobs', 'TATTOO ARTIST'),
(142, 'jobs', 'PIERCER'),
(143, 'jobs', 'MASSAGE THERAPIST'),
(144, 'jobs', 'CHIROPRACTOR'),
(145, 'jobs', 'PHYSICAL THERAPIST'),
(146, 'jobs', 'OCCUPATIONAL THERAPIST'),
(147, 'jobs', 'SPEECH THERAPIST'),
(148, 'jobs', 'AUDIOLOGIST'),
(149, 'jobs', 'OPTOMETRIST'),
(150, 'jobs', 'OPHTHALMOLOGIST');

INSERT INTO puzzles (day_of_year, category, answer) VALUES
(151, 'jobs', 'RADIOLOGIST'),
(152, 'jobs', 'ANESTHESIOLOGIST'),
(153, 'jobs', 'CARDIOLOGIST'),
(154, 'jobs', 'NEUROLOGIST'),
(155, 'jobs', 'DERMATOLOGIST'),
(156, 'jobs', 'PEDIATRICIAN'),
(157, 'jobs', 'OBSTETRICIAN'),
(158, 'jobs', 'ONCOLOGIST'),
(159, 'jobs', 'PODIATRIST'),
(160, 'jobs', 'ORTHODONTIST'),
(161, 'jobs', 'ORAL SURGEON'),
(162, 'jobs', 'MIDWIFE'),
(163, 'jobs', 'DOULA'),
(164, 'jobs', 'NANNY'),
(165, 'jobs', 'BABYSITTER'),
(166, 'jobs', 'DAYCARE WORKER'),
(167, 'jobs', 'PRESCHOOL TEACHER'),
(168, 'jobs', 'ELEMENTARY TEACHER'),
(169, 'jobs', 'HIGH SCHOOL TEACHER'),
(170, 'jobs', 'COLLEGE PROFESSOR'),
(171, 'jobs', 'TUTOR'),
(172, 'jobs', 'LIBRARIAN'),
(173, 'jobs', 'ARCHIVIST'),
(174, 'jobs', 'CURATOR'),
(175, 'jobs', 'MUSEUM GUIDE'),
(176, 'jobs', 'ARCHAEOLOGIST'),
(177, 'jobs', 'ANTHROPOLOGIST'),
(178, 'jobs', 'HISTORIAN'),
(179, 'jobs', 'GEOLOGIST'),
(180, 'jobs', 'METEOROLOGIST'),
(181, 'jobs', 'OCEANOGRAPHER'),
(182, 'jobs', 'ASTRONOMER'),
(183, 'jobs', 'MARINE BIOLOGIST'),
(184, 'jobs', 'BOTANIST'),
(185, 'jobs', 'ZOOLOGIST'),
(186, 'jobs', 'ECOLOGIST'),
(187, 'jobs', 'ENVIRONMENTAL SCIENTIST'),
(188, 'jobs', 'PARK RANGER'),
(189, 'jobs', 'FOREST RANGER'),
(190, 'jobs', 'WILDLIFE PHOTOGRAPHER'),
(191, 'jobs', 'DOCUMENTARY FILMMAKER'),
(192, 'jobs', 'NEWS ANCHOR'),
(193, 'jobs', 'RADIO HOST'),
(194, 'jobs', 'PODCASTER'),
(195, 'jobs', 'BLOGGER'),
(196, 'jobs', 'INFLUENCER'),
(197, 'jobs', 'YOUTUBER'),
(198, 'jobs', 'STREAMER'),
(199, 'jobs', 'GAME DEVELOPER'),
(200, 'jobs', 'WEB DEVELOPER');

INSERT INTO puzzles (day_of_year, category, answer) VALUES
(201, 'jobs', 'APP DEVELOPER'),
(202, 'jobs', 'SYSTEMS ADMINISTRATOR'),
(203, 'jobs', 'NETWORK ENGINEER'),
(204, 'jobs', 'CYBERSECURITY ANALYST'),
(205, 'jobs', 'DATABASE ADMINISTRATOR'),
(206, 'jobs', 'UX DESIGNER'),
(207, 'jobs', 'GRAPHIC DESIGNER'),
(208, 'jobs', 'INTERIOR DESIGNER'),
(209, 'jobs', 'URBAN PLANNER'),
(210, 'jobs', 'CIVIL ENGINEER'),
(211, 'jobs', 'STRUCTURAL ENGINEER'),
(212, 'jobs', 'MECHANICAL ENGINEER'),
(213, 'jobs', 'ELECTRICAL ENGINEER'),
(214, 'jobs', 'CHEMICAL ENGINEER'),
(215, 'jobs', 'AEROSPACE ENGINEER'),
(216, 'jobs', 'BIOMEDICAL ENGINEER'),
(217, 'jobs', 'ROBOTICS ENGINEER'),
(218, 'jobs', 'AI RESEARCHER'),
(219, 'jobs', 'PATENT ATTORNEY'),
(220, 'jobs', 'IMMIGRATION LAWYER'),
(221, 'jobs', 'CRIMINAL LAWYER'),
(222, 'jobs', 'DIVORCE LAWYER'),
(223, 'jobs', 'TAX ATTORNEY'),
(224, 'jobs', 'NOTARY'),
(225, 'jobs', 'COURT REPORTER'),
(226, 'jobs', 'BAILIFF'),
(227, 'jobs', 'PRISON GUARD'),
(228, 'jobs', 'PAROLE OFFICER'),
(229, 'jobs', 'SOCIAL WORKER'),
(230, 'jobs', 'CASE MANAGER'),
(231, 'jobs', 'COUNSELOR'),
(232, 'jobs', 'SCHOOL COUNSELOR'),
(233, 'jobs', 'CAREER COUNSELOR'),
(234, 'jobs', 'RECRUITER'),
(235, 'jobs', 'HR MANAGER'),
(236, 'jobs', 'TRAINING SPECIALIST'),
(237, 'jobs', 'EVENT PLANNER'),
(238, 'jobs', 'WEDDING PLANNER'),
(239, 'jobs', 'CATERER'),
(240, 'jobs', 'SOMMELIER'),
(241, 'jobs', 'BARTENDER'),
(242, 'jobs', 'BARISTA'),
(243, 'jobs', 'WAITER'),
(244, 'jobs', 'HOST'),
(245, 'jobs', 'RESTAURANT MANAGER'),
(246, 'jobs', 'FOOD CRITIC'),
(247, 'jobs', 'NUTRITIONIST'),
(248, 'jobs', 'DIETITIAN'),
(249, 'jobs', 'PERSONAL TRAINER'),
(250, 'jobs', 'YOGA INSTRUCTOR');

INSERT INTO puzzles (day_of_year, category, answer) VALUES
(251, 'jobs', 'PILATES INSTRUCTOR'),
(252, 'jobs', 'AEROBICS INSTRUCTOR'),
(253, 'jobs', 'SPIN INSTRUCTOR'),
(254, 'jobs', 'MARTIAL ARTS INSTRUCTOR'),
(255, 'jobs', 'BOXING TRAINER'),
(256, 'jobs', 'SKI INSTRUCTOR'),
(257, 'jobs', 'SURFING INSTRUCTOR'),
(258, 'jobs', 'SCUBA INSTRUCTOR'),
(259, 'jobs', 'DRIVING INSTRUCTOR'),
(260, 'jobs', 'FLIGHT INSTRUCTOR'),
(261, 'jobs', 'MUSIC TEACHER'),
(262, 'jobs', 'ART TEACHER'),
(263, 'jobs', 'DRAMA TEACHER'),
(264, 'jobs', 'DANCE TEACHER'),
(265, 'jobs', 'LANGUAGE TEACHER'),
(266, 'jobs', 'TRANSLATOR'),
(267, 'jobs', 'INTERPRETER'),
(268, 'jobs', 'SIGN LANGUAGE INTERPRETER'),
(269, 'jobs', 'VOICE ACTOR'),
(270, 'jobs', 'NARRATOR'),
(271, 'jobs', 'AUDIOBOOK READER'),
(272, 'jobs', 'RADIO DJ'),
(273, 'jobs', 'CLUB DJ'),
(274, 'jobs', 'SOUND ENGINEER'),
(275, 'jobs', 'RECORDING ENGINEER'),
(276, 'jobs', 'MUSIC PRODUCER'),
(277, 'jobs', 'FILM EDITOR'),
(278, 'jobs', 'VIDEO EDITOR'),
(279, 'jobs', 'CINEMATOGRAPHER'),
(280, 'jobs', 'CAMERA OPERATOR'),
(281, 'jobs', 'GRIP'),
(282, 'jobs', 'GAFFER'),
(283, 'jobs', 'SET DESIGNER'),
(284, 'jobs', 'PROP MASTER'),
(285, 'jobs', 'COSTUME DESIGNER'),
(286, 'jobs', 'WARDROBE STYLIST'),
(287, 'jobs', 'SPECIAL EFFECTS ARTIST'),
(288, 'jobs', 'CGI ARTIST'),
(289, 'jobs', 'MOTION CAPTURE ARTIST'),
(290, 'jobs', 'FOLEY ARTIST'),
(291, 'jobs', 'COMPOSER'),
(292, 'jobs', 'CONDUCTOR'),
(293, 'jobs', 'ORCHESTRA MUSICIAN'),
(294, 'jobs', 'OPERA SINGER'),
(295, 'jobs', 'BACKUP SINGER'),
(296, 'jobs', 'SESSION MUSICIAN'),
(297, 'jobs', 'ROADIE'),
(298, 'jobs', 'CONCERT PROMOTER'),
(299, 'jobs', 'TALENT AGENT'),
(300, 'jobs', 'PUBLICIST');

INSERT INTO puzzles (day_of_year, category, answer) VALUES
(301, 'jobs', 'PRESS SECRETARY'),
(302, 'jobs', 'SPEECHWRITER'),
(303, 'jobs', 'COPYWRITER'),
(304, 'jobs', 'CONTENT WRITER'),
(305, 'jobs', 'TECHNICAL WRITER'),
(306, 'jobs', 'GRANT WRITER'),
(307, 'jobs', 'EDITOR'),
(308, 'jobs', 'PROOFREADER'),
(309, 'jobs', 'LITERARY AGENT'),
(310, 'jobs', 'PUBLISHER'),
(311, 'jobs', 'BOOK DESIGNER'),
(312, 'jobs', 'TYPOGRAPHER'),
(313, 'jobs', 'CALLIGRAPHER'),
(314, 'jobs', 'SIGN MAKER'),
(315, 'jobs', 'ENGRAVER'),
(316, 'jobs', 'PRINTER'),
(317, 'jobs', 'BOOKBINDER'),
(318, 'jobs', 'PAPERMAKER'),
(319, 'jobs', 'GLASS BLOWER'),
(320, 'jobs', 'POTTER'),
(321, 'jobs', 'CERAMICIST'),
(322, 'jobs', 'WOODWORKER'),
(323, 'jobs', 'FURNITURE MAKER'),
(324, 'jobs', 'UPHOLSTERER'),
(325, 'jobs', 'LEATHERWORKER'),
(326, 'jobs', 'SHOEMAKER'),
(327, 'jobs', 'COBBLER'),
(328, 'jobs', 'HATMAKER'),
(329, 'jobs', 'WIG MAKER'),
(330, 'jobs', 'PROP MAKER'),
(331, 'jobs', 'PUPPET MAKER'),
(332, 'jobs', 'TOY MAKER'),
(333, 'jobs', 'DOLL MAKER'),
(334, 'jobs', 'INSTRUMENT MAKER'),
(335, 'jobs', 'PIANO TUNER'),
(336, 'jobs', 'LUTHIER'),
(337, 'jobs', 'BREWER'),
(338, 'jobs', 'WINEMAKER'),
(339, 'jobs', 'DISTILLER'),
(340, 'jobs', 'CHEESEMAKER'),
(341, 'jobs', 'BAKER'),
(342, 'jobs', 'PASTRY CHEF'),
(343, 'jobs', 'CHOCOLATIER'),
(344, 'jobs', 'ICE CREAM MAKER'),
(345, 'jobs', 'BUTCHER'),
(346, 'jobs', 'FISHMONGER'),
(347, 'jobs', 'SUSHI CHEF'),
(348, 'jobs', 'PIZZA MAKER'),
(349, 'jobs', 'FOOD TRUCK OWNER'),
(350, 'jobs', 'STREET VENDOR');

INSERT INTO puzzles (day_of_year, category, answer) VALUES
(351, 'jobs', 'AUCTIONEER'),
(352, 'jobs', 'ANTIQUE DEALER'),
(353, 'jobs', 'PAWNBROKER'),
(354, 'jobs', 'APPRAISER'),
(355, 'jobs', 'INSURANCE AGENT'),
(356, 'jobs', 'CLAIMS ADJUSTER'),
(357, 'jobs', 'ACTUARY'),
(358, 'jobs', 'UNDERWRITER'),
(359, 'jobs', 'FINANCIAL PLANNER'),
(360, 'jobs', 'WEALTH MANAGER'),
(361, 'jobs', 'STOCKBROKER'),
(362, 'jobs', 'INVESTMENT BANKER'),
(363, 'jobs', 'VENTURE CAPITALIST'),
(364, 'jobs', 'AUDITOR'),
(365, 'jobs', 'BOOKKEEPER');

-- ============================================================================
-- PART 4: INSERT CANDIDATE TRAITS FOR ALL 365 JOBS
-- ============================================================================

-- Day 1: FIREFIGHTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'strong', 'calm', 'selfless', 'quick', 'heroic', 'fearless', 'athletic', 'dedicated', 'courageous', 'resilient', 'tough'])
FROM puzzles WHERE day_of_year = 1 AND category = 'jobs';

-- Day 2: NURSE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['caring', 'patient', 'compassionate', 'skilled', 'attentive', 'dedicated', 'empathetic', 'calm', 'gentle', 'nurturing', 'tireless', 'kind'])
FROM puzzles WHERE day_of_year = 2 AND category = 'jobs';

-- Day 3: PILOT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['focused', 'calm', 'precise', 'confident', 'skilled', 'alert', 'responsible', 'decisive', 'composed', 'professional', 'sharp', 'steady'])
FROM puzzles WHERE day_of_year = 3 AND category = 'jobs';

-- Day 4: CHEF
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'passionate', 'precise', 'organized', 'fast', 'skilled', 'artistic', 'perfectionist', 'innovative', 'disciplined', 'intense', 'tasteful'])
FROM puzzles WHERE day_of_year = 4 AND category = 'jobs';

-- Day 5: TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'inspiring', 'knowledgeable', 'caring', 'dedicated', 'creative', 'encouraging', 'organized', 'passionate', 'supportive', 'wise', 'motivating'])
FROM puzzles WHERE day_of_year = 5 AND category = 'jobs';

-- Day 6: DOCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['intelligent', 'caring', 'skilled', 'dedicated', 'knowledgeable', 'calm', 'precise', 'compassionate', 'professional', 'thorough', 'trustworthy', 'analytical'])
FROM puzzles WHERE day_of_year = 6 AND category = 'jobs';

-- Day 7: POLICE OFFICER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'alert', 'strong', 'protective', 'disciplined', 'observant', 'fair', 'dedicated', 'authoritative', 'vigilant', 'tough', 'responsible'])
FROM puzzles WHERE day_of_year = 7 AND category = 'jobs';

-- Day 8: LAWYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'analytical', 'articulate', 'sharp', 'confident', 'logical', 'thorough', 'strategic', 'argumentative', 'persistent', 'clever', 'ambitious'])
FROM puzzles WHERE day_of_year = 8 AND category = 'jobs';

-- Day 9: ARCHITECT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'visionary', 'precise', 'artistic', 'technical', 'innovative', 'imaginative', 'practical', 'skilled', 'patient', 'aesthetic', 'ambitious'])
FROM puzzles WHERE day_of_year = 9 AND category = 'jobs';

-- Day 10: ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'logical', 'precise', 'innovative', 'methodical', 'technical', 'creative', 'practical', 'intelligent', 'focused', 'systematic', 'skilled'])
FROM puzzles WHERE day_of_year = 10 AND category = 'jobs';

-- Day 11: ACCOUNTANT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'organized', 'analytical', 'methodical', 'reliable', 'thorough', 'logical', 'patient', 'accurate', 'trustworthy', 'meticulous', 'focused'])
FROM puzzles WHERE day_of_year = 11 AND category = 'jobs';

-- Day 12: DENTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'gentle', 'patient', 'skilled', 'calm', 'meticulous', 'professional', 'steady', 'caring', 'thorough', 'reassuring', 'dedicated'])
FROM puzzles WHERE day_of_year = 12 AND category = 'jobs';

-- Day 13: VETERINARIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['compassionate', 'gentle', 'patient', 'skilled', 'caring', 'knowledgeable', 'calm', 'dedicated', 'loving', 'observant', 'empathetic', 'kind'])
FROM puzzles WHERE day_of_year = 13 AND category = 'jobs';

-- Day 14: PHARMACIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'knowledgeable', 'careful', 'organized', 'helpful', 'trustworthy', 'attentive', 'patient', 'professional', 'accurate', 'reliable', 'thorough'])
FROM puzzles WHERE day_of_year = 14 AND category = 'jobs';

-- Day 15: JOURNALIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'persistent', 'objective', 'articulate', 'brave', 'investigative', 'ethical', 'observant', 'quick', 'resourceful', 'tenacious', 'informed'])
FROM puzzles WHERE day_of_year = 15 AND category = 'jobs';

-- Day 16: PHOTOGRAPHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'observant', 'artistic', 'patient', 'technical', 'passionate', 'imaginative', 'skilled', 'perceptive', 'adventurous', 'visual', 'aesthetic'])
FROM puzzles WHERE day_of_year = 16 AND category = 'jobs';

-- Day 17: MUSICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'passionate', 'talented', 'expressive', 'dedicated', 'artistic', 'disciplined', 'emotional', 'skilled', 'imaginative', 'rhythmic', 'gifted'])
FROM puzzles WHERE day_of_year = 17 AND category = 'jobs';

-- Day 18: ACTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['expressive', 'creative', 'emotional', 'versatile', 'charismatic', 'dedicated', 'talented', 'dramatic', 'confident', 'imaginative', 'captivating', 'passionate'])
FROM puzzles WHERE day_of_year = 18 AND category = 'jobs';

-- Day 19: DANCER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['graceful', 'athletic', 'expressive', 'disciplined', 'passionate', 'flexible', 'rhythmic', 'elegant', 'dedicated', 'artistic', 'energetic', 'coordinated'])
FROM puzzles WHERE day_of_year = 19 AND category = 'jobs';

-- Day 20: PAINTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'imaginative', 'patient', 'expressive', 'passionate', 'observant', 'skilled', 'visionary', 'dedicated', 'emotional', 'talented'])
FROM puzzles WHERE day_of_year = 20 AND category = 'jobs';

-- Day 21: SCULPTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'patient', 'artistic', 'skilled', 'strong', 'visionary', 'precise', 'dedicated', 'imaginative', 'tactile', 'persistent', 'talented'])
FROM puzzles WHERE day_of_year = 21 AND category = 'jobs';

-- Day 22: WRITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'imaginative', 'articulate', 'observant', 'passionate', 'thoughtful', 'expressive', 'dedicated', 'curious', 'introspective', 'talented', 'patient'])
FROM puzzles WHERE day_of_year = 22 AND category = 'jobs';

-- Day 23: POET
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'emotional', 'expressive', 'imaginative', 'sensitive', 'thoughtful', 'artistic', 'introspective', 'passionate', 'lyrical', 'observant', 'deep'])
FROM puzzles WHERE day_of_year = 23 AND category = 'jobs';

-- Day 24: DIRECTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['visionary', 'creative', 'decisive', 'commanding', 'artistic', 'passionate', 'organized', 'collaborative', 'inspiring', 'ambitious', 'perfectionist', 'talented'])
FROM puzzles WHERE day_of_year = 24 AND category = 'jobs';

-- Day 25: PRODUCER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'business-minded', 'creative', 'decisive', 'resourceful', 'strategic', 'collaborative', 'ambitious', 'diplomatic', 'persuasive', 'driven', 'connected'])
FROM puzzles WHERE day_of_year = 25 AND category = 'jobs';

-- Day 26: ASTRONAUT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'intelligent', 'disciplined', 'adventurous', 'resilient', 'calm', 'curious', 'fit', 'dedicated', 'fearless', 'pioneering', 'determined'])
FROM puzzles WHERE day_of_year = 26 AND category = 'jobs';

-- Day 27: SCIENTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'analytical', 'methodical', 'intelligent', 'patient', 'precise', 'innovative', 'dedicated', 'logical', 'observant', 'persistent', 'brilliant'])
FROM puzzles WHERE day_of_year = 27 AND category = 'jobs';

-- Day 28: BIOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'observant', 'patient', 'analytical', 'dedicated', 'methodical', 'passionate', 'knowledgeable', 'precise', 'investigative', 'thorough', 'scientific'])
FROM puzzles WHERE day_of_year = 28 AND category = 'jobs';

-- Day 29: CHEMIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'analytical', 'curious', 'methodical', 'careful', 'intelligent', 'patient', 'innovative', 'logical', 'dedicated', 'experimental', 'thorough'])
FROM puzzles WHERE day_of_year = 29 AND category = 'jobs';

-- Day 30: PHYSICIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brilliant', 'analytical', 'curious', 'logical', 'innovative', 'theoretical', 'patient', 'dedicated', 'intelligent', 'methodical', 'abstract', 'persistent'])
FROM puzzles WHERE day_of_year = 30 AND category = 'jobs';

-- Day 31: MATHEMATICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['logical', 'analytical', 'brilliant', 'patient', 'precise', 'abstract', 'dedicated', 'methodical', 'curious', 'persistent', 'intelligent', 'focused'])
FROM puzzles WHERE day_of_year = 31 AND category = 'jobs';

-- Day 32: PROGRAMMER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['logical', 'analytical', 'creative', 'patient', 'focused', 'precise', 'innovative', 'dedicated', 'methodical', 'curious', 'technical', 'persistent'])
FROM puzzles WHERE day_of_year = 32 AND category = 'jobs';

-- Day 33: DATA SCIENTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'curious', 'logical', 'technical', 'innovative', 'methodical', 'intelligent', 'precise', 'patient', 'dedicated', 'insightful', 'thorough'])
FROM puzzles WHERE day_of_year = 33 AND category = 'jobs';

-- Day 34: SURGEON
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'steady', 'focused', 'skilled', 'calm', 'confident', 'meticulous', 'dedicated', 'intelligent', 'composed', 'decisive', 'perfectionist'])
FROM puzzles WHERE day_of_year = 34 AND category = 'jobs';

-- Day 35: PSYCHOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['empathetic', 'patient', 'insightful', 'understanding', 'analytical', 'compassionate', 'observant', 'calm', 'wise', 'supportive', 'perceptive', 'caring'])
FROM puzzles WHERE day_of_year = 35 AND category = 'jobs';

-- Day 36: THERAPIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['empathetic', 'patient', 'supportive', 'understanding', 'compassionate', 'calm', 'wise', 'insightful', 'trustworthy', 'caring', 'encouraging', 'attentive'])
FROM puzzles WHERE day_of_year = 36 AND category = 'jobs';

-- Day 37: PSYCHIATRIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'empathetic', 'knowledgeable', 'patient', 'insightful', 'calm', 'professional', 'observant', 'compassionate', 'intelligent', 'dedicated', 'thorough'])
FROM puzzles WHERE day_of_year = 37 AND category = 'jobs';

-- Day 38: PARAMEDIC
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['quick', 'calm', 'skilled', 'brave', 'decisive', 'compassionate', 'resilient', 'focused', 'dedicated', 'strong', 'alert', 'heroic'])
FROM puzzles WHERE day_of_year = 38 AND category = 'jobs';

-- Day 39: LIFEGUARD
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['alert', 'fit', 'brave', 'quick', 'responsible', 'vigilant', 'strong', 'calm', 'athletic', 'watchful', 'decisive', 'heroic'])
FROM puzzles WHERE day_of_year = 39 AND category = 'jobs';

-- Day 40: DETECTIVE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['observant', 'analytical', 'persistent', 'clever', 'intuitive', 'thorough', 'patient', 'logical', 'curious', 'determined', 'sharp', 'methodical'])
FROM puzzles WHERE day_of_year = 40 AND category = 'jobs';

-- Day 41: SPY
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['secretive', 'cunning', 'observant', 'resourceful', 'brave', 'intelligent', 'deceptive', 'calm', 'adaptable', 'discreet', 'skilled', 'stealthy'])
FROM puzzles WHERE day_of_year = 41 AND category = 'jobs';

-- Day 42: SOLDIER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'disciplined', 'strong', 'loyal', 'dedicated', 'tough', 'resilient', 'obedient', 'fearless', 'patriotic', 'determined', 'skilled'])
FROM puzzles WHERE day_of_year = 42 AND category = 'jobs';

-- Day 43: SAILOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['adventurous', 'skilled', 'resilient', 'brave', 'disciplined', 'strong', 'experienced', 'patient', 'resourceful', 'tough', 'dedicated', 'nautical'])
FROM puzzles WHERE day_of_year = 43 AND category = 'jobs';

-- Day 44: MARINE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'tough', 'disciplined', 'strong', 'fearless', 'loyal', 'resilient', 'dedicated', 'fierce', 'determined', 'skilled', 'elite'])
FROM puzzles WHERE day_of_year = 44 AND category = 'jobs';

-- Day 45: GENERAL
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['strategic', 'commanding', 'decisive', 'disciplined', 'experienced', 'authoritative', 'intelligent', 'respected', 'brave', 'calculated', 'inspiring', 'powerful'])
FROM puzzles WHERE day_of_year = 45 AND category = 'jobs';

-- Day 46: DIPLOMAT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['diplomatic', 'articulate', 'patient', 'cultured', 'tactful', 'persuasive', 'intelligent', 'composed', 'strategic', 'respectful', 'charming', 'worldly'])
FROM puzzles WHERE day_of_year = 46 AND category = 'jobs';

-- Day 47: AMBASSADOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['diplomatic', 'distinguished', 'articulate', 'cultured', 'respectful', 'charming', 'intelligent', 'composed', 'influential', 'worldly', 'tactful', 'professional'])
FROM puzzles WHERE day_of_year = 47 AND category = 'jobs';

-- Day 48: POLITICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'charismatic', 'ambitious', 'strategic', 'articulate', 'confident', 'diplomatic', 'cunning', 'influential', 'determined', 'connected', 'calculating'])
FROM puzzles WHERE day_of_year = 48 AND category = 'jobs';

-- Day 49: MAYOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['charismatic', 'diplomatic', 'decisive', 'ambitious', 'connected', 'influential', 'articulate', 'dedicated', 'strategic', 'approachable', 'confident', 'responsible'])
FROM puzzles WHERE day_of_year = 49 AND category = 'jobs';

-- Day 50: GOVERNOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['authoritative', 'decisive', 'diplomatic', 'ambitious', 'influential', 'strategic', 'articulate', 'powerful', 'experienced', 'confident', 'political', 'commanding'])
FROM puzzles WHERE day_of_year = 50 AND category = 'jobs';

-- Day 51: JUDGE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['fair', 'wise', 'authoritative', 'impartial', 'analytical', 'patient', 'respected', 'intelligent', 'decisive', 'dignified', 'ethical', 'experienced'])
FROM puzzles WHERE day_of_year = 51 AND category = 'jobs';

-- Day 52: PROSECUTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'aggressive', 'thorough', 'determined', 'articulate', 'analytical', 'confident', 'strategic', 'ethical', 'persistent', 'sharp', 'dedicated'])
FROM puzzles WHERE day_of_year = 52 AND category = 'jobs';

-- Day 53: PARALEGAL
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'thorough', 'analytical', 'dedicated', 'precise', 'supportive', 'reliable', 'hardworking', 'knowledgeable', 'efficient', 'methodical', 'patient'])
FROM puzzles WHERE day_of_year = 53 AND category = 'jobs';

-- Day 54: REALTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'friendly', 'knowledgeable', 'persistent', 'charming', 'ambitious', 'professional', 'networked', 'motivated', 'patient', 'confident', 'helpful'])
FROM puzzles WHERE day_of_year = 54 AND category = 'jobs';

-- Day 55: BROKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'analytical', 'ambitious', 'strategic', 'confident', 'networked', 'knowledgeable', 'aggressive', 'shrewd', 'driven', 'connected', 'professional'])
FROM puzzles WHERE day_of_year = 55 AND category = 'jobs';

-- Day 56: BANKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'professional', 'trustworthy', 'precise', 'conservative', 'knowledgeable', 'organized', 'reliable', 'discreet', 'confident', 'strategic', 'formal'])
FROM puzzles WHERE day_of_year = 56 AND category = 'jobs';

-- Day 57: TRADER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['quick', 'analytical', 'decisive', 'aggressive', 'confident', 'bold', 'strategic', 'focused', 'ambitious', 'sharp', 'competitive', 'resilient'])
FROM puzzles WHERE day_of_year = 57 AND category = 'jobs';

-- Day 58: ECONOMIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'theoretical', 'intelligent', 'methodical', 'logical', 'patient', 'knowledgeable', 'observant', 'insightful', 'dedicated', 'scholarly', 'thorough'])
FROM puzzles WHERE day_of_year = 58 AND category = 'jobs';

-- Day 59: ANALYST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'logical', 'thorough', 'methodical', 'precise', 'focused', 'intelligent', 'observant', 'patient', 'dedicated', 'insightful', 'organized'])
FROM puzzles WHERE day_of_year = 59 AND category = 'jobs';

-- Day 60: CONSULTANT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'strategic', 'knowledgeable', 'confident', 'articulate', 'professional', 'experienced', 'insightful', 'adaptable', 'persuasive', 'diplomatic', 'skilled'])
FROM puzzles WHERE day_of_year = 60 AND category = 'jobs';

-- Day 61: MANAGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'decisive', 'diplomatic', 'responsible', 'confident', 'strategic', 'supportive', 'experienced', 'authoritative', 'fair', 'focused', 'communicative'])
FROM puzzles WHERE day_of_year = 61 AND category = 'jobs';

-- Day 62: CEO
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['visionary', 'decisive', 'strategic', 'confident', 'ambitious', 'charismatic', 'powerful', 'experienced', 'influential', 'commanding', 'driven', 'bold'])
FROM puzzles WHERE day_of_year = 62 AND category = 'jobs';

-- Day 63: ENTREPRENEUR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['ambitious', 'innovative', 'bold', 'driven', 'creative', 'resilient', 'visionary', 'determined', 'resourceful', 'confident', 'passionate', 'hardworking'])
FROM puzzles WHERE day_of_year = 63 AND category = 'jobs';

-- Day 64: INVENTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'innovative', 'curious', 'imaginative', 'persistent', 'intelligent', 'visionary', 'patient', 'dedicated', 'eccentric', 'brilliant', 'resourceful'])
FROM puzzles WHERE day_of_year = 64 AND category = 'jobs';

-- Day 65: DESIGNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'innovative', 'visual', 'imaginative', 'skilled', 'aesthetic', 'patient', 'passionate', 'dedicated', 'talented', 'trendy'])
FROM puzzles WHERE day_of_year = 65 AND category = 'jobs';

-- Day 66: ILLUSTRATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['artistic', 'creative', 'skilled', 'imaginative', 'patient', 'talented', 'expressive', 'visual', 'dedicated', 'observant', 'passionate', 'detailed'])
FROM puzzles WHERE day_of_year = 66 AND category = 'jobs';

-- Day 67: ANIMATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'patient', 'artistic', 'imaginative', 'technical', 'dedicated', 'skilled', 'passionate', 'observant', 'talented', 'focused', 'persistent'])
FROM puzzles WHERE day_of_year = 67 AND category = 'jobs';

-- Day 68: CARTOONIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'humorous', 'artistic', 'witty', 'observant', 'imaginative', 'talented', 'expressive', 'clever', 'satirical', 'skilled', 'dedicated'])
FROM puzzles WHERE day_of_year = 68 AND category = 'jobs';

-- Day 69: COMEDIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['funny', 'witty', 'quick', 'charismatic', 'observant', 'confident', 'creative', 'bold', 'entertaining', 'clever', 'spontaneous', 'charming'])
FROM puzzles WHERE day_of_year = 69 AND category = 'jobs';

-- Day 70: MAGICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['mysterious', 'skilled', 'charismatic', 'entertaining', 'creative', 'practiced', 'confident', 'clever', 'captivating', 'theatrical', 'precise', 'charming'])
FROM puzzles WHERE day_of_year = 70 AND category = 'jobs';

-- Day 71: CLOWN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['funny', 'entertaining', 'energetic', 'playful', 'colorful', 'silly', 'creative', 'expressive', 'joyful', 'theatrical', 'talented', 'cheerful'])
FROM puzzles WHERE day_of_year = 71 AND category = 'jobs';

-- Day 72: ACROBAT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['flexible', 'strong', 'graceful', 'athletic', 'brave', 'skilled', 'disciplined', 'agile', 'fearless', 'talented', 'dedicated', 'precise'])
FROM puzzles WHERE day_of_year = 72 AND category = 'jobs';

-- Day 73: STUNTMAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'athletic', 'fearless', 'skilled', 'tough', 'daring', 'professional', 'strong', 'resilient', 'calculated', 'experienced', 'dedicated'])
FROM puzzles WHERE day_of_year = 73 AND category = 'jobs';

-- Day 74: BODYGUARD
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['protective', 'strong', 'alert', 'vigilant', 'brave', 'disciplined', 'loyal', 'intimidating', 'skilled', 'observant', 'dedicated', 'tough'])
FROM puzzles WHERE day_of_year = 74 AND category = 'jobs';

-- Day 75: BOUNCER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['intimidating', 'strong', 'alert', 'tough', 'imposing', 'observant', 'calm', 'authoritative', 'patient', 'firm', 'vigilant', 'decisive'])
FROM puzzles WHERE day_of_year = 75 AND category = 'jobs';

-- Day 76: SECURITY GUARD
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['vigilant', 'alert', 'observant', 'responsible', 'dedicated', 'patient', 'professional', 'reliable', 'calm', 'attentive', 'watchful', 'trustworthy'])
FROM puzzles WHERE day_of_year = 76 AND category = 'jobs';

-- Day 77: PRIVATE INVESTIGATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['observant', 'persistent', 'resourceful', 'discreet', 'clever', 'patient', 'analytical', 'thorough', 'determined', 'suspicious', 'cunning', 'dedicated'])
FROM puzzles WHERE day_of_year = 77 AND category = 'jobs';

-- Day 78: FORENSIC SCIENTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'meticulous', 'observant', 'patient', 'precise', 'scientific', 'thorough', 'dedicated', 'methodical', 'intelligent', 'focused', 'detailed'])
FROM puzzles WHERE day_of_year = 78 AND category = 'jobs';

-- Day 79: CORONER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'composed', 'thorough', 'objective', 'scientific', 'professional', 'meticulous', 'dedicated', 'observant', 'patient', 'methodical', 'knowledgeable'])
FROM puzzles WHERE day_of_year = 79 AND category = 'jobs';

-- Day 80: MORTICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['compassionate', 'composed', 'respectful', 'professional', 'meticulous', 'calm', 'dignified', 'patient', 'empathetic', 'skilled', 'dedicated', 'discreet'])
FROM puzzles WHERE day_of_year = 80 AND category = 'jobs';

-- Day 81: FLORIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'gentle', 'patient', 'passionate', 'skilled', 'aesthetic', 'caring', 'organized', 'friendly', 'dedicated', 'imaginative'])
FROM puzzles WHERE day_of_year = 81 AND category = 'jobs';

-- Day 82: GARDENER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'hardworking', 'nurturing', 'knowledgeable', 'dedicated', 'outdoor', 'peaceful', 'skilled', 'caring', 'observant', 'strong', 'passionate'])
FROM puzzles WHERE day_of_year = 82 AND category = 'jobs';

-- Day 83: LANDSCAPER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'hardworking', 'strong', 'skilled', 'outdoor', 'artistic', 'patient', 'dedicated', 'knowledgeable', 'practical', 'physical', 'visionary'])
FROM puzzles WHERE day_of_year = 83 AND category = 'jobs';

-- Day 84: FARMER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['hardworking', 'patient', 'dedicated', 'resilient', 'strong', 'early-rising', 'knowledgeable', 'resourceful', 'tough', 'humble', 'practical', 'tireless'])
FROM puzzles WHERE day_of_year = 84 AND category = 'jobs';

-- Day 85: RANCHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['hardworking', 'tough', 'patient', 'resilient', 'dedicated', 'knowledgeable', 'strong', 'independent', 'practical', 'outdoor', 'experienced', 'tireless'])
FROM puzzles WHERE day_of_year = 85 AND category = 'jobs';

-- Day 86: BEEKEEPER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'calm', 'gentle', 'knowledgeable', 'dedicated', 'careful', 'passionate', 'observant', 'protective', 'skilled', 'brave', 'nurturing'])
FROM puzzles WHERE day_of_year = 86 AND category = 'jobs';

-- Day 87: FISHERMAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'hardworking', 'resilient', 'early-rising', 'skilled', 'tough', 'experienced', 'dedicated', 'strong', 'weathered', 'adventurous', 'persistent'])
FROM puzzles WHERE day_of_year = 87 AND category = 'jobs';

-- Day 88: HUNTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'skilled', 'quiet', 'observant', 'stealthy', 'outdoor', 'experienced', 'focused', 'brave', 'precise', 'dedicated', 'knowledgeable'])
FROM puzzles WHERE day_of_year = 88 AND category = 'jobs';

-- Day 89: ZOOKEEPER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['caring', 'patient', 'passionate', 'knowledgeable', 'dedicated', 'gentle', 'observant', 'brave', 'hardworking', 'compassionate', 'strong', 'nurturing'])
FROM puzzles WHERE day_of_year = 89 AND category = 'jobs';

-- Day 90: DOG TRAINER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'calm', 'consistent', 'knowledgeable', 'gentle', 'dedicated', 'firm', 'observant', 'passionate', 'skilled', 'understanding', 'persistent'])
FROM puzzles WHERE day_of_year = 90 AND category = 'jobs';

-- Day 91: JOCKEY
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['small', 'athletic', 'brave', 'skilled', 'light', 'competitive', 'quick', 'determined', 'disciplined', 'agile', 'focused', 'dedicated'])
FROM puzzles WHERE day_of_year = 91 AND category = 'jobs';

-- Day 92: COACH
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['motivating', 'strategic', 'patient', 'encouraging', 'experienced', 'demanding', 'supportive', 'inspiring', 'disciplined', 'passionate', 'dedicated', 'wise'])
FROM puzzles WHERE day_of_year = 92 AND category = 'jobs';

-- Day 93: REFEREE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['fair', 'decisive', 'alert', 'impartial', 'quick', 'authoritative', 'observant', 'calm', 'consistent', 'respected', 'confident', 'focused'])
FROM puzzles WHERE day_of_year = 93 AND category = 'jobs';

-- Day 94: ATHLETE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['athletic', 'competitive', 'disciplined', 'dedicated', 'strong', 'fit', 'determined', 'focused', 'talented', 'driven', 'resilient', 'passionate'])
FROM puzzles WHERE day_of_year = 94 AND category = 'jobs';

-- Day 95: BOXER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['tough', 'brave', 'strong', 'disciplined', 'aggressive', 'resilient', 'quick', 'determined', 'fierce', 'focused', 'powerful', 'athletic'])
FROM puzzles WHERE day_of_year = 95 AND category = 'jobs';

-- Day 96: WRESTLER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['strong', 'athletic', 'disciplined', 'aggressive', 'tough', 'powerful', 'flexible', 'determined', 'competitive', 'skilled', 'resilient', 'fierce'])
FROM puzzles WHERE day_of_year = 96 AND category = 'jobs';

-- Day 97: GYMNAST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['flexible', 'graceful', 'strong', 'athletic', 'disciplined', 'dedicated', 'agile', 'talented', 'focused', 'precise', 'elegant', 'fearless'])
FROM puzzles WHERE day_of_year = 97 AND category = 'jobs';

-- Day 98: SWIMMER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['athletic', 'disciplined', 'fast', 'strong', 'dedicated', 'fit', 'competitive', 'focused', 'resilient', 'skilled', 'determined', 'graceful'])
FROM puzzles WHERE day_of_year = 98 AND category = 'jobs';

-- Day 99: DIVER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'graceful', 'athletic', 'precise', 'fearless', 'disciplined', 'focused', 'skilled', 'calm', 'dedicated', 'agile', 'talented'])
FROM puzzles WHERE day_of_year = 99 AND category = 'jobs';

-- Day 100: SKIER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['athletic', 'adventurous', 'brave', 'skilled', 'agile', 'fast', 'focused', 'disciplined', 'fearless', 'competitive', 'balanced', 'dedicated'])
FROM puzzles WHERE day_of_year = 100 AND category = 'jobs';

-- Day 101: GOLFER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'precise', 'focused', 'calm', 'disciplined', 'strategic', 'skilled', 'composed', 'competitive', 'dedicated', 'athletic', 'determined'])
FROM puzzles WHERE day_of_year = 101 AND category = 'jobs';

-- Day 102: TENNIS PLAYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['athletic', 'quick', 'competitive', 'focused', 'agile', 'determined', 'skilled', 'disciplined', 'strategic', 'fit', 'resilient', 'dedicated'])
FROM puzzles WHERE day_of_year = 102 AND category = 'jobs';

-- Day 103: SOCCER PLAYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['athletic', 'fast', 'skilled', 'competitive', 'agile', 'disciplined', 'dedicated', 'teamwork', 'strategic', 'fit', 'passionate', 'determined'])
FROM puzzles WHERE day_of_year = 103 AND category = 'jobs';

-- Day 104: BASKETBALL PLAYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['tall', 'athletic', 'quick', 'skilled', 'competitive', 'agile', 'disciplined', 'focused', 'teamwork', 'dedicated', 'strong', 'determined'])
FROM puzzles WHERE day_of_year = 104 AND category = 'jobs';

-- Day 105: BASEBALL PLAYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['athletic', 'patient', 'skilled', 'competitive', 'focused', 'disciplined', 'dedicated', 'strategic', 'quick', 'strong', 'determined', 'teamwork'])
FROM puzzles WHERE day_of_year = 105 AND category = 'jobs';

-- Day 106: HOCKEY PLAYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['tough', 'fast', 'athletic', 'aggressive', 'skilled', 'competitive', 'strong', 'disciplined', 'teamwork', 'brave', 'resilient', 'dedicated'])
FROM puzzles WHERE day_of_year = 106 AND category = 'jobs';

-- Day 107: RACE CAR DRIVER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'fast', 'focused', 'competitive', 'fearless', 'skilled', 'quick', 'calm', 'determined', 'precise', 'bold', 'dedicated'])
FROM puzzles WHERE day_of_year = 107 AND category = 'jobs';

-- Day 108: PILOT (commercial)
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['calm', 'focused', 'precise', 'responsible', 'skilled', 'professional', 'composed', 'confident', 'alert', 'decisive', 'steady', 'experienced'])
FROM puzzles WHERE day_of_year = 108 AND category = 'jobs';

-- Day 109: FLIGHT ATTENDANT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['friendly', 'calm', 'patient', 'professional', 'helpful', 'polite', 'attentive', 'composed', 'caring', 'organized', 'courteous', 'dedicated'])
FROM puzzles WHERE day_of_year = 109 AND category = 'jobs';

-- Day 110: AIR TRAFFIC CONTROLLER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['focused', 'calm', 'precise', 'alert', 'decisive', 'responsible', 'quick', 'skilled', 'composed', 'sharp', 'attentive', 'dedicated'])
FROM puzzles WHERE day_of_year = 110 AND category = 'jobs';

-- Day 111: SHIP CAPTAIN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['commanding', 'experienced', 'responsible', 'calm', 'decisive', 'authoritative', 'skilled', 'brave', 'respected', 'steady', 'knowledgeable', 'dedicated'])
FROM puzzles WHERE day_of_year = 111 AND category = 'jobs';

-- Day 112: CRUISE DIRECTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['entertaining', 'organized', 'charismatic', 'energetic', 'friendly', 'creative', 'social', 'enthusiastic', 'confident', 'charming', 'professional', 'outgoing'])
FROM puzzles WHERE day_of_year = 112 AND category = 'jobs';

-- Day 113: TOUR GUIDE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'friendly', 'enthusiastic', 'articulate', 'patient', 'entertaining', 'engaging', 'organized', 'passionate', 'outgoing', 'informative', 'charming'])
FROM puzzles WHERE day_of_year = 113 AND category = 'jobs';

-- Day 114: TRAVEL AGENT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'knowledgeable', 'helpful', 'patient', 'friendly', 'experienced', 'resourceful', 'attentive', 'professional', 'enthusiastic', 'dedicated', 'thorough'])
FROM puzzles WHERE day_of_year = 114 AND category = 'jobs';

-- Day 115: HOTEL MANAGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'professional', 'diplomatic', 'patient', 'dedicated', 'experienced', 'attentive', 'hospitable', 'responsible', 'calm', 'efficient', 'courteous'])
FROM puzzles WHERE day_of_year = 115 AND category = 'jobs';

-- Day 116: CONCIERGE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['helpful', 'knowledgeable', 'friendly', 'resourceful', 'polite', 'attentive', 'professional', 'courteous', 'patient', 'connected', 'discreet', 'accommodating'])
FROM puzzles WHERE day_of_year = 116 AND category = 'jobs';

-- Day 117: BELLHOP
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['helpful', 'friendly', 'polite', 'strong', 'courteous', 'quick', 'attentive', 'professional', 'reliable', 'energetic', 'hardworking', 'patient'])
FROM puzzles WHERE day_of_year = 117 AND category = 'jobs';

-- Day 118: HOUSEKEEPER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['thorough', 'organized', 'hardworking', 'reliable', 'efficient', 'dedicated', 'meticulous', 'discreet', 'trustworthy', 'patient', 'tidy', 'responsible'])
FROM puzzles WHERE day_of_year = 118 AND category = 'jobs';

-- Day 119: JANITOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['hardworking', 'reliable', 'thorough', 'dedicated', 'humble', 'responsible', 'trustworthy', 'patient', 'efficient', 'steady', 'conscientious', 'tireless'])
FROM puzzles WHERE day_of_year = 119 AND category = 'jobs';

-- Day 120: CUSTODIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['reliable', 'hardworking', 'thorough', 'responsible', 'dedicated', 'trustworthy', 'patient', 'efficient', 'conscientious', 'humble', 'steady', 'organized'])
FROM puzzles WHERE day_of_year = 120 AND category = 'jobs';

-- Day 121: PLUMBER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'practical', 'reliable', 'patient', 'experienced', 'handy', 'knowledgeable', 'hardworking', 'thorough', 'technical', 'resourceful', 'dedicated'])
FROM puzzles WHERE day_of_year = 121 AND category = 'jobs';

-- Day 122: ELECTRICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'careful', 'precise', 'knowledgeable', 'practical', 'reliable', 'technical', 'patient', 'methodical', 'experienced', 'logical', 'focused'])
FROM puzzles WHERE day_of_year = 122 AND category = 'jobs';

-- Day 123: CARPENTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'precise', 'patient', 'creative', 'hardworking', 'practical', 'strong', 'experienced', 'dedicated', 'meticulous', 'handy', 'artistic'])
FROM puzzles WHERE day_of_year = 123 AND category = 'jobs';

-- Day 124: MASON
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'strong', 'patient', 'precise', 'hardworking', 'experienced', 'dedicated', 'meticulous', 'practical', 'steady', 'reliable', 'tough'])
FROM puzzles WHERE day_of_year = 124 AND category = 'jobs';

-- Day 125: ROOFER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brave', 'hardworking', 'strong', 'skilled', 'tough', 'fearless', 'experienced', 'reliable', 'dedicated', 'resilient', 'practical', 'athletic'])
FROM puzzles WHERE day_of_year = 125 AND category = 'jobs';

-- Day 126: PAINTER (house)
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'meticulous', 'skilled', 'steady', 'precise', 'reliable', 'hardworking', 'dedicated', 'thorough', 'experienced', 'careful', 'artistic'])
FROM puzzles WHERE day_of_year = 126 AND category = 'jobs';

-- Day 127: WELDER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'precise', 'careful', 'strong', 'focused', 'experienced', 'steady', 'technical', 'dedicated', 'hardworking', 'patient', 'meticulous'])
FROM puzzles WHERE day_of_year = 127 AND category = 'jobs';

-- Day 128: MECHANIC
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'practical', 'knowledgeable', 'patient', 'technical', 'experienced', 'handy', 'thorough', 'reliable', 'dedicated', 'precise', 'hardworking'])
FROM puzzles WHERE day_of_year = 128 AND category = 'jobs';

-- Day 129: MACHINIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'skilled', 'patient', 'technical', 'meticulous', 'experienced', 'focused', 'dedicated', 'methodical', 'careful', 'knowledgeable', 'steady'])
FROM puzzles WHERE day_of_year = 129 AND category = 'jobs';

-- Day 130: BLACKSMITH
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['strong', 'skilled', 'patient', 'creative', 'hardworking', 'traditional', 'experienced', 'dedicated', 'tough', 'precise', 'artistic', 'resilient'])
FROM puzzles WHERE day_of_year = 130 AND category = 'jobs';

-- Day 131: LOCKSMITH
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'precise', 'trustworthy', 'knowledgeable', 'resourceful', 'experienced', 'dedicated', 'careful', 'technical', 'reliable', 'clever'])
FROM puzzles WHERE day_of_year = 131 AND category = 'jobs';

-- Day 132: JEWELER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'artistic', 'patient', 'skilled', 'meticulous', 'creative', 'knowledgeable', 'dedicated', 'steady', 'elegant', 'careful', 'talented'])
FROM puzzles WHERE day_of_year = 132 AND category = 'jobs';

-- Day 133: WATCHMAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'patient', 'meticulous', 'skilled', 'steady', 'dedicated', 'careful', 'focused', 'technical', 'experienced', 'detailed', 'methodical'])
FROM puzzles WHERE day_of_year = 133 AND category = 'jobs';

-- Day 134: TAILOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'skilled', 'patient', 'meticulous', 'creative', 'dedicated', 'artistic', 'experienced', 'careful', 'attentive', 'elegant', 'professional'])
FROM puzzles WHERE day_of_year = 134 AND category = 'jobs';

-- Day 135: SEAMSTRESS
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'precise', 'creative', 'meticulous', 'dedicated', 'artistic', 'careful', 'talented', 'experienced', 'steady', 'hardworking'])
FROM puzzles WHERE day_of_year = 135 AND category = 'jobs';

-- Day 136: FASHION DESIGNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'trendy', 'artistic', 'innovative', 'visionary', 'passionate', 'stylish', 'imaginative', 'bold', 'talented', 'ambitious', 'aesthetic'])
FROM puzzles WHERE day_of_year = 136 AND category = 'jobs';

-- Day 137: MODEL
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['beautiful', 'graceful', 'tall', 'confident', 'photogenic', 'elegant', 'poised', 'disciplined', 'stylish', 'expressive', 'professional', 'striking'])
FROM puzzles WHERE day_of_year = 137 AND category = 'jobs';

-- Day 138: MAKEUP ARTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['artistic', 'creative', 'skilled', 'patient', 'precise', 'trendy', 'talented', 'imaginative', 'steady', 'dedicated', 'stylish', 'gentle'])
FROM puzzles WHERE day_of_year = 138 AND category = 'jobs';

-- Day 139: HAIRDRESSER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'skilled', 'friendly', 'artistic', 'patient', 'trendy', 'social', 'talented', 'stylish', 'dedicated', 'attentive', 'personable'])
FROM puzzles WHERE day_of_year = 139 AND category = 'jobs';

-- Day 140: BARBER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'friendly', 'patient', 'precise', 'social', 'traditional', 'steady', 'experienced', 'professional', 'personable', 'dedicated', 'talented'])
FROM puzzles WHERE day_of_year = 140 AND category = 'jobs';

-- Day 141: TATTOO ARTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['artistic', 'creative', 'precise', 'skilled', 'patient', 'steady', 'talented', 'edgy', 'dedicated', 'imaginative', 'focused', 'confident'])
FROM puzzles WHERE day_of_year = 141 AND category = 'jobs';

-- Day 142: PIERCER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'steady', 'skilled', 'calm', 'confident', 'professional', 'hygienic', 'patient', 'careful', 'experienced', 'dedicated', 'edgy'])
FROM puzzles WHERE day_of_year = 142 AND category = 'jobs';

-- Day 143: MASSAGE THERAPIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['gentle', 'skilled', 'calming', 'patient', 'strong', 'caring', 'professional', 'intuitive', 'soothing', 'dedicated', 'healing', 'attentive'])
FROM puzzles WHERE day_of_year = 143 AND category = 'jobs';

-- Day 144: CHIROPRACTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'strong', 'precise', 'knowledgeable', 'professional', 'caring', 'patient', 'experienced', 'healing', 'dedicated', 'confident', 'thorough'])
FROM puzzles WHERE day_of_year = 144 AND category = 'jobs';

-- Day 145: PHYSICAL THERAPIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'encouraging', 'skilled', 'caring', 'dedicated', 'knowledgeable', 'supportive', 'motivating', 'strong', 'compassionate', 'professional', 'persistent'])
FROM puzzles WHERE day_of_year = 145 AND category = 'jobs';

-- Day 146: OCCUPATIONAL THERAPIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'caring', 'creative', 'supportive', 'dedicated', 'encouraging', 'knowledgeable', 'compassionate', 'skilled', 'adaptable', 'empathetic', 'professional'])
FROM puzzles WHERE day_of_year = 146 AND category = 'jobs';

-- Day 147: SPEECH THERAPIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'encouraging', 'skilled', 'caring', 'dedicated', 'articulate', 'supportive', 'compassionate', 'knowledgeable', 'gentle', 'persistent', 'empathetic'])
FROM puzzles WHERE day_of_year = 147 AND category = 'jobs';

-- Day 148: AUDIOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'skilled', 'caring', 'precise', 'knowledgeable', 'professional', 'dedicated', 'thorough', 'compassionate', 'technical', 'attentive', 'gentle'])
FROM puzzles WHERE day_of_year = 148 AND category = 'jobs';

-- Day 149: OPTOMETRIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'patient', 'skilled', 'professional', 'knowledgeable', 'thorough', 'caring', 'dedicated', 'gentle', 'attentive', 'meticulous', 'experienced'])
FROM puzzles WHERE day_of_year = 149 AND category = 'jobs';

-- Day 150: OPHTHALMOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'skilled', 'knowledgeable', 'patient', 'steady', 'professional', 'dedicated', 'meticulous', 'caring', 'experienced', 'intelligent', 'thorough'])
FROM puzzles WHERE day_of_year = 150 AND category = 'jobs';

-- Day 151: RADIOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'observant', 'precise', 'patient', 'knowledgeable', 'thorough', 'dedicated', 'intelligent', 'focused', 'meticulous', 'professional', 'skilled'])
FROM puzzles WHERE day_of_year = 151 AND category = 'jobs';

-- Day 152: ANESTHESIOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['calm', 'precise', 'focused', 'knowledgeable', 'responsible', 'skilled', 'vigilant', 'composed', 'dedicated', 'careful', 'professional', 'intelligent'])
FROM puzzles WHERE day_of_year = 152 AND category = 'jobs';

-- Day 153: CARDIOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'knowledgeable', 'caring', 'dedicated', 'precise', 'thorough', 'intelligent', 'professional', 'compassionate', 'analytical', 'patient', 'experienced'])
FROM puzzles WHERE day_of_year = 153 AND category = 'jobs';

-- Day 154: NEUROLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['intelligent', 'analytical', 'patient', 'knowledgeable', 'thorough', 'skilled', 'dedicated', 'precise', 'observant', 'professional', 'curious', 'methodical'])
FROM puzzles WHERE day_of_year = 154 AND category = 'jobs';

-- Day 155: DERMATOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['observant', 'skilled', 'patient', 'knowledgeable', 'precise', 'professional', 'caring', 'thorough', 'dedicated', 'gentle', 'meticulous', 'experienced'])
FROM puzzles WHERE day_of_year = 155 AND category = 'jobs';

-- Day 156: PEDIATRICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['caring', 'patient', 'gentle', 'kind', 'knowledgeable', 'compassionate', 'friendly', 'dedicated', 'nurturing', 'calm', 'reassuring', 'playful'])
FROM puzzles WHERE day_of_year = 156 AND category = 'jobs';

-- Day 157: OBSTETRICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['caring', 'calm', 'skilled', 'patient', 'supportive', 'knowledgeable', 'reassuring', 'dedicated', 'compassionate', 'experienced', 'professional', 'gentle'])
FROM puzzles WHERE day_of_year = 157 AND category = 'jobs';

-- Day 158: ONCOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['compassionate', 'knowledgeable', 'dedicated', 'supportive', 'caring', 'resilient', 'patient', 'skilled', 'empathetic', 'professional', 'thorough', 'hopeful'])
FROM puzzles WHERE day_of_year = 158 AND category = 'jobs';

-- Day 159: PODIATRIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'knowledgeable', 'precise', 'caring', 'dedicated', 'professional', 'thorough', 'gentle', 'experienced', 'meticulous', 'attentive'])
FROM puzzles WHERE day_of_year = 159 AND category = 'jobs';

-- Day 160: ORTHODONTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'patient', 'skilled', 'meticulous', 'gentle', 'dedicated', 'knowledgeable', 'professional', 'caring', 'thorough', 'experienced', 'steady'])
FROM puzzles WHERE day_of_year = 160 AND category = 'jobs';

-- Day 161: ORAL SURGEON
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'skilled', 'steady', 'calm', 'knowledgeable', 'professional', 'dedicated', 'meticulous', 'confident', 'experienced', 'careful', 'focused'])
FROM puzzles WHERE day_of_year = 161 AND category = 'jobs';

-- Day 162: MIDWIFE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['caring', 'calm', 'supportive', 'patient', 'experienced', 'nurturing', 'gentle', 'knowledgeable', 'reassuring', 'compassionate', 'dedicated', 'skilled'])
FROM puzzles WHERE day_of_year = 162 AND category = 'jobs';

-- Day 163: DOULA
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['supportive', 'caring', 'calm', 'nurturing', 'patient', 'compassionate', 'reassuring', 'gentle', 'encouraging', 'dedicated', 'empathetic', 'experienced'])
FROM puzzles WHERE day_of_year = 163 AND category = 'jobs';

-- Day 164: NANNY
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['caring', 'patient', 'nurturing', 'responsible', 'loving', 'dedicated', 'trustworthy', 'playful', 'gentle', 'reliable', 'attentive', 'kind'])
FROM puzzles WHERE day_of_year = 164 AND category = 'jobs';

-- Day 165: BABYSITTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['responsible', 'patient', 'caring', 'reliable', 'playful', 'attentive', 'trustworthy', 'friendly', 'energetic', 'gentle', 'kind', 'fun'])
FROM puzzles WHERE day_of_year = 165 AND category = 'jobs';

-- Day 166: DAYCARE WORKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'caring', 'energetic', 'playful', 'nurturing', 'attentive', 'dedicated', 'gentle', 'creative', 'responsible', 'kind', 'loving'])
FROM puzzles WHERE day_of_year = 166 AND category = 'jobs';

-- Day 167: PRESCHOOL TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'nurturing', 'creative', 'playful', 'caring', 'gentle', 'enthusiastic', 'dedicated', 'imaginative', 'kind', 'encouraging', 'energetic'])
FROM puzzles WHERE day_of_year = 167 AND category = 'jobs';

-- Day 168: ELEMENTARY TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'encouraging', 'creative', 'caring', 'dedicated', 'enthusiastic', 'nurturing', 'organized', 'supportive', 'kind', 'inspiring', 'passionate'])
FROM puzzles WHERE day_of_year = 168 AND category = 'jobs';

-- Day 169: HIGH SCHOOL TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'knowledgeable', 'inspiring', 'dedicated', 'passionate', 'supportive', 'firm', 'encouraging', 'organized', 'engaging', 'experienced', 'fair'])
FROM puzzles WHERE day_of_year = 169 AND category = 'jobs';

-- Day 170: COLLEGE PROFESSOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'intelligent', 'scholarly', 'passionate', 'articulate', 'dedicated', 'inspiring', 'experienced', 'thoughtful', 'analytical', 'patient', 'wise'])
FROM puzzles WHERE day_of_year = 170 AND category = 'jobs';

-- Day 171: TUTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'knowledgeable', 'encouraging', 'supportive', 'dedicated', 'clear', 'helpful', 'adaptable', 'attentive', 'skilled', 'understanding', 'passionate'])
FROM puzzles WHERE day_of_year = 171 AND category = 'jobs';

-- Day 172: LIBRARIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['quiet', 'organized', 'knowledgeable', 'helpful', 'patient', 'bookish', 'dedicated', 'resourceful', 'calm', 'intelligent', 'meticulous', 'scholarly'])
FROM puzzles WHERE day_of_year = 172 AND category = 'jobs';

-- Day 173: ARCHIVIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['meticulous', 'organized', 'patient', 'dedicated', 'scholarly', 'thorough', 'knowledgeable', 'careful', 'methodical', 'passionate', 'precise', 'detail-oriented'])
FROM puzzles WHERE day_of_year = 173 AND category = 'jobs';

-- Day 174: CURATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'passionate', 'artistic', 'scholarly', 'organized', 'dedicated', 'cultured', 'meticulous', 'creative', 'eloquent', 'visionary', 'experienced'])
FROM puzzles WHERE day_of_year = 174 AND category = 'jobs';

-- Day 175: MUSEUM GUIDE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'enthusiastic', 'articulate', 'patient', 'engaging', 'passionate', 'friendly', 'informative', 'cultured', 'dedicated', 'personable', 'eloquent'])
FROM puzzles WHERE day_of_year = 175 AND category = 'jobs';

-- Day 176: ARCHAEOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'curious', 'meticulous', 'adventurous', 'dedicated', 'scholarly', 'passionate', 'thorough', 'observant', 'persistent', 'knowledgeable', 'methodical'])
FROM puzzles WHERE day_of_year = 176 AND category = 'jobs';

-- Day 177: ANTHROPOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'observant', 'patient', 'scholarly', 'open-minded', 'dedicated', 'analytical', 'empathetic', 'thorough', 'passionate', 'cultured', 'thoughtful'])
FROM puzzles WHERE day_of_year = 177 AND category = 'jobs';

-- Day 178: HISTORIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['scholarly', 'curious', 'patient', 'thorough', 'analytical', 'dedicated', 'knowledgeable', 'passionate', 'meticulous', 'thoughtful', 'articulate', 'studious'])
FROM puzzles WHERE day_of_year = 178 AND category = 'jobs';

-- Day 179: GEOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'analytical', 'patient', 'observant', 'adventurous', 'dedicated', 'scientific', 'thorough', 'methodical', 'outdoor', 'knowledgeable', 'passionate'])
FROM puzzles WHERE day_of_year = 179 AND category = 'jobs';

-- Day 180: METEOROLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'articulate', 'knowledgeable', 'scientific', 'patient', 'observant', 'dedicated', 'precise', 'curious', 'professional', 'charismatic', 'passionate'])
FROM puzzles WHERE day_of_year = 180 AND category = 'jobs';

-- Day 181: OCEANOGRAPHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'adventurous', 'scientific', 'dedicated', 'passionate', 'analytical', 'patient', 'observant', 'brave', 'knowledgeable', 'thorough', 'exploratory'])
FROM puzzles WHERE day_of_year = 181 AND category = 'jobs';

-- Day 182: ASTRONOMER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'patient', 'analytical', 'scientific', 'observant', 'dedicated', 'passionate', 'intelligent', 'methodical', 'nocturnal', 'precise', 'visionary'])
FROM puzzles WHERE day_of_year = 182 AND category = 'jobs';

-- Day 183: MARINE BIOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'adventurous', 'passionate', 'scientific', 'patient', 'dedicated', 'observant', 'analytical', 'brave', 'knowledgeable', 'caring', 'exploratory'])
FROM puzzles WHERE day_of_year = 183 AND category = 'jobs';

-- Day 184: BOTANIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'curious', 'observant', 'scientific', 'dedicated', 'passionate', 'methodical', 'knowledgeable', 'thorough', 'gentle', 'analytical', 'nurturing'])
FROM puzzles WHERE day_of_year = 184 AND category = 'jobs';

-- Day 185: ZOOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'passionate', 'patient', 'observant', 'scientific', 'dedicated', 'caring', 'knowledgeable', 'adventurous', 'analytical', 'compassionate', 'thorough'])
FROM puzzles WHERE day_of_year = 185 AND category = 'jobs';

-- Day 186: ECOLOGIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['passionate', 'scientific', 'observant', 'dedicated', 'analytical', 'patient', 'caring', 'knowledgeable', 'thorough', 'environmentalist', 'curious', 'outdoor'])
FROM puzzles WHERE day_of_year = 186 AND category = 'jobs';

-- Day 187: ENVIRONMENTAL SCIENTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['passionate', 'analytical', 'dedicated', 'scientific', 'observant', 'thorough', 'caring', 'knowledgeable', 'patient', 'methodical', 'environmentalist', 'committed'])
FROM puzzles WHERE day_of_year = 187 AND category = 'jobs';

-- Day 188: PARK RANGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['outdoor', 'knowledgeable', 'protective', 'patient', 'dedicated', 'adventurous', 'caring', 'brave', 'fit', 'passionate', 'responsible', 'friendly'])
FROM puzzles WHERE day_of_year = 188 AND category = 'jobs';

-- Day 189: FOREST RANGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['outdoor', 'brave', 'protective', 'knowledgeable', 'dedicated', 'strong', 'patient', 'caring', 'adventurous', 'fit', 'responsible', 'resilient'])
FROM puzzles WHERE day_of_year = 189 AND category = 'jobs';

-- Day 190: WILDLIFE PHOTOGRAPHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'adventurous', 'passionate', 'observant', 'artistic', 'dedicated', 'brave', 'skilled', 'outdoor', 'creative', 'persistent', 'resilient'])
FROM puzzles WHERE day_of_year = 190 AND category = 'jobs';

-- Day 191: DOCUMENTARY FILMMAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['curious', 'passionate', 'patient', 'storytelling', 'dedicated', 'observant', 'creative', 'persistent', 'adventurous', 'artistic', 'brave', 'insightful'])
FROM puzzles WHERE day_of_year = 191 AND category = 'jobs';

-- Day 192: NEWS ANCHOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['articulate', 'professional', 'calm', 'charismatic', 'confident', 'informed', 'composed', 'polished', 'trustworthy', 'poised', 'eloquent', 'attractive'])
FROM puzzles WHERE day_of_year = 192 AND category = 'jobs';

-- Day 193: RADIO HOST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['articulate', 'entertaining', 'charismatic', 'quick', 'friendly', 'engaging', 'witty', 'energetic', 'personable', 'passionate', 'confident', 'spontaneous'])
FROM puzzles WHERE day_of_year = 193 AND category = 'jobs';

-- Day 194: PODCASTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['articulate', 'engaging', 'passionate', 'curious', 'creative', 'personable', 'knowledgeable', 'entertaining', 'conversational', 'dedicated', 'charismatic', 'authentic'])
FROM puzzles WHERE day_of_year = 194 AND category = 'jobs';

-- Day 195: BLOGGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'passionate', 'articulate', 'dedicated', 'opinionated', 'engaging', 'curious', 'consistent', 'authentic', 'knowledgeable', 'observant', 'expressive'])
FROM puzzles WHERE day_of_year = 195 AND category = 'jobs';

-- Day 196: INFLUENCER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['charismatic', 'trendy', 'engaging', 'creative', 'photogenic', 'confident', 'authentic', 'social', 'ambitious', 'persuasive', 'stylish', 'relatable'])
FROM puzzles WHERE day_of_year = 196 AND category = 'jobs';

-- Day 197: YOUTUBER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'entertaining', 'charismatic', 'engaging', 'dedicated', 'personable', 'consistent', 'confident', 'passionate', 'authentic', 'energetic', 'relatable'])
FROM puzzles WHERE day_of_year = 197 AND category = 'jobs';

-- Day 198: STREAMER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['entertaining', 'engaging', 'charismatic', 'quick', 'funny', 'dedicated', 'interactive', 'energetic', 'skilled', 'personable', 'passionate', 'consistent'])
FROM puzzles WHERE day_of_year = 198 AND category = 'jobs';

-- Day 199: GAME DEVELOPER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'technical', 'patient', 'passionate', 'innovative', 'dedicated', 'logical', 'artistic', 'skilled', 'imaginative', 'persistent', 'collaborative'])
FROM puzzles WHERE day_of_year = 199 AND category = 'jobs';

-- Day 200: WEB DEVELOPER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['technical', 'logical', 'creative', 'patient', 'dedicated', 'skilled', 'analytical', 'innovative', 'focused', 'methodical', 'persistent', 'adaptable'])
FROM puzzles WHERE day_of_year = 200 AND category = 'jobs';

-- Day 201: APP DEVELOPER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['technical', 'creative', 'logical', 'innovative', 'dedicated', 'patient', 'skilled', 'analytical', 'focused', 'persistent', 'adaptable', 'methodical'])
FROM puzzles WHERE day_of_year = 201 AND category = 'jobs';

-- Day 202: SYSTEMS ADMINISTRATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['technical', 'methodical', 'patient', 'organized', 'reliable', 'analytical', 'dedicated', 'knowledgeable', 'thorough', 'calm', 'responsible', 'focused'])
FROM puzzles WHERE day_of_year = 202 AND category = 'jobs';

-- Day 203: NETWORK ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['technical', 'analytical', 'methodical', 'logical', 'patient', 'knowledgeable', 'dedicated', 'skilled', 'thorough', 'organized', 'focused', 'reliable'])
FROM puzzles WHERE day_of_year = 203 AND category = 'jobs';

-- Day 204: CYBERSECURITY ANALYST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'vigilant', 'technical', 'methodical', 'curious', 'dedicated', 'intelligent', 'thorough', 'paranoid', 'skilled', 'focused', 'persistent'])
FROM puzzles WHERE day_of_year = 204 AND category = 'jobs';

-- Day 205: DATABASE ADMINISTRATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'technical', 'methodical', 'precise', 'analytical', 'patient', 'dedicated', 'thorough', 'reliable', 'logical', 'meticulous', 'skilled'])
FROM puzzles WHERE day_of_year = 205 AND category = 'jobs';

-- Day 206: UX DESIGNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'empathetic', 'analytical', 'innovative', 'observant', 'dedicated', 'artistic', 'curious', 'collaborative', 'skilled', 'patient', 'intuitive'])
FROM puzzles WHERE day_of_year = 206 AND category = 'jobs';

-- Day 207: GRAPHIC DESIGNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'visual', 'innovative', 'skilled', 'patient', 'dedicated', 'imaginative', 'aesthetic', 'passionate', 'talented', 'trendy'])
FROM puzzles WHERE day_of_year = 207 AND category = 'jobs';

-- Day 208: INTERIOR DESIGNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'visual', 'organized', 'aesthetic', 'innovative', 'patient', 'skilled', 'passionate', 'stylish', 'imaginative', 'practical'])
FROM puzzles WHERE day_of_year = 208 AND category = 'jobs';

-- Day 209: URBAN PLANNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'visionary', 'organized', 'strategic', 'dedicated', 'patient', 'collaborative', 'creative', 'thorough', 'knowledgeable', 'practical', 'thoughtful'])
FROM puzzles WHERE day_of_year = 209 AND category = 'jobs';

-- Day 210: CIVIL ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'precise', 'logical', 'technical', 'practical', 'methodical', 'dedicated', 'skilled', 'patient', 'thorough', 'organized', 'responsible'])
FROM puzzles WHERE day_of_year = 210 AND category = 'jobs';

-- Day 211: STRUCTURAL ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'precise', 'technical', 'methodical', 'logical', 'careful', 'dedicated', 'skilled', 'thorough', 'responsible', 'patient', 'intelligent'])
FROM puzzles WHERE day_of_year = 211 AND category = 'jobs';

-- Day 212: MECHANICAL ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'logical', 'innovative', 'technical', 'creative', 'precise', 'dedicated', 'methodical', 'skilled', 'practical', 'patient', 'curious'])
FROM puzzles WHERE day_of_year = 212 AND category = 'jobs';

-- Day 213: ELECTRICAL ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'technical', 'logical', 'precise', 'innovative', 'methodical', 'dedicated', 'skilled', 'patient', 'intelligent', 'focused', 'curious'])
FROM puzzles WHERE day_of_year = 213 AND category = 'jobs';

-- Day 214: CHEMICAL ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'precise', 'scientific', 'methodical', 'innovative', 'careful', 'dedicated', 'intelligent', 'patient', 'thorough', 'skilled', 'logical'])
FROM puzzles WHERE day_of_year = 214 AND category = 'jobs';

-- Day 215: AEROSPACE ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['innovative', 'analytical', 'precise', 'intelligent', 'technical', 'dedicated', 'visionary', 'methodical', 'skilled', 'patient', 'ambitious', 'curious'])
FROM puzzles WHERE day_of_year = 215 AND category = 'jobs';

-- Day 216: BIOMEDICAL ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['innovative', 'analytical', 'caring', 'technical', 'dedicated', 'intelligent', 'precise', 'scientific', 'passionate', 'methodical', 'skilled', 'curious'])
FROM puzzles WHERE day_of_year = 216 AND category = 'jobs';

-- Day 217: ROBOTICS ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['innovative', 'technical', 'creative', 'analytical', 'logical', 'dedicated', 'curious', 'skilled', 'patient', 'methodical', 'visionary', 'intelligent'])
FROM puzzles WHERE day_of_year = 217 AND category = 'jobs';

-- Day 218: AI RESEARCHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['brilliant', 'innovative', 'analytical', 'curious', 'dedicated', 'logical', 'patient', 'visionary', 'intelligent', 'methodical', 'persistent', 'passionate'])
FROM puzzles WHERE day_of_year = 218 AND category = 'jobs';

-- Day 219: PATENT ATTORNEY
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'technical', 'thorough', 'precise', 'knowledgeable', 'dedicated', 'patient', 'meticulous', 'logical', 'articulate', 'skilled', 'persistent'])
FROM puzzles WHERE day_of_year = 219 AND category = 'jobs';

-- Day 220: IMMIGRATION LAWYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['compassionate', 'dedicated', 'thorough', 'patient', 'knowledgeable', 'empathetic', 'persistent', 'articulate', 'organized', 'caring', 'skilled', 'passionate'])
FROM puzzles WHERE day_of_year = 220 AND category = 'jobs';

-- Day 221: CRIMINAL LAWYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'aggressive', 'articulate', 'analytical', 'strategic', 'confident', 'dedicated', 'sharp', 'thorough', 'determined', 'passionate', 'bold'])
FROM puzzles WHERE day_of_year = 221 AND category = 'jobs';

-- Day 222: DIVORCE LAWYER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['diplomatic', 'patient', 'empathetic', 'thorough', 'strategic', 'articulate', 'dedicated', 'compassionate', 'persistent', 'calm', 'skilled', 'negotiating'])
FROM puzzles WHERE day_of_year = 222 AND category = 'jobs';

-- Day 223: TAX ATTORNEY
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'precise', 'thorough', 'knowledgeable', 'patient', 'methodical', 'dedicated', 'meticulous', 'strategic', 'organized', 'skilled', 'detail-oriented'])
FROM puzzles WHERE day_of_year = 223 AND category = 'jobs';

-- Day 224: NOTARY
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'trustworthy', 'professional', 'organized', 'reliable', 'thorough', 'patient', 'meticulous', 'responsible', 'ethical', 'dedicated', 'careful'])
FROM puzzles WHERE day_of_year = 224 AND category = 'jobs';

-- Day 225: COURT REPORTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['fast', 'accurate', 'focused', 'patient', 'precise', 'skilled', 'dedicated', 'attentive', 'professional', 'reliable', 'composed', 'meticulous'])
FROM puzzles WHERE day_of_year = 225 AND category = 'jobs';

-- Day 226: BAILIFF
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['authoritative', 'calm', 'professional', 'alert', 'respectful', 'strong', 'dedicated', 'responsible', 'composed', 'vigilant', 'disciplined', 'reliable'])
FROM puzzles WHERE day_of_year = 226 AND category = 'jobs';

-- Day 227: PRISON GUARD
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['vigilant', 'tough', 'alert', 'disciplined', 'authoritative', 'calm', 'observant', 'strong', 'patient', 'responsible', 'firm', 'resilient'])
FROM puzzles WHERE day_of_year = 227 AND category = 'jobs';

-- Day 228: PAROLE OFFICER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['firm', 'patient', 'observant', 'supportive', 'fair', 'dedicated', 'thorough', 'vigilant', 'responsible', 'compassionate', 'experienced', 'persistent'])
FROM puzzles WHERE day_of_year = 228 AND category = 'jobs';

-- Day 229: SOCIAL WORKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['compassionate', 'patient', 'dedicated', 'empathetic', 'resilient', 'caring', 'resourceful', 'supportive', 'passionate', 'understanding', 'determined', 'selfless'])
FROM puzzles WHERE day_of_year = 229 AND category = 'jobs';

-- Day 230: CASE MANAGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'compassionate', 'patient', 'dedicated', 'thorough', 'resourceful', 'supportive', 'empathetic', 'responsible', 'persistent', 'caring', 'professional'])
FROM puzzles WHERE day_of_year = 230 AND category = 'jobs';

-- Day 231: COUNSELOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['empathetic', 'patient', 'supportive', 'understanding', 'compassionate', 'calm', 'wise', 'dedicated', 'caring', 'trustworthy', 'insightful', 'encouraging'])
FROM puzzles WHERE day_of_year = 231 AND category = 'jobs';

-- Day 232: SCHOOL COUNSELOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['supportive', 'patient', 'caring', 'understanding', 'encouraging', 'empathetic', 'approachable', 'dedicated', 'wise', 'compassionate', 'helpful', 'trustworthy'])
FROM puzzles WHERE day_of_year = 232 AND category = 'jobs';

-- Day 233: CAREER COUNSELOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['supportive', 'knowledgeable', 'encouraging', 'patient', 'insightful', 'helpful', 'dedicated', 'empathetic', 'resourceful', 'understanding', 'experienced', 'motivating'])
FROM puzzles WHERE day_of_year = 233 AND category = 'jobs';

-- Day 234: RECRUITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['personable', 'persuasive', 'organized', 'persistent', 'networked', 'observant', 'strategic', 'confident', 'patient', 'communicative', 'dedicated', 'ambitious'])
FROM puzzles WHERE day_of_year = 234 AND category = 'jobs';

-- Day 235: HR MANAGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['diplomatic', 'organized', 'fair', 'patient', 'professional', 'empathetic', 'discreet', 'dedicated', 'communicative', 'supportive', 'thorough', 'responsible'])
FROM puzzles WHERE day_of_year = 235 AND category = 'jobs';

-- Day 236: TRAINING SPECIALIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'articulate', 'organized', 'encouraging', 'knowledgeable', 'engaging', 'dedicated', 'creative', 'supportive', 'adaptable', 'enthusiastic', 'skilled'])
FROM puzzles WHERE day_of_year = 236 AND category = 'jobs';

-- Day 237: EVENT PLANNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'creative', 'calm', 'resourceful', 'dedicated', 'detail-oriented', 'energetic', 'patient', 'communicative', 'flexible', 'professional', 'multitasking'])
FROM puzzles WHERE day_of_year = 237 AND category = 'jobs';

-- Day 238: WEDDING PLANNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'creative', 'calm', 'patient', 'romantic', 'detail-oriented', 'resourceful', 'dedicated', 'supportive', 'elegant', 'professional', 'enthusiastic'])
FROM puzzles WHERE day_of_year = 238 AND category = 'jobs';

-- Day 239: CATERER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'skilled', 'creative', 'professional', 'efficient', 'dedicated', 'calm', 'hardworking', 'resourceful', 'experienced', 'flexible', 'passionate'])
FROM puzzles WHERE day_of_year = 239 AND category = 'jobs';

-- Day 240: SOMMELIER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'sophisticated', 'refined', 'passionate', 'articulate', 'cultured', 'patient', 'experienced', 'dedicated', 'perceptive', 'elegant', 'professional'])
FROM puzzles WHERE day_of_year = 240 AND category = 'jobs';

-- Day 241: BARTENDER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['friendly', 'quick', 'social', 'skilled', 'attentive', 'charming', 'patient', 'creative', 'observant', 'personable', 'entertaining', 'charismatic'])
FROM puzzles WHERE day_of_year = 241 AND category = 'jobs';

-- Day 242: BARISTA
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['friendly', 'quick', 'skilled', 'patient', 'energetic', 'attentive', 'personable', 'dedicated', 'creative', 'efficient', 'cheerful', 'passionate'])
FROM puzzles WHERE day_of_year = 242 AND category = 'jobs';

-- Day 243: WAITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['friendly', 'patient', 'attentive', 'quick', 'polite', 'organized', 'hardworking', 'personable', 'efficient', 'courteous', 'energetic', 'dedicated'])
FROM puzzles WHERE day_of_year = 243 AND category = 'jobs';

-- Day 244: HOST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['friendly', 'welcoming', 'organized', 'polite', 'patient', 'personable', 'calm', 'professional', 'attentive', 'charming', 'efficient', 'courteous'])
FROM puzzles WHERE day_of_year = 244 AND category = 'jobs';

-- Day 245: RESTAURANT MANAGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'calm', 'diplomatic', 'experienced', 'dedicated', 'patient', 'efficient', 'professional', 'responsible', 'decisive', 'hardworking', 'multitasking'])
FROM puzzles WHERE day_of_year = 245 AND category = 'jobs';

-- Day 246: FOOD CRITIC
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['discerning', 'articulate', 'knowledgeable', 'observant', 'opinionated', 'cultured', 'experienced', 'analytical', 'honest', 'sophisticated', 'passionate', 'descriptive'])
FROM puzzles WHERE day_of_year = 246 AND category = 'jobs';

-- Day 247: NUTRITIONIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'patient', 'supportive', 'dedicated', 'caring', 'encouraging', 'healthy', 'scientific', 'compassionate', 'thorough', 'professional', 'helpful'])
FROM puzzles WHERE day_of_year = 247 AND category = 'jobs';

-- Day 248: DIETITIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'patient', 'supportive', 'scientific', 'dedicated', 'caring', 'thorough', 'professional', 'encouraging', 'compassionate', 'analytical', 'healthy'])
FROM puzzles WHERE day_of_year = 248 AND category = 'jobs';

-- Day 249: PERSONAL TRAINER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['motivating', 'fit', 'energetic', 'encouraging', 'disciplined', 'patient', 'dedicated', 'supportive', 'passionate', 'strong', 'inspiring', 'knowledgeable'])
FROM puzzles WHERE day_of_year = 249 AND category = 'jobs';

-- Day 250: YOGA INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['calm', 'flexible', 'patient', 'peaceful', 'dedicated', 'inspiring', 'serene', 'fit', 'gentle', 'encouraging', 'spiritual', 'mindful'])
FROM puzzles WHERE day_of_year = 250 AND category = 'jobs';

-- Day 251: PILATES INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['fit', 'patient', 'encouraging', 'flexible', 'disciplined', 'dedicated', 'strong', 'motivating', 'calm', 'precise', 'supportive', 'graceful'])
FROM puzzles WHERE day_of_year = 251 AND category = 'jobs';

-- Day 252: AEROBICS INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['energetic', 'fit', 'motivating', 'enthusiastic', 'encouraging', 'dedicated', 'lively', 'disciplined', 'passionate', 'cheerful', 'athletic', 'inspiring'])
FROM puzzles WHERE day_of_year = 252 AND category = 'jobs';

-- Day 253: SPIN INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['energetic', 'motivating', 'fit', 'intense', 'encouraging', 'dedicated', 'passionate', 'disciplined', 'enthusiastic', 'inspiring', 'athletic', 'driven'])
FROM puzzles WHERE day_of_year = 253 AND category = 'jobs';

-- Day 254: MARTIAL ARTS INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['disciplined', 'patient', 'skilled', 'dedicated', 'strong', 'wise', 'focused', 'respected', 'calm', 'experienced', 'fit', 'inspiring'])
FROM puzzles WHERE day_of_year = 254 AND category = 'jobs';

-- Day 255: BOXING TRAINER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['tough', 'motivating', 'experienced', 'disciplined', 'strong', 'dedicated', 'encouraging', 'patient', 'intense', 'skilled', 'inspiring', 'demanding'])
FROM puzzles WHERE day_of_year = 255 AND category = 'jobs';

-- Day 256: SKI INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'skilled', 'adventurous', 'encouraging', 'athletic', 'dedicated', 'calm', 'experienced', 'fit', 'friendly', 'confident', 'outdoor'])
FROM puzzles WHERE day_of_year = 256 AND category = 'jobs';

-- Day 257: SURFING INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'adventurous', 'skilled', 'relaxed', 'athletic', 'encouraging', 'dedicated', 'fit', 'cool', 'experienced', 'friendly', 'brave'])
FROM puzzles WHERE day_of_year = 257 AND category = 'jobs';

-- Day 258: SCUBA INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['calm', 'patient', 'skilled', 'adventurous', 'experienced', 'dedicated', 'brave', 'responsible', 'knowledgeable', 'fit', 'encouraging', 'careful'])
FROM puzzles WHERE day_of_year = 258 AND category = 'jobs';

-- Day 259: DRIVING INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'calm', 'experienced', 'encouraging', 'alert', 'clear', 'dedicated', 'observant', 'responsible', 'brave', 'composed', 'reassuring'])
FROM puzzles WHERE day_of_year = 259 AND category = 'jobs';

-- Day 260: FLIGHT INSTRUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['calm', 'patient', 'experienced', 'skilled', 'responsible', 'precise', 'dedicated', 'knowledgeable', 'composed', 'encouraging', 'professional', 'confident'])
FROM puzzles WHERE day_of_year = 260 AND category = 'jobs';

-- Day 261: MUSIC TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'passionate', 'talented', 'encouraging', 'dedicated', 'skilled', 'creative', 'inspiring', 'musical', 'supportive', 'disciplined', 'expressive'])
FROM puzzles WHERE day_of_year = 261 AND category = 'jobs';

-- Day 262: ART TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'patient', 'inspiring', 'artistic', 'encouraging', 'passionate', 'imaginative', 'dedicated', 'supportive', 'talented', 'expressive', 'skilled'])
FROM puzzles WHERE day_of_year = 262 AND category = 'jobs';

-- Day 263: DRAMA TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['expressive', 'creative', 'passionate', 'encouraging', 'theatrical', 'patient', 'inspiring', 'dedicated', 'dramatic', 'energetic', 'supportive', 'talented'])
FROM puzzles WHERE day_of_year = 263 AND category = 'jobs';

-- Day 264: DANCE TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['graceful', 'patient', 'encouraging', 'disciplined', 'dedicated', 'passionate', 'talented', 'inspiring', 'energetic', 'creative', 'expressive', 'skilled'])
FROM puzzles WHERE day_of_year = 264 AND category = 'jobs';

-- Day 265: LANGUAGE TEACHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'articulate', 'knowledgeable', 'encouraging', 'dedicated', 'passionate', 'cultured', 'clear', 'supportive', 'engaging', 'multilingual', 'skilled'])
FROM puzzles WHERE day_of_year = 265 AND category = 'jobs';

-- Day 266: TRANSLATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'multilingual', 'patient', 'knowledgeable', 'dedicated', 'articulate', 'cultured', 'thorough', 'skilled', 'meticulous', 'focused', 'analytical'])
FROM puzzles WHERE day_of_year = 266 AND category = 'jobs';

-- Day 267: INTERPRETER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['quick', 'multilingual', 'articulate', 'focused', 'skilled', 'calm', 'professional', 'attentive', 'precise', 'cultured', 'dedicated', 'sharp'])
FROM puzzles WHERE day_of_year = 267 AND category = 'jobs';

-- Day 268: SIGN LANGUAGE INTERPRETER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['expressive', 'skilled', 'quick', 'attentive', 'patient', 'dedicated', 'compassionate', 'professional', 'focused', 'caring', 'communicative', 'precise'])
FROM puzzles WHERE day_of_year = 268 AND category = 'jobs';

-- Day 269: VOICE ACTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['expressive', 'versatile', 'talented', 'creative', 'skilled', 'dramatic', 'imaginative', 'dedicated', 'animated', 'engaging', 'passionate', 'professional'])
FROM puzzles WHERE day_of_year = 269 AND category = 'jobs';

-- Day 270: NARRATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['articulate', 'expressive', 'engaging', 'calm', 'skilled', 'talented', 'patient', 'dedicated', 'clear', 'professional', 'captivating', 'soothing'])
FROM puzzles WHERE day_of_year = 270 AND category = 'jobs';

-- Day 271: AUDIOBOOK READER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['expressive', 'articulate', 'patient', 'talented', 'engaging', 'skilled', 'dedicated', 'soothing', 'clear', 'dramatic', 'versatile', 'captivating'])
FROM puzzles WHERE day_of_year = 271 AND category = 'jobs';

-- Day 272: RADIO DJ
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['energetic', 'charismatic', 'entertaining', 'quick', 'engaging', 'personable', 'passionate', 'creative', 'spontaneous', 'lively', 'confident', 'musical'])
FROM puzzles WHERE day_of_year = 272 AND category = 'jobs';

-- Day 273: CLUB DJ
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['energetic', 'skilled', 'creative', 'charismatic', 'musical', 'entertaining', 'passionate', 'cool', 'intuitive', 'dedicated', 'trendy', 'talented'])
FROM puzzles WHERE day_of_year = 273 AND category = 'jobs';

-- Day 274: SOUND ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['technical', 'skilled', 'patient', 'precise', 'creative', 'dedicated', 'focused', 'knowledgeable', 'musical', 'meticulous', 'experienced', 'analytical'])
FROM puzzles WHERE day_of_year = 274 AND category = 'jobs';

-- Day 275: RECORDING ENGINEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['technical', 'skilled', 'patient', 'creative', 'precise', 'musical', 'dedicated', 'focused', 'experienced', 'meticulous', 'collaborative', 'passionate'])
FROM puzzles WHERE day_of_year = 275 AND category = 'jobs';

-- Day 276: MUSIC PRODUCER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'musical', 'skilled', 'visionary', 'passionate', 'technical', 'dedicated', 'innovative', 'collaborative', 'patient', 'talented', 'ambitious'])
FROM puzzles WHERE day_of_year = 276 AND category = 'jobs';

-- Day 277: FILM EDITOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'creative', 'skilled', 'precise', 'dedicated', 'artistic', 'focused', 'meticulous', 'technical', 'storytelling', 'collaborative', 'passionate'])
FROM puzzles WHERE day_of_year = 277 AND category = 'jobs';

-- Day 278: VIDEO EDITOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'patient', 'skilled', 'technical', 'precise', 'dedicated', 'artistic', 'focused', 'meticulous', 'innovative', 'passionate', 'collaborative'])
FROM puzzles WHERE day_of_year = 278 AND category = 'jobs';

-- Day 279: CINEMATOGRAPHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['artistic', 'creative', 'visual', 'skilled', 'technical', 'passionate', 'patient', 'imaginative', 'dedicated', 'observant', 'innovative', 'talented'])
FROM puzzles WHERE day_of_year = 279 AND category = 'jobs';

-- Day 280: CAMERA OPERATOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['steady', 'skilled', 'patient', 'focused', 'technical', 'dedicated', 'observant', 'precise', 'experienced', 'creative', 'professional', 'calm'])
FROM puzzles WHERE day_of_year = 280 AND category = 'jobs';

-- Day 281: GRIP
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['strong', 'hardworking', 'skilled', 'reliable', 'dedicated', 'technical', 'patient', 'experienced', 'collaborative', 'tough', 'resourceful', 'professional'])
FROM puzzles WHERE day_of_year = 281 AND category = 'jobs';

-- Day 282: GAFFER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['technical', 'skilled', 'creative', 'experienced', 'dedicated', 'collaborative', 'knowledgeable', 'patient', 'resourceful', 'professional', 'artistic', 'reliable'])
FROM puzzles WHERE day_of_year = 282 AND category = 'jobs';

-- Day 283: SET DESIGNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'imaginative', 'skilled', 'visual', 'dedicated', 'collaborative', 'resourceful', 'patient', 'innovative', 'passionate', 'practical'])
FROM puzzles WHERE day_of_year = 283 AND category = 'jobs';

-- Day 284: PROP MASTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'creative', 'resourceful', 'dedicated', 'meticulous', 'skilled', 'patient', 'imaginative', 'thorough', 'reliable', 'collaborative', 'experienced'])
FROM puzzles WHERE day_of_year = 284 AND category = 'jobs';

-- Day 285: COSTUME DESIGNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'skilled', 'imaginative', 'dedicated', 'passionate', 'meticulous', 'researching', 'collaborative', 'visionary', 'talented', 'patient'])
FROM puzzles WHERE day_of_year = 285 AND category = 'jobs';

-- Day 286: WARDROBE STYLIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['stylish', 'creative', 'organized', 'trendy', 'skilled', 'dedicated', 'aesthetic', 'patient', 'collaborative', 'fashionable', 'resourceful', 'meticulous'])
FROM puzzles WHERE day_of_year = 286 AND category = 'jobs';

-- Day 287: SPECIAL EFFECTS ARTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'skilled', 'technical', 'imaginative', 'innovative', 'patient', 'dedicated', 'artistic', 'meticulous', 'passionate', 'talented', 'resourceful'])
FROM puzzles WHERE day_of_year = 287 AND category = 'jobs';

-- Day 288: CGI ARTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'technical', 'artistic', 'patient', 'skilled', 'innovative', 'imaginative', 'dedicated', 'meticulous', 'talented', 'focused', 'passionate'])
FROM puzzles WHERE day_of_year = 288 AND category = 'jobs';

-- Day 289: MOTION CAPTURE ARTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['expressive', 'athletic', 'skilled', 'dedicated', 'creative', 'patient', 'talented', 'technical', 'versatile', 'focused', 'imaginative', 'precise'])
FROM puzzles WHERE day_of_year = 289 AND category = 'jobs';

-- Day 290: FOLEY ARTIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'imaginative', 'skilled', 'patient', 'resourceful', 'dedicated', 'observant', 'artistic', 'innovative', 'meticulous', 'passionate', 'talented'])
FROM puzzles WHERE day_of_year = 290 AND category = 'jobs';

-- Day 291: COMPOSER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'musical', 'talented', 'imaginative', 'passionate', 'dedicated', 'expressive', 'patient', 'inspired', 'skilled', 'artistic', 'visionary'])
FROM puzzles WHERE day_of_year = 291 AND category = 'jobs';

-- Day 292: CONDUCTOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['commanding', 'musical', 'passionate', 'expressive', 'talented', 'charismatic', 'precise', 'dedicated', 'inspiring', 'skilled', 'authoritative', 'elegant'])
FROM puzzles WHERE day_of_year = 292 AND category = 'jobs';

-- Day 293: ORCHESTRA MUSICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['talented', 'disciplined', 'dedicated', 'skilled', 'passionate', 'musical', 'patient', 'collaborative', 'precise', 'focused', 'expressive', 'professional'])
FROM puzzles WHERE day_of_year = 293 AND category = 'jobs';

-- Day 294: OPERA SINGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['talented', 'dramatic', 'passionate', 'expressive', 'powerful', 'disciplined', 'dedicated', 'elegant', 'theatrical', 'emotional', 'skilled', 'gifted'])
FROM puzzles WHERE day_of_year = 294 AND category = 'jobs';

-- Day 295: BACKUP SINGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['talented', 'supportive', 'skilled', 'harmonious', 'dedicated', 'professional', 'musical', 'versatile', 'reliable', 'patient', 'collaborative', 'passionate'])
FROM puzzles WHERE day_of_year = 295 AND category = 'jobs';

-- Day 296: SESSION MUSICIAN
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'versatile', 'professional', 'talented', 'adaptable', 'dedicated', 'reliable', 'musical', 'patient', 'collaborative', 'experienced', 'quick'])
FROM puzzles WHERE day_of_year = 296 AND category = 'jobs';

-- Day 297: ROADIE
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['hardworking', 'strong', 'dedicated', 'reliable', 'technical', 'patient', 'resilient', 'tireless', 'experienced', 'resourceful', 'flexible', 'tough'])
FROM puzzles WHERE day_of_year = 297 AND category = 'jobs';

-- Day 298: CONCERT PROMOTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['ambitious', 'networked', 'persuasive', 'organized', 'risk-taking', 'passionate', 'strategic', 'dedicated', 'experienced', 'connected', 'resourceful', 'bold'])
FROM puzzles WHERE day_of_year = 298 AND category = 'jobs';

-- Day 299: TALENT AGENT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'networked', 'ambitious', 'strategic', 'persistent', 'confident', 'observant', 'dedicated', 'charming', 'experienced', 'connected', 'shrewd'])
FROM puzzles WHERE day_of_year = 299 AND category = 'jobs';

-- Day 300: PUBLICIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['articulate', 'strategic', 'networked', 'persuasive', 'dedicated', 'resourceful', 'professional', 'organized', 'connected', 'diplomatic', 'confident', 'charismatic'])
FROM puzzles WHERE day_of_year = 300 AND category = 'jobs';

-- Day 301: PRESS SECRETARY
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['articulate', 'composed', 'diplomatic', 'quick', 'professional', 'strategic', 'calm', 'confident', 'knowledgeable', 'polished', 'loyal', 'poised'])
FROM puzzles WHERE day_of_year = 301 AND category = 'jobs';

-- Day 302: SPEECHWRITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['articulate', 'creative', 'persuasive', 'eloquent', 'dedicated', 'insightful', 'strategic', 'skilled', 'passionate', 'thoughtful', 'talented', 'collaborative'])
FROM puzzles WHERE day_of_year = 302 AND category = 'jobs';

-- Day 303: COPYWRITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'persuasive', 'articulate', 'clever', 'dedicated', 'imaginative', 'witty', 'skilled', 'adaptable', 'passionate', 'concise', 'talented'])
FROM puzzles WHERE day_of_year = 303 AND category = 'jobs';

-- Day 304: CONTENT WRITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'articulate', 'dedicated', 'adaptable', 'curious', 'skilled', 'consistent', 'patient', 'passionate', 'thorough', 'versatile', 'engaging'])
FROM puzzles WHERE day_of_year = 304 AND category = 'jobs';

-- Day 305: TECHNICAL WRITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['clear', 'precise', 'organized', 'patient', 'thorough', 'dedicated', 'analytical', 'skilled', 'methodical', 'articulate', 'meticulous', 'logical'])
FROM puzzles WHERE day_of_year = 305 AND category = 'jobs';

-- Day 306: GRANT WRITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'thorough', 'dedicated', 'organized', 'articulate', 'patient', 'strategic', 'persistent', 'skilled', 'meticulous', 'passionate', 'analytical'])
FROM puzzles WHERE day_of_year = 306 AND category = 'jobs';

-- Day 307: EDITOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['meticulous', 'patient', 'articulate', 'thorough', 'dedicated', 'precise', 'knowledgeable', 'skilled', 'critical', 'organized', 'analytical', 'experienced'])
FROM puzzles WHERE day_of_year = 307 AND category = 'jobs';

-- Day 308: PROOFREADER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['meticulous', 'patient', 'precise', 'thorough', 'dedicated', 'focused', 'observant', 'detail-oriented', 'skilled', 'organized', 'accurate', 'reliable'])
FROM puzzles WHERE day_of_year = 308 AND category = 'jobs';

-- Day 309: LITERARY AGENT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'networked', 'passionate', 'strategic', 'articulate', 'dedicated', 'observant', 'experienced', 'supportive', 'persistent', 'shrewd', 'connected'])
FROM puzzles WHERE day_of_year = 309 AND category = 'jobs';

-- Day 310: PUBLISHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['strategic', 'experienced', 'passionate', 'decisive', 'networked', 'knowledgeable', 'dedicated', 'business-minded', 'visionary', 'risk-taking', 'organized', 'influential'])
FROM puzzles WHERE day_of_year = 310 AND category = 'jobs';

-- Day 311: BOOK DESIGNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'visual', 'patient', 'skilled', 'aesthetic', 'dedicated', 'meticulous', 'imaginative', 'passionate', 'talented', 'organized'])
FROM puzzles WHERE day_of_year = 311 AND category = 'jobs';

-- Day 312: TYPOGRAPHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'artistic', 'patient', 'meticulous', 'creative', 'dedicated', 'aesthetic', 'skilled', 'visual', 'passionate', 'detail-oriented', 'talented'])
FROM puzzles WHERE day_of_year = 312 AND category = 'jobs';

-- Day 313: CALLIGRAPHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['artistic', 'patient', 'precise', 'skilled', 'elegant', 'dedicated', 'meticulous', 'steady', 'creative', 'traditional', 'talented', 'passionate'])
FROM puzzles WHERE day_of_year = 313 AND category = 'jobs';

-- Day 314: SIGN MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'creative', 'precise', 'patient', 'artistic', 'dedicated', 'practical', 'meticulous', 'experienced', 'visual', 'hardworking', 'resourceful'])
FROM puzzles WHERE day_of_year = 314 AND category = 'jobs';

-- Day 315: ENGRAVER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'patient', 'skilled', 'artistic', 'meticulous', 'dedicated', 'steady', 'creative', 'experienced', 'careful', 'talented', 'traditional'])
FROM puzzles WHERE day_of_year = 315 AND category = 'jobs';

-- Day 316: PRINTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['technical', 'precise', 'organized', 'patient', 'dedicated', 'skilled', 'reliable', 'meticulous', 'experienced', 'thorough', 'hardworking', 'efficient'])
FROM puzzles WHERE day_of_year = 316 AND category = 'jobs';

-- Day 317: BOOKBINDER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'skilled', 'meticulous', 'traditional', 'dedicated', 'artistic', 'precise', 'experienced', 'careful', 'passionate', 'crafty', 'talented'])
FROM puzzles WHERE day_of_year = 317 AND category = 'jobs';

-- Day 318: PAPERMAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'skilled', 'traditional', 'dedicated', 'meticulous', 'artistic', 'experienced', 'precise', 'passionate', 'crafty', 'resourceful', 'creative'])
FROM puzzles WHERE day_of_year = 318 AND category = 'jobs';

-- Day 319: GLASS BLOWER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'creative', 'artistic', 'brave', 'dedicated', 'precise', 'experienced', 'talented', 'passionate', 'steady', 'imaginative'])
FROM puzzles WHERE day_of_year = 319 AND category = 'jobs';

-- Day 320: POTTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'patient', 'artistic', 'skilled', 'dedicated', 'passionate', 'imaginative', 'calm', 'talented', 'experienced', 'tactile', 'peaceful'])
FROM puzzles WHERE day_of_year = 320 AND category = 'jobs';

-- Day 321: CERAMICIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['artistic', 'creative', 'patient', 'skilled', 'dedicated', 'imaginative', 'passionate', 'tactile', 'experienced', 'talented', 'precise', 'calm'])
FROM puzzles WHERE day_of_year = 321 AND category = 'jobs';

-- Day 322: WOODWORKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'creative', 'precise', 'dedicated', 'experienced', 'artistic', 'practical', 'passionate', 'meticulous', 'strong', 'talented'])
FROM puzzles WHERE day_of_year = 322 AND category = 'jobs';

-- Day 323: FURNITURE MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'creative', 'patient', 'precise', 'artistic', 'dedicated', 'practical', 'experienced', 'meticulous', 'passionate', 'talented', 'strong'])
FROM puzzles WHERE day_of_year = 323 AND category = 'jobs';

-- Day 324: UPHOLSTERER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'precise', 'creative', 'dedicated', 'meticulous', 'experienced', 'artistic', 'practical', 'hardworking', 'talented', 'thorough'])
FROM puzzles WHERE day_of_year = 324 AND category = 'jobs';

-- Day 325: LEATHERWORKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'creative', 'precise', 'dedicated', 'artistic', 'experienced', 'meticulous', 'passionate', 'talented', 'traditional', 'crafty'])
FROM puzzles WHERE day_of_year = 325 AND category = 'jobs';

-- Day 326: SHOEMAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'precise', 'creative', 'dedicated', 'meticulous', 'traditional', 'experienced', 'artistic', 'passionate', 'talented', 'crafty'])
FROM puzzles WHERE day_of_year = 326 AND category = 'jobs';

-- Day 327: COBBLER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'experienced', 'traditional', 'dedicated', 'meticulous', 'practical', 'reliable', 'humble', 'hardworking', 'crafty', 'precise'])
FROM puzzles WHERE day_of_year = 327 AND category = 'jobs';

-- Day 328: HATMAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'skilled', 'artistic', 'patient', 'dedicated', 'precise', 'imaginative', 'traditional', 'passionate', 'meticulous', 'talented', 'stylish'])
FROM puzzles WHERE day_of_year = 328 AND category = 'jobs';

-- Day 329: WIG MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'meticulous', 'creative', 'dedicated', 'precise', 'artistic', 'experienced', 'talented', 'passionate', 'gentle', 'careful'])
FROM puzzles WHERE day_of_year = 329 AND category = 'jobs';

-- Day 330: PROP MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'skilled', 'resourceful', 'imaginative', 'dedicated', 'patient', 'artistic', 'versatile', 'experienced', 'practical', 'talented', 'innovative'])
FROM puzzles WHERE day_of_year = 330 AND category = 'jobs';

-- Day 331: PUPPET MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'imaginative', 'skilled', 'artistic', 'patient', 'playful', 'dedicated', 'talented', 'passionate', 'whimsical', 'meticulous', 'expressive'])
FROM puzzles WHERE day_of_year = 331 AND category = 'jobs';

-- Day 332: TOY MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'imaginative', 'playful', 'skilled', 'patient', 'dedicated', 'artistic', 'joyful', 'talented', 'whimsical', 'passionate', 'innovative'])
FROM puzzles WHERE day_of_year = 332 AND category = 'jobs';

-- Day 333: DOLL MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'patient', 'artistic', 'skilled', 'meticulous', 'dedicated', 'imaginative', 'passionate', 'gentle', 'talented', 'precise', 'whimsical'])
FROM puzzles WHERE day_of_year = 333 AND category = 'jobs';

-- Day 334: INSTRUMENT MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'precise', 'musical', 'dedicated', 'artistic', 'experienced', 'passionate', 'meticulous', 'talented', 'traditional', 'creative'])
FROM puzzles WHERE day_of_year = 334 AND category = 'jobs';

-- Day 335: PIANO TUNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'precise', 'musical', 'skilled', 'dedicated', 'experienced', 'meticulous', 'calm', 'focused', 'professional', 'reliable', 'attentive'])
FROM puzzles WHERE day_of_year = 335 AND category = 'jobs';

-- Day 336: LUTHIER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'patient', 'artistic', 'precise', 'dedicated', 'musical', 'passionate', 'experienced', 'meticulous', 'traditional', 'talented', 'crafty'])
FROM puzzles WHERE day_of_year = 336 AND category = 'jobs';

-- Day 337: BREWER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'creative', 'passionate', 'knowledgeable', 'dedicated', 'skilled', 'innovative', 'scientific', 'experienced', 'meticulous', 'artistic', 'experimental'])
FROM puzzles WHERE day_of_year = 337 AND category = 'jobs';

-- Day 338: WINEMAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'passionate', 'knowledgeable', 'dedicated', 'skilled', 'refined', 'experienced', 'scientific', 'artistic', 'traditional', 'sophisticated', 'meticulous'])
FROM puzzles WHERE day_of_year = 338 AND category = 'jobs';

-- Day 339: DISTILLER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'skilled', 'passionate', 'knowledgeable', 'dedicated', 'scientific', 'experienced', 'meticulous', 'traditional', 'innovative', 'precise', 'creative'])
FROM puzzles WHERE day_of_year = 339 AND category = 'jobs';

-- Day 340: CHEESEMAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['patient', 'skilled', 'passionate', 'dedicated', 'knowledgeable', 'traditional', 'experienced', 'meticulous', 'scientific', 'artistic', 'precise', 'creative'])
FROM puzzles WHERE day_of_year = 340 AND category = 'jobs';

-- Day 341: BAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['early-rising', 'patient', 'skilled', 'creative', 'dedicated', 'passionate', 'hardworking', 'precise', 'warm', 'experienced', 'artistic', 'nurturing'])
FROM puzzles WHERE day_of_year = 341 AND category = 'jobs';

-- Day 342: PASTRY CHEF
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'precise', 'artistic', 'patient', 'skilled', 'dedicated', 'passionate', 'meticulous', 'imaginative', 'talented', 'perfectionist', 'elegant'])
FROM puzzles WHERE day_of_year = 342 AND category = 'jobs';

-- Day 343: CHOCOLATIER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'artistic', 'passionate', 'precise', 'skilled', 'dedicated', 'elegant', 'imaginative', 'meticulous', 'talented', 'refined', 'patient'])
FROM puzzles WHERE day_of_year = 343 AND category = 'jobs';

-- Day 344: ICE CREAM MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['creative', 'passionate', 'skilled', 'innovative', 'patient', 'dedicated', 'playful', 'artistic', 'joyful', 'experimental', 'talented', 'imaginative'])
FROM puzzles WHERE day_of_year = 344 AND category = 'jobs';

-- Day 345: BUTCHER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'strong', 'precise', 'experienced', 'dedicated', 'knowledgeable', 'traditional', 'hardworking', 'reliable', 'patient', 'professional', 'efficient'])
FROM puzzles WHERE day_of_year = 345 AND category = 'jobs';

-- Day 346: FISHMONGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'early-rising', 'skilled', 'experienced', 'dedicated', 'hardworking', 'friendly', 'reliable', 'traditional', 'professional', 'loud', 'patient'])
FROM puzzles WHERE day_of_year = 346 AND category = 'jobs';

-- Day 347: SUSHI CHEF
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['precise', 'skilled', 'artistic', 'patient', 'dedicated', 'disciplined', 'traditional', 'meticulous', 'passionate', 'elegant', 'focused', 'experienced'])
FROM puzzles WHERE day_of_year = 347 AND category = 'jobs';

-- Day 348: PIZZA MAKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['skilled', 'passionate', 'fast', 'dedicated', 'creative', 'traditional', 'hardworking', 'experienced', 'friendly', 'precise', 'energetic', 'patient'])
FROM puzzles WHERE day_of_year = 348 AND category = 'jobs';

-- Day 349: FOOD TRUCK OWNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['entrepreneurial', 'hardworking', 'creative', 'dedicated', 'passionate', 'resourceful', 'friendly', 'resilient', 'adventurous', 'skilled', 'ambitious', 'independent'])
FROM puzzles WHERE day_of_year = 349 AND category = 'jobs';

-- Day 350: STREET VENDOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['hardworking', 'resilient', 'friendly', 'entrepreneurial', 'patient', 'dedicated', 'resourceful', 'persistent', 'loud', 'tough', 'independent', 'charming'])
FROM puzzles WHERE day_of_year = 350 AND category = 'jobs';

-- Day 351: AUCTIONEER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['fast', 'charismatic', 'articulate', 'energetic', 'knowledgeable', 'entertaining', 'confident', 'quick', 'persuasive', 'experienced', 'engaging', 'loud'])
FROM puzzles WHERE day_of_year = 351 AND category = 'jobs';

-- Day 352: ANTIQUE DEALER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'patient', 'observant', 'experienced', 'passionate', 'shrewd', 'dedicated', 'cultured', 'discerning', 'curious', 'resourceful', 'networked'])
FROM puzzles WHERE day_of_year = 352 AND category = 'jobs';

-- Day 353: PAWNBROKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['shrewd', 'observant', 'patient', 'knowledgeable', 'experienced', 'cautious', 'business-minded', 'resourceful', 'tough', 'fair', 'discreet', 'calculating'])
FROM puzzles WHERE day_of_year = 353 AND category = 'jobs';

-- Day 354: APPRAISER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['knowledgeable', 'observant', 'analytical', 'experienced', 'thorough', 'precise', 'patient', 'objective', 'dedicated', 'discerning', 'professional', 'meticulous'])
FROM puzzles WHERE day_of_year = 354 AND category = 'jobs';

-- Day 355: INSURANCE AGENT
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['persuasive', 'patient', 'knowledgeable', 'persistent', 'professional', 'friendly', 'trustworthy', 'organized', 'dedicated', 'helpful', 'ambitious', 'reliable'])
FROM puzzles WHERE day_of_year = 355 AND category = 'jobs';

-- Day 356: CLAIMS ADJUSTER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'thorough', 'patient', 'observant', 'fair', 'organized', 'dedicated', 'professional', 'objective', 'meticulous', 'experienced', 'persistent'])
FROM puzzles WHERE day_of_year = 356 AND category = 'jobs';

-- Day 357: ACTUARY
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'mathematical', 'precise', 'logical', 'patient', 'intelligent', 'dedicated', 'methodical', 'thorough', 'detail-oriented', 'focused', 'skilled'])
FROM puzzles WHERE day_of_year = 357 AND category = 'jobs';

-- Day 358: UNDERWRITER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'thorough', 'cautious', 'methodical', 'patient', 'precise', 'dedicated', 'organized', 'logical', 'experienced', 'detail-oriented', 'responsible'])
FROM puzzles WHERE day_of_year = 358 AND category = 'jobs';

-- Day 359: FINANCIAL PLANNER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'trustworthy', 'patient', 'knowledgeable', 'organized', 'dedicated', 'strategic', 'professional', 'thorough', 'supportive', 'experienced', 'caring'])
FROM puzzles WHERE day_of_year = 359 AND category = 'jobs';

-- Day 360: WEALTH MANAGER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'trustworthy', 'strategic', 'knowledgeable', 'professional', 'patient', 'discreet', 'dedicated', 'experienced', 'sophisticated', 'confident', 'networked'])
FROM puzzles WHERE day_of_year = 360 AND category = 'jobs';

-- Day 361: STOCKBROKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['aggressive', 'quick', 'ambitious', 'confident', 'analytical', 'persuasive', 'competitive', 'bold', 'sharp', 'dedicated', 'strategic', 'driven'])
FROM puzzles WHERE day_of_year = 361 AND category = 'jobs';

-- Day 362: INVESTMENT BANKER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['ambitious', 'analytical', 'competitive', 'driven', 'intelligent', 'dedicated', 'strategic', 'confident', 'hardworking', 'sharp', 'networked', 'tireless'])
FROM puzzles WHERE day_of_year = 362 AND category = 'jobs';

-- Day 363: VENTURE CAPITALIST
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['analytical', 'bold', 'risk-taking', 'visionary', 'networked', 'strategic', 'experienced', 'shrewd', 'confident', 'ambitious', 'patient', 'wealthy'])
FROM puzzles WHERE day_of_year = 363 AND category = 'jobs';

-- Day 364: AUDITOR
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['thorough', 'analytical', 'meticulous', 'organized', 'precise', 'patient', 'dedicated', 'objective', 'ethical', 'methodical', 'detail-oriented', 'professional'])
FROM puzzles WHERE day_of_year = 364 AND category = 'jobs';

-- Day 365: BOOKKEEPER
INSERT INTO candidate_traits (puzzle_id, word)
SELECT id, unnest(ARRAY['organized', 'precise', 'reliable', 'patient', 'meticulous', 'dedicated', 'trustworthy', 'thorough', 'methodical', 'accurate', 'detail-oriented', 'responsible'])
FROM puzzles WHERE day_of_year = 365 AND category = 'jobs';

-- ============================================================================
-- MIGRATION COMPLETE
-- ============================================================================
-- This script has created 365 jobs puzzles (one for each day of the year)
-- with 12 candidate traits each. The app should be modified to:
-- 1. Query puzzles by day_of_year instead of date
-- 2. Use: EXTRACT(DOY FROM CURRENT_DATE) to get the current day of year
-- ============================================================================


-- ============================================================================
-- PART 5: UPDATE DATABASE FUNCTIONS FOR DAY_OF_YEAR
-- ============================================================================

-- Drop existing function first (signature is changing)
DROP FUNCTION IF EXISTS get_trait_pair_for_voting(VARCHAR);

-- Update the get_trait_pair_for_voting function to use day_of_year
CREATE OR REPLACE FUNCTION get_trait_pair_for_voting(p_player_id VARCHAR DEFAULT NULL)
RETURNS TABLE (
  puzzle_id UUID,
  answer VARCHAR,
  category VARCHAR,
  puzzle_date DATE,
  day_of_year INT,
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
  v_day_of_year INT;
  v_current_doy INT;
BEGIN
  -- Get current day of year
  v_current_doy := EXTRACT(DOY FROM CURRENT_DATE)::INT;
  
  -- Find a puzzle for a future day_of_year (wrapping around at year end)
  -- Look for puzzles with day_of_year > current, or wrap to beginning of year
  SELECT p.id, p.answer, p.category, p.date, p.day_of_year
  INTO v_puzzle_id, v_answer, v_category, v_puzzle_date, v_day_of_year
  FROM puzzles p
  WHERE p.day_of_year IS NOT NULL
    AND p.day_of_year != v_current_doy
    AND EXISTS (SELECT 1 FROM candidate_traits ct WHERE ct.puzzle_id = p.id)
  ORDER BY 
    CASE WHEN p.day_of_year > v_current_doy THEN 0 ELSE 1 END,
    p.day_of_year ASC,
    RANDOM()
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
    v_day_of_year,
    (SELECT id FROM random_traits LIMIT 1 OFFSET 0),
    (SELECT word FROM random_traits LIMIT 1 OFFSET 0),
    (SELECT vote_count FROM random_traits LIMIT 1 OFFSET 0),
    (SELECT id FROM random_traits LIMIT 1 OFFSET 1),
    (SELECT word FROM random_traits LIMIT 1 OFFSET 1),
    (SELECT vote_count FROM random_traits LIMIT 1 OFFSET 1);
END;
$$ LANGUAGE plpgsql;

-- Update get_todays_leaderboard to use day_of_year
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
DECLARE
  v_current_doy INT;
BEGIN
  v_current_doy := EXTRACT(DOY FROM CURRENT_DATE)::INT;
  
  RETURN QUERY
  SELECT 
    gr.id,
    gr.player_id,
    gr.mode,
    gr.time_spent,
    gr.incorrect_count,
    gr.created_at,
    ROW_NUMBER() OVER (
      PARTITION BY gr.puzzle_id 
      ORDER BY gr.incorrect_count ASC, gr.time_spent ASC
    ) as rank
  FROM game_results gr
  JOIN puzzles p ON gr.puzzle_id = p.id
  WHERE gr.won = true
    AND p.day_of_year = v_current_doy
    AND (p_category IS NULL OR p.category = p_category)
  ORDER BY gr.incorrect_count ASC, gr.time_spent ASC
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- END OF MIGRATION
-- ============================================================================
