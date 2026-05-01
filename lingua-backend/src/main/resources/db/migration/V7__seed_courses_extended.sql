-- =====================================================
-- LINGUA PLATFORM - Seed Data V7
-- Sections, Units, Lessons, Exercises for ALL courses
-- Existing seed only had courses 1, 4, 7
-- This file adds courses 2, 3, 5, 6, 8, 9
-- =====================================================

-- ========================
-- COURSE 2: JLPT N4 - Sections (id starting from 100)
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(100, 2, 1, 'Cuộc sống thường ngày', 'Hội thoại trong cuộc sống hàng ngày, công việc, học tập', 'A2'),
(101, 2, 2, 'Du lịch & Mua sắm', 'Giao tiếp khi đi du lịch, mua sắm, tại nhà hàng', 'A2'),
(102, 2, 3, 'Sức khỏe & Cơ thể', 'Nói về sức khỏe, đi khám bệnh, mô tả triệu chứng', 'A2'),
(103, 2, 4, 'Tính cách & Cảm xúc', 'Mô tả tính cách, cảm xúc, ý kiến cá nhân', 'A2'),
(104, 2, 5, 'Văn hóa Nhật Bản', 'Tìm hiểu văn hóa, phong tục Nhật Bản', 'A2'),
(105, 2, 6, 'Ôn tập tổng hợp N4', 'Ôn tập toàn bộ kiến thức N4', 'A2');

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(200, 100, 1, '日常会話', 'Trò chuyện thường ngày', '💬', 60),
(201, 100, 2, '仕事と勉強', 'Công việc và học tập', '💼', 60),
(202, 101, 1, '旅行の計画', 'Lập kế hoạch du lịch', '✈️', 60),
(203, 101, 2, 'レストランで', 'Tại nhà hàng', '🍱', 60),
(204, 102, 1, '体の部分', 'Các bộ phận cơ thể', '🫁', 60),
(205, 102, 2, '病院で', 'Tại bệnh viện', '🏥', 60),
(206, 103, 1, '性格を表す', 'Mô tả tính cách', '😊', 60),
(207, 104, 1, '日本の祭り', 'Lễ hội Nhật Bản', '🎎', 60);

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(300, 200, 1, '初対面の挨拶', 'NORMAL', 18, 8),
(301, 200, 2, '自己紹介の続き', 'NORMAL', 18, 8),
(302, 200, 3, '家族について話す', 'NORMAL', 18, 8),
(303, 201, 1, '会社の話', 'NORMAL', 18, 8),
(304, 201, 2, '勉強について', 'NORMAL', 18, 8),
(305, 202, 1, '旅行の準備', 'NORMAL', 18, 8),
(306, 202, 2, 'ホテルの予約', 'NORMAL', 18, 8),
(307, 203, 1, '注文の仕方', 'NORMAL', 18, 8),
(308, 203, 2, '会計', 'NORMAL', 18, 8),
(309, 204, 1, '体の部分の名前', 'NORMAL', 18, 8),
(310, 205, 1, '症状を伝える', 'NORMAL', 18, 8),
(311, 205, 2, '薬局で', 'CHECKPOINT', 25, 10),
(312, 206, 1, '形容詞で人を表す', 'NORMAL', 18, 8),
(313, 207, 1, '夏祭り', 'NORMAL', 18, 8);

-- N4 Exercises
INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(300, 1, 'MULTIPLE_CHOICE',
 '{"question": "「はじめまして」はどんな時に使いますか。", "options": ["初めて会った時", "別れる時", "感謝する時", "謝る時"]}',
 '{"correct": 0, "explanation": "はじめまして = lần đầu gặp"}', '{"hint": "First meeting"}', 2),
(300, 2, 'FILL_BLANK',
 '{"sentence": "はじめまして。田中と＿＿。よろしくお願いします。", "context": "Tự giới thiệu"}',
 '{"correct": "申します", "alternatives": ["もうします", "言います"]}', '{"hint": "Cách nói lịch sự cho 言う"}', 2),
