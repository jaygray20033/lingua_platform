-- =====================================================
-- LINGUA PLATFORM - Seed Data V6
-- Mock Tests with full questions
-- Includes: JLPT N5 (extended), JLPT N4, HSK 1, HSK 2, CEFR A1, CEFR A2
-- =====================================================

-- ========================
-- ADDITIONAL MOCK TESTS
-- (Existing: 1=JLPT N5, others)
-- ========================
INSERT INTO mock_tests (id, certification, level_code, title, total_duration_min, pass_score, section_config_json) VALUES
(10, 'JLPT', 'N4', 'JLPT N4 - Đề thi thử số 1', 105, 90,
 '{"sections": [{"name": "VOCAB", "title": "語彙 Từ vựng", "duration_min": 25, "question_count": 8}, {"name": "GRAMMAR", "title": "文法 Ngữ pháp", "duration_min": 30, "question_count": 8}, {"name": "READING", "title": "読解 Đọc hiểu", "duration_min": 30, "question_count": 5}, {"name": "LISTENING", "title": "聴解 Nghe hiểu", "duration_min": 35, "question_count": 5}]}'),
(11, 'HSK', 'HSK1', 'HSK 1 - Đề thi thử số 1', 40, 120,
 '{"sections": [{"name": "LISTENING", "title": "听力 Nghe", "duration_min": 15, "question_count": 6}, {"name": "READING", "title": "阅读 Đọc", "duration_min": 17, "question_count": 8}, {"name": "WRITING", "title": "书写 Viết", "duration_min": 8, "question_count": 4}]}'),
(12, 'HSK', 'HSK2', 'HSK 2 - Đề thi thử số 1', 55, 120,
 '{"sections": [{"name": "LISTENING", "title": "听力 Nghe", "duration_min": 25, "question_count": 6}, {"name": "READING", "title": "阅读 Đọc", "duration_min": 20, "question_count": 8}, {"name": "WRITING", "title": "书写 Viết", "duration_min": 10, "question_count": 4}]}'),
(13, 'CEFR', 'A1', 'CEFR A1 - English Practice Test', 60, 60,
 '{"sections": [{"name": "VOCABULARY", "title": "Vocabulary Từ vựng", "duration_min": 15, "question_count": 8}, {"name": "GRAMMAR", "title": "Grammar Ngữ pháp", "duration_min": 15, "question_count": 8}, {"name": "READING", "title": "Reading Đọc hiểu", "duration_min": 20, "question_count": 5}, {"name": "LISTENING", "title": "Listening Nghe hiểu", "duration_min": 10, "question_count": 4}]}'),
(14, 'CEFR', 'A2', 'CEFR A2 - English Practice Test', 75, 65,
 '{"sections": [{"name": "VOCABULARY", "title": "Vocabulary", "duration_min": 20, "question_count": 8}, {"name": "GRAMMAR", "title": "Grammar", "duration_min": 20, "question_count": 8}, {"name": "READING", "title": "Reading", "duration_min": 25, "question_count": 5}, {"name": "LISTENING", "title": "Listening", "duration_min": 10, "question_count": 4}]}');

