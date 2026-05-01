-- =====================================================================
-- V17__daily_quests_and_streak_freeze.sql
-- UPGRADE-09: Daily Quest System — quest templates + per-user daily rolls.
-- UPGRADE-10: Streak Freeze ledger — record consumption and purchases.
-- UPGRADE-05: Sample stroke-order JSON for a few common kanji (fallback to
--             HanziWriter CDN remains the default).
-- =====================================================================

-- ---------------------------------------------------------------------
-- UPGRADE-09: quest templates
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS quest_templates (
    id            BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    code          VARCHAR(80)  NOT NULL UNIQUE,
    title         VARCHAR(200) NOT NULL,
    description   VARCHAR(400) NOT NULL,
    category      VARCHAR(50)  NOT NULL,        -- LESSON | SRS | XP | TEST | VOCAB
    target_count  INT          NOT NULL DEFAULT 1,
    reward_xp     INT          NOT NULL DEFAULT 5,
    reward_gems   INT          NOT NULL DEFAULT 5,
    icon          VARCHAR(20)  NULL,
    enabled       BOOLEAN      NOT NULL DEFAULT TRUE,
    INDEX idx_quest_template_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO quest_templates (code, title, description, category, target_count, reward_xp, reward_gems, icon) VALUES
    ('LEARN_10_WORDS',  'Học 10 từ vựng mới',     'Mở 10 từ trong Từ vựng / Hán tự hôm nay',           'VOCAB',  10, 10, 5,  '📖'),
    ('SRS_REVIEW_20',   'Ôn 20 thẻ Flashcard',    'Hoàn thành 20 lượt ôn SRS hôm nay',                 'SRS',    20, 15, 5,  '🧠'),
    ('SRS_REVIEW_50',   'Marathon Flashcard',     'Hoàn thành 50 lượt ôn SRS hôm nay',                 'SRS',    50, 30, 10, '🚀'),
    ('FINISH_LESSON_1', 'Hoàn thành 1 bài học',   'Học xong 1 bài học bất kỳ',                         'LESSON',  1, 10, 5,  '✅'),
    ('FINISH_LESSON_3', 'Học chăm 3 bài',         'Học xong 3 bài học hôm nay',                        'LESSON',  3, 25, 10, '🔥'),
    ('XP_30',           'Đạt 30 XP',              'Kiếm tổng 30 XP trong ngày hôm nay',                'XP',     30, 10, 5,  '⚡'),
    ('XP_100',          'Vượt mục tiêu 100 XP',   'Kiếm tổng 100 XP trong ngày hôm nay',               'XP',    100, 30, 15, '⭐'),
    ('TAKE_TEST_1',     'Thử sức 1 đề thi',       'Hoàn thành 1 mock test bất kỳ',                     'TEST',    1, 25, 10, '📝'),
    ('GRAMMAR_OPEN_3',  'Khám phá ngữ pháp',      'Mở chi tiết 3 ngữ pháp hôm nay',                    'VOCAB',   3, 10, 5,  '📐'),
    ('FAVORITE_5',      'Lưu yêu thích',          'Đánh dấu 5 từ/kanji vào Yêu thích hôm nay',          'VOCAB',   5,  5, 3,  '⭐');

-- ---------------------------------------------------------------------
-- Extend daily_quests to link to a template (optional) so the UI can
-- render category icons and reward metadata consistently.
-- ---------------------------------------------------------------------
ALTER TABLE daily_quests
    ADD COLUMN template_id BIGINT NULL AFTER quest_code,
    ADD COLUMN reward_xp   INT    NOT NULL DEFAULT 5 AFTER reward_gems,
    ADD COLUMN claimed     BOOLEAN NOT NULL DEFAULT FALSE AFTER completed,
    ADD INDEX idx_daily_quest_template (template_id);

-- ---------------------------------------------------------------------
-- UPGRADE-10: streak freeze purchase / consumption ledger
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS streak_freeze_log (
    id          BIGINT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT      NOT NULL,
    action      ENUM('PURCHASE','CONSUME','GRANT') NOT NULL,
    quantity    INT         NOT NULL DEFAULT 1,
    cost_gems   INT         NOT NULL DEFAULT 0,
    note        VARCHAR(200) NULL,
    created_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_freeze_user (user_id, created_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- BUG-BE-07: idempotency key for lesson completion. Prevents the same
-- finished attempt from being submitted twice (front-end double-click,
-- network retry, etc.). NULL is allowed for legacy rows.
-- ---------------------------------------------------------------------
ALTER TABLE lesson_attempts
    ADD COLUMN idempotency_key VARCHAR(64) NULL AFTER status,
    ADD UNIQUE KEY uk_lesson_attempt_idem (user_id, lesson_id, idempotency_key);

-- ---------------------------------------------------------------------
-- UPGRADE-05: minimal stroke-order JSON for a handful of N5 kanji so the
-- frontend has *some* offline data. The 3.5 HanziWriter CDN remains the
-- runtime fallback when stroke_order_json is NULL.
-- The JSON shape is HanziWriter's (strokes: SVG path strings).
-- ---------------------------------------------------------------------
UPDATE characters_table
SET stroke_order_json = JSON_OBJECT(
    'character', '一',
    'strokes', JSON_ARRAY('M 50 500 L 950 500'),
    'medians', JSON_ARRAY(JSON_ARRAY(JSON_ARRAY(50,500), JSON_ARRAY(950,500)))
)
WHERE `character_text` = '一' AND (stroke_order_json IS NULL);

UPDATE characters_table
SET stroke_order_json = JSON_OBJECT(
    'character', '二',
    'strokes', JSON_ARRAY('M 100 350 L 900 350','M 50 700 L 950 700'),
    'medians', JSON_ARRAY(
        JSON_ARRAY(JSON_ARRAY(100,350), JSON_ARRAY(900,350)),
        JSON_ARRAY(JSON_ARRAY(50,700),  JSON_ARRAY(950,700))
    )
)
WHERE `character_text` = '二' AND (stroke_order_json IS NULL);

UPDATE characters_table
SET stroke_order_json = JSON_OBJECT(
    'character', '三',
    'strokes', JSON_ARRAY(
        'M 100 250 L 900 250',
        'M 50  500 L 950 500',
        'M 50  750 L 950 750'
    )
)
WHERE `character_text` = '三' AND (stroke_order_json IS NULL);

UPDATE characters_table
SET stroke_order_json = JSON_OBJECT(
    'character', '人',
    'strokes', JSON_ARRAY(
        'M 500 100 L 200 900',
        'M 500 100 L 800 900'
    )
)
WHERE `character_text` = '人' AND (stroke_order_json IS NULL);

UPDATE characters_table
SET stroke_order_json = JSON_OBJECT(
    'character', '日',
    'strokes', JSON_ARRAY(
        'M 250 150 L 250 850',
        'M 250 150 L 750 150 L 750 850 L 250 850',
        'M 250 500 L 750 500'
    )
)
WHERE `character_text` = '日' AND (stroke_order_json IS NULL);

UPDATE characters_table
SET stroke_order_json = JSON_OBJECT(
    'character', '月',
    'strokes', JSON_ARRAY(
        'M 250 150 L 250 900',
        'M 250 150 L 750 200 L 750 850',
        'M 250 400 L 750 400',
        'M 250 600 L 750 600'
    )
)
WHERE `character_text` = '月' AND (stroke_order_json IS NULL);
