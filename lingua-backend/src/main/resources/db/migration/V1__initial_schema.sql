-- =====================================================
-- LINGUA PLATFORM - Database Schema
-- Flyway Migration V1 - Initial Schema (30+ tables)
-- =====================================================

-- ========================
-- MODULE: AUTH & USER
-- ========================
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    display_name VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(500),
    auth_provider ENUM('LOCAL','GOOGLE','FACEBOOK','APPLE') DEFAULT 'LOCAL',
    provider_uid VARCHAR(255),
    native_language_code VARCHAR(10) DEFAULT 'vi',
    timezone VARCHAR(50) DEFAULT 'Asia/Ho_Chi_Minh',
    ui_language VARCHAR(10) DEFAULT 'vi',
    role ENUM('LEARNER','PREMIUM_LEARNER','CONTENT_CREATOR','TEACHER','ADMIN') DEFAULT 'LEARNER',
    email_verified BOOLEAN DEFAULT FALSE,
    status ENUM('ACTIVE','SUSPENDED','BANNED','DELETED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_email (email),
    INDEX idx_users_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE refresh_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token_hash VARCHAR(500) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    revoked_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_refresh_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE otp_codes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL,
    purpose ENUM('REGISTER','RESET_PW') NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_otp_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================
-- MODULE: LANGUAGE & COURSE
-- ========================
CREATE TABLE languages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    native_name VARCHAR(100),
    flag_emoji VARCHAR(10),
    direction ENUM('LTR','RTL') DEFAULT 'LTR'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_languages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    language_id BIGINT NOT NULL,
    level_code VARCHAR(20) DEFAULT 'N5',
    daily_xp_goal INT DEFAULT 20,
    reason ENUM('WORK','STUDY_ABROAD','TRAVEL','HOBBY','OTHER') DEFAULT 'HOBBY',
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id),
    UNIQUE KEY uk_user_lang (user_id, language_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE courses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    source_lang_id BIGINT NOT NULL,
    target_lang_id BIGINT NOT NULL,
    level_code VARCHAR(20),
    certification ENUM('JLPT','TOPIK','CEFR','HSK','IELTS','NONE') DEFAULT 'NONE',
    is_premium BOOLEAN DEFAULT FALSE,
    thumbnail_url VARCHAR(500),
    author_id BIGINT,
    status ENUM('DRAFT','PENDING_REVIEW','PUBLISHED','ARCHIVED') DEFAULT 'PUBLISHED',
    total_units INT DEFAULT 0,
    estimated_hours INT DEFAULT 0,
    rating_avg DECIMAL(3,2) DEFAULT 0.00,
    rating_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (source_lang_id) REFERENCES languages(id),
    FOREIGN KEY (target_lang_id) REFERENCES languages(id),
    FOREIGN KEY (author_id) REFERENCES users(id),
    INDEX idx_courses_lang (target_lang_id, level_code),
    INDEX idx_courses_cert (certification, level_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE enrollments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    status ENUM('ACTIVE','COMPLETED','DROPPED') DEFAULT 'ACTIVE',
    progress_percent DECIMAL(5,2) DEFAULT 0.00,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    UNIQUE KEY uk_enrollment (user_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================
-- MODULE: LEARNING PATH
-- ========================
CREATE TABLE sections (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT NOT NULL,
    order_index INT NOT NULL DEFAULT 0,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    cefr_mapping VARCHAR(10),
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    INDEX idx_sections_course (course_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE units (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    section_id BIGINT NOT NULL,
    order_index INT NOT NULL DEFAULT 0,
    title VARCHAR(255) NOT NULL,
    communication_goal VARCHAR(500),
    icon VARCHAR(100),
    xp_reward INT DEFAULT 50,
    FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
    INDEX idx_units_section (section_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE lessons (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    unit_id BIGINT NOT NULL,
    order_index INT NOT NULL DEFAULT 0,
    title VARCHAR(255) NOT NULL,
    type ENUM('NORMAL','STORY','CHECKPOINT','LEGENDARY') DEFAULT 'NORMAL',
    xp_reward INT DEFAULT 15,
    heart_cost_per_error INT DEFAULT 1,
    exercise_count INT DEFAULT 10,
    FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE CASCADE,
    INDEX idx_lessons_unit (unit_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE exercises (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lesson_id BIGINT NOT NULL,
    order_index INT NOT NULL DEFAULT 0,
    type ENUM('TRANSLATE_TO_TARGET','TRANSLATE_TO_SOURCE','TAP_WHAT_YOU_HEAR',
              'TYPE_WHAT_YOU_HEAR','SPEAK_SENTENCE','MATCH_PAIRS',
              'MULTIPLE_CHOICE','FILL_BLANK','READING_COMPREHENSION',
              'LISTENING_COMPREHENSION','WRITE_KANJI','ROLEPLAY_AI') NOT NULL,
    prompt_json JSON,
    answer_json JSON,
    hint_json JSON,
    audio_url VARCHAR(500),
    image_url VARCHAR(500),
    difficulty TINYINT DEFAULT 1,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    INDEX idx_exercises_lesson (lesson_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE lesson_attempts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,
    status ENUM('IN_PROGRESS','COMPLETED','ABANDONED') DEFAULT 'IN_PROGRESS',
    score_percent DECIMAL(5,2) DEFAULT 0,
    xp_earned INT DEFAULT 0,
    hearts_lost INT DEFAULT 0,
    duration_sec INT DEFAULT 0,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id),
    INDEX idx_attempts_user (user_id, started_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE answer_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    attempt_id BIGINT NOT NULL,
    exercise_id BIGINT NOT NULL,
    user_answer TEXT,
    is_correct BOOLEAN DEFAULT FALSE,
    time_ms INT DEFAULT 0,
    hints_used INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (attempt_id) REFERENCES lesson_attempts(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_lesson_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,
    completion_count INT DEFAULT 0,
    best_score DECIMAL(5,2) DEFAULT 0,
    is_legendary BOOLEAN DEFAULT FALSE,
    last_completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id),
    UNIQUE KEY uk_user_lesson (user_id, lesson_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================
-- MODULE: VOCABULARY & CHARACTER
-- ========================
CREATE TABLE words (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    language_id BIGINT NOT NULL,
    text VARCHAR(255) NOT NULL,
    reading VARCHAR(255),
    romaji VARCHAR(255),
    pos ENUM('NOUN','VERB','ADJ','ADV','PARTICLE','CONJUNCTION','INTERJECTION','COUNTER','PREFIX','SUFFIX','OTHER') DEFAULT 'NOUN',
    jlpt_level VARCHAR(10),
    topik_level VARCHAR(10),
    cefr_level VARCHAR(10),
    hsk_level VARCHAR(10),
    audio_url VARCHAR(500),
    frequency_rank INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (language_id) REFERENCES languages(id),
    INDEX idx_words_lang_level (language_id, jlpt_level),
    INDEX idx_words_text (text),
    FULLTEXT INDEX ft_words_text (text, reading, romaji)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE word_meanings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    word_id BIGINT NOT NULL,
    translation_lang_id BIGINT NOT NULL,
    meaning TEXT NOT NULL,
    example_sentence TEXT,
    example_translation TEXT,
    example_audio_url VARCHAR(500),
    FOREIGN KEY (word_id) REFERENCES words(id) ON DELETE CASCADE,
    FOREIGN KEY (translation_lang_id) REFERENCES languages(id),
    INDEX idx_meanings_word (word_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE characters_table (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    language_id BIGINT NOT NULL,
    `character_text` VARCHAR(10) NOT NULL,
    stroke_count INT DEFAULT 0,
    jlpt_level VARCHAR(10),
    frequency_rank INT DEFAULT 0,
    meaning_vi VARCHAR(500),
    meaning_en VARCHAR(500),
    on_reading VARCHAR(255),
    kun_reading VARCHAR(255),
    han_viet VARCHAR(255),
    mnemonic_text TEXT,
    stroke_svg_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (language_id) REFERENCES languages(id),
    INDEX idx_chars_lang (language_id, jlpt_level),
    INDEX idx_chars_text (`character_text`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_components (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    character_id BIGINT NOT NULL,
    component_id BIGINT NOT NULL,
    position VARCHAR(50),
    FOREIGN KEY (character_id) REFERENCES characters_table(id) ON DELETE CASCADE,
    FOREIGN KEY (component_id) REFERENCES characters_table(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE word_characters (
    word_id BIGINT NOT NULL,
    character_id BIGINT NOT NULL,
    order_index INT DEFAULT 0,
    PRIMARY KEY (word_id, character_id),
    FOREIGN KEY (word_id) REFERENCES words(id) ON DELETE CASCADE,
    FOREIGN KEY (character_id) REFERENCES characters_table(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE user_known_words (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    word_id BIGINT NOT NULL,
    strength INT DEFAULT 0,
    first_seen_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_seen_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (word_id) REFERENCES words(id),
    UNIQUE KEY uk_user_word (user_id, word_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================
-- MODULE: GRAMMAR
-- ========================
CREATE TABLE grammars (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    language_id BIGINT NOT NULL,
    pattern VARCHAR(255) NOT NULL,
    meaning_vi TEXT,
    meaning_en TEXT,
    structure TEXT,
    jlpt_level VARCHAR(10),
    cefr_level VARCHAR(10),
    hsk_level VARCHAR(10),
    example_sentence TEXT,
    example_translation TEXT,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (language_id) REFERENCES languages(id),
    INDEX idx_grammar_lang (language_id, jlpt_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- MODULE: SRS / FLASHCARD
-- ========================
CREATE TABLE decks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    owner_id BIGINT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    language_id BIGINT,
    is_public BOOLEAN DEFAULT TRUE,
    card_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (language_id) REFERENCES languages(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cards (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    deck_id BIGINT NOT NULL,
    front_text TEXT NOT NULL,
    back_text TEXT NOT NULL,
    audio_url VARCHAR(500),
    image_url VARCHAR(500),
    ref_word_id BIGINT,
    ref_character_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE,
    FOREIGN KEY (ref_word_id) REFERENCES words(id) ON DELETE SET NULL,
    FOREIGN KEY (ref_character_id) REFERENCES characters_table(id) ON DELETE SET NULL,
    INDEX idx_cards_deck (deck_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE flashcard_reviews (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    card_id BIGINT NOT NULL,
    state ENUM('NEW','LEARNING','REVIEW','RELEARNING','SUSPENDED') DEFAULT 'NEW',
    ease_factor DECIMAL(4,2) DEFAULT 2.50,
    interval_days INT DEFAULT 0,
    repetitions INT DEFAULT 0,
    lapses INT DEFAULT 0,
    next_review_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_reviewed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (card_id) REFERENCES cards(id) ON DELETE CASCADE,
    INDEX idx_fr_user_due (user_id, next_review_at),
    UNIQUE KEY uk_user_card (user_id, card_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE review_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    flashcard_review_id BIGINT NOT NULL,
    rating ENUM('AGAIN','HARD','GOOD','EASY') NOT NULL,
    previous_interval INT,
    new_interval INT,
    reviewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (flashcard_review_id) REFERENCES flashcard_reviews(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================
-- MODULE: GAMIFICATION
-- ========================
CREATE TABLE user_gamification (
    user_id BIGINT PRIMARY KEY,
    total_xp BIGINT DEFAULT 0,
    level INT DEFAULT 1,
    gems INT DEFAULT 50,
    hearts INT DEFAULT 5,
    hearts_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    streak_count INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    last_streak_date DATE,
    streak_freeze_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE heart_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    delta INT NOT NULL,
    reason ENUM('WRONG_ANSWER','REFILL_GEM','REFILL_TIME','REFILL_PRACTICE','PREMIUM_INFINITE') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE gem_transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    delta INT NOT NULL,
    reason VARCHAR(100),
    ref_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE daily_xp_logs (
    user_id BIGINT NOT NULL,
    log_date DATE NOT NULL,
    xp_gained INT DEFAULT 0,
    goal_met BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (user_id, log_date),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE achievements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    icon_url VARCHAR(500),
    rarity ENUM('COMMON','UNCOMMON','RARE','EPIC','LEGENDARY') DEFAULT 'COMMON',
    trigger_rule JSON
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_achievements (
    user_id BIGINT NOT NULL,
    achievement_id BIGINT NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress INT DEFAULT 0,
    PRIMARY KEY (user_id, achievement_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE leagues (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    tier INT UNIQUE NOT NULL,
    icon_url VARCHAR(500),
    promotion_threshold INT DEFAULT 7
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE league_groups (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    league_id BIGINT NOT NULL,
    week_start_date DATE NOT NULL,
    week_end_date DATE NOT NULL,
    member_count INT DEFAULT 0,
    FOREIGN KEY (league_id) REFERENCES leagues(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE user_leagues (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    league_group_id BIGINT NOT NULL,
    weekly_xp INT DEFAULT 0,
    final_rank INT NULL,
    result ENUM('PROMOTED','STAYED','DEMOTED') NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (league_group_id) REFERENCES league_groups(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE daily_quests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    quest_code VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    target INT DEFAULT 1,
    progress INT DEFAULT 0,
    reward_gems INT DEFAULT 5,
    completed BOOLEAN DEFAULT FALSE,
    quest_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_quests_user_date (user_id, quest_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- MODULE: MOCK TEST
-- ========================
CREATE TABLE mock_tests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT,
    certification ENUM('JLPT','TOPIK','CEFR','HSK','IELTS','NONE') DEFAULT 'JLPT',
    level_code VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    total_duration_min INT DEFAULT 60,
    pass_score INT DEFAULT 60,
    section_config_json JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE mock_test_questions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    mock_test_id BIGINT NOT NULL,
    section ENUM('VOCAB','GRAMMAR','READING','LISTENING','WRITING') NOT NULL,
    question_json JSON NOT NULL,
    answer_json JSON NOT NULL,
    difficulty TINYINT DEFAULT 1,
    order_index INT DEFAULT 0,
    FOREIGN KEY (mock_test_id) REFERENCES mock_tests(id) ON DELETE CASCADE,
    INDEX idx_mtq_test (mock_test_id, section)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE mock_test_attempts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    mock_test_id BIGINT NOT NULL,
    score_total INT DEFAULT 0,
    score_by_section_json JSON,
    passed BOOLEAN DEFAULT FALSE,
    duration_sec INT DEFAULT 0,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submitted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (mock_test_id) REFERENCES mock_tests(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================
-- MODULE: NOTIFICATION
-- ========================
CREATE TABLE notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    type ENUM('STREAK_REMIND','FRIEND_ACTIVITY','LEAGUE_RESULT','NEW_COURSE','AI_FEEDBACK','PAYMENT','SYSTEM') NOT NULL,
    title VARCHAR(255),
    body TEXT,
    deep_link VARCHAR(500),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notif_user (user_id, is_read, created_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