(300, 3, 'TRANSLATE_TO_TARGET',
 '{"sentence": "Rất hân hạnh được gặp bạn", "from": "vi", "to": "ja"}',
 '{"correct": "お会いできて嬉しいです", "alternatives": ["お会いできてうれしいです"]}', '{"hint": "嬉しい = vui"}', 2),
(303, 1, 'MULTIPLE_CHOICE',
 '{"question": "私は会社で＿＿。", "options": ["働きます", "勉強します", "遊びます", "休みます"]}',
 '{"correct": 0, "explanation": "Công ty → làm việc 働く"}', '{"hint": "work"}', 2),
(309, 1, 'MULTIPLE_CHOICE',
 '{"question": "「目」の意味は？", "options": ["mắt", "mũi", "tai", "miệng"]}',
 '{"correct": 0, "explanation": "目 (め) = mắt"}', '{"hint": "see"}', 1),
(310, 1, 'MULTIPLE_CHOICE',
 '{"question": "「お腹が痛い」の意味は？", "options": ["Đau bụng", "Đau đầu", "Đau lưng", "Đau chân"]}',
 '{"correct": 0, "explanation": "お腹 = bụng, 痛い = đau"}', '{"hint": "stomach"}', 2);

-- ========================
-- COURSE 3: JLPT N3 - Sections
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(110, 3, 1, 'Hội thoại nâng cao', 'Hội thoại trung cấp, biểu đạt cảm xúc tinh tế', 'B1'),
(111, 3, 2, 'Tin tức & Thời sự', 'Đọc hiểu tin tức, thảo luận thời sự', 'B1'),
(112, 3, 3, 'Văn hóa & Xã hội', 'Tìm hiểu sâu về văn hóa và xã hội Nhật Bản', 'B1'),
(113, 3, 4, 'Kinh tế & Việc làm', 'Từ vựng kinh tế, môi trường công sở', 'B1'),
(114, 3, 5, 'Ôn tập tổng hợp N3', 'Ôn tập toàn bộ kiến thức N3', 'B1');

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(220, 110, 1, '感情の表現', 'Diễn đạt cảm xúc tinh tế', '🎭', 70),
(221, 110, 2, '丁寧な日本語', 'Tiếng Nhật trang trọng', '🎩', 70),
(222, 111, 1, 'ニュースを読む', 'Đọc tin tức', '📰', 70),
(223, 113, 1, 'ビジネス日本語', 'Tiếng Nhật thương mại', '💼', 70);

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(320, 220, 1, '微妙な感情を表す', 'NORMAL', 20, 10),
(321, 221, 1, '敬語の基礎', 'NORMAL', 20, 10),
(322, 221, 2, '尊敬語と謙譲語', 'NORMAL', 20, 10),
(323, 222, 1, '見出しの読み方', 'NORMAL', 20, 10),
(324, 223, 1, '会議で使う表現', 'NORMAL', 20, 10);

INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(320, 1, 'MULTIPLE_CHOICE',
 '{"question": "「うれしい」と「楽しい」の違いは？", "options": ["うれしい=cảm xúc bên trong / 楽しい=hoạt động vui", "Giống nhau", "Khác về độ chính tả", "Một là quá khứ"]}',
 '{"correct": 0, "explanation": "うれしい diễn tả cảm xúc, 楽しい diễn tả trải nghiệm vui"}', '{"hint": "cảm xúc vs trải nghiệm"}', 3),
(321, 1, 'MULTIPLE_CHOICE',
 '{"question": "「行く」の尊敬語は？", "options": ["いらっしゃる", "おいでになる", "参る", "拝見する"]}',
 '{"correct": 0, "explanation": "行く・来る・いる の尊敬語 = いらっしゃる"}', '{"hint": "Tôn kính ngữ"}', 3);

