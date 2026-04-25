-- =====================================================
-- LINGUA PLATFORM - Seed Data
-- V2: Languages, Courses, Vocabulary, Grammar, Exercises
-- =====================================================

-- ========================
-- 1. LANGUAGES
-- ========================
INSERT INTO languages (id, code, name, native_name, flag_emoji, direction) VALUES
(1, 'ja', 'Japanese', '日本語', '🇯🇵', 'LTR'),
(2, 'en', 'English', 'English', '🇬🇧', 'LTR'),
(3, 'zh', 'Chinese', '中文', '🇨🇳', 'LTR'),
(4, 'ko', 'Korean', '한국어', '🇰🇷', 'LTR'),
(5, 'vi', 'Vietnamese', 'Tiếng Việt', '🇻🇳', 'LTR');

-- ========================
-- 2. DEFAULT ADMIN USER
-- ========================
INSERT INTO users (id, email, password_hash, display_name, role, email_verified, status) VALUES
(1, 'admin@lingua.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Admin', 'ADMIN', TRUE, 'ACTIVE'),
(2, 'demo@lingua.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Demo User', 'LEARNER', TRUE, 'ACTIVE');

INSERT INTO user_gamification (user_id, total_xp, level, gems, hearts, streak_count) VALUES
(1, 0, 1, 999, 5, 0),
(2, 150, 3, 75, 5, 7);

-- ========================
-- 3. COURSES
-- ========================

-- === JAPANESE COURSES ===
INSERT INTO courses (id, title, slug, description, source_lang_id, target_lang_id, level_code, certification, status, total_units, estimated_hours) VALUES
(1, 'JLPT N5 - Tiếng Nhật Cơ Bản', 'jlpt-n5', 'Khóa học tiếng Nhật cơ bản cho người mới bắt đầu. Bao gồm Hiragana, Katakana, 100+ Kanji, 800+ từ vựng và ngữ pháp N5.', 5, 1, 'N5', 'JLPT', 'PUBLISHED', 20, 120),
(2, 'JLPT N4 - Tiếng Nhật Sơ Trung Cấp', 'jlpt-n4', 'Nâng cao trình độ từ N5 lên N4. 300+ Kanji mới, 1500+ từ vựng, ngữ pháp trung cấp.', 5, 1, 'N4', 'JLPT', 'PUBLISHED', 20, 150),
(3, 'JLPT N3 - Tiếng Nhật Trung Cấp', 'jlpt-n3', 'Trình độ trung cấp JLPT N3 với 650+ Kanji và 3500+ từ vựng.', 5, 1, 'N3', 'JLPT', 'PUBLISHED', 20, 200),

-- === ENGLISH COURSES ===
(4, 'English A1 - Beginner', 'english-a1', 'Khóa tiếng Anh cơ bản A1 theo chuẩn CEFR. Giao tiếp đơn giản hàng ngày.', 5, 2, 'A1', 'CEFR', 'PUBLISHED', 15, 80),
(5, 'English A2 - Elementary', 'english-a2', 'Tiếng Anh A2 - Giao tiếp trong tình huống quen thuộc.', 5, 2, 'A2', 'CEFR', 'PUBLISHED', 15, 100),
(6, 'English B1 - Intermediate', 'english-b1', 'Tiếng Anh B1 trung cấp - Hiểu ý chính trong văn bản rõ ràng.', 5, 2, 'B1', 'CEFR', 'PUBLISHED', 20, 150),

-- === CHINESE COURSES ===
(7, 'HSK 1 - Tiếng Trung Cơ Bản', 'hsk-1', 'Khóa tiếng Trung HSK 1 cho người mới bắt đầu. 150 từ vựng cơ bản.', 5, 3, 'HSK1', 'HSK', 'PUBLISHED', 10, 60),
(8, 'HSK 2 - Tiếng Trung Sơ Cấp', 'hsk-2', 'Tiếng Trung HSK 2 với 300 từ vựng mới.', 5, 3, 'HSK2', 'HSK', 'PUBLISHED', 12, 80),
(9, 'HSK 3 - Tiếng Trung Trung Cấp', 'hsk-3', 'Tiếng Trung HSK 3 với 600 từ vựng.', 5, 3, 'HSK3', 'HSK', 'PUBLISHED', 15, 120);

-- ========================
-- 4. SECTIONS for JLPT N5
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(1, 1, 1, 'Chào hỏi & Tự giới thiệu', 'Học cách chào hỏi và tự giới thiệu bản thân bằng tiếng Nhật', 'A1'),
(2, 1, 2, 'Số đếm & Thời gian', 'Học số đếm, ngày tháng, giờ giấc', 'A1'),
(3, 1, 3, 'Gia đình & Mô tả', 'Nói về gia đình, tính cách, ngoại hình', 'A1'),
(4, 1, 4, 'Mua sắm & Nhà hàng', 'Giao tiếp khi mua sắm, gọi món ăn', 'A1'),
(5, 1, 5, 'Di chuyển & Phương hướng', 'Hỏi đường, phương tiện giao thông', 'A1'),
(6, 1, 6, 'Công việc & Trường học', 'Nói về nghề nghiệp, trường lớp', 'A1'),
(7, 1, 7, 'Sở thích & Thể thao', 'Nói về sở thích, hoạt động giải trí', 'A1'),
(8, 1, 8, 'Ôn tập tổng hợp N5', 'Ôn tập toàn bộ kiến thức N5', 'A1');

-- ========================
-- 5. UNITS for Section 1 (Chào hỏi & Tự giới thiệu)
-- ========================
INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(1, 1, 1, 'Chào hỏi cơ bản', 'Có thể chào hỏi đơn giản', '👋', 50),
(2, 1, 2, 'Tự giới thiệu', 'Có thể giới thiệu tên, quốc tịch', '🙋', 50),
(3, 1, 3, 'Hỏi thăm sức khỏe', 'Hỏi thăm và trả lời về sức khỏe', '💬', 50),
(4, 1, 4, 'Cảm ơn & Xin lỗi', 'Sử dụng các cụm từ lịch sự', '🙏', 50),
(5, 1, 5, 'Ôn tập Section 1', 'Kiểm tra kiến thức Section 1', '🏆', 100),
-- Units for Section 2
(6, 2, 1, 'Số đếm 1-100', 'Đếm số bằng tiếng Nhật', '🔢', 50),
(7, 2, 2, 'Ngày tháng', 'Nói ngày tháng năm', '📅', 50),
(8, 2, 3, 'Giờ giấc', 'Hỏi và nói giờ', '⏰', 50),
(9, 2, 4, 'Tuần & Mùa', 'Nói về thứ trong tuần và mùa', '🗓️', 50),
(10, 2, 5, 'Ôn tập Section 2', 'Kiểm tra kiến thức Section 2', '🏆', 100),
-- Units for Section 3
(11, 3, 1, 'Gia đình', 'Nói về các thành viên gia đình', '👨‍👩‍👧‍👦', 50),
(12, 3, 2, 'Tính từ mô tả', 'Dùng tính từ miêu tả người/vật', '📝', 50),
(13, 3, 3, 'Màu sắc', 'Học các màu sắc cơ bản', '🎨', 50),
(14, 3, 4, 'Cơ thể & Ngoại hình', 'Miêu tả cơ thể và ngoại hình', '🧑', 50),
(15, 3, 5, 'Ôn tập Section 3', 'Kiểm tra kiến thức Section 3', '🏆', 100),
-- Units for Section 4
(16, 4, 1, 'Ở cửa hàng', 'Mua sắm cơ bản', '🛍️', 50),
(17, 4, 2, 'Ở nhà hàng', 'Gọi món ăn', '🍜', 50),
(18, 4, 3, 'Đồ ăn & Thức uống', 'Từ vựng đồ ăn thức uống', '🍱', 50),
(19, 4, 4, 'Tiền tệ & Giá cả', 'Nói về giá tiền', '💴', 50),
(20, 4, 5, 'Ôn tập Section 4', 'Kiểm tra kiến thức Section 4', '🏆', 100);

-- ========================
-- 6. LESSONS for Unit 1 (Chào hỏi cơ bản)
-- ========================
INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(1, 1, 1, 'おはようございます - Chào buổi sáng', 'NORMAL', 15, 10),
(2, 1, 2, 'こんにちは - Xin chào', 'NORMAL', 15, 10),
(3, 1, 3, 'こんばんは - Chào buổi tối', 'NORMAL', 15, 10),
(4, 1, 4, 'さようなら - Tạm biệt', 'NORMAL', 15, 10),
(5, 1, 5, 'Kiểm tra: Chào hỏi cơ bản', 'CHECKPOINT', 25, 15),
-- Lessons for Unit 2
(6, 2, 1, 'わたしは〜です - Tôi là...', 'NORMAL', 15, 10),
(7, 2, 2, 'おなまえは？ - Tên bạn là gì?', 'NORMAL', 15, 10),
(8, 2, 3, '〜じんです - Quốc tịch', 'NORMAL', 15, 10),
(9, 2, 4, 'おしごとは？ - Nghề nghiệp', 'NORMAL', 15, 10),
(10, 2, 5, 'Kiểm tra: Tự giới thiệu', 'CHECKPOINT', 25, 15),
-- Lessons for Unit 3
(11, 3, 1, 'おげんきですか - Bạn khỏe không?', 'NORMAL', 15, 10),
(12, 3, 2, 'はい、げんきです - Vâng, tôi khỏe', 'NORMAL', 15, 10),
(13, 3, 3, 'ちょっと - Một chút', 'NORMAL', 15, 10),
(14, 3, 4, 'どうぞよろしく - Rất vui được gặp', 'NORMAL', 15, 10),
(15, 3, 5, 'Kiểm tra: Hỏi thăm', 'CHECKPOINT', 25, 15),
-- Lessons for Unit 6 (Số đếm)
(16, 6, 1, 'いち〜じゅう (1-10)', 'NORMAL', 15, 10),
(17, 6, 2, 'じゅういち〜にじゅう (11-20)', 'NORMAL', 15, 10),
(18, 6, 3, 'にじゅういち〜ひゃく (21-100)', 'NORMAL', 15, 10),
(19, 6, 4, 'Bộ đếm cơ bản: つ、人、個', 'NORMAL', 15, 10),
(20, 6, 5, 'Kiểm tra: Số đếm', 'CHECKPOINT', 25, 15),
-- Lessons for Unit 11 (Gia đình)
(21, 11, 1, 'おかあさん・おとうさん - Bố Mẹ', 'NORMAL', 15, 10),
(22, 11, 2, 'きょうだい - Anh chị em', 'NORMAL', 15, 10),
(23, 11, 3, 'かぞく - Gia đình tôi', 'NORMAL', 15, 10),
(24, 11, 4, 'なんにんかぞく - Gia đình mấy người', 'NORMAL', 15, 10),
(25, 11, 5, 'Kiểm tra: Gia đình', 'CHECKPOINT', 25, 15),
-- Lessons for Unit 16 (Mua sắm)
(26, 16, 1, 'これ・それ・あれ - Cái này/đó/kia', 'NORMAL', 15, 10),
(27, 16, 2, 'いくらですか - Bao nhiêu tiền?', 'NORMAL', 15, 10),
(28, 16, 3, 'ください - Cho tôi xin...', 'NORMAL', 15, 10),
(29, 16, 4, 'やすい・たかい - Rẻ/Đắt', 'NORMAL', 15, 10),
(30, 16, 5, 'Kiểm tra: Mua sắm', 'CHECKPOINT', 25, 15);

