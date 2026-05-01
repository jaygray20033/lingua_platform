-- =====================================================
-- V9: Grammar Detail Extension - thêm explanation, examples, practice
-- =====================================================

-- Mở rộng bảng grammars: thêm explanation chi tiết, formation, usage, common_mistakes
ALTER TABLE grammars
    ADD COLUMN explanation_vi LONGTEXT AFTER note,
    ADD COLUMN explanation_en LONGTEXT AFTER explanation_vi,
    ADD COLUMN formation TEXT AFTER explanation_en,
    ADD COLUMN usage_context TEXT AFTER formation,
    ADD COLUMN common_mistakes TEXT AFTER usage_context,
    ADD COLUMN related_patterns TEXT AFTER common_mistakes,
    ADD COLUMN difficulty_score INT DEFAULT 1 AFTER related_patterns,
    ADD COLUMN audio_url VARCHAR(500) AFTER difficulty_score;

-- Bảng ví dụ ngữ pháp (mỗi pattern có thể có nhiều ví dụ)
CREATE TABLE IF NOT EXISTS grammar_examples (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    grammar_id BIGINT NOT NULL,
    sentence TEXT NOT NULL,
    reading TEXT,
    romaji TEXT,
    translation_vi TEXT,
    translation_en TEXT,
    note TEXT,
    audio_url VARCHAR(500),
    order_index INT DEFAULT 0,
    FOREIGN KEY (grammar_id) REFERENCES grammars(id) ON DELETE CASCADE,
    INDEX idx_ge_grammar (grammar_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng bài tập thực hành ngữ pháp
CREATE TABLE IF NOT EXISTS grammar_exercises (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    grammar_id BIGINT NOT NULL,
    type ENUM('MULTIPLE_CHOICE','FILL_BLANK','REORDER','TRANSLATE') DEFAULT 'MULTIPLE_CHOICE',
    question_json JSON NOT NULL,
    answer_json JSON NOT NULL,
    explanation TEXT,
    difficulty INT DEFAULT 1,
    order_index INT DEFAULT 0,
    FOREIGN KEY (grammar_id) REFERENCES grammars(id) ON DELETE CASCADE,
    INDEX idx_gex_grammar (grammar_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