-- ========================
-- COURSE 5: English A2 Sections
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(120, 5, 1, 'Past Experiences', 'Talk about past events and experiences', 'A2'),
(121, 5, 2, 'Future Plans', 'Discuss plans, intentions, predictions', 'A2'),
(122, 5, 3, 'Travel & Holidays', 'Talking about travel, booking, asking for directions', 'A2'),
(123, 5, 4, 'Health & Lifestyle', 'Health, food, exercise, daily routines', 'A2'),
(124, 5, 5, 'Shopping & Money', 'Shopping, prices, comparing products', 'A2');

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(230, 120, 1, 'Last weekend', 'Talk about last weekend activities', '📅', 60),
(231, 120, 2, 'Childhood memories', 'Share childhood stories', '👶', 60),
(232, 121, 1, 'Tomorrow plans', 'Talk about plans for tomorrow', '📋', 60),
(233, 122, 1, 'Booking a hotel', 'Reserve accommodation', '🏨', 60),
(234, 123, 1, 'At the doctor', 'Describe symptoms', '🩺', 60);

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(330, 230, 1, 'What did you do?', 'NORMAL', 18, 8),
(331, 230, 2, 'Past simple practice', 'NORMAL', 18, 8),
(332, 231, 1, 'When I was a child', 'NORMAL', 18, 8),
(333, 232, 1, 'Tomorrow I will...', 'NORMAL', 18, 8),
(334, 233, 1, 'I would like to book...', 'NORMAL', 18, 8),
(335, 234, 1, 'I have a headache', 'NORMAL', 18, 8);

INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(330, 1, 'MULTIPLE_CHOICE',
 '{"question": "What is the past form of ''go''?", "options": ["went", "goed", "gone", "going"]}',
 '{"correct": 0, "explanation": "go → went (irregular verb)"}', '{"hint": "Irregular"}', 2),
(330, 2, 'FILL_BLANK',
 '{"sentence": "Yesterday, I ___ to the cinema.", "context": "Past simple"}',
 '{"correct": "went", "alternatives": ["went"]}', '{"hint": "Past of go"}', 2),
(330, 3, 'TRANSLATE_TO_TARGET',
 '{"sentence": "Hôm qua tôi đã đến trường", "from": "vi", "to": "en"}',
 '{"correct": "Yesterday I went to school", "alternatives": ["Yesterday I went to the school"]}', '{"hint": "Past simple"}', 2),
(330, 4, 'MULTIPLE_CHOICE',
 '{"question": "Choose the correct sentence:", "options": ["I saw a movie last night.", "I see a movie last night.", "I seeing a movie last night.", "I am see a movie last night."]}',
 '{"correct": 0, "explanation": "Past simple: saw"}', '{"hint": "Past tense"}', 2),
(333, 1, 'MULTIPLE_CHOICE',
 '{"question": "Which is future tense?", "options": ["I will go", "I went", "I go", "I am going"]}',
 '{"correct": 0, "explanation": "will + V = future"}', '{"hint": "will"}', 1),
(335, 1, 'MULTIPLE_CHOICE',
 '{"question": "Choose: ''I have ___ ____''.", "options": ["a headache", "a hurt", "a sicky", "a feel bad"]}',
 '{"correct": 0, "explanation": "have a headache = đau đầu"}', '{"hint": "head + ache"}', 2);

-- ========================
-- COURSE 6: English B1 Sections
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(130, 6, 1, 'Conditionals', 'First, second, third conditionals', 'B1'),
(131, 6, 2, 'Reported Speech', 'Report what others said', 'B1'),
(132, 6, 3, 'Phrasal Verbs', 'Common English phrasal verbs', 'B1'),
(133, 6, 4, 'Work & Career', 'Job interviews, CVs, business communication', 'B1'),
(134, 6, 5, 'Environment & Society', 'Global issues, environment, technology', 'B1');

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(240, 130, 1, 'If clauses', 'Master conditional sentences', '🔀', 70),
(241, 131, 1, 'He said that...', 'Report direct speech', '🗣️', 70),
(242, 132, 1, 'Look up, look after', 'Common phrasal verbs', '📚', 70),
(243, 133, 1, 'Job interview', 'Prepare for job interviews', '💼', 70);

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(340, 240, 1, 'First conditional', 'NORMAL', 20, 10),
(341, 240, 2, 'Second conditional', 'NORMAL', 20, 10),
(342, 241, 1, 'Reporting statements', 'NORMAL', 20, 10),
(343, 242, 1, 'Phrasal verbs with ''get''', 'NORMAL', 20, 10),
(344, 243, 1, 'Tell me about yourself', 'NORMAL', 20, 10);

INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(340, 1, 'MULTIPLE_CHOICE',
 '{"question": "If it ___ tomorrow, we will cancel the trip.", "options": ["rains", "rained", "will rain", "raining"]}',
 '{"correct": 0, "explanation": "First conditional: If + V (present), will + V"}', '{"hint": "Present simple"}', 3),
(341, 1, 'MULTIPLE_CHOICE',
 '{"question": "If I ___ rich, I would travel the world.", "options": ["were", "was", "am", "be"]}',
 '{"correct": 0, "explanation": "Second conditional: If + were/V2, would + V"}', '{"hint": "Subjunctive"}', 3);

-- ========================
-- COURSE 8: HSK 2 Sections
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(140, 8, 1, '时间和日期', 'Thời gian và ngày tháng', 'A1'),
(141, 8, 2, '工作和学习', 'Công việc và học tập', 'A2'),
(142, 8, 3, '运动和爱好', 'Thể thao và sở thích', 'A2'),
(143, 8, 4, '旅游', 'Du lịch', 'A2'),
(144, 8, 5, '比较和选择', 'So sánh và lựa chọn', 'A2');

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(250, 140, 1, '日期与节日', 'Ngày tháng và lễ hội', '📅', 60),
(251, 141, 1, '工作', 'Công việc', '💼', 60),
(252, 141, 2, '学校生活', 'Cuộc sống học đường', '🏫', 60),
(253, 142, 1, '运动', 'Thể thao', '⚽', 60),
(254, 144, 1, '比较', 'So sánh', '⚖️', 60);

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(350, 250, 1, '今天几号？', 'NORMAL', 18, 8),
(351, 250, 2, '春节快乐！', 'NORMAL', 18, 8),
(352, 251, 1, '我的工作', 'NORMAL', 18, 8),
(353, 253, 1, '我喜欢踢足球', 'NORMAL', 18, 8),
(354, 254, 1, '谁更高？', 'NORMAL', 18, 8);

INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(350, 1, 'MULTIPLE_CHOICE',
 '{"question": "「今天几号？」 means?", "options": ["Hôm nay ngày mấy?", "Hôm nay thứ mấy?", "Bây giờ mấy giờ?", "Năm nay là năm mấy?"]}',
 '{"correct": 0, "explanation": "几号 = ngày bao nhiêu"}', '{"hint": "号 = ngày"}', 2),
(354, 1, 'MULTIPLE_CHOICE',
 '{"question": "「我比你高」 means?", "options": ["Tôi cao hơn bạn", "Bạn cao hơn tôi", "Chúng ta cao bằng nhau", "Tôi không cao"]}',
 '{"correct": 0, "explanation": "A 比 B + Adj = A hơn B"}', '{"hint": "比 = so sánh"}', 2),
(354, 2, 'FILL_BLANK',
 '{"sentence": "他___我大三岁。", "context": "So sánh tuổi"}',
 '{"correct": "比", "alternatives": ["比"]}', '{"hint": "comparison"}', 2);

-- ========================
-- COURSE 9: HSK 3 Sections
-- ========================
INSERT INTO sections (id, course_id, order_index, title, description, cefr_mapping) VALUES
(150, 9, 1, '日常生活', 'Cuộc sống hàng ngày', 'A2'),
(151, 9, 2, '中国文化', 'Văn hóa Trung Quốc', 'B1'),
(152, 9, 3, '旅行经历', 'Kinh nghiệm du lịch', 'B1'),
(153, 9, 4, '感情表达', 'Diễn tả cảm xúc', 'B1'),
(154, 9, 5, '复杂语法', 'Ngữ pháp phức tạp', 'B1');