-- ========================
-- 7. JAPANESE VOCABULARY (JLPT N5 - 200+ words)
-- ========================
INSERT INTO words (id, language_id, text, reading, romaji, pos, jlpt_level, frequency_rank) VALUES
-- Greetings
(1, 1, 'おはようございます', 'おはようございます', 'ohayou gozaimasu', 'INTERJECTION', 'N5', 1),
(2, 1, 'こんにちは', 'こんにちは', 'konnichiwa', 'INTERJECTION', 'N5', 2),
(3, 1, 'こんばんは', 'こんばんは', 'konbanwa', 'INTERJECTION', 'N5', 3),
(4, 1, 'さようなら', 'さようなら', 'sayounara', 'INTERJECTION', 'N5', 4),
(5, 1, 'ありがとうございます', 'ありがとうございます', 'arigatou gozaimasu', 'INTERJECTION', 'N5', 5),
(6, 1, 'すみません', 'すみません', 'sumimasen', 'INTERJECTION', 'N5', 6),
(7, 1, 'おやすみなさい', 'おやすみなさい', 'oyasuminasai', 'INTERJECTION', 'N5', 7),
(8, 1, 'はじめまして', 'はじめまして', 'hajimemashite', 'INTERJECTION', 'N5', 8),
(9, 1, 'どうぞよろしく', 'どうぞよろしく', 'douzo yoroshiku', 'INTERJECTION', 'N5', 9),
(10, 1, 'いただきます', 'いただきます', 'itadakimasu', 'INTERJECTION', 'N5', 10),
-- Pronouns & People
(11, 1, 'わたし', 'わたし', 'watashi', 'NOUN', 'N5', 11),
(12, 1, 'あなた', 'あなた', 'anata', 'NOUN', 'N5', 12),
(13, 1, 'かれ', 'かれ', 'kare', 'NOUN', 'N5', 13),
(14, 1, 'かのじょ', 'かのじょ', 'kanojo', 'NOUN', 'N5', 14),
(15, 1, 'せんせい', 'せんせい', 'sensei', 'NOUN', 'N5', 15),
(16, 1, 'がくせい', 'がくせい', 'gakusei', 'NOUN', 'N5', 16),
(17, 1, 'ともだち', 'ともだち', 'tomodachi', 'NOUN', 'N5', 17),
(18, 1, 'こども', 'こども', 'kodomo', 'NOUN', 'N5', 18),
(19, 1, 'おとこ', 'おとこ', 'otoko', 'NOUN', 'N5', 19),
(20, 1, 'おんな', 'おんな', 'onna', 'NOUN', 'N5', 20),
-- Family
(21, 1, 'おかあさん', 'おかあさん', 'okaasan', 'NOUN', 'N5', 21),
(22, 1, 'おとうさん', 'おとうさん', 'otousan', 'NOUN', 'N5', 22),
(23, 1, 'おにいさん', 'おにいさん', 'oniisan', 'NOUN', 'N5', 23),
(24, 1, 'おねえさん', 'おねえさん', 'oneesan', 'NOUN', 'N5', 24),
(25, 1, 'いもうと', 'いもうと', 'imouto', 'NOUN', 'N5', 25),
(26, 1, 'おとうと', 'おとうと', 'otouto', 'NOUN', 'N5', 26),
(27, 1, 'かぞく', 'かぞく', 'kazoku', 'NOUN', 'N5', 27),
-- Numbers
(28, 1, 'いち', 'いち', 'ichi', 'COUNTER', 'N5', 28),
(29, 1, 'に', 'に', 'ni', 'COUNTER', 'N5', 29),
(30, 1, 'さん', 'さん', 'san', 'COUNTER', 'N5', 30),
(31, 1, 'よん', 'よん', 'yon', 'COUNTER', 'N5', 31),
(32, 1, 'ご', 'ご', 'go', 'COUNTER', 'N5', 32),
(33, 1, 'ろく', 'ろく', 'roku', 'COUNTER', 'N5', 33),
(34, 1, 'なな', 'なな', 'nana', 'COUNTER', 'N5', 34),
(35, 1, 'はち', 'はち', 'hachi', 'COUNTER', 'N5', 35),
(36, 1, 'きゅう', 'きゅう', 'kyuu', 'COUNTER', 'N5', 36),
(37, 1, 'じゅう', 'じゅう', 'juu', 'COUNTER', 'N5', 37),
(38, 1, 'ひゃく', 'ひゃく', 'hyaku', 'COUNTER', 'N5', 38),
(39, 1, 'せん', 'せん', 'sen', 'COUNTER', 'N5', 39),
(40, 1, 'まん', 'まん', 'man', 'COUNTER', 'N5', 40),
-- Common nouns
(41, 1, 'にほんご', 'にほんご', 'nihongo', 'NOUN', 'N5', 41),
(42, 1, 'えいご', 'えいご', 'eigo', 'NOUN', 'N5', 42),
(43, 1, 'ほん', 'ほん', 'hon', 'NOUN', 'N5', 43),
(44, 1, 'でんわ', 'でんわ', 'denwa', 'NOUN', 'N5', 44),
(45, 1, 'みず', 'みず', 'mizu', 'NOUN', 'N5', 45),
(46, 1, 'おちゃ', 'おちゃ', 'ocha', 'NOUN', 'N5', 46),
(47, 1, 'ごはん', 'ごはん', 'gohan', 'NOUN', 'N5', 47),
(48, 1, 'パン', 'パン', 'pan', 'NOUN', 'N5', 48),
(49, 1, 'にく', 'にく', 'niku', 'NOUN', 'N5', 49),
(50, 1, 'さかな', 'さかな', 'sakana', 'NOUN', 'N5', 50),
(51, 1, 'くだもの', 'くだもの', 'kudamono', 'NOUN', 'N5', 51),
(52, 1, 'やさい', 'やさい', 'yasai', 'NOUN', 'N5', 52),
(53, 1, 'いえ', 'いえ', 'ie', 'NOUN', 'N5', 53),
(54, 1, 'へや', 'へや', 'heya', 'NOUN', 'N5', 54),
(55, 1, 'がっこう', 'がっこう', 'gakkou', 'NOUN', 'N5', 55),
(56, 1, 'えき', 'えき', 'eki', 'NOUN', 'N5', 56),
(57, 1, 'びょういん', 'びょういん', 'byouin', 'NOUN', 'N5', 57),
(58, 1, 'ぎんこう', 'ぎんこう', 'ginkou', 'NOUN', 'N5', 58),
(59, 1, 'みせ', 'みせ', 'mise', 'NOUN', 'N5', 59),
(60, 1, 'レストラン', 'レストラン', 'resutoran', 'NOUN', 'N5', 60),
-- Adjectives
(61, 1, 'おおきい', 'おおきい', 'ookii', 'ADJ', 'N5', 61),
(62, 1, 'ちいさい', 'ちいさい', 'chiisai', 'ADJ', 'N5', 62),
(63, 1, 'たかい', 'たかい', 'takai', 'ADJ', 'N5', 63),
(64, 1, 'やすい', 'やすい', 'yasui', 'ADJ', 'N5', 64),
(65, 1, 'あたらしい', 'あたらしい', 'atarashii', 'ADJ', 'N5', 65),
(66, 1, 'ふるい', 'ふるい', 'furui', 'ADJ', 'N5', 66),
(67, 1, 'いい', 'いい', 'ii', 'ADJ', 'N5', 67),
(68, 1, 'わるい', 'わるい', 'warui', 'ADJ', 'N5', 68),
(69, 1, 'おいしい', 'おいしい', 'oishii', 'ADJ', 'N5', 69),
(70, 1, 'あつい', 'あつい', 'atsui', 'ADJ', 'N5', 70),
(71, 1, 'さむい', 'さむい', 'samui', 'ADJ', 'N5', 71),
(72, 1, 'はやい', 'はやい', 'hayai', 'ADJ', 'N5', 72),
(73, 1, 'おそい', 'おそい', 'osoi', 'ADJ', 'N5', 73),
(74, 1, 'げんき', 'げんき', 'genki', 'ADJ', 'N5', 74),
(75, 1, 'きれい', 'きれい', 'kirei', 'ADJ', 'N5', 75),
-- Verbs
(76, 1, 'たべる', 'たべる', 'taberu', 'VERB', 'N5', 76),
(77, 1, 'のむ', 'のむ', 'nomu', 'VERB', 'N5', 77),
(78, 1, 'みる', 'みる', 'miru', 'VERB', 'N5', 78),
(79, 1, 'きく', 'きく', 'kiku', 'VERB', 'N5', 79),
(80, 1, 'よむ', 'よむ', 'yomu', 'VERB', 'N5', 80),
(81, 1, 'かく', 'かく', 'kaku', 'VERB', 'N5', 81),
(82, 1, 'はなす', 'はなす', 'hanasu', 'VERB', 'N5', 82),
(83, 1, 'いく', 'いく', 'iku', 'VERB', 'N5', 83),
(84, 1, 'くる', 'くる', 'kuru', 'VERB', 'N5', 84),
(85, 1, 'かえる', 'かえる', 'kaeru', 'VERB', 'N5', 85),
(86, 1, 'する', 'する', 'suru', 'VERB', 'N5', 86),
(87, 1, 'べんきょうする', 'べんきょうする', 'benkyou suru', 'VERB', 'N5', 87),
(88, 1, 'ねる', 'ねる', 'neru', 'VERB', 'N5', 88),
(89, 1, 'おきる', 'おきる', 'okiru', 'VERB', 'N5', 89),
(90, 1, 'あるく', 'あるく', 'aruku', 'VERB', 'N5', 90),
-- Time & Days
(91, 1, 'きょう', 'きょう', 'kyou', 'NOUN', 'N5', 91),
(92, 1, 'あした', 'あした', 'ashita', 'NOUN', 'N5', 92),
(93, 1, 'きのう', 'きのう', 'kinou', 'NOUN', 'N5', 93),
(94, 1, 'あさ', 'あさ', 'asa', 'NOUN', 'N5', 94),
(95, 1, 'ひる', 'ひる', 'hiru', 'NOUN', 'N5', 95),
(96, 1, 'よる', 'よる', 'yoru', 'NOUN', 'N5', 96),
(97, 1, 'げつようび', 'げつようび', 'getsuyoubi', 'NOUN', 'N5', 97),
(98, 1, 'かようび', 'かようび', 'kayoubi', 'NOUN', 'N5', 98),
(99, 1, 'すいようび', 'すいようび', 'suiyoubi', 'NOUN', 'N5', 99),
(100, 1, 'もくようび', 'もくようび', 'mokuyoubi', 'NOUN', 'N5', 100),
-- Places & Transportation
(101, 1, 'くるま', 'くるま', 'kuruma', 'NOUN', 'N5', 101),
(102, 1, 'でんしゃ', 'でんしゃ', 'densha', 'NOUN', 'N5', 102),
(103, 1, 'バス', 'バス', 'basu', 'NOUN', 'N5', 103),
(104, 1, 'タクシー', 'タクシー', 'takushii', 'NOUN', 'N5', 104),
(105, 1, 'ひこうき', 'ひこうき', 'hikouki', 'NOUN', 'N5', 105),
-- More verbs
(106, 1, 'かう', 'かう', 'kau', 'VERB', 'N5', 106),
(107, 1, 'まつ', 'まつ', 'matsu', 'VERB', 'N5', 107),
(108, 1, 'わかる', 'わかる', 'wakaru', 'VERB', 'N5', 108),
(109, 1, 'あう', 'あう', 'au', 'VERB', 'N5', 109),
(110, 1, 'つくる', 'つくる', 'tsukuru', 'VERB', 'N5', 110);

