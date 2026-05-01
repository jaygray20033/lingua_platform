ALTER TABLE refresh_tokens
    ADD COLUMN revoked BOOLEAN NOT NULL DEFAULT FALSE;

UPDATE refresh_tokens
   SET revoked = TRUE
 WHERE revoked = FALSE
   AND revoked_at IS NOT NULL;

CREATE INDEX idx_refresh_user_revoked
    ON refresh_tokens (user_id, revoked);

ALTER TABLE mock_test_attempts
    ADD COLUMN answers_json JSON NULL;

