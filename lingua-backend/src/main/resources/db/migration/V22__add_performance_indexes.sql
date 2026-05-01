-- =============================================================================
-- BUG-14: Thêm các index để tăng tốc các query thường xuyên.
--
-- FIX: Sửa tên cột/bảng cho khớp với schema thực tế:
--   - words: dùng (language_id, jlpt_level) thay vì (lang_code, level)
--   - flashcard_reviews: dùng next_review_at thay vì due_date
--   - favorites → user_favorites (tên bảng thực)
-- =============================================================================

DELIMITER $$

DROP PROCEDURE IF EXISTS create_index_if_not_exists$$
CREATE PROCEDURE create_index_if_not_exists(
    IN p_table   VARCHAR(64),
    IN p_index   VARCHAR(64),
    IN p_columns VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = p_table
          AND index_name = p_index
    ) AND EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = DATABASE()
          AND table_name = p_table
    ) THEN
        SET @sql = CONCAT('CREATE INDEX ', p_index, ' ON ', p_table, ' (', p_columns, ')');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$

DELIMITER ;

-- words(language_id, jlpt_level) — search/filter từ vựng theo ngôn ngữ + cấp độ JLPT
CALL create_index_if_not_exists('words', 'idx_words_lang_jlpt2', 'language_id, jlpt_level');
CALL create_index_if_not_exists('words', 'idx_words_lang_cefr', 'language_id, cefr_level');
CALL create_index_if_not_exists('words', 'idx_words_lang_hsk', 'language_id, hsk_level');

-- flashcard_reviews(user_id, next_review_at) — lấy thẻ đến hạn ôn tập
CALL create_index_if_not_exists('flashcard_reviews', 'idx_flashcard_due2', 'user_id, next_review_at');

-- daily_xp_logs(user_id, log_date) — biểu đồ XP theo ngày, streak
CALL create_index_if_not_exists('daily_xp_logs', 'idx_daily_xp_user_date', 'user_id, log_date');

-- lesson_attempts(user_id, completed_at) — lịch sử học tập
CALL create_index_if_not_exists('lesson_attempts', 'idx_lesson_attempts_user2', 'user_id, completed_at');

-- user_favorites(user_id, item_type) — danh sách yêu thích
CALL create_index_if_not_exists('user_favorites', 'idx_favorites_user_type', 'user_id, item_type');

-- refresh_tokens(user_id, expires_at) — auth refresh
CALL create_index_if_not_exists('refresh_tokens', 'idx_refresh_user_expires', 'user_id, expires_at');

DROP PROCEDURE IF EXISTS create_index_if_not_exists;