-- ========================
-- 8. WORD MEANINGS (Vietnamese translations)
-- ========================
INSERT INTO word_meanings (word_id, translation_lang_id, meaning, example_sentence, example_translation) VALUES
(1, 5, 'Chào buổi sáng (lịch sự)', 'おはようございます、せんせい。', 'Chào buổi sáng, thầy/cô.'),
(2, 5, 'Xin chào (ban ngày)', 'こんにちは、おげんきですか。', 'Xin chào, bạn có khỏe không?'),
(3, 5, 'Chào buổi tối', 'こんばんは、きょうはさむいですね。', 'Chào buổi tối, hôm nay lạnh nhỉ.'),
(4, 5, 'Tạm biệt', 'さようなら、またあした。', 'Tạm biệt, hẹn gặp lại ngày mai.'),
(5, 5, 'Cảm ơn (lịch sự)', 'ありがとうございます、せんせい。', 'Cảm ơn thầy/cô.'),
(6, 5, 'Xin lỗi / Xin phép', 'すみません、トイレはどこですか。', 'Xin lỗi, nhà vệ sinh ở đâu?'),
(7, 5, 'Chúc ngủ ngon', 'おやすみなさい、いいゆめを。', 'Chúc ngủ ngon, mơ đẹp nhé.'),
(8, 5, 'Rất vui được gặp bạn (lần đầu)', 'はじめまして、たなかです。', 'Rất vui được gặp bạn, tôi là Tanaka.'),
(9, 5, 'Rất vui được quen biết', 'どうぞよろしくおねがいします。', 'Mong được giúp đỡ nhiều.'),
(10, 5, 'Tôi xin phép ăn', 'いただきます！', 'Tôi xin phép ăn!'),
(11, 5, 'Tôi', 'わたしはベトナムじんです。', 'Tôi là người Việt Nam.'),
(12, 5, 'Bạn', 'あなたのなまえはなんですか。', 'Tên bạn là gì?'),
(13, 5, 'Anh ấy', 'かれはがくせいです。', 'Anh ấy là sinh viên.'),
(14, 5, 'Cô ấy', 'かのじょはせんせいです。', 'Cô ấy là giáo viên.'),
(15, 5, 'Giáo viên / Thầy cô', 'せんせいはにほんじんです。', 'Thầy/cô là người Nhật.'),
(16, 5, 'Học sinh / Sinh viên', 'わたしはがくせいです。', 'Tôi là sinh viên.'),
(17, 5, 'Bạn bè', 'ともだちとえいがをみます。', 'Tôi xem phim với bạn.'),
(18, 5, 'Trẻ em / Con', 'こどもがさんにんいます。', 'Có 3 đứa trẻ.'),
(19, 5, 'Đàn ông / Nam', 'おとこのひとがいます。', 'Có một người đàn ông.'),
(20, 5, 'Phụ nữ / Nữ', 'おんなのこがきます。', 'Cô gái đang đến.'),
(21, 5, 'Mẹ (kính ngữ)', 'おかあさんはやさしいです。', 'Mẹ rất hiền.'),
(22, 5, 'Bố (kính ngữ)', 'おとうさんはかいしゃいんです。', 'Bố là nhân viên công ty.'),
(23, 5, 'Anh trai (kính ngữ)', 'おにいさんはだいがくせいです。', 'Anh trai là sinh viên đại học.'),
(24, 5, 'Chị gái (kính ngữ)', 'おねえさんはきれいです。', 'Chị gái rất xinh.'),
(25, 5, 'Em gái', 'いもうとはじゅうさいです。', 'Em gái 10 tuổi.'),
(26, 5, 'Em trai', 'おとうとはがくせいです。', 'Em trai là học sinh.'),
(27, 5, 'Gia đình', 'わたしのかぞくはごにんです。', 'Gia đình tôi có 5 người.'),
(41, 5, 'Tiếng Nhật', 'にほんごをべんきょうします。', 'Tôi học tiếng Nhật.'),
(42, 5, 'Tiếng Anh', 'えいごがすきです。', 'Tôi thích tiếng Anh.'),
(43, 5, 'Sách / Quyển', 'ほんをよみます。', 'Tôi đọc sách.'),
(44, 5, 'Điện thoại', 'でんわをかけます。', 'Tôi gọi điện thoại.'),
(45, 5, 'Nước', 'みずをのみます。', 'Tôi uống nước.'),
(46, 5, 'Trà', 'おちゃをのみましょう。', 'Hãy uống trà nhé.'),
(47, 5, 'Cơm / Bữa ăn', 'ごはんをたべます。', 'Tôi ăn cơm.'),
(48, 5, 'Bánh mì', 'あさパンをたべます。', 'Buổi sáng tôi ăn bánh mì.'),
(49, 5, 'Thịt', 'にくがすきです。', 'Tôi thích thịt.'),
(50, 5, 'Cá', 'さかなをたべます。', 'Tôi ăn cá.'),
(61, 5, 'To / Lớn', 'このいえはおおきいです。', 'Ngôi nhà này to.'),
(62, 5, 'Nhỏ / Bé', 'このねこはちいさいです。', 'Con mèo này nhỏ.'),
(63, 5, 'Cao / Đắt', 'このほんはたかいです。', 'Cuốn sách này đắt.'),
(64, 5, 'Rẻ', 'このかばんはやすいです。', 'Cái túi này rẻ.'),
(65, 5, 'Mới', 'あたらしいくるまをかいました。', 'Tôi đã mua xe mới.'),
(66, 5, 'Cũ', 'ふるいいえにすんでいます。', 'Tôi sống ở nhà cũ.'),
(67, 5, 'Tốt / Hay', 'このえいがはいいです。', 'Bộ phim này hay.'),
(68, 5, 'Xấu / Kém', 'てんきがわるいです。', 'Thời tiết xấu.'),
(69, 5, 'Ngon', 'このラーメンはおいしいです。', 'Mì ramen này ngon.'),
(70, 5, 'Nóng', 'きょうはあついです。', 'Hôm nay nóng.'),
(71, 5, 'Lạnh', 'ふゆはさむいです。', 'Mùa đông lạnh.'),
(76, 5, 'Ăn', 'あさごはんをたべます。', 'Tôi ăn bữa sáng.'),
(77, 5, 'Uống', 'コーヒーをのみます。', 'Tôi uống cà phê.'),
(78, 5, 'Xem / Nhìn', 'テレビをみます。', 'Tôi xem tivi.'),
(79, 5, 'Nghe / Hỏi', 'おんがくをききます。', 'Tôi nghe nhạc.'),
(80, 5, 'Đọc', 'しんぶんをよみます。', 'Tôi đọc báo.'),
(81, 5, 'Viết', 'てがみをかきます。', 'Tôi viết thư.'),
(82, 5, 'Nói', 'にほんごをはなします。', 'Tôi nói tiếng Nhật.'),
(83, 5, 'Đi', 'がっこうにいきます。', 'Tôi đi đến trường.'),
(84, 5, 'Đến', 'ともだちがきます。', 'Bạn bè đến.'),
(85, 5, 'Về', 'うちにかえります。', 'Tôi về nhà.'),
(86, 5, 'Làm', 'しゅくだいをします。', 'Tôi làm bài tập.'),
(87, 5, 'Học', 'まいにちべんきょうします。', 'Tôi học mỗi ngày.'),
(88, 5, 'Ngủ', 'じゅうじにねます。', 'Tôi ngủ lúc 10 giờ.'),
(89, 5, 'Thức dậy', 'ろくじにおきます。', 'Tôi thức dậy lúc 6 giờ.'),
(90, 5, 'Đi bộ', 'こうえんをあるきます。', 'Tôi đi bộ ở công viên.'),
(91, 5, 'Hôm nay', 'きょうはにちようびです。', 'Hôm nay là chủ nhật.'),
(92, 5, 'Ngày mai', 'あしたがっこうにいきます。', 'Ngày mai tôi đi học.'),
(93, 5, 'Hôm qua', 'きのうえいがをみました。', 'Hôm qua tôi đã xem phim.'),
(101, 5, 'Ô tô', 'くるまでいきます。', 'Tôi đi bằng ô tô.'),
(102, 5, 'Tàu điện', 'でんしゃでがっこうにいきます。', 'Tôi đi đến trường bằng tàu điện.'),
(103, 5, 'Xe buýt', 'バスにのります。', 'Tôi đi xe buýt.'),
(106, 5, 'Mua', 'くだものをかいます。', 'Tôi mua trái cây.'),
(107, 5, 'Chờ / Đợi', 'ともだちをまちます。', 'Tôi chờ bạn.'),
(108, 5, 'Hiểu', 'にほんごがわかります。', 'Tôi hiểu tiếng Nhật.'),
(109, 5, 'Gặp', 'ともだちにあいます。', 'Tôi gặp bạn.'),
(110, 5, 'Làm / Chế tạo', 'ケーキをつくります。', 'Tôi làm bánh.');