-- ========================
-- ADDITIONAL JLPT N5 QUESTIONS (mock_test_id = 1)
-- Add more questions to existing N5 test
-- ========================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
-- More VOCAB (continuing from existing 8)
(1, 'VOCAB', '{"question": "「いま、なんじですか。」「＿＿です。」", "options": ["10じ", "10にち", "10つき", "10ねん"]}', '{"correct": 0, "explanation": "なんじ = mấy giờ → 〜じ"}', 1, 9),
(1, 'VOCAB', '{"question": "「あめ」のはんたいは？", "options": ["はれ", "ゆき", "くもり", "かぜ"]}', '{"correct": 0, "explanation": "あめ (mưa) ↔ はれ (nắng)"}', 2, 10),
(1, 'VOCAB', '{"question": "「いぬ」の漢字は？", "options": ["犬", "猫", "鳥", "魚"]}', '{"correct": 0, "explanation": "犬 = いぬ (chó)"}', 1, 11),
(1, 'VOCAB', '{"question": "「ちいさい」の反対語は？", "options": ["おおきい", "ながい", "たかい", "あつい"]}', '{"correct": 0, "explanation": "ちいさい (nhỏ) ↔ おおきい (to)"}', 1, 12),
(1, 'VOCAB', '{"question": "Bạn của tôi là người ___.", "options": ["かわいい", "かわい", "かわよい", "かわよう"]}', '{"correct": 0, "explanation": "かわいい = dễ thương (adj-i)"}', 1, 13),
(1, 'VOCAB', '{"question": "「ほん」を＿＿ます。", "options": ["よみ", "たべ", "のみ", "あるき"]}', '{"correct": 0, "explanation": "本 (sách) → 読む (đọc)"}', 1, 14),
(1, 'VOCAB', '{"question": "「あした」はどういう意味？", "options": ["Ngày mai", "Hôm qua", "Hôm nay", "Tuần sau"]}', '{"correct": 0, "explanation": "あした = ngày mai"}', 1, 15),
-- More GRAMMAR
(1, 'GRAMMAR', '{"question": "わたし＿＿日本人です。", "options": ["は", "が", "を", "に"]}', '{"correct": 0, "explanation": "は - trợ từ chủ đề"}', 1, 9),
(1, 'GRAMMAR', '{"question": "あした＿＿いきます。", "options": ["デパートに", "デパートを", "デパートで", "デパートが"]}', '{"correct": 0, "explanation": "に chỉ đích đến"}', 1, 10),
(1, 'GRAMMAR', '{"question": "うちで＿＿。", "options": ["ねます", "ねる", "ねて", "ねろ"]}', '{"correct": 0, "explanation": "Dạng masu lịch sự"}', 1, 11),
(1, 'GRAMMAR', '{"question": "りんご＿＿バナナを買います。", "options": ["と", "に", "で", "を"]}', '{"correct": 0, "explanation": "と = và (liệt kê)"}', 1, 12),
(1, 'GRAMMAR', '{"question": "これは＿＿ですか。", "options": ["なん", "だれ", "どこ", "いつ"]}', '{"correct": 0, "explanation": "Hỏi về vật → なん"}', 1, 13),
(1, 'GRAMMAR', '{"question": "ねこ＿＿いません。", "options": ["は", "を", "に", "が"]}', '{"correct": 0, "explanation": "Mèo → động vật → が います/いません"}', 2, 14),
(1, 'GRAMMAR', '{"question": "わたしのうちは＿＿。", "options": ["ひろくないです", "ひろいくないです", "ひろじゃないです", "ひろいではないです"]}', '{"correct": 0, "explanation": "Phủ định adj-い: ひろい → ひろくない"}', 2, 15),
-- More READING
(1, 'READING', '{"passage": "わたしのなまえはやまだです。にほんからきました。いま、ベトナムにすんでいます。まいにちベトナムごをべんきょうします。", "question": "やまださんはどこのくににすんでいますか。", "options": ["ベトナム", "にほん", "アメリカ", "かんこく"]}', '{"correct": 0, "explanation": "いま、ベトナムにすんでいます = Hiện tại sống ở Việt Nam"}', 1, 3),
(1, 'READING', '{"passage": "あした、ともだちとデパートにいきます。プレゼントをかいます。たんじょうびのプレゼントです。", "question": "なぜデパートにいきますか。", "options": ["プレゼントを買うため", "ともだちにあうため", "おかねをはらうため", "やすみのため"]}', '{"correct": 0, "explanation": "プレゼントをかいます = mua quà"}', 2, 4),
(1, 'READING', '{"passage": "きょうはきんようびです。あしたはやすみです。あさっては日曜日です。", "question": "きょうはなんようびですか。", "options": ["きんようび", "どようび", "にちようび", "げつようび"]}', '{"correct": 0, "explanation": "きょうはきんようびです = Hôm nay thứ sáu"}', 1, 5),
-- More LISTENING
(1, 'LISTENING', '{"audio_text": "ABC: あした 9じに えきで あいましょう。BCD: はい、いいですよ。", "question": "ふたりは いつ あいますか。", "options": ["あした 9じ", "あした 8じ", "きょう 9じ", "きょう 8じ"]}', '{"correct": 0, "explanation": "あした 9じに あいましょう"}', 1, 3),
(1, 'LISTENING', '{"audio_text": "ABC: にちようびに なにを しますか。BCD: えいがを みます。それから、レストランで ばんごはんを たべます。", "question": "BCDさんは にちようびに なにを しますか。", "options": ["えいがをみる、ばんごはんをたべる", "がっこうにいく", "はたらく", "ねる"]}', '{"correct": 0, "explanation": "Xem phim và ăn tối"}', 2, 4);