INSERT INTO units (id, section_id, order_index, title, communication_goal, icon, xp_reward) VALUES
(260, 150, 1, '健康生活', 'Cuộc sống lành mạnh', '🏃', 70),
(261, 151, 1, '中国节日', 'Lễ hội Trung Quốc', '🏮', 70),
(262, 152, 1, '我的旅行', 'Chuyến đi của tôi', '🧳', 70),
(263, 154, 1, '虽然...但是', 'Câu nhượng bộ', '🔀', 70);

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(360, 260, 1, '锻炼身体', 'NORMAL', 20, 10),
(361, 261, 1, '春节', 'NORMAL', 20, 10),
(362, 261, 2, '中秋节', 'NORMAL', 20, 10),
(363, 262, 1, '我去过北京', 'NORMAL', 20, 10),
(364, 263, 1, '虽然累，但是开心', 'NORMAL', 20, 10);

INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(363, 1, 'MULTIPLE_CHOICE',
 '{"question": "「我去过北京」中「过」表示？", "options": ["Đã từng", "Đang", "Sẽ", "Phải"]}',
 '{"correct": 0, "explanation": "过 = đã từng (kinh nghiệm)"}', '{"hint": "experience"}', 3),
(364, 1, 'MULTIPLE_CHOICE',
 '{"question": "「虽然...但是...」 means?", "options": ["Mặc dù... nhưng...", "Nếu... thì...", "Vì... nên...", "Khi... thì..."]}',
 '{"correct": 0, "explanation": "虽然...但是 = mặc dù...nhưng"}', '{"hint": "concession"}', 3);

-- ========================
-- ENROLLMENTS for demo user (extend)
-- ========================
INSERT INTO enrollments (user_id, course_id, status, progress_percent) VALUES
(2, 2, 'ACTIVE', 0.00),
(2, 5, 'ACTIVE', 0.00),
(2, 8, 'ACTIVE', 0.00);

-- ========================
-- Additional sections/units/lessons for COURSE 1 (JLPT N5)
-- to make existing course richer
-- ========================
-- Existing course 1 already has sections 1-8 with units 1-26 and lessons up to ~30
-- Let's add a few more lessons to existing units

INSERT INTO lessons (id, unit_id, order_index, title, type, xp_reward, exercise_count) VALUES
(80, 1, 5, 'Tự giới thiệu nâng cao', 'NORMAL', 20, 10),
(81, 1, 6, 'Câu chào hằng ngày', 'NORMAL', 20, 10),
(82, 1, 7, 'Nói chuyện qua điện thoại', 'CHECKPOINT', 25, 12);

INSERT INTO exercises (lesson_id, order_index, type, prompt_json, answer_json, hint_json, difficulty) VALUES
(80, 1, 'MULTIPLE_CHOICE',
 '{"question": "「ご出身はどちらですか」と聞かれたら？", "options": ["ベトナムから来ました", "私は学生です", "今日は暑いです", "ありがとう"]}',
 '{"correct": 0, "explanation": "Hỏi quê quán → trả lời từ đâu đến"}', '{"hint": "出身 = quê quán"}', 2),
(80, 2, 'FILL_BLANK',
 '{"sentence": "私は28歳＿＿。", "context": "Nói tuổi"}',
 '{"correct": "です", "alternatives": ["です"]}', '{"hint": "polite form"}', 1),
(81, 1, 'MULTIPLE_CHOICE',
 '{"question": "Khi gặp ai đó vào buổi tối, bạn nói gì?", "options": ["こんばんは", "おはようございます", "こんにちは", "おやすみなさい"]}',
 '{"correct": 0, "explanation": "こんばんは = chào buổi tối"}', '{"hint": "tối"}', 1),
(82, 1, 'MULTIPLE_CHOICE',
 '{"question": "Bắt đầu cuộc gọi điện thoại bằng tiếng Nhật:", "options": ["もしもし", "おはよう", "さようなら", "おやすみ"]}',
 '{"correct": 0, "explanation": "もしもし = alo"}', '{"hint": "phone call"}', 1);