-- ========================
-- 9. ENGLISH VOCABULARY (CEFR A1 - 100+ words)
-- ========================
INSERT INTO words (id, language_id, text, reading, romaji, pos, cefr_level, frequency_rank) VALUES
(201, 2, 'hello', NULL, NULL, 'INTERJECTION', 'A1', 1),
(202, 2, 'goodbye', NULL, NULL, 'INTERJECTION', 'A1', 2),
(203, 2, 'please', NULL, NULL, 'ADV', 'A1', 3),
(204, 2, 'thank you', NULL, NULL, 'INTERJECTION', 'A1', 4),
(205, 2, 'sorry', NULL, NULL, 'ADJ', 'A1', 5),
(206, 2, 'yes', NULL, NULL, 'ADV', 'A1', 6),
(207, 2, 'no', NULL, NULL, 'ADV', 'A1', 7),
(208, 2, 'name', NULL, NULL, 'NOUN', 'A1', 8),
(209, 2, 'family', NULL, NULL, 'NOUN', 'A1', 9),
(210, 2, 'friend', NULL, NULL, 'NOUN', 'A1', 10),
(211, 2, 'mother', NULL, NULL, 'NOUN', 'A1', 11),
(212, 2, 'father', NULL, NULL, 'NOUN', 'A1', 12),
(213, 2, 'brother', NULL, NULL, 'NOUN', 'A1', 13),
(214, 2, 'sister', NULL, NULL, 'NOUN', 'A1', 14),
(215, 2, 'teacher', NULL, NULL, 'NOUN', 'A1', 15),
(216, 2, 'student', NULL, NULL, 'NOUN', 'A1', 16),
(217, 2, 'water', NULL, NULL, 'NOUN', 'A1', 17),
(218, 2, 'food', NULL, NULL, 'NOUN', 'A1', 18),
(219, 2, 'house', NULL, NULL, 'NOUN', 'A1', 19),
(220, 2, 'school', NULL, NULL, 'NOUN', 'A1', 20),
(221, 2, 'book', NULL, NULL, 'NOUN', 'A1', 21),
(222, 2, 'eat', NULL, NULL, 'VERB', 'A1', 22),
(223, 2, 'drink', NULL, NULL, 'VERB', 'A1', 23),
(224, 2, 'read', NULL, NULL, 'VERB', 'A1', 24),
(225, 2, 'write', NULL, NULL, 'VERB', 'A1', 25),
(226, 2, 'speak', NULL, NULL, 'VERB', 'A1', 26),
(227, 2, 'listen', NULL, NULL, 'VERB', 'A1', 27),
(228, 2, 'go', NULL, NULL, 'VERB', 'A1', 28),
(229, 2, 'come', NULL, NULL, 'VERB', 'A1', 29),
(230, 2, 'see', NULL, NULL, 'VERB', 'A1', 30),
(231, 2, 'big', NULL, NULL, 'ADJ', 'A1', 31),
(232, 2, 'small', NULL, NULL, 'ADJ', 'A1', 32),
(233, 2, 'good', NULL, NULL, 'ADJ', 'A1', 33),
(234, 2, 'bad', NULL, NULL, 'ADJ', 'A1', 34),
(235, 2, 'new', NULL, NULL, 'ADJ', 'A1', 35),
(236, 2, 'old', NULL, NULL, 'ADJ', 'A1', 36),
(237, 2, 'hot', NULL, NULL, 'ADJ', 'A1', 37),
(238, 2, 'cold', NULL, NULL, 'ADJ', 'A1', 38),
(239, 2, 'happy', NULL, NULL, 'ADJ', 'A1', 39),
(240, 2, 'today', NULL, NULL, 'ADV', 'A1', 40);

INSERT INTO word_meanings (word_id, translation_lang_id, meaning, example_sentence, example_translation) VALUES
(201, 5, 'Xin chào', 'Hello, how are you?', 'Xin chào, bạn khỏe không?'),
(202, 5, 'Tạm biệt', 'Goodbye, see you tomorrow.', 'Tạm biệt, hẹn gặp lại ngày mai.'),
(203, 5, 'Xin vui lòng / Làm ơn', 'Please sit down.', 'Xin hãy ngồi xuống.'),
(204, 5, 'Cảm ơn', 'Thank you very much.', 'Cảm ơn rất nhiều.'),
(205, 5, 'Xin lỗi', 'I am sorry.', 'Tôi xin lỗi.'),
(222, 5, 'Ăn', 'I eat breakfast at 7.', 'Tôi ăn sáng lúc 7 giờ.'),
(223, 5, 'Uống', 'I drink water every day.', 'Tôi uống nước mỗi ngày.'),
(224, 5, 'Đọc', 'I read books.', 'Tôi đọc sách.'),
(225, 5, 'Viết', 'She writes a letter.', 'Cô ấy viết thư.'),
(226, 5, 'Nói', 'He speaks English.', 'Anh ấy nói tiếng Anh.'),
(227, 5, 'Nghe', 'Listen to the music.', 'Hãy nghe nhạc.'),
(228, 5, 'Đi', 'I go to school.', 'Tôi đi đến trường.'),
(231, 5, 'To / Lớn', 'This is a big house.', 'Đây là một ngôi nhà lớn.'),
(232, 5, 'Nhỏ / Bé', 'It is a small cat.', 'Đó là một con mèo nhỏ.');

-- ========================
-- 10. CHINESE VOCABULARY (HSK 1 - 80+ words)
-- ========================
INSERT INTO words (id, language_id, text, reading, romaji, pos, hsk_level, frequency_rank) VALUES
(301, 3, '你好', 'nǐ hǎo', NULL, 'INTERJECTION', 'HSK1', 1),
(302, 3, '谢谢', 'xiè xiè', NULL, 'INTERJECTION', 'HSK1', 2),
(303, 3, '再见', 'zài jiàn', NULL, 'INTERJECTION', 'HSK1', 3),
(304, 3, '对不起', 'duì bù qǐ', NULL, 'INTERJECTION', 'HSK1', 4),
(305, 3, '我', 'wǒ', NULL, 'NOUN', 'HSK1', 5),
(306, 3, '你', 'nǐ', NULL, 'NOUN', 'HSK1', 6),
(307, 3, '他', 'tā', NULL, 'NOUN', 'HSK1', 7),
(308, 3, '她', 'tā', NULL, 'NOUN', 'HSK1', 8),
(309, 3, '爸爸', 'bà ba', NULL, 'NOUN', 'HSK1', 9),
(310, 3, '妈妈', 'mā ma', NULL, 'NOUN', 'HSK1', 10),
(311, 3, '老师', 'lǎo shī', NULL, 'NOUN', 'HSK1', 11),
(312, 3, '学生', 'xué shēng', NULL, 'NOUN', 'HSK1', 12),
(313, 3, '朋友', 'péng yǒu', NULL, 'NOUN', 'HSK1', 13),
(314, 3, '家', 'jiā', NULL, 'NOUN', 'HSK1', 14),
(315, 3, '学校', 'xué xiào', NULL, 'NOUN', 'HSK1', 15),
(316, 3, '水', 'shuǐ', NULL, 'NOUN', 'HSK1', 16),
(317, 3, '茶', 'chá', NULL, 'NOUN', 'HSK1', 17),
(318, 3, '米饭', 'mǐ fàn', NULL, 'NOUN', 'HSK1', 18),
(319, 3, '书', 'shū', NULL, 'NOUN', 'HSK1', 19),
(320, 3, '电话', 'diàn huà', NULL, 'NOUN', 'HSK1', 20),
(321, 3, '吃', 'chī', NULL, 'VERB', 'HSK1', 21),
(322, 3, '喝', 'hē', NULL, 'VERB', 'HSK1', 22),
(323, 3, '看', 'kàn', NULL, 'VERB', 'HSK1', 23),
(324, 3, '听', 'tīng', NULL, 'VERB', 'HSK1', 24),
(325, 3, '说', 'shuō', NULL, 'VERB', 'HSK1', 25),
(326, 3, '读', 'dú', NULL, 'VERB', 'HSK1', 26),
(327, 3, '写', 'xiě', NULL, 'VERB', 'HSK1', 27),
(328, 3, '去', 'qù', NULL, 'VERB', 'HSK1', 28),
(329, 3, '来', 'lái', NULL, 'VERB', 'HSK1', 29),
(330, 3, '买', 'mǎi', NULL, 'VERB', 'HSK1', 30),
(331, 3, '大', 'dà', NULL, 'ADJ', 'HSK1', 31),
(332, 3, '小', 'xiǎo', NULL, 'ADJ', 'HSK1', 32),
(333, 3, '好', 'hǎo', NULL, 'ADJ', 'HSK1', 33),
(334, 3, '多', 'duō', NULL, 'ADJ', 'HSK1', 34),
(335, 3, '少', 'shǎo', NULL, 'ADJ', 'HSK1', 35),
(336, 3, '热', 'rè', NULL, 'ADJ', 'HSK1', 36),
(337, 3, '冷', 'lěng', NULL, 'ADJ', 'HSK1', 37),
(338, 3, '今天', 'jīn tiān', NULL, 'NOUN', 'HSK1', 38),
(339, 3, '明天', 'míng tiān', NULL, 'NOUN', 'HSK1', 39),
(340, 3, '昨天', 'zuó tiān', NULL, 'NOUN', 'HSK1', 40);

INSERT INTO word_meanings (word_id, translation_lang_id, meaning, example_sentence, example_translation) VALUES
(301, 5, 'Xin chào', '你好，你叫什么名字？', 'Xin chào, bạn tên gì?'),
(302, 5, 'Cảm ơn', '谢谢你的帮助。', 'Cảm ơn sự giúp đỡ của bạn.'),
(303, 5, 'Tạm biệt', '再见，明天见。', 'Tạm biệt, ngày mai gặp.'),
(304, 5, 'Xin lỗi', '对不起，我迟到了。', 'Xin lỗi, tôi đến muộn.'),
(305, 5, 'Tôi', '我是越南人。', 'Tôi là người Việt Nam.'),
(306, 5, 'Bạn', '你是学生吗？', 'Bạn là học sinh à?'),
(307, 5, 'Anh ấy', '他是老师。', 'Anh ấy là giáo viên.'),
(308, 5, 'Cô ấy', '她很漂亮。', 'Cô ấy rất xinh.'),
(309, 5, 'Bố', '我爸爸是医生。', 'Bố tôi là bác sĩ.'),
(310, 5, 'Mẹ', '我妈妈做饭很好吃。', 'Mẹ tôi nấu ăn rất ngon.'),
(321, 5, 'Ăn', '我吃米饭。', 'Tôi ăn cơm.'),
(322, 5, 'Uống', '我喝茶。', 'Tôi uống trà.'),
(323, 5, 'Xem / Nhìn', '我看书。', 'Tôi đọc sách.'),
(324, 5, 'Nghe', '听音乐。', 'Nghe nhạc.'),
(325, 5, 'Nói', '你说中文吗？', 'Bạn nói tiếng Trung không?'),
(328, 5, 'Đi', '我去学校。', 'Tôi đi đến trường.'),
(329, 5, 'Đến', '他来了。', 'Anh ấy đến rồi.'),
(330, 5, 'Mua', '我买水果。', 'Tôi mua trái cây.');