-- ========================
-- JLPT N4 Mock Test Questions (mock_test_id = 2)
-- ========================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
-- VOCAB
(10, 'VOCAB', '{"question": "「会議」の読み方は？", "options": ["かいぎ", "かいき", "あいぎ", "あいき"]}', '{"correct": 0, "explanation": "会議 = かいぎ (cuộc họp)"}', 2, 1),
(10, 'VOCAB', '{"question": "「便利」の意味は？", "options": ["Tiện lợi", "Bất tiện", "Đắt tiền", "Rẻ"]}', '{"correct": 0, "explanation": "便利 (べんり) = tiện lợi"}', 2, 2),
(10, 'VOCAB', '{"question": "「道」の読み方は？", "options": ["みち", "どう", "とう", "みつ"]}', '{"correct": 0, "explanation": "道 訓: みち (kun-yomi)"}', 2, 3),
(10, 'VOCAB', '{"question": "「強い」の反対は？", "options": ["弱い", "高い", "短い", "古い"]}', '{"correct": 0, "explanation": "強い (mạnh) ↔ 弱い (yếu)"}', 2, 4),
(10, 'VOCAB', '{"question": "「考える」の読み方は？", "options": ["かんがえる", "おぼえる", "つたえる", "かなえる"]}', '{"correct": 0, "explanation": "考える = かんがえる (suy nghĩ)"}', 2, 5),
(10, 'VOCAB', '{"question": "「お茶を＿＿。」", "options": ["いれます", "つくります", "あけます", "やきます"]}', '{"correct": 0, "explanation": "お茶を入れる = pha trà"}', 2, 6),
(10, 'VOCAB', '{"question": "「美しい」の読み方は？", "options": ["うつくしい", "やさしい", "きびしい", "おとなしい"]}', '{"correct": 0, "explanation": "美しい = うつくしい (đẹp)"}', 2, 7),
(10, 'VOCAB', '{"question": "「働く」の意味は？", "options": ["Làm việc", "Học tập", "Nghỉ ngơi", "Chơi"]}', '{"correct": 0, "explanation": "働く (はたらく) = làm việc"}', 1, 8),
-- GRAMMAR
(10, 'GRAMMAR', '{"question": "あした雨が＿＿と思います。", "options": ["ふる", "ふります", "ふって", "ふっている"]}', '{"correct": 0, "explanation": "と思います → form thường"}', 2, 1),
(10, 'GRAMMAR', '{"question": "日本へ＿＿ことがあります。", "options": ["行った", "行く", "行って", "行きます"]}', '{"correct": 0, "explanation": "Vた + ことがある = đã từng"}', 2, 2),
(10, 'GRAMMAR', '{"question": "音楽を聞き＿＿勉強します。", "options": ["ながら", "ところ", "とき", "ように"]}', '{"correct": 0, "explanation": "Vます + ながら = vừa...vừa"}', 2, 3),
(10, 'GRAMMAR', '{"question": "宿題を＿＿なければなりません。", "options": ["し", "して", "した", "する"]}', '{"correct": 0, "explanation": "なければなりません → V-ない form"}', 3, 4),
(10, 'GRAMMAR', '{"question": "ここでたばこを＿＿はいけません。", "options": ["すって", "すう", "すい", "すった"]}', '{"correct": 0, "explanation": "Vて + はいけません = không được"}', 2, 5),
(10, 'GRAMMAR', '{"question": "明日東京に行く＿＿です。", "options": ["つもり", "ところ", "とき", "ばかり"]}', '{"correct": 0, "explanation": "つもり = dự định"}', 2, 6),
(10, 'GRAMMAR', '{"question": "安けれ＿＿買います。", "options": ["ば", "たら", "なら", "と"]}', '{"correct": 0, "explanation": "Adj-い → kereba (điều kiện)"}', 3, 7),
(10, 'GRAMMAR', '{"question": "日本語が話せる＿＿になりました。", "options": ["よう", "とき", "ところ", "ばかり"]}', '{"correct": 0, "explanation": "ようになる = trở nên có thể"}', 3, 8),
-- READING
(10, 'READING', '{"passage": "私は毎朝6時に起きます。朝ごはんを食べてから、会社に行きます。会社まで電車で30分かかります。仕事は9時から始まります。", "question": "この人は何時に起きますか。", "options": ["6時", "7時", "8時", "9時"]}', '{"correct": 0, "explanation": "毎朝6時に起きます"}', 2, 1),
(10, 'READING', '{"passage": "去年の夏、家族で沖縄に旅行しました。沖縄の海はとてもきれいでした。毎日泳いだり、おいしい料理を食べたりしました。来年も行きたいです。", "question": "この人は去年どこに旅行しましたか。", "options": ["沖縄", "東京", "北海道", "京都"]}', '{"correct": 0, "explanation": "去年の夏、家族で沖縄に旅行しました"}', 2, 2),
(10, 'READING', '{"passage": "山田さんはとても忙しい人です。月曜日から金曜日まで会社で働きます。土曜日にスポーツをします。日曜日は家で休みます。", "question": "山田さんは日曜日に何をしますか。", "options": ["家で休みます", "会社で働きます", "スポーツをします", "旅行に行きます"]}', '{"correct": 0, "explanation": "日曜日は家で休みます"}', 2, 3),
(10, 'READING', '{"passage": "私の趣味は料理です。週末によく新しい料理を作ります。先週は中華料理を作りました。難しかったですが、おいしかったです。", "question": "先週何を作りましたか。", "options": ["中華料理", "日本料理", "イタリア料理", "韓国料理"]}', '{"correct": 0, "explanation": "先週は中華料理を作りました"}', 2, 4),
(10, 'READING', '{"passage": "新しい携帯電話を買いました。とても便利です。写真を撮ったり、音楽を聞いたりできます。", "question": "新しい携帯電話で何ができますか。", "options": ["写真を撮ること、音楽を聞くこと", "電話だけ", "メールだけ", "ゲームだけ"]}', '{"correct": 0, "explanation": "写真を撮ったり、音楽を聞いたり"}', 2, 5),
-- LISTENING
(10, 'LISTENING', '{"audio_text": "明日の天気予報です。東京は朝から雨で、午後は雪に変わります。気温は5度で寒いです。", "question": "明日の東京の天気は？", "options": ["朝は雨、午後は雪", "一日中晴れ", "一日中雨", "朝は雪、午後は晴れ"]}', '{"correct": 0, "explanation": "朝から雨で、午後は雪に変わります"}', 2, 1),
(10, 'LISTENING', '{"audio_text": "A: 田中さん、来週一緒に映画に行きませんか。B: いいですね。何曜日がいいですか。A: 土曜日はどうですか。B: 土曜日はちょっと... 日曜日がいいです。", "question": "二人はいつ映画に行きますか。", "options": ["日曜日", "土曜日", "金曜日", "木曜日"]}', '{"correct": 0, "explanation": "B prefers 日曜日"}', 3, 2),
(10, 'LISTENING', '{"audio_text": "店員: いらっしゃいませ。お客様: このシャツを試着してもいいですか。店員: はい、どうぞ。あちらの試着室をご利用ください。", "question": "お客様は何をしたいですか。", "options": ["シャツを試着する", "シャツを買う", "店を出る", "別の商品を見る"]}', '{"correct": 0, "explanation": "試着 = thử đồ"}', 3, 3),
(10, 'LISTENING', '{"audio_text": "A: もしもし、田中さんですか。B: はい、そうです。A: 私、山田です。明日のパーティーに行けません。すみません。", "question": "山田さんは何を伝えていますか。", "options": ["明日のパーティーに行けないこと", "今日のパーティーに行くこと", "パーティーが中止になったこと", "新しい予定があること"]}', '{"correct": 0, "explanation": "明日のパーティーに行けません = không thể đi"}', 2, 4),
(10, 'LISTENING', '{"audio_text": "受付: お名前は？お客様: 鈴木と言います。受付: 鈴木様ですね。少々お待ちください。", "question": "お客様の名前は？", "options": ["鈴木", "田中", "山田", "佐藤"]}', '{"correct": 0, "explanation": "鈴木と言います"}', 1, 5);

