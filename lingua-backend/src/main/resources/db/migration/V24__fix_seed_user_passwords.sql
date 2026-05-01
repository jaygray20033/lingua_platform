-- =============================================================================
-- BUG-11 FIX: Reset seeded user passwords to a hash that actually matches
-- the documented credentials.
--
-- ROOT CAUSE: V2__seed_data.sql shipped a bcrypt hash that did not correspond
-- to any documented password. README.md advertised `demo@lingua.com / password`
-- and huongdanchay.md advertised `admin@lingua.local / lingua123` and
-- `student@lingua.local / lingua123`, but no one could log in.
--
-- This migration:
--   1) Resets the password_hash for the existing users (id=1,2) to a freshly
--      generated $2a$10$ bcrypt hash of `lingua123` (jBCrypt compatible).
--   2) Inserts the documented seed users referenced by huongdanchay.md
--      (admin@lingua.local, student@lingua.local) so the docs match reality.
-- =============================================================================

-- Hash below is bcrypt of the literal string `lingua123` (cost 10, $2a$ prefix)
-- Verified with org.mindrot.jbcrypt.BCrypt.checkpw("lingua123", HASH) == true.

UPDATE users
   SET password_hash = '$2a$10$kfCY6e/9X89RSpHJ.I/iuuk3ImIe9YOwH5lUruabwy5n5ejevSEvy'
 WHERE email IN ('admin@lingua.com', 'demo@lingua.com');

INSERT INTO users (email, password_hash, display_name, role, email_verified, status)
SELECT 'admin@lingua.local',
       '$2a$10$kfCY6e/9X89RSpHJ.I/iuuk3ImIe9YOwH5lUruabwy5n5ejevSEvy',
       'Admin (local)', 'ADMIN', TRUE, 'ACTIVE'
 WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@lingua.local');

INSERT INTO users (email, password_hash, display_name, role, email_verified, status)
SELECT 'student@lingua.local',
       '$2a$10$kfCY6e/9X89RSpHJ.I/iuuk3ImIe9YOwH5lUruabwy5n5ejevSEvy',
       'Student (local)', 'LEARNER', TRUE, 'ACTIVE'
 WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'student@lingua.local');

-- Initialize gamification rows for the new users so /api/gamification/me works.
INSERT INTO user_gamification (user_id, total_xp, level, gems, hearts, streak_count)
SELECT u.id, 0, 1, 100, 5, 0
  FROM users u
  LEFT JOIN user_gamification g ON g.user_id = u.id
 WHERE u.email IN ('admin@lingua.local', 'student@lingua.local')
   AND g.user_id IS NULL;