-- ========================
-- 11. JAPANESE GRAMMAR (N5)
-- ========================
INSERT INTO grammars (id, language_id, pattern, meaning_vi, meaning_en, structure, jlpt_level, example_sentence, example_translation, note) VALUES
(1, 1, '〜は〜です', 'A là B', 'A is B', 'Danh từ は Danh từ です', 'N5', 'わたしはがくせいです。', 'Tôi là sinh viên.', 'Cấu trúc câu cơ bản nhất. は (wa) là trợ từ chủ đề.'),
(2, 1, '〜は〜じゃないです', 'A không phải là B', 'A is not B', 'Danh từ は Danh từ じゃないです', 'N5', 'これはほんじゃないです。', 'Đây không phải là sách.', 'Thể phủ định của です. Có thể dùng ではありません (lịch sự hơn).'),
(3, 1, '〜は〜ですか', 'A có phải là B không?', 'Is A B?', 'Danh từ は Danh từ ですか', 'N5', 'あなたはせんせいですか。', 'Bạn có phải là giáo viên không?', 'Thêm か vào cuối câu để tạo câu hỏi Yes/No.'),
(4, 1, '〜の〜', 'của (sở hữu)', 'possessive particle', 'Danh từ の Danh từ', 'N5', 'わたしのほんです。', 'Đây là sách của tôi.', 'の nối 2 danh từ, thể hiện sở hữu hoặc thuộc tính.'),
(5, 1, '〜を〜ます', 'Làm gì đó (tân ngữ)', 'do something (object)', 'Danh từ を Động từ ます', 'N5', 'ごはんをたべます。', 'Tôi ăn cơm.', 'を (wo) là trợ từ tân ngữ, đánh dấu đối tượng của hành động.'),
(6, 1, '〜に/へ いきます', 'Đi đến đâu', 'go to somewhere', 'Nơi chốn に/へ いきます', 'N5', 'がっこうにいきます。', 'Tôi đi đến trường.', 'に chỉ đích đến cụ thể, へ chỉ hướng di chuyển.'),
(7, 1, '〜で〜ます', 'Bằng phương tiện/tại nơi', 'by means of / at location', 'Phương tiện/Nơi で Động từ', 'N5', 'でんしゃでいきます。', 'Tôi đi bằng tàu điện.', 'で có 2 nghĩa: phương tiện hoặc nơi diễn ra hành động.'),
(8, 1, '〜が あります/います', 'Có (tồn tại)', 'there is/are', 'Danh từ が あります/います', 'N5', 'ねこがいます。', 'Có con mèo.', 'あります cho vật vô tri, います cho sinh vật.'),
(9, 1, '〜がすきです', 'Thích cái gì', 'like something', 'Danh từ がすきです', 'N5', 'にほんごがすきです。', 'Tôi thích tiếng Nhật.', 'すき là na-adjective, dùng が chứ không dùng を.'),
(10, 1, '〜たいです', 'Muốn làm gì', 'want to do', 'Động từ (stem) たいです', 'N5', 'にほんにいきたいです。', 'Tôi muốn đi Nhật Bản.', 'Bỏ ます, thêm たい. Chỉ dùng cho ngôi thứ nhất.'),
(11, 1, '〜ましょう', 'Cùng làm gì đi', 'let us do', 'Động từ ましょう', 'N5', 'いっしょにべんきょうしましょう。', 'Hãy cùng nhau học nhé.', 'Dùng để rủ rê, đề nghị cùng làm gì đó.'),
(12, 1, '〜ました', 'Đã làm gì (quá khứ)', 'did something (past)', 'Động từ ました', 'N5', 'きのうえいがをみました。', 'Hôm qua tôi đã xem phim.', 'Thể quá khứ lịch sự của động từ.'),
(13, 1, '〜ませんでした', 'Đã không làm gì', 'did not do', 'Động từ ませんでした', 'N5', 'きのうべんきょうしませんでした。', 'Hôm qua tôi đã không học.', 'Thể quá khứ phủ định lịch sự.'),
(14, 1, '〜てください', 'Xin hãy làm gì', 'please do', 'Động từ て ください', 'N5', 'ちょっとまってください。', 'Xin hãy chờ một chút.', 'Dùng để yêu cầu, nhờ vả lịch sự. Cần biến đổi thể て.'),
(15, 1, '〜ています', 'Đang làm gì', 'is doing', 'Động từ て います', 'N5', 'ほんをよんでいます。', 'Tôi đang đọc sách.', 'Diễn tả hành động đang diễn ra hoặc trạng thái kéo dài.'),
(16, 1, '〜てもいいですか', 'Có được phép làm không?', 'may I do?', 'Động từ て もいいですか', 'N5', 'しゃしんをとってもいいですか。', 'Tôi có thể chụp ảnh không?', 'Xin phép làm gì đó.'),
(17, 1, '〜ないでください', 'Xin đừng làm gì', 'please do not', 'Động từ ない で ください', 'N5', 'ここでたばこをすわないでください。', 'Xin đừng hút thuốc ở đây.', 'Yêu cầu không làm gì đó một cách lịch sự.'),
(18, 1, '〜から', 'Vì / Bởi vì', 'because', 'Câu1 から Câu2', 'N5', 'あついですから、まどをあけてください。', 'Vì nóng, xin hãy mở cửa sổ.', 'Nối 2 câu, diễn tả nguyên nhân - kết quả.'),
(19, 1, '〜が、〜', 'Nhưng', 'but', 'Câu1 が Câu2', 'N5', 'にほんごはむずかしいですが、おもしろいです。', 'Tiếng Nhật khó nhưng thú vị.', 'Nối 2 câu có ý nghĩa tương phản.'),
(20, 1, 'いつ・どこ・だれ・なに', 'Khi nào/Ở đâu/Ai/Cái gì', 'when/where/who/what', 'Từ nghi vấn + ですか', 'N5', 'これはなんですか。', 'Đây là cái gì?', 'Các từ nghi vấn cơ bản trong tiếng Nhật.');

-- ========================
-- 12. EXERCISES for Lesson 1 (おはようございます)
-- ========================
INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
-- Lesson 1: Chào buổi sáng
(1, 1, 'MULTIPLE_CHOICE',
 '{"question": "「おはようございます」có nghĩa là gì?", "options": ["Chào buổi sáng", "Chào buổi tối", "Tạm biệt", "Xin lỗi"]}',
 '{"correct": 0, "explanation": "おはようございます = Chào buổi sáng (lịch sự)"}',
 '{"hint": "Đây là lời chào dùng vào buổi sáng"}', 1),

(1, 2, 'MULTIPLE_CHOICE',
 '{"question": "Bạn gặp thầy giáo lúc 8 giờ sáng, bạn nói gì?", "options": ["おはようございます", "こんにちは", "こんばんは", "さようなら"]}',
 '{"correct": 0, "explanation": "Buổi sáng dùng おはようございます"}',
 '{"hint": "8 giờ sáng = buổi sáng"}', 1),

(1, 3, 'TRANSLATE_TO_SOURCE',
 '{"sentence": "おはようございます、せんせい。", "from": "ja", "to": "vi"}',
 '{"correct": "Chào buổi sáng, thầy/cô.", "alternatives": ["Chào buổi sáng thầy", "Chào buổi sáng, giáo viên"]}',
 '{"hint": "せんせい = thầy/cô giáo"}', 1),

(1, 4, 'FILL_BLANK',
 '{"sentence": "____ございます、せんせい。", "context": "Chào buổi sáng, thầy/cô."}',
 '{"correct": "おはよう", "alternatives": ["おはよう"]}',
 '{"hint": "おは..."}', 2),

(1, 5, 'MATCH_PAIRS',
 '{"pairs": [{"left": "おはようございます", "right": "Chào buổi sáng"}, {"left": "こんにちは", "right": "Xin chào"}, {"left": "こんばんは", "right": "Chào buổi tối"}, {"left": "さようなら", "right": "Tạm biệt"}]}',
 '{"correct_pairs": [[0,0],[1,1],[2,2],[3,3]]}',
 '{"hint": "Nối lời chào tiếng Nhật với nghĩa tiếng Việt"}', 1),

(1, 6, 'MULTIPLE_CHOICE',
 '{"question": "Cách nói ngắn gọn (thân mật) của おはようございます là gì?", "options": ["おはよう", "おやすみ", "ありがとう", "すみません"]}',
 '{"correct": 0, "explanation": "おはよう là thể thân mật của おはようございます"}',
 '{"hint": "Bỏ ございます đi"}', 2),

(1, 7, 'TRANSLATE_TO_TARGET',
 '{"sentence": "Chào buổi sáng", "from": "vi", "to": "ja"}',
 '{"correct": "おはようございます", "alternatives": ["おはよう"]}',
 '{"hint": "おは...ございます"}', 2),

(1, 8, 'MULTIPLE_CHOICE',
 '{"question": "Từ nào KHÔNG phải lời chào?", "options": ["すみません", "おはようございます", "こんにちは", "こんばんは"]}',
 '{"correct": 0, "explanation": "すみません = Xin lỗi, không phải lời chào"}',
 '{"hint": "すみません có nghĩa khác"}', 2),

(1, 9, 'FILL_BLANK',
 '{"sentence": "おはようございます、____。(Chào buổi sáng, thầy/cô.)", "context": "Điền từ còn thiếu"}',
 '{"correct": "せんせい", "alternatives": ["先生"]}',
 '{"hint": "Giáo viên = せ...い"}', 2),

(1, 10, 'MULTIPLE_CHOICE',
 '{"question": "おはようございます dùng trong thời gian nào?", "options": ["Buổi sáng (đến ~10h)", "Buổi trưa (12h-14h)", "Buổi chiều (14h-18h)", "Buổi tối (18h+)"]}',
 '{"correct": 0, "explanation": "おはようございます dùng từ sáng đến khoảng 10-11 giờ"}',
 '{"hint": "おはよう liên quan đến 朝 (asa - buổi sáng)"}', 1),

-- Lesson 2: こんにちは
(2, 1, 'MULTIPLE_CHOICE',
 '{"question": "「こんにちは」dùng khi nào?", "options": ["Ban ngày (trưa-chiều)", "Buổi sáng sớm", "Buổi tối", "Khi đi ngủ"]}',
 '{"correct": 0, "explanation": "こんにちは dùng từ khoảng 10h đến chiều tối"}',
 '{"hint": "Đây là lời chào phổ biến nhất ban ngày"}', 1),

(2, 2, 'TRANSLATE_TO_SOURCE',
 '{"sentence": "こんにちは、おげんきですか。", "from": "ja", "to": "vi"}',
 '{"correct": "Xin chào, bạn có khỏe không?", "alternatives": ["Xin chào, bạn khỏe không?"]}',
 '{"hint": "おげんき = sức khỏe"}', 1),

(2, 3, 'FILL_BLANK',
 '{"sentence": "こんにちは、お____ですか。", "context": "Xin chào, bạn có khỏe không?"}',
 '{"correct": "げんき", "alternatives": ["元気"]}',
 '{"hint": "げ...き = khỏe"}', 2),

(2, 4, 'MATCH_PAIRS',
 '{"pairs": [{"left": "おはようございます", "right": "~10h sáng"}, {"left": "こんにちは", "right": "Ban ngày"}, {"left": "こんばんは", "right": "Buổi tối"}, {"left": "おやすみなさい", "right": "Khi đi ngủ"}]}',
 '{"correct_pairs": [[0,0],[1,1],[2,2],[3,3]]}',
 '{"hint": "Nối lời chào với thời gian sử dụng"}', 1),

(2, 5, 'MULTIPLE_CHOICE',
 '{"question": "Ai đó chào bạn \"こんにちは\", bạn đáp lại thế nào?", "options": ["こんにちは", "おはようございます", "さようなら", "すみません"]}',
 '{"correct": 0, "explanation": "Đáp lại cùng lời chào こんにちは"}',
 '{"hint": "Đáp lại bằng cùng lời chào"}', 1),

-- Lesson 6: わたしは〜です
(6, 1, 'MULTIPLE_CHOICE',
 '{"question": "「わたしはたなかです」có nghĩa là gì?", "options": ["Tôi là Tanaka", "Bạn là Tanaka", "Tanaka là giáo viên", "Tanaka đến rồi"]}',
 '{"correct": 0, "explanation": "わたし = tôi, は = (trợ từ), たなか = Tanaka, です = là"}',
 '{"hint": "わたし = tôi"}', 1),

