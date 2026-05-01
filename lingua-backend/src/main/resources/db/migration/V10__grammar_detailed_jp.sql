-- =====================================================
-- V10: Grammar chi tiết JAPANESE - explanation, examples, exercises
-- Cập nhật explanation_vi/en, formation, usage_context, common_mistakes
-- cho các pattern N5 quan trọng đã có sẵn (id 1-12, 100-119, 200-213)
-- Sau đó thêm grammar_examples + grammar_exercises
-- =====================================================

-- 1. です (id giả định - cập nhật theo pattern hoặc tạo mới)
-- Để an toàn, ta sẽ UPSERT bằng pattern + jlpt_level
SET @lang_jp = 1;

-- ===== UPDATE chi tiết cho 1 số pattern N5 quan trọng =====
UPDATE grammars
SET explanation_vi = 'です là trợ động từ lịch sự nối với danh từ hoặc tính từ để khẳng định "là ~". Đây là cấu trúc cơ bản nhất của tiếng Nhật, bắt buộc phải biết.\n\n📌 4 dạng cơ bản:\n• Hiện tại khẳng định: です  → わたしはがくせいです (Tôi là học sinh)\n• Hiện tại phủ định: では ありません / じゃ ありません  → わたしはがくせいでは ありません\n• Quá khứ khẳng định: でした  → きのうはあめでした (Hôm qua trời mưa)\n• Quá khứ phủ định: では ありませんでした / じゃ ありませんでした\n\nですthể thân mật là だ, dùng với bạn bè/gia đình.',
    explanation_en = 'です is the polite copula meaning "to be". It links a noun or na-adjective to the subject. Conjugates into 4 forms: present positive (です), present negative (ではありません), past positive (でした), past negative (ではありませんでした).',
    formation = 'N/Na-Adj + です\n→ phủ định: + ではありません (formal) / じゃありません (casual)\n→ quá khứ: でした\n→ quá khứ phủ định: ではありませんでした',
    usage_context = 'Dùng trong văn nói lịch sự (敬体 keitai). Đây là dạng dùng với người mới quen, đồng nghiệp, khách hàng. Trong văn viết hoặc với bạn bè thân, có thể bỏ です hoặc dùng だ.',
    common_mistakes = '❌ Sai: わたしはがくせいだです → ✅ Đúng: わたしはがくせいです\n❌ Sai: い-Adj + です kèm な (たかいなです) → ✅ Đúng: たかいです\n⚠️ Lưu ý: です KHÔNG đi với động từ (gakuemasu, không phải gakuemasudesu)',
    related_patterns = 'だ (thể thường), である (văn viết trang trọng), でございます (cực kì lịch sự)',
    difficulty_score = 1
WHERE language_id = @lang_jp AND pattern LIKE '%です%' AND pattern NOT LIKE '%たい%' AND pattern NOT LIKE '%まし%' AND jlpt_level = 'N5'
LIMIT 1;

UPDATE grammars
SET explanation_vi = 'は (đọc là "wa", không phải "ha") là trợ từ chủ đề (topic marker), đứng sau danh từ để chỉ đó là chủ đề/chủ ngữ của câu. Đây là trợ từ quan trọng nhất tiếng Nhật.\n\n📌 Ví dụ:\n• わたしは ベトナムじんです → Về tôi (chủ đề), tôi là người Việt\n• これは ほんです → Cái này là sách\n\n🔄 Phân biệt với が:\n• は = chủ đề đã biết, thông tin nền\n• が = chủ ngữ mới, nhấn mạnh\n→ きのうケーキを たべました。あのケーキは おいしかったです。\n  (Cái bánh ấy thì ngon - chủ đề đã được nhắc đến)',
    explanation_en = 'は (pronounced "wa") is the topic marker. It marks what the sentence is about. Different from が (subject marker which introduces new information).',
    formation = 'N + は + (predicate)',
    usage_context = 'Dùng để giới thiệu chủ đề câu, so sánh, nhấn mạnh thông tin đã biết. Thường ở đầu câu.',
    common_mistakes = '❌ Đọc là "ha" → ✅ Đọc là "wa"\n❌ Dùng は cho chủ ngữ mới chưa biết → ✅ Dùng が cho thông tin mới\n❌ Bỏ は trong câu lịch sự ngắn → ✅ Vẫn cần は với người lạ',
    related_patterns = 'が (chủ ngữ), も (cũng), を (tân ngữ)',
    difficulty_score = 2
WHERE language_id = @lang_jp AND pattern LIKE '%は%' AND pattern NOT LIKE '%ありません%' AND jlpt_level = 'N5'
LIMIT 1;

