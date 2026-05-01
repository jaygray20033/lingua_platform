-- =====================================================================
-- V16__example_sentences.sql
-- UPGRADE-08: Sentence-mining table — multi-language example sentences
-- linked to a base word. Frontend shows 2-3 examples in the word detail
-- modal (VocabularyExplorer). Translations always include Vietnamese.
-- =====================================================================

CREATE TABLE IF NOT EXISTS example_sentences (
    id            BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    word_id       BIGINT       NOT NULL,
    sentence      VARCHAR(500) NOT NULL,        -- Original text in target language
    reading       VARCHAR(500) NULL,            -- Furigana / pinyin
    translation_vi VARCHAR(500) NOT NULL,
    translation_en VARCHAR(500) NULL,
    audio_url     VARCHAR(500) NULL,            -- UPGRADE-07: pre-generated TTS
    difficulty    VARCHAR(10)  NULL,            -- N5 | A1 | HSK1 ...
    sort_order    INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_example_word (word_id, sort_order),
    FOREIGN KEY (word_id) REFERENCES words(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed a handful of high-quality JP / EN / ZH sentences for the most common
-- core words (looked up by text + language_id so we don't depend on auto IDs).
SET @lang_jp := (SELECT id FROM languages WHERE code = 'ja' LIMIT 1);
SET @lang_en := (SELECT id FROM languages WHERE code = 'en' LIMIT 1);
SET @lang_zh := (SELECT id FROM languages WHERE code = 'zh' LIMIT 1);

-- Japanese examples
INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '会議は十時から始まります。', 'かいぎは じゅうじから はじまります。', 'Cuộc họp bắt đầu lúc 10 giờ.', 'The meeting starts at 10 o''clock.', 'N4', 1
FROM words w WHERE w.language_id=@lang_jp AND w.text='会議' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '計画を立てるのは大切です。', 'けいかくを たてるのは たいせつです。', 'Lập kế hoạch là điều quan trọng.', 'Making a plan is important.', 'N4', 1
FROM words w WHERE w.language_id=@lang_jp AND w.text='計画' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '日本での生活経験は貴重でした。', 'にほんでの せいかつ けいけんは きちょうでした。', 'Kinh nghiệm sống ở Nhật rất quý giá.', 'My experience living in Japan was precious.', 'N4', 1
FROM words w WHERE w.language_id=@lang_jp AND w.text='経験' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '試験の準備をしています。', 'しけんの じゅんびを しています。', 'Tôi đang chuẩn bị cho kỳ thi.', 'I am preparing for the exam.', 'N4', 1
FROM words w WHERE w.language_id=@lang_jp AND w.text='試験' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '将来の夢は何ですか。', 'しょうらいの ゆめは なんですか。', 'Ước mơ tương lai của bạn là gì?', 'What is your dream for the future?', 'N4', 1
FROM words w WHERE w.language_id=@lang_jp AND w.text='将来' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '紹介してくれてありがとう。', 'しょうかいして くれて ありがとう。', 'Cảm ơn vì đã giới thiệu.', 'Thank you for introducing me.', 'N4', 1
FROM words w WHERE w.language_id=@lang_jp AND w.text='紹介' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '今日は仕事を休みました。', 'きょうは しごとを やすみました。', 'Hôm nay tôi đã nghỉ làm.', 'I took a day off from work today.', 'N5', 1
FROM words w WHERE w.language_id=@lang_jp AND w.text='仕事' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '日本語を勉強しています。', 'にほんごを べんきょうして います。', 'Tôi đang học tiếng Nhật.', 'I am studying Japanese.', 'N5', 1
FROM words w WHERE w.language_id=@lang_jp AND w.text='勉強' LIMIT 1;

-- English examples
INSERT IGNORE INTO example_sentences (word_id, sentence, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, 'Reading is one of my favorite hobbies.', 'Đọc sách là một trong những sở thích yêu thích của tôi.', NULL, 'A2', 1
FROM words w WHERE w.language_id=@lang_en AND w.text='hobby' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, 'Could you give me some advice about studying English?', 'Bạn có thể cho tôi vài lời khuyên về việc học tiếng Anh không?', NULL, 'A2', 1
FROM words w WHERE w.language_id=@lang_en AND w.text='advice' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, 'Travel is a great way to discover new cultures.', 'Du lịch là cách tuyệt vời để khám phá văn hóa mới.', NULL, 'A2', 1
FROM words w WHERE w.language_id=@lang_en AND w.text='discover' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, 'We need to consider all the consequences before deciding.', 'Chúng ta cần xem xét mọi hệ quả trước khi quyết định.', NULL, 'B1', 1
FROM words w WHERE w.language_id=@lang_en AND w.text='consider' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, 'This experience taught me a lot about teamwork.', 'Trải nghiệm này dạy tôi rất nhiều về làm việc nhóm.', NULL, 'A2', 1
FROM words w WHERE w.language_id=@lang_en AND w.text='experience' LIMIT 1;

-- Chinese examples
INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '谢谢你的帮助。', 'xièxie nǐ de bāngzhù.', 'Cảm ơn sự giúp đỡ của bạn.', 'Thank you for your help.', 'HSK2', 1
FROM words w WHERE w.language_id=@lang_zh AND w.text='帮助' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '我每天都看报纸。', 'wǒ měitiān dōu kàn bàozhǐ.', 'Hàng ngày tôi đều đọc báo.', 'I read the newspaper every day.', 'HSK2', 1
FROM words w WHERE w.language_id=@lang_zh AND w.text='报纸' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '请告诉我你的电话号码。', 'qǐng gàosù wǒ nǐ de diànhuà hàomǎ.', 'Vui lòng cho tôi biết số điện thoại của bạn.', 'Please tell me your phone number.', 'HSK2', 1
FROM words w WHERE w.language_id=@lang_zh AND w.text='告诉' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '我们一起参加比赛吧。', 'wǒmen yìqǐ cānjiā bǐsài ba.', 'Chúng ta cùng tham gia cuộc thi nào.', 'Let''s join the competition together.', 'HSK3', 1
FROM words w WHERE w.language_id=@lang_zh AND w.text='参加' LIMIT 1;

INSERT IGNORE INTO example_sentences (word_id, sentence, reading, translation_vi, translation_en, difficulty, sort_order)
SELECT w.id, '北京是一个很大的城市。', 'běijīng shì yī ge hěn dà de chéngshì.', 'Bắc Kinh là một thành phố rất lớn.', 'Beijing is a very big city.', 'HSK3', 1
FROM words w WHERE w.language_id=@lang_zh AND w.text='城市' LIMIT 1;