(6, 2, 'FILL_BLANK',
 '{"sentence": "わたし____がくせいです。", "context": "Tôi là sinh viên."}',
 '{"correct": "は", "alternatives": ["は"]}',
 '{"hint": "Trợ từ chủ đề trong tiếng Nhật"}', 1),

(6, 3, 'TRANSLATE_TO_TARGET',
 '{"sentence": "Tôi là người Việt Nam.", "from": "vi", "to": "ja"}',
 '{"correct": "わたしはベトナムじんです。", "alternatives": ["わたしはベトナム人です"]}',
 '{"hint": "ベトナム = Việt Nam, じん = người"}', 2),

(6, 4, 'MULTIPLE_CHOICE',
 '{"question": "Trợ từ nào đánh dấu chủ đề trong câu tiếng Nhật?", "options": ["は", "が", "を", "に"]}',
 '{"correct": 0, "explanation": "は (đọc là wa) là trợ từ đánh dấu chủ đề"}',
 '{"hint": "Đọc là \"wa\" nhưng viết là \"ha\""}', 2),

(6, 5, 'MATCH_PAIRS',
 '{"pairs": [{"left": "わたし", "right": "Tôi"}, {"left": "あなた", "right": "Bạn"}, {"left": "せんせい", "right": "Giáo viên"}, {"left": "がくせい", "right": "Sinh viên"}]}',
 '{"correct_pairs": [[0,0],[1,1],[2,2],[3,3]]}',
 '{"hint": "Nối từ với nghĩa"}', 1),

-- Lesson 16: Số đếm 1-10
(16, 1, 'MULTIPLE_CHOICE',
 '{"question": "Số 3 trong tiếng Nhật là gì?", "options": ["さん", "に", "よん", "ご"]}',
 '{"correct": 0, "explanation": "さん (san) = 3"}',
 '{"hint": "Gần giống cách gọi kính ngữ \" ~さん\""}', 1),

(16, 2, 'MATCH_PAIRS',
 '{"pairs": [{"left": "いち", "right": "1"}, {"left": "に", "right": "2"}, {"left": "さん", "right": "3"}, {"left": "よん", "right": "4"}, {"left": "ご", "right": "5"}]}',
 '{"correct_pairs": [[0,0],[1,1],[2,2],[3,3],[4,4]]}',
 '{"hint": "Nối số đếm tiếng Nhật với số"}', 1),

(16, 3, 'FILL_BLANK',
 '{"sentence": "いち、に、____、よん、ご", "context": "Đếm từ 1 đến 5"}',
 '{"correct": "さん", "alternatives": ["三"]}',
 '{"hint": "Số 3"}', 1),

(16, 4, 'MULTIPLE_CHOICE',
 '{"question": "じゅう là số mấy?", "options": ["10", "100", "1000", "7"]}',
 '{"correct": 0, "explanation": "じゅう (juu) = 10"}',
 '{"hint": "Số tròn chục đầu tiên"}', 1),

(16, 5, 'TRANSLATE_TO_SOURCE',
 '{"sentence": "ろく、なな、はち、きゅう、じゅう", "from": "ja", "to": "vi"}',
 '{"correct": "6, 7, 8, 9, 10", "alternatives": ["sáu, bảy, tám, chín, mười"]}',
 '{"hint": "Đếm từ 6 đến 10"}', 1),

-- Lesson 21: Family vocabulary
(21, 1, 'MULTIPLE_CHOICE',
 '{"question": "「おかあさん」có nghĩa là gì?", "options": ["Mẹ", "Bố", "Anh trai", "Chị gái"]}',
 '{"correct": 0, "explanation": "おかあさん = Mẹ (kính ngữ khi nói về mẹ người khác hoặc gọi mẹ mình)"}',
 '{"hint": "か = mẹ (母)"}', 1),

(21, 2, 'MATCH_PAIRS',
 '{"pairs": [{"left": "おかあさん", "right": "Mẹ"}, {"left": "おとうさん", "right": "Bố"}, {"left": "おにいさん", "right": "Anh trai"}, {"left": "おねえさん", "right": "Chị gái"}]}',
 '{"correct_pairs": [[0,0],[1,1],[2,2],[3,3]]}',
 '{"hint": "Nối thành viên gia đình"}', 1),

(21, 3, 'FILL_BLANK',
 '{"sentence": "____はかいしゃいんです。(Bố là nhân viên công ty.)", "context": "Điền từ chỉ bố"}',
 '{"correct": "おとうさん", "alternatives": ["父"]}',
 '{"hint": "おとう..."}', 2),

(21, 4, 'TRANSLATE_TO_TARGET',
 '{"sentence": "Gia đình tôi có 5 người.", "from": "vi", "to": "ja"}',
 '{"correct": "わたしのかぞくはごにんです。", "alternatives": ["私の家族は五人です"]}',
 '{"hint": "かぞく = gia đình, ごにん = 5 người"}', 3),

(21, 5, 'MULTIPLE_CHOICE',
 '{"question": "いもうと là ai?", "options": ["Em gái", "Em trai", "Chị gái", "Anh trai"]}',
 '{"correct": 0, "explanation": "いもうと = em gái (thân mật khi nói về em gái mình)"}',
 '{"hint": "いもうと bắt đầu bằng い"}', 1),

-- Lesson 26: Shopping これ・それ・あれ
(26, 1, 'MULTIPLE_CHOICE',
 '{"question": "「これ」chỉ vật ở đâu?", "options": ["Gần người nói", "Gần người nghe", "Xa cả hai", "Không xác định"]}',
 '{"correct": 0, "explanation": "これ = cái này (gần người nói)"}',
 '{"hint": "こ = gần"}', 1),

(26, 2, 'MATCH_PAIRS',
 '{"pairs": [{"left": "これ", "right": "Cái này (gần mình)"}, {"left": "それ", "right": "Cái đó (gần bạn)"}, {"left": "あれ", "right": "Cái kia (xa cả hai)"}, {"left": "どれ", "right": "Cái nào?"}]}',
 '{"correct_pairs": [[0,0],[1,1],[2,2],[3,3]]}',
 '{"hint": "こ=gần mình, そ=gần bạn, あ=xa, ど=hỏi"}', 1),

(26, 3, 'FILL_BLANK',
 '{"sentence": "____はいくらですか。(Cái này bao nhiêu tiền?)", "context": "Hỏi giá vật gần mình"}',
 '{"correct": "これ", "alternatives": ["これ"]}',
 '{"hint": "Vật gần người nói = こ..."}', 1),

(26, 4, 'TRANSLATE_TO_SOURCE',
 '{"sentence": "これはせんえんです。", "from": "ja", "to": "vi"}',
 '{"correct": "Cái này 1000 yên.", "alternatives": ["Cái này là 1000 yên", "Cái này giá 1000 yên"]}',
 '{"hint": "せんえん = 1000 yên"}', 2),

(26, 5, 'MULTIPLE_CHOICE',
 '{"question": "Bạn muốn hỏi giá một vật, bạn nói gì?", "options": ["いくらですか", "なんですか", "どこですか", "だれですか"]}',
 '{"correct": 0, "explanation": "いくらですか = Bao nhiêu tiền?"}',
 '{"hint": "いくら = bao nhiêu (tiền)"}', 1);

-- ========================
-- 13. KANJI (N5 - 50 characters)
-- ========================
INSERT INTO characters_table (id, language_id, character_text, stroke_count, jlpt_level, frequency_rank, meaning_vi, meaning_en, on_reading, kun_reading, han_viet, mnemonic_text) VALUES
(1, 1, '一', 1, 'N5', 1, 'Một', 'One', 'イチ', 'ひと(つ)', 'Nhất', 'Một nét ngang = số 1'),
(2, 1, '二', 2, 'N5', 2, 'Hai', 'Two', 'ニ', 'ふた(つ)', 'Nhị', 'Hai nét ngang = số 2'),
(3, 1, '三', 3, 'N5', 3, 'Ba', 'Three', 'サン', 'み(つ)', 'Tam', 'Ba nét ngang = số 3'),
(4, 1, '四', 5, 'N5', 4, 'Bốn', 'Four', 'シ', 'よん', 'Tứ', 'Hình cái bàn có 4 chân'),
(5, 1, '五', 4, 'N5', 5, 'Năm', 'Five', 'ゴ', 'いつ(つ)', 'Ngũ', 'Hình bàn tay 5 ngón'),
(6, 1, '六', 4, 'N5', 6, 'Sáu', 'Six', 'ロク', 'む(つ)', 'Lục', 'Nóc nhà có 6 góc'),
(7, 1, '七', 2, 'N5', 7, 'Bảy', 'Seven', 'シチ', 'なな', 'Thất', 'Số 7 lật ngược'),
(8, 1, '八', 2, 'N5', 8, 'Tám', 'Eight', 'ハチ', 'や(つ)', 'Bát', 'Hai nét tỏa ra = tám'),
(9, 1, '九', 2, 'N5', 9, 'Chín', 'Nine', 'キュウ', 'ここの(つ)', 'Cửu', 'Giống số 9 viết tay'),
(10, 1, '十', 2, 'N5', 10, 'Mười', 'Ten', 'ジュウ', 'とお', 'Thập', 'Dấu cộng + = thập'),
(11, 1, '日', 4, 'N5', 11, 'Ngày/Mặt trời', 'Day/Sun', 'ニチ・ジツ', 'ひ', 'Nhật', 'Hình mặt trời vuông'),
(12, 1, '月', 4, 'N5', 12, 'Tháng/Mặt trăng', 'Month/Moon', 'ゲツ・ガツ', 'つき', 'Nguyệt', 'Hình mặt trăng lưỡi liềm'),
(13, 1, '火', 4, 'N5', 13, 'Lửa', 'Fire', 'カ', 'ひ', 'Hỏa', 'Hình ngọn lửa bốc cháy'),
(14, 1, '水', 4, 'N5', 14, 'Nước', 'Water', 'スイ', 'みず', 'Thủy', 'Dòng nước chảy'),
(15, 1, '木', 4, 'N5', 15, 'Cây/Gỗ', 'Tree/Wood', 'モク・ボク', 'き', 'Mộc', 'Hình cái cây có cành'),
(16, 1, '金', 8, 'N5', 16, 'Vàng/Tiền', 'Gold/Money', 'キン・コン', 'かね', 'Kim', 'Mái nhà chứa vàng dưới đất'),
(17, 1, '土', 3, 'N5', 17, 'Đất', 'Earth/Soil', 'ド・ト', 'つち', 'Thổ', 'Hình cây mọc trên đất'),
(18, 1, '人', 2, 'N5', 18, 'Người', 'Person', 'ジン・ニン', 'ひと', 'Nhân', 'Hình người đang đi'),
(19, 1, '大', 3, 'N5', 19, 'Lớn/To', 'Big', 'ダイ・タイ', 'おお(きい)', 'Đại', 'Người dang rộng tay = to lớn'),
(20, 1, '小', 3, 'N5', 20, 'Nhỏ/Bé', 'Small', 'ショウ', 'ちい(さい)', 'Tiểu', 'Hình chia nhỏ = bé'),
(21, 1, '山', 3, 'N5', 21, 'Núi', 'Mountain', 'サン', 'やま', 'Sơn', 'Hình 3 đỉnh núi'),
(22, 1, '川', 3, 'N5', 22, 'Sông', 'River', 'セン', 'かわ', 'Xuyên', 'Hình 3 dòng nước chảy'),
(23, 1, '上', 3, 'N5', 23, 'Trên', 'Up/Above', 'ジョウ', 'うえ', 'Thượng', 'Vạch chỉ lên trên'),
(24, 1, '下', 3, 'N5', 24, 'Dưới', 'Down/Below', 'カ・ゲ', 'した', 'Hạ', 'Vạch chỉ xuống dưới'),
(25, 1, '中', 4, 'N5', 25, 'Giữa/Trong', 'Middle/Inside', 'チュウ', 'なか', 'Trung', 'Đường thẳng xuyên qua giữa'),
(26, 1, '学', 8, 'N5', 26, 'Học', 'Study/Learn', 'ガク', 'まな(ぶ)', 'Học', 'Trẻ con dưới mái nhà = học'),
(27, 1, '生', 5, 'N5', 27, 'Sống/Sinh', 'Life/Birth', 'セイ・ショウ', 'い(きる)', 'Sinh', 'Cây mọc lên từ đất = sự sống'),
(28, 1, '先', 6, 'N5', 28, 'Trước/Tiên', 'First/Previous', 'セン', 'さき', 'Tiên', 'Người đi trước'),
(29, 1, '食', 9, 'N5', 29, 'Ăn', 'Eat/Food', 'ショク', 'た(べる)', 'Thực', 'Mái nhà + tốt = nơi ăn uống'),
(30, 1, '見', 7, 'N5', 30, 'Nhìn/Thấy', 'See/Look', 'ケン', 'み(る)', 'Kiến', 'Con mắt trên đôi chân = nhìn');