-- ========================
-- HSK 1 Mock Test Questions (mock_test_id = 3)
-- ========================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
-- LISTENING
(11, 'LISTENING', '{"audio_text": "你好！", "question": "听到的是什么意思？", "options": ["Xin chào", "Cảm ơn", "Tạm biệt", "Xin lỗi"]}', '{"correct": 0, "explanation": "你好 (nǐ hǎo) = Xin chào"}', 1, 1),
(11, 'LISTENING', '{"audio_text": "我喜欢吃苹果。", "question": "他喜欢吃什么？", "options": ["苹果", "香蕉", "西瓜", "葡萄"]}', '{"correct": 0, "explanation": "苹果 = quả táo"}', 1, 2),
(11, 'LISTENING', '{"audio_text": "现在是几点？现在是八点。", "question": "现在几点？", "options": ["八点", "九点", "十点", "七点"]}', '{"correct": 0, "explanation": "八点 (8 giờ)"}', 1, 3),
(11, 'LISTENING', '{"audio_text": "我有一个哥哥。", "question": "他有什么？", "options": ["哥哥", "弟弟", "姐姐", "妹妹"]}', '{"correct": 0, "explanation": "哥哥 = anh trai"}', 1, 4),
(11, 'LISTENING', '{"audio_text": "今天天气很好。", "question": "今天天气怎么样？", "options": ["很好", "不好", "下雨", "刮风"]}', '{"correct": 0, "explanation": "天气很好 = thời tiết đẹp"}', 1, 5),
(11, 'LISTENING', '{"audio_text": "我是中国人。", "question": "他是什么国人？", "options": ["中国人", "日本人", "美国人", "韩国人"]}', '{"correct": 0, "explanation": "中国人 (người Trung Quốc)"}', 1, 6),
-- READING
(11, 'READING', '{"question": "「我」的意思是什么？", "options": ["Tôi", "Bạn", "Anh ấy", "Cô ấy"]}', '{"correct": 0, "explanation": "我 (wǒ) = tôi"}', 1, 1),
(11, 'READING', '{"question": "「谢谢」的意思是？", "options": ["Cảm ơn", "Xin lỗi", "Xin chào", "Tạm biệt"]}', '{"correct": 0, "explanation": "谢谢 (xiè xie) = cảm ơn"}', 1, 2),
(11, 'READING', '{"question": "下面哪个词是数字？", "options": ["七", "山", "水", "火"]}', '{"correct": 0, "explanation": "七 (qī) = bảy"}', 1, 3),
(11, 'READING', '{"question": "「学生」的意思是？", "options": ["Học sinh", "Giáo viên", "Bác sĩ", "Công nhân"]}', '{"correct": 0, "explanation": "学生 (xué shēng) = học sinh"}', 1, 4),
(11, 'READING', '{"question": "「我喜欢吃米饭」中「米饭」是？", "options": ["Cơm", "Phở", "Mì", "Bún"]}', '{"correct": 0, "explanation": "米饭 (mǐ fàn) = cơm"}', 2, 5),
(11, 'READING', '{"passage": "我叫王明。我是中国人。我有一个姐姐。她是医生。", "question": "王明的姐姐做什么工作？", "options": ["医生", "老师", "学生", "工人"]}', '{"correct": 0, "explanation": "她是医生 = Cô ấy là bác sĩ"}', 2, 6),
(11, 'READING', '{"question": "「再见」用在什么时候？", "options": ["Khi tạm biệt", "Khi gặp gỡ", "Khi cảm ơn", "Khi xin lỗi"]}', '{"correct": 0, "explanation": "再见 (zài jiàn) = tạm biệt"}', 1, 7),
(11, 'READING', '{"question": "「你叫什么名字？」回答应该是？", "options": ["我叫小明", "我很好", "再见", "谢谢"]}', '{"correct": 0, "explanation": "Hỏi tên → trả lời tên"}', 1, 8),
-- WRITING
(11, 'WRITING', '{"question": "选出正确的写法：「nǐ hǎo」", "options": ["你好", "你坏", "妳好", "你號"]}', '{"correct": 0, "explanation": "你好 = nǐ hǎo"}', 1, 1),
(11, 'WRITING', '{"question": "选出正确的写法：「xiè xie」", "options": ["谢谢", "谢射", "射谢", "谢谢"]}', '{"correct": 0, "explanation": "谢谢 = xiè xie"}', 1, 2),
(11, 'WRITING', '{"question": "「我＿＿八岁。」填什么？", "options": ["是", "在", "有", "去"]}', '{"correct": 0, "explanation": "我是八岁 = Tôi 8 tuổi"}', 1, 3),
(11, 'WRITING', '{"question": "「他不＿＿苹果。」", "options": ["吃", "喝", "看", "听"]}', '{"correct": 0, "explanation": "Apple → eat (吃)"}', 1, 4);