UPDATE grammars
SET explanation_vi = 'Vます là dạng lịch sự của động từ tiếng Nhật, dùng trong văn nói chính thức.\n\n📌 4 dạng chia:\n• Hiện tại khẳng định: Vます (たべます - ăn)\n• Hiện tại phủ định: Vません (たべません - không ăn)\n• Quá khứ khẳng định: Vました (たべました - đã ăn)\n• Quá khứ phủ định: Vませんでした (たべませんでした - đã không ăn)\n\n🔍 Cách chia từ thể từ điển sang Vます:\n• Nhóm 1 (う-verb): bỏ う → đổi sang い + ます (のむ → のみます)\n• Nhóm 2 (る-verb): bỏ る + ます (たべる → たべます)\n• Nhóm 3 (bất quy tắc): する→します, くる→きます',
    explanation_en = 'The masu-form is the polite form of verbs, used in formal speech. There are 4 conjugations: ~ます (positive), ~ません (negative), ~ました (past), ~ませんでした (past negative).',
    formation = 'Group 1: う-row → い-row + ます\nGroup 2: bỏ る + ます\nGroup 3: する→します, くる→きます',
    usage_context = 'Dùng khi nói chuyện với người mới quen, đồng nghiệp, khách hàng, người lớn tuổi. Cũng dùng trong các thông báo chính thức.',
    common_mistakes = '❌ Chia sai nhóm động từ: たべるます → ✅ たべます\n❌ Quá khứ: たべますでした → ✅ たべました\n❌ Phủ định quá khứ: たべませんした → ✅ たべませんでした',
    related_patterns = 'V thể từ điển (thường), Vて (kết nối), Vない (phủ định thường)',
    difficulty_score = 2
WHERE language_id = @lang_jp AND pattern LIKE '%ます%' AND jlpt_level = 'N5'
ORDER BY id LIMIT 1;

-- ===== Thêm grammar_examples cho các pattern N5 chính =====
-- (Chỉ thêm cho 1 số pattern điển hình, không phải tất cả)

-- Examples cho 〜が好きです (id 100)
INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(100, 'わたしはねこがすきです。', 'わたしはねこがすきです', 'Watashi wa neko ga suki desu.', 'Tôi thích mèo.', 'I like cats.', 'Câu khẳng định cơ bản', 1),
(100, 'なつやすみがすきですか。', 'なつやすみがすきですか', 'Natsuyasumi ga suki desu ka.', 'Bạn có thích kỳ nghỉ hè không?', 'Do you like summer vacation?', 'Câu hỏi - thêm か cuối câu', 2),
(100, 'わたしはコーヒーがあまりすきじゃありません。', 'わたしはコーヒーがあまりすきじゃありません', 'Watashi wa koohii ga amari suki ja arimasen.', 'Tôi không thích cà phê lắm.', 'I don''t really like coffee.', 'Phủ định nhẹ với あまり', 3),
(100, 'はは は おんがくがだいすきです。', 'はは は おんがくが だいすきです', 'Haha wa ongaku ga daisuki desu.', 'Mẹ tôi rất thích âm nhạc.', 'My mother loves music.', 'だいすき = rất thích', 4);

-- Examples cho 〜を + Verb (id 104)
INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(104, 'まいあさパンをたべます。', 'まいあさパンをたべます', 'Maiasa pan o tabemasu.', 'Mỗi sáng tôi ăn bánh mì.', 'I eat bread every morning.', 'を chỉ tân ngữ trực tiếp', 1),
(104, 'にほんごのほんをよんでいます。', 'にほんごのほんをよんでいます', 'Nihongo no hon o yondeimasu.', 'Tôi đang đọc sách tiếng Nhật.', 'I am reading a Japanese book.', 'を + đang ~', 2),
(104, 'てがみをかきました。', 'てがみをかきました', 'Tegami o kakimashita.', 'Tôi đã viết thư.', 'I wrote a letter.', 'を + quá khứ', 3);

-- Examples cho Vたいです (id 111)
INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(111, 'にほんへいきたいです。', 'にほんへ いきたいです', 'Nihon e ikitai desu.', 'Tôi muốn đi Nhật Bản.', 'I want to go to Japan.', 'Mong muốn cá nhân', 1),
(111, 'おいしいラーメンがたべたいです。', 'おいしいラーメンが たべたいです', 'Oishii raamen ga tabetai desu.', 'Tôi muốn ăn ramen ngon.', 'I want to eat delicious ramen.', 'Khi có たい, を thường đổi thành が', 2),
(111, 'なつやすみにうみへいきたかったです。', 'なつやすみに うみへ いきたかったです', 'Natsuyasumi ni umi e ikitakatta desu.', 'Tôi đã muốn đi biển vào kỳ nghỉ hè.', 'I wanted to go to the sea during summer vacation.', 'Quá khứ: たい → たかった', 3);

-- Examples cho 〜と思います (id 200, N4)
INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(200, 'あしたあめがふるとおもいます。', 'あした あめが ふると おもいます', 'Ashita ame ga furu to omoimasu.', 'Tôi nghĩ ngày mai trời sẽ mưa.', 'I think it will rain tomorrow.', 'Dự đoán', 1),
(200, 'たなかさんはやさしいひとだとおもいます。', 'たなかさんは やさしい ひとだと おもいます', 'Tanaka-san wa yasashii hito da to omoimasu.', 'Tôi nghĩ anh Tanaka là người tốt bụng.', 'I think Mr. Tanaka is a kind person.', 'Đánh giá người', 2),
(200, 'にほんごはむずかしいとおもいません。', 'にほんごは むずかしいと おもいません', 'Nihongo wa muzukashii to omoimasen.', 'Tôi không nghĩ tiếng Nhật khó.', 'I don''t think Japanese is difficult.', 'Phủ định ý kiến', 3);