-- ========================
-- 14. MOCK TESTS
-- ========================
INSERT INTO mock_tests (id, certification, level_code, title, total_duration_min, pass_score, section_config_json) VALUES
(1, 'JLPT', 'N5', 'JLPT N5 - Đề thi thử số 1', 90, 80,
 '{"sections": [{"name": "VOCAB", "title": "語彙 Từ vựng", "duration_min": 15, "question_count": 15}, {"name": "GRAMMAR", "title": "文法 Ngữ pháp", "duration_min": 20, "question_count": 15}, {"name": "READING", "title": "読解 Đọc hiểu", "duration_min": 30, "question_count": 10}, {"name": "LISTENING", "title": "聴解 Nghe hiểu", "duration_min": 25, "question_count": 10}]}'),

(2, 'HSK', 'HSK1', 'HSK 1 - Đề thi thử số 1', 40, 120,
 '{"sections": [{"name": "LISTENING", "title": "听力 Nghe hiểu", "duration_min": 15, "question_count": 20}, {"name": "READING", "title": "阅读 Đọc hiểu", "duration_min": 25, "question_count": 20}]}');

-- JLPT N5 Mock Test Questions
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
-- VOCAB Section
(1, 'VOCAB', '{"question": "「にほんご」の漢字はどれですか。", "options": ["日本語", "日本後", "日本悟", "日本御"]}', '{"correct": 0, "explanation": "日本語 = にほんご (tiếng Nhật)"}', 1, 1),
(1, 'VOCAB', '{"question": "「がっこう」はなんですか。", "options": ["Trường học", "Bệnh viện", "Ngân hàng", "Bưu điện"]}', '{"correct": 0, "explanation": "がっこう (学校) = trường học"}', 1, 2),
(1, 'VOCAB', '{"question": "「たべる」の意味は？", "options": ["Ăn", "Uống", "Ngủ", "Đi"]}', '{"correct": 0, "explanation": "たべる (食べる) = ăn"}', 1, 3),
(1, 'VOCAB', '{"question": "「やすい」の反対は？", "options": ["たかい", "おおきい", "ちいさい", "ふるい"]}', '{"correct": 0, "explanation": "やすい (rẻ) ↔ たかい (đắt)"}', 2, 4),
(1, 'VOCAB', '{"question": "「でんわ」はなんですか。", "options": ["Điện thoại", "Tivi", "Radio", "Máy tính"]}', '{"correct": 0, "explanation": "でんわ (電話) = điện thoại"}', 1, 5),
(1, 'VOCAB', '{"question": "月曜日のつぎは＿＿です。", "options": ["火曜日", "水曜日", "木曜日", "金曜日"]}', '{"correct": 0, "explanation": "Thứ 2 → Thứ 3 (火曜日)"}', 2, 6),
(1, 'VOCAB', '{"question": "「きれい」はどういう意味？", "options": ["Xinh đẹp/Sạch sẽ", "To lớn", "Nhỏ bé", "Khó khăn"]}', '{"correct": 0, "explanation": "きれい = xinh đẹp, sạch sẽ (na-adjective)"}', 1, 7),
(1, 'VOCAB', '{"question": "「みる」はなんですか。", "options": ["Xem/Nhìn", "Nghe", "Đọc", "Viết"]}', '{"correct": 0, "explanation": "みる (見る) = xem, nhìn"}', 1, 8),

-- GRAMMAR Section
(1, 'GRAMMAR', '{"question": "わたし＿＿がくせいです。", "options": ["は", "が", "を", "に"]}', '{"correct": 0, "explanation": "は là trợ từ chủ đề: わたしは～です"}', 1, 1),
(1, 'GRAMMAR', '{"question": "ごはん＿＿たべます。", "options": ["を", "は", "に", "で"]}', '{"correct": 0, "explanation": "を đánh dấu tân ngữ: ごはんをたべます"}', 1, 2),
(1, 'GRAMMAR', '{"question": "がっこう＿＿いきます。", "options": ["に", "を", "は", "が"]}', '{"correct": 0, "explanation": "に chỉ đích đến: がっこうにいきます"}', 1, 3),
(1, 'GRAMMAR', '{"question": "これはほん＿＿ないです。", "options": ["じゃ", "は", "が", "を"]}', '{"correct": 0, "explanation": "Phủ định: ～じゃないです"}', 2, 4),
(1, 'GRAMMAR', '{"question": "にほんご＿＿すきです。", "options": ["が", "を", "は", "に"]}', '{"correct": 0, "explanation": "すき dùng với が: ～がすきです"}', 2, 5),
(1, 'GRAMMAR', '{"question": "バス＿＿いきます。", "options": ["で", "に", "を", "が"]}', '{"correct": 0, "explanation": "で chỉ phương tiện: バスでいきます"}', 2, 6),
(1, 'GRAMMAR', '{"question": "きのうえいがを＿＿。", "options": ["みました", "みます", "みて", "みる"]}', '{"correct": 0, "explanation": "Quá khứ: きのう～ました"}', 2, 7),
(1, 'GRAMMAR', '{"question": "いっしょにべんきょう＿＿。", "options": ["しましょう", "します", "した", "しない"]}', '{"correct": 0, "explanation": "Rủ rê: ～ましょう = hãy cùng nhau"}', 2, 8),

-- READING Section
(1, 'READING', '{"passage": "たなかさんはにほんじんです。まいにちにほんごをおしえます。がっこうでえいごもおしえます。", "question": "たなかさんは何をしますか。", "options": ["にほんごとえいごをおしえます", "にほんごをべんきょうします", "えいごだけおしえます", "がっこうにいきません"]}', '{"correct": 0, "explanation": "Tanaka dạy cả tiếng Nhật và tiếng Anh"}', 2, 1),
(1, 'READING', '{"passage": "わたしはまいあさ7じにおきます。パンをたべて、コーヒーをのみます。8じにがっこうにいきます。", "question": "この人は何時に起きますか。", "options": ["7じ", "8じ", "6じ", "9じ"]}', '{"correct": 0, "explanation": "まいあさ7じにおきます = Mỗi sáng thức dậy lúc 7 giờ"}', 1, 2),

-- LISTENING Section (text-based simulation)
(1, 'LISTENING', '{"audio_text": "おはようございます。きょうはいいてんきですね。", "question": "この人は何と言っていますか。", "options": ["Chào buổi sáng, hôm nay thời tiết đẹp nhỉ", "Chào buổi tối, hôm nay lạnh nhỉ", "Tạm biệt, hẹn gặp lại", "Xin lỗi, tôi bận"]}', '{"correct": 0, "explanation": "おはようございます = chào buổi sáng, いいてんき = thời tiết đẹp"}', 1, 1),
(1, 'LISTENING', '{"audio_text": "すみません、えきはどこですか。まっすぐいって、みぎにまがってください。", "question": "えきはどこですか。", "options": ["Đi thẳng rồi rẽ phải", "Đi thẳng rồi rẽ trái", "Ngay trước mặt", "Phía sau"]}', '{"correct": 0, "explanation": "まっすぐ = thẳng, みぎ = phải, まがる = rẽ"}', 2, 2);

-- ========================
-- 15. ACHIEVEMENTS
-- ========================
INSERT INTO achievements (code, title, description, rarity, trigger_rule) VALUES
('FIRST_STEP', 'Bước chân đầu tiên', 'Hoàn thành bài học đầu tiên', 'COMMON', '{"type": "lesson_complete", "count": 1}'),
('WORD_COLLECTOR_50', 'Thu thập từ vựng', 'Học 50 từ vựng', 'COMMON', '{"type": "words_learned", "count": 50}'),
('WORD_COLLECTOR_200', 'Kho từ vựng', 'Học 200 từ vựng', 'UNCOMMON', '{"type": "words_learned", "count": 200}'),
('WORD_COLLECTOR_500', 'Bậc thầy từ vựng', 'Học 500 từ vựng', 'RARE', '{"type": "words_learned", "count": 500}'),
('STREAK_7', 'Tuần lễ chăm chỉ', 'Streak 7 ngày liên tiếp', 'COMMON', '{"type": "streak", "count": 7}'),
('STREAK_30', 'Tháng kiên trì', 'Streak 30 ngày liên tiếp', 'UNCOMMON', '{"type": "streak", "count": 30}'),
('STREAK_100', 'Chiến binh Streak', 'Streak 100 ngày liên tiếp', 'RARE', '{"type": "streak", "count": 100}'),
('STREAK_365', 'Huyền thoại Streak', 'Streak 365 ngày liên tiếp', 'LEGENDARY', '{"type": "streak", "count": 365}'),
('PERFECT_LESSON', 'Hoàn hảo', 'Hoàn thành bài học không sai câu nào', 'UNCOMMON', '{"type": "perfect_score", "count": 1}'),
('SPEED_DEMON', 'Tốc độ ánh sáng', 'Hoàn thành bài học dưới 2 phút', 'RARE', '{"type": "speed_complete", "seconds": 120}'),
('SRS_MASTER_100', 'SRS Thành thạo', 'Review 100 thẻ flashcard', 'UNCOMMON', '{"type": "srs_reviews", "count": 100}'),
('KANJI_HUNTER_50', 'Thợ săn Kanji', 'Học 50 Kanji', 'UNCOMMON', '{"type": "kanji_learned", "count": 50}'),
('MOCK_TEST_PASS', 'Đậu thử', 'Đậu đề thi thử đầu tiên', 'UNCOMMON', '{"type": "mock_test_pass", "count": 1}');