-- ========================
-- HSK 2 Mock Test Questions (mock_test_id = 4)
-- ========================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
-- LISTENING
(12, 'LISTENING', '{"audio_text": "我每天早上六点起床。", "question": "他几点起床？", "options": ["六点", "七点", "八点", "九点"]}', '{"correct": 0, "explanation": "六点 = 6 giờ"}', 2, 1),
(12, 'LISTENING', '{"audio_text": "今天是星期三。", "question": "今天是星期几？", "options": ["星期三", "星期一", "星期二", "星期四"]}', '{"correct": 0, "explanation": "星期三 = thứ tư"}', 1, 2),
(12, 'LISTENING', '{"audio_text": "A: 你最喜欢什么颜色？B: 我喜欢蓝色。", "question": "B喜欢什么颜色？", "options": ["蓝色", "红色", "绿色", "白色"]}', '{"correct": 0, "explanation": "蓝色 = màu xanh"}', 2, 3),
(12, 'LISTENING', '{"audio_text": "我去年去了北京。", "question": "他去年去了哪里？", "options": ["北京", "上海", "广州", "深圳"]}', '{"correct": 0, "explanation": "北京 = Bắc Kinh"}', 2, 4),
(12, 'LISTENING', '{"audio_text": "妈妈正在做饭。", "question": "妈妈在做什么？", "options": ["做饭", "看书", "睡觉", "洗衣服"]}', '{"correct": 0, "explanation": "做饭 = nấu cơm"}', 2, 5),
(12, 'LISTENING', '{"audio_text": "明天我们去公园玩。", "question": "明天去哪里？", "options": ["公园", "学校", "医院", "商店"]}', '{"correct": 0, "explanation": "公园 = công viên"}', 2, 6),
-- READING
(12, 'READING', '{"question": "「比」用在什么句型？", "options": ["比较句", "疑问句", "否定句", "感叹句"]}', '{"correct": 0, "explanation": "比 = so sánh"}', 2, 1),
(12, 'READING', '{"question": "「我比你高」中「高」的意思？", "options": ["Cao", "To", "Đẹp", "Tốt"]}', '{"correct": 0, "explanation": "高 (gāo) = cao"}', 2, 2),
(12, 'READING', '{"passage": "小李每天早上跑步。他喜欢运动。他还喜欢游泳和打篮球。", "question": "小李喜欢什么？", "options": ["跑步、游泳、打篮球", "看书", "唱歌", "做饭"]}', '{"correct": 0, "explanation": "Tổng hợp các sở thích vận động"}', 2, 3),
(12, 'READING', '{"question": "「请坐」是什么意思？", "options": ["Mời ngồi", "Mời đứng", "Mời ăn", "Mời uống"]}', '{"correct": 0, "explanation": "请坐 = mời ngồi"}', 1, 4),
(12, 'READING', '{"question": "「我吃过北京烤鸭」中「过」表示？", "options": ["Đã từng", "Đang", "Sẽ", "Phải"]}', '{"correct": 0, "explanation": "过 = đã từng (kinh nghiệm)"}', 3, 5),
(12, 'READING', '{"passage": "王老师非常忙。她从星期一到星期五都在学校教书。", "question": "王老师什么时候在学校？", "options": ["星期一到星期五", "周末", "每天", "假期"]}', '{"correct": 0, "explanation": "从星期一到星期五"}', 2, 6),
(12, 'READING', '{"question": "「太贵了」表示什么？", "options": ["Quá đắt", "Quá rẻ", "Quá nhỏ", "Quá to"]}', '{"correct": 0, "explanation": "太贵了 = quá đắt"}', 2, 7),
(12, 'READING', '{"question": "「告诉」的意思是？", "options": ["Nói cho biết", "Hỏi", "Trả lời", "Im lặng"]}', '{"correct": 0, "explanation": "告诉 (gào sù) = nói cho biết"}', 2, 8),
-- WRITING
(12, 'WRITING', '{"question": "「我_____你高」(So sánh)", "options": ["比", "和", "也", "都"]}', '{"correct": 0, "explanation": "比 = so sánh hơn"}', 2, 1),
(12, 'WRITING', '{"question": "「你_____吃过中国菜？」", "options": ["有没有", "什么", "在", "吗"]}', '{"correct": 0, "explanation": "有没有 + V过 = đã từng chưa"}', 3, 2),
(12, 'WRITING', '{"question": "选出正确的: 「fáng jiān」", "options": ["房间", "饭间", "方间", "放间"]}', '{"correct": 0, "explanation": "房间 = phòng"}', 2, 3),
(12, 'WRITING', '{"question": "「他正_____看电视。」", "options": ["在", "了", "过", "着"]}', '{"correct": 0, "explanation": "正在 = đang (tiến hành)"}', 2, 4);

