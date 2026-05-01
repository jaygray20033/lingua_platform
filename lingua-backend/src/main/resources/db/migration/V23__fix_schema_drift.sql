ALTER TABLE achievements MODIFY COLUMN rarity VARCHAR(255);

ALTER TABLE courses MODIFY COLUMN rating_avg DOUBLE;

ALTER TABLE enrollments MODIFY COLUMN progress_percent DOUBLE;

ALTER TABLE exercises MODIFY COLUMN difficulty INT;
ALTER TABLE exercises MODIFY COLUMN type VARCHAR(255);

ALTER TABLE flashcard_reviews MODIFY COLUMN ease_factor DOUBLE;

ALTER TABLE grammar_exercises MODIFY COLUMN type VARCHAR(255);

ALTER TABLE languages MODIFY COLUMN direction VARCHAR(255);

ALTER TABLE lesson_attempts MODIFY COLUMN score_percent DOUBLE;

ALTER TABLE mock_test_questions MODIFY COLUMN difficulty INT;
ALTER TABLE mock_test_questions MODIFY COLUMN section VARCHAR(255);

ALTER TABLE mock_tests MODIFY COLUMN certification VARCHAR(255);

ALTER TABLE user_lesson_progress MODIFY COLUMN best_score DOUBLE;

ALTER TABLE words MODIFY COLUMN pos VARCHAR(255);