-- ========================
-- 16. LEAGUES
-- ========================
INSERT INTO leagues (name, tier, promotion_threshold) VALUES
('Bronze', 1, 7),
('Silver', 2, 7),
('Gold', 3, 7),
('Sapphire', 4, 7),
('Ruby', 5, 7),
('Emerald', 6, 7),
('Amethyst', 7, 7),
('Pearl', 8, 7),
('Obsidian', 9, 7),
('Diamond', 10, 7);

-- ========================
-- 17. SRS DECKS (System decks)
-- ========================
INSERT INTO decks (id, owner_id, name, description, language_id, is_public, card_count) VALUES
(1, NULL, 'JLPT N5 Từ vựng', 'Bộ thẻ từ vựng JLPT N5 - 800+ từ', 1, TRUE, 110),
(2, NULL, 'JLPT N5 Kanji', 'Bộ thẻ Kanji JLPT N5 - 103 chữ', 1, TRUE, 30),
(3, NULL, 'English A1 Vocabulary', 'Từ vựng tiếng Anh cơ bản A1', 2, TRUE, 40),
(4, NULL, 'HSK 1 Từ vựng', 'Bộ thẻ từ vựng HSK 1 - 150 từ', 3, TRUE, 40);

-- Cards for JLPT N5 Vocabulary Deck
INSERT INTO cards (deck_id, front_text, back_text, ref_word_id) VALUES
(1, 'おはようございます', 'Chào buổi sáng (lịch sự)\nVD: おはようございます、せんせい。', 1),
(1, 'こんにちは', 'Xin chào (ban ngày)\nVD: こんにちは、おげんきですか。', 2),
(1, 'さようなら', 'Tạm biệt\nVD: さようなら、またあした。', 4),
(1, 'ありがとうございます', 'Cảm ơn (lịch sự)\nVD: ありがとうございます、せんせい。', 5),
(1, 'すみません', 'Xin lỗi / Xin phép\nVD: すみません、トイレはどこですか。', 6),
(1, 'わたし', 'Tôi\nVD: わたしはベトナムじんです。', 11),
(1, 'せんせい', 'Giáo viên / Thầy cô\nVD: せんせいはにほんじんです。', 15),
(1, 'がくせい', 'Học sinh / Sinh viên\nVD: わたしはがくせいです。', 16),
(1, 'たべる', 'Ăn\nVD: ごはんをたべます。', 76),
(1, 'のむ', 'Uống\nVD: みずをのみます。', 77),
(1, 'みる', 'Xem / Nhìn\nVD: テレビをみます。', 78),
(1, 'いく', 'Đi\nVD: がっこうにいきます。', 83),
(1, 'おおきい', 'To / Lớn\nVD: このいえはおおきいです。', 61),
(1, 'ちいさい', 'Nhỏ / Bé\nVD: このねこはちいさいです。', 62),
(1, 'おいしい', 'Ngon\nVD: このラーメンはおいしいです。', 69);

-- Cards for Kanji Deck
INSERT INTO cards (deck_id, front_text, back_text, ref_character_id) VALUES
(2, '一', 'イチ / ひと(つ)\nNghĩa: Một\nHán Việt: Nhất\nNét: 1', 1),
(2, '二', 'ニ / ふた(つ)\nNghĩa: Hai\nHán Việt: Nhị\nNét: 2', 2),
(2, '三', 'サン / み(つ)\nNghĩa: Ba\nHán Việt: Tam\nNét: 3', 3),
(2, '日', 'ニチ / ひ\nNghĩa: Ngày, Mặt trời\nHán Việt: Nhật\nNét: 4', 11),
(2, '月', 'ゲツ / つき\nNghĩa: Tháng, Mặt trăng\nHán Việt: Nguyệt\nNét: 4', 12),
(2, '人', 'ジン / ひと\nNghĩa: Người\nHán Việt: Nhân\nNét: 2', 18),
(2, '大', 'ダイ / おお(きい)\nNghĩa: Lớn, To\nHán Việt: Đại\nNét: 3', 19),
(2, '学', 'ガク / まな(ぶ)\nNghĩa: Học\nHán Việt: Học\nNét: 8', 26),
(2, '食', 'ショク / た(べる)\nNghĩa: Ăn\nHán Việt: Thực\nNét: 9', 29),
(2, '見', 'ケン / み(る)\nNghĩa: Nhìn, Thấy\nHán Việt: Kiến\nNét: 7', 30);

-- ========================
-- 18. SECTIONS & UNITS for ENGLISH A1
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(20, 4, 1, 'Greetings & Introductions', 'Chào hỏi và tự giới thiệu bằng tiếng Anh', 'A1'),
(21, 4, 2, 'Numbers & Time', 'Số đếm và giờ giấc', 'A1'),
(22, 4, 3, 'Family & People', 'Gia đình và con người', 'A1'),
(23, 4, 4, 'Daily Life', 'Cuộc sống hàng ngày', 'A1');

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(30, 20, 1, 'Hello & Goodbye', 'Say hello and goodbye', '👋', 50),
(31, 20, 2, 'My Name Is...', 'Introduce yourself', '🙋', 50),
(32, 20, 3, 'Nice to Meet You', 'Meet new people', '🤝', 50),
(33, 21, 1, 'Numbers 1-20', 'Count from 1 to 20', '🔢', 50),
(34, 22, 1, 'My Family', 'Talk about family', '👨‍👩‍👧‍👦', 50);

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(40, 30, 1, 'Hello! How are you?', 'NORMAL', 15, 8),
(41, 30, 2, 'Good morning/afternoon/evening', 'NORMAL', 15, 8),
(42, 31, 1, 'My name is... / I am...', 'NORMAL', 15, 8),
(43, 31, 2, 'Where are you from?', 'NORMAL', 15, 8),
(44, 33, 1, 'Numbers 1-10', 'NORMAL', 15, 8),
(45, 34, 1, 'Mom, Dad, Brother, Sister', 'NORMAL', 15, 8);

-- English exercises
INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(40, 1, 'MULTIPLE_CHOICE',
 '{"question": "\"Hello\" nghĩa là gì?", "options": ["Xin chào", "Tạm biệt", "Cảm ơn", "Xin lỗi"]}',
 '{"correct": 0, "explanation": "Hello = Xin chào"}', '{"hint": "Lời chào phổ biến nhất"}', 1),
(40, 2, 'FILL_BLANK',
 '{"sentence": "Hello! How ____ you?", "context": "Xin chào! Bạn khỏe không?"}',
 '{"correct": "are", "alternatives": ["are"]}', '{"hint": "a.."}', 1),
(40, 3, 'TRANSLATE_TO_TARGET',
 '{"sentence": "Xin chào, bạn khỏe không?", "from": "vi", "to": "en"}',
 '{"correct": "Hello, how are you?", "alternatives": ["Hi, how are you?"]}', '{"hint": "Hello..."}', 1),
(40, 4, 'MATCH_PAIRS',
 '{"pairs": [{"left": "Hello", "right": "Xin chào"}, {"left": "Goodbye", "right": "Tạm biệt"}, {"left": "Thank you", "right": "Cảm ơn"}, {"left": "Sorry", "right": "Xin lỗi"}]}',
 '{"correct_pairs": [[0,0],[1,1],[2,2],[3,3]]}', '{"hint": "Nối từ tiếng Anh với nghĩa"}', 1),
(40, 5, 'MULTIPLE_CHOICE',
 '{"question": "Khi gặp ai đó lúc sáng, bạn nói gì?", "options": ["Good morning", "Good evening", "Good night", "Goodbye"]}',
 '{"correct": 0, "explanation": "Good morning = Chào buổi sáng"}', '{"hint": "morning = buổi sáng"}', 1);

-- ========================
-- 19. SECTIONS & UNITS for HSK 1
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(30, 7, 1, 'Chào hỏi cơ bản', 'Học cách chào hỏi bằng tiếng Trung', 'A1'),
(31, 7, 2, 'Gia đình & Bạn bè', 'Nói về gia đình và bạn bè', 'A1'),
(32, 7, 3, 'Mua sắm & Ăn uống', 'Giao tiếp khi mua sắm', 'A1');

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(40, 30, 1, '你好 - Xin chào', 'Chào hỏi cơ bản bằng tiếng Trung', '👋', 50),
(41, 30, 2, '我叫... - Tên tôi là...', 'Tự giới thiệu bản thân', '🙋', 50),
(42, 31, 1, '家人 - Gia đình', 'Nói về gia đình', '👨‍👩‍👧‍👦', 50);

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(50, 40, 1, '你好 - Xin chào', 'NORMAL', 15, 8),
(51, 40, 2, '谢谢 & 对不起', 'NORMAL', 15, 8),
(52, 41, 1, '我叫什么名字？', 'NORMAL', 15, 8),
(53, 42, 1, '爸爸妈妈 - Bố Mẹ', 'NORMAL', 15, 8);

-- Chinese exercises
INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(50, 1, 'MULTIPLE_CHOICE',
 '{"question": "「你好」có nghĩa là gì?", "options": ["Xin chào", "Tạm biệt", "Cảm ơn", "Xin lỗi"]}',
 '{"correct": 0, "explanation": "你好 (nǐ hǎo) = Xin chào"}', '{"hint": "你 = bạn, 好 = tốt"}', 1),
(50, 2, 'FILL_BLANK',
 '{"sentence": "____，你叫什么名字？", "context": "Xin chào, bạn tên gì?"}',
 '{"correct": "你好", "alternatives": ["你好"]}', '{"hint": "nǐ hǎo"}', 1),
(50, 3, 'MATCH_PAIRS',
 '{"pairs": [{"left": "你好", "right": "Xin chào"}, {"left": "谢谢", "right": "Cảm ơn"}, {"left": "再见", "right": "Tạm biệt"}, {"left": "对不起", "right": "Xin lỗi"}]}',
 '{"correct_pairs": [[0,0],[1,1],[2,2],[3,3]]}', '{"hint": "Nối tiếng Trung với nghĩa"}', 1),
(50, 4, 'TRANSLATE_TO_SOURCE',
 '{"sentence": "你好，你叫什么名字？", "from": "zh", "to": "vi"}',
 '{"correct": "Xin chào, bạn tên gì?", "alternatives": ["Xin chào, tên bạn là gì?"]}', '{"hint": "叫 = gọi là, 名字 = tên"}', 2),
(50, 5, 'MULTIPLE_CHOICE',
 '{"question": "Pinyin của 你好 là gì?", "options": ["nǐ hǎo", "nǐ hào", "ní hǎo", "nì háo"]}',
 '{"correct": 0, "explanation": "你好 đọc là nǐ hǎo (thanh 3 + thanh 3)"}', '{"hint": "Cả hai đều thanh 3"}', 2);

-- Enrollment for demo user
INSERT INTO enrollments (user_id, course_id, status, progress_percent) VALUES
(2, 1, 'ACTIVE', 5.00),
(2, 4, 'ACTIVE', 0.00),
(2, 7, 'ACTIVE', 0.00);