-- ========================
-- CEFR A1 English Mock Test (mock_test_id = 5)
-- ========================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
-- VOCABULARY
(13, 'VOCAB', '{"question": "What is the opposite of ''hot''?", "options": ["cold", "warm", "hot", "cool"]}', '{"correct": 0, "explanation": "hot ↔ cold"}', 1, 1),
(13, 'VOCAB', '{"question": "Which is a color?", "options": ["red", "table", "happy", "run"]}', '{"correct": 0, "explanation": "red is a color"}', 1, 2),
(13, 'VOCAB', '{"question": "''My ___ is John'' - fill in the blank.", "options": ["name", "age", "country", "home"]}', '{"correct": 0, "explanation": "My name is..."}', 1, 3),
(13, 'VOCAB', '{"question": "Which is a family member?", "options": ["mother", "school", "book", "car"]}', '{"correct": 0, "explanation": "mother = mẹ"}', 1, 4),
(13, 'VOCAB', '{"question": "What do you drink?", "options": ["water", "table", "chair", "book"]}', '{"correct": 0, "explanation": "water = uống"}', 1, 5),
(13, 'VOCAB', '{"question": "''Good ___'' (in the morning)", "options": ["morning", "night", "evening", "afternoon"]}', '{"correct": 0, "explanation": "Good morning"}', 1, 6),
(13, 'VOCAB', '{"question": "How do you say ''mèo'' in English?", "options": ["cat", "dog", "fish", "bird"]}', '{"correct": 0, "explanation": "cat = mèo"}', 1, 7),
(13, 'VOCAB', '{"question": "''I am ___ years old.''", "options": ["twenty", "table", "school", "happy"]}', '{"correct": 0, "explanation": "Number for age"}', 1, 8),
-- GRAMMAR
(13, 'GRAMMAR', '{"question": "I ___ a student.", "options": ["am", "is", "are", "be"]}', '{"correct": 0, "explanation": "I + am"}', 1, 1),
(13, 'GRAMMAR', '{"question": "She ___ to school every day.", "options": ["goes", "go", "going", "gone"]}', '{"correct": 0, "explanation": "She/he/it + V-s"}', 1, 2),
(13, 'GRAMMAR', '{"question": "There ___ many books on the table.", "options": ["are", "is", "be", "am"]}', '{"correct": 0, "explanation": "Plural + are"}', 1, 3),
(13, 'GRAMMAR', '{"question": "I ___ swim well.", "options": ["can", "must", "should", "would"]}', '{"correct": 0, "explanation": "Ability → can"}', 1, 4),
(13, 'GRAMMAR', '{"question": "This is ___ apple.", "options": ["an", "a", "the", "no article"]}', '{"correct": 0, "explanation": "an + vowel"}', 1, 5),
(13, 'GRAMMAR', '{"question": "I have ___ brother.", "options": ["a", "an", "the", "no article"]}', '{"correct": 0, "explanation": "a + consonant"}', 1, 6),
(13, 'GRAMMAR', '{"question": "Tom is ___ than me.", "options": ["taller", "tall", "tallest", "more tall"]}', '{"correct": 0, "explanation": "Comparative tall → taller"}', 2, 7),
(13, 'GRAMMAR', '{"question": "I ___ go to school yesterday.", "options": ["went", "go", "goes", "going"]}', '{"correct": 0, "explanation": "Past simple of go = went"}', 2, 8),
-- READING
(13, 'READING', '{"passage": "Hi! I am Anna. I am 20 years old. I live in London. I am a student. I like reading and music.", "question": "How old is Anna?", "options": ["20", "18", "25", "30"]}', '{"correct": 0, "explanation": "I am 20 years old"}', 1, 1),
(13, 'READING', '{"passage": "Hi! I am Anna. I am 20 years old. I live in London. I am a student.", "question": "Where does Anna live?", "options": ["London", "Paris", "New York", "Tokyo"]}', '{"correct": 0, "explanation": "I live in London"}', 1, 2),
(13, 'READING', '{"passage": "John gets up at 7 am every day. He has breakfast and then goes to work. He works in an office.", "question": "What time does John get up?", "options": ["7 am", "8 am", "6 am", "9 am"]}', '{"correct": 0, "explanation": "gets up at 7 am"}', 1, 3),
(13, 'READING', '{"passage": "My family is small. I have a mother, a father, and a brother. We live in a small house.", "question": "How many people are in the family?", "options": ["4", "3", "5", "2"]}', '{"correct": 0, "explanation": "mother + father + brother + me = 4"}', 2, 4),
(13, 'READING', '{"passage": "It is hot today. I want to drink some water and go swimming.", "question": "How is the weather?", "options": ["hot", "cold", "rainy", "snowy"]}', '{"correct": 0, "explanation": "It is hot today"}', 1, 5),
-- LISTENING
(13, 'LISTENING', '{"audio_text": "Hello! My name is Sarah. I am from England.", "question": "Where is Sarah from?", "options": ["England", "America", "Japan", "Vietnam"]}', '{"correct": 0, "explanation": "I am from England"}', 1, 1),
(13, 'LISTENING', '{"audio_text": "I want to buy a book. Where is the bookshop?", "question": "What does the speaker want?", "options": ["a book", "a pen", "a bag", "a car"]}', '{"correct": 0, "explanation": "I want to buy a book"}', 1, 2),
(13, 'LISTENING', '{"audio_text": "It is 3 o''clock. Time for lunch!", "question": "What time is it?", "options": ["3 o''clock", "2 o''clock", "4 o''clock", "1 o''clock"]}', '{"correct": 0, "explanation": "It is 3 o''clock"}', 1, 3),
(13, 'LISTENING', '{"audio_text": "I love my dog. His name is Max.", "question": "What is the dog''s name?", "options": ["Max", "Rex", "Buddy", "Charlie"]}', '{"correct": 0, "explanation": "His name is Max"}', 1, 4);