-- Examples cho 〜たことがある (id 203)
INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(203, 'にほんへいったことがあります。', 'にほんへ いったことが あります', 'Nihon e itta koto ga arimasu.', 'Tôi đã từng đi Nhật.', 'I have been to Japan.', 'Kinh nghiệm có rồi', 1),
(203, 'すしをたべたことがありますか。', 'すしを たべたことが ありますか', 'Sushi o tabeta koto ga arimasu ka.', 'Bạn đã từng ăn sushi chưa?', 'Have you ever eaten sushi?', 'Câu hỏi kinh nghiệm', 2),
(203, 'いちども そのえいがをみたことがありません。', 'いちども その えいがを みたことが ありません', 'Ichido mo sono eiga o mita koto ga arimasen.', 'Tôi chưa bao giờ xem bộ phim đó.', 'I have never seen that movie.', 'Phủ định: chưa từng', 3);

-- ===== Grammar exercises - bài tập thực hành =====
INSERT INTO grammar_exercises (grammar_id, type, question_json, answer_json, explanation, difficulty, order_index) VALUES

-- 〜が好きです
(100, 'MULTIPLE_CHOICE',
 '{"question":"Chọn câu đúng để nói: Tôi thích chó (いぬ).","options":["わたしはいぬですすき。","わたしはいぬがすきです。","わたしはいぬをすきです。","わたしはいぬにすきです。"]}',
 '{"correct":1,"alternatives":[]}',
 'Cấu trúc: N + が + すきです (không dùng を hoặc に).', 1, 1),
(100, 'FILL_BLANK',
 '{"question":"Điền trợ từ thích hợp: わたしはおんがく___ すきです。"}',
 '{"correct":"が","alternatives":[]}',
 'Trước すき luôn dùng trợ từ が, không phải を.', 1, 2),

-- 〜を + V
(104, 'MULTIPLE_CHOICE',
 '{"question":"わたしは まいにち ほん___ よみます。","options":["は","が","を","に"]}',
 '{"correct":2,"alternatives":[]}',
 'を chỉ tân ngữ trực tiếp của động từ よむ (đọc).', 1, 1),

-- Vたいです
(111, 'MULTIPLE_CHOICE',
 '{"question":"Chọn câu đúng nghĩa ''Tôi muốn ăn cơm''.","options":["ごはんを たべたいです。","ごはんに たべます。","ごはんが たべます。","ごはんを たべません。"]}',
 '{"correct":0,"alternatives":[]}',
 'Vます stem + たいです: たべます → たべ + たいです.', 1, 1),
(111, 'FILL_BLANK',
 '{"question":"Chia たい ở quá khứ: にほんへ いき___ です。 (đã muốn đi)"}',
 '{"correct":"たかった","alternatives":["たかった です","たかったです"]}',
 'たい hoạt động như tính từ い → quá khứ: たかった.', 2, 2),

-- 〜と思います
(200, 'MULTIPLE_CHOICE',
 '{"question":"Câu nào dùng と思います đúng?","options":["あめがふるますとおもいます。","あめがふるとおもいます。","あめがふるですとおもいます。","あめがふりますとおもいます。"]}',
 '{"correct":1,"alternatives":[]}',
 'Trước と思います dùng dạng thường (plain form): ふる, không phải ふります.', 2, 1),

-- 〜たことがある
(203, 'MULTIPLE_CHOICE',
 '{"question":"Chọn câu đúng nghĩa ''Tôi chưa từng đi Mỹ''.","options":["アメリカへ いきます ことがありません。","アメリカへ いった ことがありません。","アメリカへ いく ことがありません。","アメリカへ いって ことがありません。"]}',
 '{"correct":1,"alternatives":[]}',
 'Cấu trúc: V thể た + ことがある (kinh nghiệm). Phủ định = ことがありません.', 2, 1);

-- Cập nhật difficulty_score cho grammar đã có
UPDATE grammars SET difficulty_score = 1 WHERE language_id = @lang_jp AND jlpt_level = 'N5' AND difficulty_score IS NULL;
UPDATE grammars SET difficulty_score = 2 WHERE language_id = @lang_jp AND jlpt_level = 'N4' AND difficulty_score IS NULL;
UPDATE grammars SET difficulty_score = 3 WHERE language_id = @lang_jp AND jlpt_level = 'N3' AND difficulty_score IS NULL;

-- Bổ sung explanation_vi cho các grammar còn lại có pattern phổ biến (chỉ những cái chưa có)
UPDATE grammars
SET explanation_vi = CONCAT('Mẫu ngữ pháp: ', pattern, '\n\n📌 Ý nghĩa: ', COALESCE(meaning_vi, ''), '\n\n📐 Cấu trúc: ', COALESCE(structure, ''), '\n\n💡 ', COALESCE(note, ''))
WHERE language_id = @lang_jp AND (explanation_vi IS NULL OR explanation_vi = '');
