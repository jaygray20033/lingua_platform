-- =====================================================================
-- V18__lesson_review_queue_and_audio.sql
-- UPGRADE-06: Spaced-repetition for lessons. After POST /api/lessons/{id}/complete
--             with score < 70%, the lesson is added to a per-user review queue
--             and surfaced on the Dashboard ("Bài cần ôn lại").
-- UPGRADE-07: Audio pronunciation. Add `audio_url` to words so we can serve
--             pre-generated TTS clips; UI falls back to Web Speech API when
--             the column is NULL.
-- =====================================================================

-- ---------------------------------------------------------------------
-- UPGRADE-06: lesson review queue
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lesson_review_queue (
    id              BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT       NOT NULL,
    lesson_id       BIGINT       NOT NULL,
    last_score      DOUBLE       NOT NULL DEFAULT 0,
    fail_count      INT          NOT NULL DEFAULT 1,
    review_after    DATE         NOT NULL,                    -- when it should reappear
    last_failed_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved        BOOLEAN      NOT NULL DEFAULT FALSE,      -- TRUE when user re-passes >= 70%
    resolved_at     TIMESTAMP    NULL,
    UNIQUE KEY uk_review_user_lesson (user_id, lesson_id),
    INDEX idx_review_pending (user_id, resolved, review_after),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- UPGRADE-07: audio pronunciation column on words.
-- gTTS / Google Cloud TTS pipeline can populate this column offline; the
-- frontend uses it when present, otherwise falls back to the browser's
-- SpeechSynthesis API (already wired up in `utils/tts.js`).
-- ---------------------------------------------------------------------