-- ========================
-- CEFR A2 English Mock Test (mock_test_id = 6)
-- ========================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
-- VOCABULARY
(14, 'VOCAB', '{"question": "What does ''expensive'' mean?", "options": ["costs a lot of money", "cheap", "free", "easy"]}', '{"correct": 0, "explanation": "expensive = đắt"}', 2, 1),
(14, 'VOCAB', '{"question": "''I will ___ my car next week.''", "options": ["sell", "selling", "sold", "sells"]}', '{"correct": 0, "explanation": "Modal verb + base form"}', 2, 2),
(14, 'VOCAB', '{"question": "Choose the correct word: ''She ___ in a hospital.''", "options": ["works", "play", "study", "go"]}', '{"correct": 0, "explanation": "Hospital → works"}', 2, 3),
(14, 'VOCAB', '{"question": "Synonym of ''happy''?", "options": ["pleased", "sad", "angry", "tired"]}', '{"correct": 0, "explanation": "happy ≈ pleased"}', 2, 4),
(14, 'VOCAB', '{"question": "''The hotel is ___ the bus station.''", "options": ["near", "tall", "fast", "happy"]}', '{"correct": 0, "explanation": "near = close to"}', 2, 5),
(14, 'VOCAB', '{"question": "''I usually have ___ for breakfast.''", "options": ["bread", "shoes", "table", "key"]}', '{"correct": 0, "explanation": "Breakfast food"}', 2, 6),
(14, 'VOCAB', '{"question": "What is the past form of ''buy''?", "options": ["bought", "buyed", "buys", "buying"]}', '{"correct": 0, "explanation": "buy → bought"}', 2, 7),
(14, 'VOCAB', '{"question": "Choose the antonym of ''difficult''.", "options": ["easy", "hard", "long", "boring"]}', '{"correct": 0, "explanation": "difficult ↔ easy"}', 2, 8),
-- GRAMMAR
(14, 'GRAMMAR', '{"question": "I ___ Japan three times.", "options": ["have visited", "visited", "visit", "am visiting"]}', '{"correct": 0, "explanation": "Present perfect for experience"}', 3, 1),
(14, 'GRAMMAR', '{"question": "While I ___ TV, the phone rang.", "options": ["was watching", "watch", "watched", "am watching"]}', '{"correct": 0, "explanation": "Past continuous + past simple"}', 3, 2),
(14, 'GRAMMAR', '{"question": "If it ___ tomorrow, we will stay home.", "options": ["rains", "rained", "rain", "raining"]}', '{"correct": 0, "explanation": "First conditional: If + present, will + V"}', 3, 3),
(14, 'GRAMMAR', '{"question": "I used to ___ in Hanoi.", "options": ["live", "lived", "living", "lives"]}', '{"correct": 0, "explanation": "used to + base form"}', 2, 4),
(14, 'GRAMMAR', '{"question": "Have you ___ been to Paris?", "options": ["ever", "never", "yet", "still"]}', '{"correct": 0, "explanation": "Have you ever...?"}', 2, 5),
(14, 'GRAMMAR', '{"question": "She is ___ student in the class.", "options": ["the best", "best", "better", "good"]}', '{"correct": 0, "explanation": "Superlative: the + -est"}', 2, 6),
(14, 'GRAMMAR', '{"question": "I have ___ money.", "options": ["some", "any", "no", "much"]}', '{"correct": 0, "explanation": "Positive sentence → some"}', 2, 7),
(14, 'GRAMMAR', '{"question": "Don''t ___ on the grass!", "options": ["walk", "walked", "walking", "walks"]}', '{"correct": 0, "explanation": "Imperative: Don''t + base"}', 1, 8),
-- READING
(14, 'READING', '{"passage": "Last weekend, I went to the beach with my family. We left early in the morning. The weather was sunny and warm. We swam in the sea and ate ice cream. We had a great time.", "question": "When did they go to the beach?", "options": ["Last weekend", "Yesterday", "Last week", "Last month"]}', '{"correct": 0, "explanation": "Last weekend"}', 2, 1),
(14, 'READING', '{"passage": "Tom is studying English at university. He has been studying for two years. He plans to be a teacher after he graduates.", "question": "How long has Tom been studying English?", "options": ["Two years", "One year", "Three years", "Five years"]}', '{"correct": 0, "explanation": "for two years"}', 2, 2),
(14, 'READING', '{"passage": "I love cooking. I usually cook dinner for my family. My favorite dish is spaghetti. It is easy to make.", "question": "What is the speaker''s favorite dish?", "options": ["Spaghetti", "Pizza", "Salad", "Soup"]}', '{"correct": 0, "explanation": "My favorite dish is spaghetti"}', 2, 3),
(14, 'READING', '{"passage": "My grandfather is 80 years old. He is still very active. He goes for a walk every morning and reads books in the afternoon.", "question": "What does the grandfather do every morning?", "options": ["Goes for a walk", "Reads books", "Sleeps", "Cooks"]}', '{"correct": 0, "explanation": "He goes for a walk every morning"}', 2, 4),
(14, 'READING', '{"passage": "Yesterday I had a busy day. In the morning, I went to school. In the afternoon, I had a meeting. In the evening, I cooked dinner and watched TV.", "question": "What did the speaker do in the evening?", "options": ["Cooked dinner and watched TV", "Went to school", "Had a meeting", "Studied"]}', '{"correct": 0, "explanation": "evening: cooked dinner and watched TV"}', 2, 5),
-- LISTENING
(14, 'LISTENING', '{"audio_text": "Excuse me, where is the nearest bank? - It is on Main Street, next to the supermarket.", "question": "Where is the bank?", "options": ["On Main Street, next to the supermarket", "Near the school", "Behind the park", "In the city center"]}', '{"correct": 0, "explanation": "On Main Street, next to the supermarket"}', 2, 1),
(14, 'LISTENING', '{"audio_text": "I would like to book a table for two, please. - For what time? - 7 pm.", "question": "What time is the booking for?", "options": ["7 pm", "6 pm", "8 pm", "9 pm"]}', '{"correct": 0, "explanation": "7 pm"}', 2, 2),
(14, 'LISTENING', '{"audio_text": "The train to London leaves at 10:30 from platform 5.", "question": "What platform does the train leave from?", "options": ["5", "10", "30", "3"]}', '{"correct": 0, "explanation": "platform 5"}', 2, 3),
(14, 'LISTENING', '{"audio_text": "I''m sorry, I can''t come to the party. I''m feeling sick.", "question": "Why can''t the speaker come?", "options": ["He is sick", "He is busy", "He is tired", "He is on holiday"]}', '{"correct": 0, "explanation": "I am feeling sick"}', 2, 4);
