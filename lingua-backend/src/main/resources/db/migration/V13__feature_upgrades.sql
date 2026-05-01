-- =====================================================================
-- V13__feature_upgrades.sql
-- Feature upgrades: daily goals, user decks, word/kanji favorites,
-- refresh tokens bookkeeping, and stroke order data for kanji.
-- =====================================================================

-- ---------------------------------------------------------------------
-- FEAT-08: Daily goal per user (XP target per day)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_daily_goals (
    user_id       BIGINT PRIMARY KEY,
    daily_xp_goal INT          NOT NULL DEFAULT 20,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- FEAT-19: Word/Kanji favorites (bookmarks)
-- Polymorphic: item_type = WORD | CHARACTER
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_favorites (
    id         BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id    BIGINT       NOT NULL,
    item_type  ENUM('WORD','CHARACTER','GRAMMAR') NOT NULL,
    item_id    BIGINT       NOT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_item (user_id, item_type, item_id),
    INDEX idx_favorites_user (user_id, item_type),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- FEAT-20: Kanji stroke order data (SVG paths / JSON sequences)
-- Stroke data is optional — front-end can fall back to Hanzi Writer CDN.
-- ---------------------------------------------------------------------
ALTER TABLE characters_table
    ADD COLUMN stroke_order_json JSON NULL;

-- ---------------------------------------------------------------------
-- FEAT-06: Seed a few core achievement definitions if missing. The
-- `trigger_rule` JSON is consumed by AchievementService.
--
-- Supported rule shapes:
--   { "type": "STREAK_DAYS",        "threshold": 7 }
--   { "type": "TOTAL_XP",           "threshold": 100 }
--   { "type": "LESSONS_COMPLETED",  "threshold": 10 }
--   { "type": "SRS_REVIEWS",        "threshold": 50 }
-- ---------------------------------------------------------------------
INSERT IGNORE INTO achievements (code, title, description, rarity, trigger_rule) VALUES
    ('FIRST_LESSON',   'Bước đi đầu tiên',  'Hoàn thành bài học đầu tiên của bạn',   'COMMON',    JSON_OBJECT('type','LESSONS_COMPLETED','threshold',1)),
    ('STREAK_7',       'Chuỗi 7 ngày',      'Duy trì streak 7 ngày liên tiếp',       'UNCOMMON',  JSON_OBJECT('type','STREAK_DAYS','threshold',7)),
    ('STREAK_30',      'Chuỗi 30 ngày',     'Duy trì streak 30 ngày liên tiếp',      'RARE',      JSON_OBJECT('type','STREAK_DAYS','threshold',30)),
    ('STREAK_100',     'Bất tử 100 ngày',   'Duy trì streak 100 ngày liên tiếp',     'LEGENDARY', JSON_OBJECT('type','STREAK_DAYS','threshold',100)),
    ('XP_100',         'Người mới chăm chỉ', 'Đạt 100 XP',                           'COMMON',    JSON_OBJECT('type','TOTAL_XP','threshold',100)),
    ('XP_1000',        'Học giả',           'Đạt 1000 XP',                           'UNCOMMON',  JSON_OBJECT('type','TOTAL_XP','threshold',1000)),
    ('XP_10000',       'Bậc thầy ngôn ngữ', 'Đạt 10000 XP',                          'EPIC',      JSON_OBJECT('type','TOTAL_XP','threshold',10000)),
    ('LESSONS_10',     'Học trò chăm chỉ',  'Hoàn thành 10 bài học',                 'COMMON',    JSON_OBJECT('type','LESSONS_COMPLETED','threshold',10)),
    ('LESSONS_50',     'Kiên trì',          'Hoàn thành 50 bài học',                 'UNCOMMON',  JSON_OBJECT('type','LESSONS_COMPLETED','threshold',50)),
    ('SRS_50',         'Flashcard Master',  'Hoàn thành 50 lượt ôn SRS',             'UNCOMMON',  JSON_OBJECT('type','SRS_REVIEWS','threshold',50));

-- ---------------------------------------------------------------------
-- FEAT-07: seed a default Weekly League (Bronze) so leaderboard API has
-- something to return even before an admin creates leagues manually.
-- ---------------------------------------------------------------------
INSERT IGNORE INTO leagues (id, name, tier, promotion_threshold) VALUES
    (1, 'Đồng',  1, 7),
    (2, 'Bạc',   2, 7),
    (3, 'Vàng',  3, 7),
    (4, 'Ngọc',  4, 5);
