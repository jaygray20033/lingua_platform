-- =====================================================
-- V12: Mock Tests đầy đủ 4 kỹ năng (Listening + Reading + Writing + Speaking)
-- Cho JLPT N3, HSK3, CEFR B1 + Mở rộng N5/HSK1/A1 thêm SPEAKING + WRITING ESSAY
-- Tham khảo:
--   • JLPT Official Practice Workbook (https://www.jlpt.jp)
--   • HSK Official Standard Course (Hanban)
--   • Cambridge English Qualifications - PET (B1) handbook
--   • CEFR Companion Volume 2020
-- =====================================================

-- Mở rộng ENUM section: thêm SPEAKING + ESSAY (kỹ năng viết tự luận)
ALTER TABLE mock_test_questions
    MODIFY COLUMN section ENUM('VOCAB','VOCABULARY','GRAMMAR','READING','LISTENING','WRITING','SPEAKING','ESSAY') NOT NULL;

-- =====================================================
-- 1) JLPT N3 - Đề thi chuẩn (mock_test_id = 20)
-- Dạng đề: 105 phút - 4 sections + speaking interview
-- =====================================================
INSERT INTO mock_tests (id, certification, level_code, title, total_duration_min, pass_score, section_config_json) VALUES
(20, 'JLPT', 'N3', 'JLPT N3 - Đề thi thử chuẩn (đầy đủ 4 kỹ năng)', 140, 95,
 '{"sections": [
    {"name": "VOCAB", "title": "語彙 Từ vựng", "duration_min": 30, "question_count": 10},
    {"name": "GRAMMAR", "title": "文法 Ngữ pháp", "duration_min": 30, "question_count": 10},
    {"name": "READING", "title": "読解 Đọc hiểu", "duration_min": 35, "question_count": 6},
    {"name": "LISTENING", "title": "聴解 Nghe hiểu", "duration_min": 25, "question_count": 6},
    {"name": "WRITING", "title": "作文 Viết luận", "duration_min": 15, "question_count": 2},
    {"name": "SPEAKING", "title": "会話 Nói (phỏng vấn)", "duration_min": 5, "question_count": 2}
 ]}');

-- N3 VOCAB
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(20, 'VOCAB', '{"question":"電車が遅れて、会議に＿＿しました。","options":["遅刻","遅延","遅れ","遅速"]}', '{"correct":0,"explanation":"遅刻 (ちこく) = đi muộn / trễ giờ. Đây là từ N3 thường gặp."}', 2, 1),
(20, 'VOCAB', '{"question":"祖母は今でもとても＿＿です。","options":["元気","元日","元来","元金"]}', '{"correct":0,"explanation":"元気 (げんき) = khỏe mạnh, nhanh nhẹn"}', 1, 2),
(20, 'VOCAB', '{"question":"「許可」の意味として最も近いものは？","options":["allow / cho phép","cấm","đồng ý qua loa","gợi ý"]}', '{"correct":0,"explanation":"許可 (きょか) = sự cho phép, allow / permission"}', 2, 3),
(20, 'VOCAB', '{"question":"このレポートを＿＿してください。","options":["提出","提案","提供","提示"]}', '{"correct":0,"explanation":"提出 (ていしゅつ) = nộp (báo cáo, đơn từ)"}', 2, 4),
(20, 'VOCAB', '{"question":"事故で道路が＿＿している。","options":["混雑","混乱","混合","混同"]}', '{"correct":0,"explanation":"混雑 (こんざつ) = đông đúc, ùn tắc"}', 2, 5),
(20, 'VOCAB', '{"question":"「諦める」の意味は？","options":["từ bỏ","cố gắng","quyết định","khẳng định"]}', '{"correct":0,"explanation":"諦める (あきらめる) = từ bỏ, đầu hàng"}', 2, 6),
(20, 'VOCAB', '{"question":"彼は失敗を＿＿に成功した。","options":["きっかけ","きっと","きょうみ","きまり"]}', '{"correct":0,"explanation":"きっかけ = cơ hội/nguyên do. Lấy thất bại làm cơ hội để thành công"}', 3, 7),
(20, 'VOCAB', '{"question":"このレストランは値段が高いが、＿＿はいい。","options":["サービス","スピーチ","スタイル","サンプル"]}', '{"correct":0,"explanation":"サービス = dịch vụ"}', 1, 8),
(20, 'VOCAB', '{"question":"「ぴったり」の使い方として正しいのは？","options":["この服はサイズがぴったりだ","ぴったり走る","水がぴったり溢れる","ぴったり笑う"]}', '{"correct":0,"explanation":"ぴったり = vừa khít / đúng lúc"}', 2, 9),
(20, 'VOCAB', '{"question":"「すっかり」の意味は？","options":["hoàn toàn","một chút","có lẽ","chắc chắn"]}', '{"correct":0,"explanation":"すっかり = hoàn toàn (forget completely, etc.)"}', 2, 10);

-- N3 GRAMMAR
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(20, 'GRAMMAR', '{"question":"日本へ来た＿＿、3年になります。","options":["ばかりに","ばかりで","ばかりか","ばかり"]}', '{"correct":3,"explanation":"〜たばかり = vừa mới ~. Cũng có thể tính từ điểm vừa mới + thời gian."}', 2, 1),
(20, 'GRAMMAR', '{"question":"勉強すれば＿＿、成績が上がります。","options":["するほど","するから","しても","するに"]}', '{"correct":0,"explanation":"〜ば〜ほど = càng ~ càng ~"}', 2, 2),
(20, 'GRAMMAR', '{"question":"先生に＿＿、漢字の読み方が分かるようになりました。","options":["教えてもらって","教えられて","教えてくれて","教えてあげて"]}', '{"correct":0,"explanation":"〜てもらう = nhờ ai làm gì cho mình (lịch sự)"}', 2, 3),
(20, 'GRAMMAR', '{"question":"明日のパーティーには行か＿＿つもりです。","options":["ない","ぬ","なく","ず"]}', '{"correct":0,"explanation":"V ない つもり = không có ý định"}', 1, 4),
(20, 'GRAMMAR', '{"question":"何時に着く＿＿、知らせてください。","options":["か","から","ので","でも"]}', '{"correct":0,"explanation":"V る/ない + か = hay không (gián tiếp)"}', 2, 5),
(20, 'GRAMMAR', '{"question":"日本語が話せる＿＿になりました。","options":["よう","こと","もの","ところ"]}', '{"correct":0,"explanation":"〜ようになる = trở nên có thể ~ (thay đổi khả năng)"}', 2, 6),
(20, 'GRAMMAR', '{"question":"雨が降りそうだから、傘を持っていった方が＿＿。","options":["いい","良かった","ある","する"]}', '{"correct":0,"explanation":"〜たほうがいい = nên ~"}', 1, 7),
(20, 'GRAMMAR', '{"question":"先生の説明は分かり＿＿。","options":["やすい","にくい","がたい","ぐるしい"]}', '{"correct":0,"explanation":"V ます stem + やすい = dễ ~"}', 1, 8),
(20, 'GRAMMAR', '{"question":"いくら＿＿、彼は聞こうとしない。","options":["言っても","言ったら","言って","言うのに"]}', '{"correct":0,"explanation":"いくら〜ても = dù có ~ bao nhiêu cũng"}', 2, 9),
(20, 'GRAMMAR', '{"question":"父にコンサートに行か＿＿。","options":["せてもらった","させてもらった","させていただいた","せていただいた"]}', '{"correct":1,"explanation":"〜させてもらう = được phép làm (sai khiến + thụ động lịch sự)"}', 3, 10);

-- N3 READING (3 đoạn văn)
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(20, 'READING', '{"passage":"私は最近、毎朝6時に起きてジョギングをしています。最初は30分も走れませんでしたが、3か月続けたら、今では1時間でも走れるようになりました。健康のためだけでなく、頭がすっきりして仕事にも集中できます。続けることは大切だと感じています。","question":"筆者は何のためにジョギングをしていますか。","options":["健康のためと、仕事に集中するため","運動会のため","ダイエットのため","友達と会うため"]}', '{"correct":0,"explanation":"健康のためだけでなく、頭がすっきりして仕事にも集中できる"}', 2, 1),
(20, 'READING', '{"passage":"私は最近、毎朝6時に起きてジョギングをしています。最初は30分も走れませんでしたが、3か月続けたら、今では1時間でも走れるようになりました。","question":"3か月後、走れるようになった時間は？","options":["30分","1時間","2時間","6時間"]}', '{"correct":1,"explanation":"今では1時間でも走れる"}', 1, 2),
(20, 'READING', '{"passage":"日本では、お正月に家族みんなが集まって、おせち料理を食べる習慣があります。おせちは、長持ちするように味が濃く、また縁起のいい食べ物が選ばれています。例えば、エビは「腰が曲がるまで長生きする」、黒豆は「まめに働けるように」という意味があります。","question":"おせち料理の特徴は何ですか。","options":["味が薄い","味が濃く、長持ちする","冷たい","辛い"]}', '{"correct":1,"explanation":"長持ちするように味が濃く"}', 2, 3),
(20, 'READING', '{"passage":"日本では、お正月に家族みんなが集まって、おせち料理を食べる習慣があります。エビは「腰が曲がるまで長生きする」、黒豆は「まめに働けるように」という意味があります。","question":"黒豆に込められた意味は？","options":["長生き","まじめに働く / chăm chỉ làm việc","お金","健康"]}', '{"correct":1,"explanation":"「まめに働く」= chăm chỉ làm việc"}', 3, 4),
(20, 'READING', '{"passage":"スマートフォンは便利ですが、使いすぎには注意が必要です。最近の研究によると、寝る前に長時間スマホを使うと、睡眠の質が下がることが分かりました。専門家は、寝る1時間前からはスマホを使わないことをすすめています。","question":"専門家の推奨は何ですか。","options":["寝る1時間前からスマホを使わない","スマホを使わない","スマホを2時間使う","朝にスマホを使う"]}', '{"correct":0,"explanation":"寝る1時間前からはスマホを使わないこと"}', 2, 5),
(20, 'READING', '{"passage":"スマートフォンを寝る前に長時間使うと、睡眠の質が下がる。","question":"何が下がりますか。","options":["睡眠の質","電池の量","気温","スマホの値段"]}', '{"correct":0,"explanation":"睡眠の質 (chất lượng giấc ngủ)"}', 1, 6);

-- N3 LISTENING
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(20, 'LISTENING', '{"audio_text":"男:すみません、市役所はどこですか。女:この道をまっすぐ行って、二つ目の信号を右に曲がってください。銀行の隣にあります。","question":"市役所はどこにありますか。","options":["銀行の隣","駅の前","学校の後ろ","公園の中"]}', '{"correct":0,"explanation":"銀行の隣にあります"}', 2, 1),
(20, 'LISTENING', '{"audio_text":"先生:明日のテストは10時からです。9時45分までに教室に入ってください。鉛筆と消しゴムだけ持ってきてください。辞書は使えません。","question":"何を持っていけませんか。","options":["鉛筆","消しゴム","辞書","ノート"]}', '{"correct":2,"explanation":"辞書は使えません"}', 2, 2),
(20, 'LISTENING', '{"audio_text":"女:今度の日曜日、買い物に行きませんか。男:すみません、日曜日は仕事なんです。土曜日ならいいですよ。女:じゃ、土曜日にしましょう。","question":"二人はいつ会いますか。","options":["日曜日","土曜日","金曜日","月曜日"]}', '{"correct":1,"explanation":"土曜日にしましょう"}', 2, 3),
(20, 'LISTENING', '{"audio_text":"電車のアナウンス:お客様にお知らせします。事故のため、東京方面の電車が30分遅れています。ご迷惑をおかけしまして申し訳ございません。","question":"なぜ遅れていますか。","options":["事故","雪","故障","工事"]}', '{"correct":0,"explanation":"事故のため"}', 2, 4),
(20, 'LISTENING', '{"audio_text":"医者:風邪ですね。この薬を1日3回、食後に飲んでください。お酒は飲まないでください。","question":"薬はいつ飲みますか。","options":["食前","食後","寝る前","朝だけ"]}', '{"correct":1,"explanation":"食後に飲んでください"}', 1, 5),
(20, 'LISTENING', '{"audio_text":"店員:このシャツは1枚3000円ですが、2枚買うと5000円になります。3枚以上買うと、1枚2000円です。","question":"3枚買うといくらですか。","options":["6000円","5000円","9000円","3000円"]}', '{"correct":0,"explanation":"3枚 × 2000円 = 6000円"}', 3, 6);

-- N3 WRITING - Essay (input_type = writing)
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(20, 'WRITING', '{"question":"次のテーマについて、200字程度で意見を書いてください:「日本に留学することの利点と難しさ」","input_type":"writing","min_words":150,"max_words":250,"hint":"利点: 言語、文化体験、就職機会。難しさ: 言葉の壁、文化の違い、生活費。"}', '{"correct":"留学の利点は、日本語が上達することと、日本文化を直接体験できることです。また、日本企業に就職するチャンスもあります。一方で、難しさとして、言葉の壁や文化の違い、生活費が高いことが挙げられます。しかし、これらの困難を乗り越えることで、自分自身も成長できると思います。","explanation":"Tiêu chí chấm: 1) Có cấu trúc 序論-本論-結論; 2) Sử dụng N3 grammar (〜ことができる, 〜という, 〜と思う); 3) Đủ độ dài 150-250 chữ."}', 3, 1),
(20, 'WRITING', '{"question":"「最近うれしかったこと」について、150字以上で書いてください。","input_type":"writing","min_words":100,"max_words":200,"hint":"何が起きたか、誰と一緒に、どう感じたかを書く"}', '{"correct":"先週、日本語能力試験N3に合格したという通知をもらいました。家族にすぐ電話をして報告したら、みんな喜んでくれました。一年間ずっと勉強してきた努力が実を結んだことを感じて、本当にうれしかったです。次はN2を目指して、もっと頑張りたいと思います。","explanation":"Đánh giá: cấu trúc rõ ràng (cái gì? khi nào? cảm xúc?), dùng đúng thì quá khứ, có biểu cảm cá nhân."}', 2, 2);

-- N3 SPEAKING (input_type = speaking)
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(20, 'SPEAKING', '{"question":"自己紹介をしてください (60秒)。名前、出身、趣味、今勉強している理由を含めて話してください。","input_type":"speaking","prep_seconds":30,"speak_seconds":60,"audio_text":"自己紹介をしてください。名前、出身、趣味、今勉強している理由を含めて話してください。"}', '{"correct":"はじめまして、私は[名前]と申します。ベトナムから来ました。趣味は[趣味]です。日本のアニメや文化が大好きで、もっと深く理解したいので日本語を勉強しています。よろしくお願いします。","explanation":"Tiêu chí: 1) Phát âm rõ ràng; 2) Sử dụng dạng です/ます (lịch sự); 3) Bao quát 4 nội dung yêu cầu; 4) Tự nhiên không vấp."}', 2, 1),
(20, 'SPEAKING', '{"question":"あなたの国の好きな祭りについて、1分間話してください。","input_type":"speaking","prep_seconds":60,"speak_seconds":60,"audio_text":"あなたの国の好きな祭りについて、1分間話してください。"}', '{"correct":"私の国で一番好きな祭りはテト (お正月) です。家族が集まって、伝統料理を食べたり、子供たちにお年玉をあげたりします。家を花で飾って、新しい一年が幸せになるように願います。とてもにぎやかで楽しい雰囲気です。","explanation":"Tiêu chí: tên jest, thời điểm, hoạt động, cảm xúc. Dùng N3 grammar 〜たり〜たり, 〜ように."}', 3, 2);

-- =====================================================
-- 2) HSK 3 - Đề thi chuẩn (mock_test_id = 21)
-- =====================================================
INSERT INTO mock_tests (id, certification, level_code, title, total_duration_min, pass_score, section_config_json) VALUES
(21, 'HSK', 'HSK3', 'HSK 3 - Đề thi thử chuẩn (4 kỹ năng)', 90, 180,
 '{"sections": [
    {"name": "LISTENING", "title": "听力 Nghe", "duration_min": 35, "question_count": 6},
    {"name": "READING", "title": "阅读 Đọc", "duration_min": 30, "question_count": 8},
    {"name": "WRITING", "title": "书写 Viết", "duration_min": 15, "question_count": 4},
    {"name": "ESSAY", "title": "短文写作 Viết đoạn văn", "duration_min": 5, "question_count": 1},
    {"name": "SPEAKING", "title": "口语 Nói", "duration_min": 5, "question_count": 2}
 ]}');

-- HSK3 LISTENING
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(21, 'LISTENING', '{"audio_text":"我每天早上六点起床，然后跑步半个小时。","question":"他每天跑步多长时间？","options":["半小时","一小时","二十分钟","两小时"]}', '{"correct":0,"explanation":"半个小时 = nửa tiếng"}', 2, 1),
(21, 'LISTENING', '{"audio_text":"明天是我妈妈的生日，我要给她买一个蛋糕。","question":"他要买什么？","options":["蛋糕","花","书","衣服"]}', '{"correct":0,"explanation":"蛋糕 (dàngāo) = bánh kem"}', 2, 2),
(21, 'LISTENING', '{"audio_text":"A: 你喜欢吃什么水果？B: 我最喜欢吃苹果，可是这里很贵。","question":"为什么他不常吃苹果？","options":["太贵","不好吃","没有","不喜欢"]}', '{"correct":0,"explanation":"这里很贵 = ở đây rất đắt"}', 2, 3),
(21, 'LISTENING', '{"audio_text":"今天的天气真不错，我们去公园散步吧。","question":"他建议做什么？","options":["去公园散步","看电影","去吃饭","回家"]}', '{"correct":0,"explanation":"我们去公园散步吧 = mình đi công viên đi"}', 2, 4),
(21, 'LISTENING', '{"audio_text":"我学了三年中文，但是说得还不太好。","question":"他学中文学了多久？","options":["三年","两年","一年","四年"]}', '{"correct":0,"explanation":"三年 = 3 năm"}', 1, 5),
(21, 'LISTENING', '{"audio_text":"A: 这件衣服多少钱？B: 五百块。A: 太贵了，便宜一点儿吧。B: 那四百五十块。","question":"最后多少钱？","options":["450块","500块","400块","550块"]}', '{"correct":0,"explanation":"那四百五十块 = vậy 450 tệ"}', 3, 6);

-- HSK3 READING
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(21, 'READING', '{"passage":"我叫小李，今年二十五岁。我是一个汉语老师，在北京工作。我每天教外国学生学习汉语。我很喜欢我的工作。","question":"小李做什么工作？","options":["汉语老师","学生","医生","司机"]}', '{"correct":0,"explanation":"我是一个汉语老师"}', 1, 1),
(21, 'READING', '{"passage":"我叫小李，今年二十五岁。我是一个汉语老师，在北京工作。","question":"小李在哪里工作？","options":["北京","上海","广州","深圳"]}', '{"correct":0,"explanation":"在北京工作"}', 1, 2),
(21, 'READING', '{"passage":"我的爱好是看电影。我每个周末都去电影院看电影。我最喜欢中国电影，因为我可以一边看一边学习汉语。","question":"作者最喜欢什么电影？","options":["中国电影","美国电影","日本电影","法国电影"]}', '{"correct":0,"explanation":"我最喜欢中国电影"}', 2, 3),
(21, 'READING', '{"passage":"我每个周末都去电影院看电影。我最喜欢中国电影，因为我可以一边看一边学习汉语。","question":"为什么他喜欢看中国电影？","options":["可以学习汉语","因为便宜","时间长","演员漂亮"]}', '{"correct":0,"explanation":"可以一边看一边学习汉语"}', 2, 4),
(21, 'READING', '{"passage":"上个星期天，我和朋友一起去爬山。山很高，我们爬了三个小时才到山顶。但是从山顶看到的风景非常美丽，所以我们都觉得很值得。","question":"他们爬了多久？","options":["三个小时","两个小时","四个小时","一个小时"]}', '{"correct":0,"explanation":"爬了三个小时"}', 2, 5),
(21, 'READING', '{"passage":"上个星期天，我和朋友一起去爬山。从山顶看到的风景非常美丽。","question":"他们觉得怎么样？","options":["很值得","很累","很无聊","很冷"]}', '{"correct":0,"explanation":"我们都觉得很值得"}', 2, 6),
(21, 'READING', '{"passage":"中国人喜欢喝茶。他们认为喝茶对身体好。在中国，有很多种茶，比如绿茶、红茶、乌龙茶等。每种茶都有不同的味道。","question":"中国人为什么喜欢喝茶？","options":["对身体好","便宜","好看","容易做"]}', '{"correct":0,"explanation":"对身体好 = tốt cho sức khỏe"}', 2, 7),
(21, 'READING', '{"passage":"在中国，有很多种茶，比如绿茶、红茶、乌龙茶等。每种茶都有不同的味道。","question":"中国茶有什么特点？","options":["种类多，味道不同","种类少","只有绿茶","味道一样"]}', '{"correct":0,"explanation":"很多种茶 + 不同的味道"}', 2, 8);

-- HSK3 WRITING (sắp xếp từ thành câu)
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(21, 'WRITING', '{"question":"排序: 起床 / 我 / 七点 / 每天 (Sắp xếp thành câu đúng)","options":["我每天七点起床。","每天我七点起床。","七点我每天起床。","起床我每天七点。"]}', '{"correct":0,"explanation":"S + 时间 + V: 我每天七点起床"}', 2, 1),
(21, 'WRITING', '{"question":"选词填空: 他___了一个小时英语。","options":["学","学习","看","听"]}', '{"correct":1,"explanation":"学习英语 (học tiếng Anh) - 学习 thường dùng với môn học"}', 2, 2),
(21, 'WRITING', '{"question":"选择正确的: hàn yǔ","options":["汉语","汗语","汉雨","韩语"]}', '{"correct":0,"explanation":"汉语 = tiếng Trung (Hán ngữ)"}', 1, 3),
(21, 'WRITING', '{"question":"排序: 妹妹 / 比 / 高 / 我 (so sánh)","options":["妹妹比我高。","我比妹妹高。","妹妹高比我。","比妹妹我高。"]}', '{"correct":0,"explanation":"A + 比 + B + Adj: 妹妹比我高"}', 2, 4);

-- HSK3 ESSAY (短文写作)
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(21, 'ESSAY', '{"question":"请用80个汉字写一篇短文，题目: 我的一天 (Một ngày của tôi)","input_type":"writing","min_words":60,"max_words":120,"hint":"包括: 起床时间、早饭、上午做什么、下午做什么、晚上做什么"}', '{"correct":"我的一天很忙。我每天早上七点起床，然后吃早饭。八点我去学校学习汉语。中午我和同学一起吃午饭。下午我在图书馆学习。晚上我回家吃晚饭，看电视，然后睡觉。我觉得我的生活很有意思。","explanation":"Tiêu chí: 60-120 chữ, dùng 时间词 (sáng/trưa/chiều/tối), động từ HSK3, có cấu trúc rõ ràng."}', 3, 1);

-- HSK3 SPEAKING
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(21, 'SPEAKING', '{"question":"请你介绍一下你的家人 (1分钟)","input_type":"speaking","prep_seconds":30,"speak_seconds":60,"audio_text":"请你介绍一下你的家人"}', '{"correct":"我家有四口人:爸爸、妈妈、弟弟和我。爸爸是医生，他在医院工作。妈妈是老师，她在中学教数学。弟弟今年十岁，他是小学生。我是大学生，正在学习汉语。我们家人很爱我。","explanation":"Tiêu chí: 4 thành viên, nghề nghiệp, tuổi/đặc điểm, cảm xúc."}', 2, 1),
(21, 'SPEAKING', '{"question":"请你说说你最喜欢的城市 (1分钟)","input_type":"speaking","prep_seconds":30,"speak_seconds":60,"audio_text":"请你说说你最喜欢的城市"}', '{"correct":"我最喜欢的城市是河内。河内是越南的首都。这里有很多有名的地方，比如还剑湖、文庙。河内的食物很好吃，特别是河粉和春卷。河内的人也很热情。我希望以后还能去河内。","explanation":"Tiêu chí: tên thành phố, vị trí, danh thắng, ẩm thực, cảm xúc cá nhân."}', 3, 2);

-- =====================================================
-- 3) CEFR B1 English (mock_test_id = 22)
-- Tham khảo Cambridge PET handbook
-- =====================================================
INSERT INTO mock_tests (id, certification, level_code, title, total_duration_min, pass_score, section_config_json) VALUES
(22, 'CEFR', 'B1', 'CEFR B1 - English Practice Test (4 skills)', 120, 65,
 '{"sections": [
    {"name": "VOCAB", "title": "Vocabulary", "duration_min": 20, "question_count": 8},
    {"name": "GRAMMAR", "title": "Grammar (Use of English)", "duration_min": 25, "question_count": 8},
    {"name": "READING", "title": "Reading Comprehension", "duration_min": 30, "question_count": 6},
    {"name": "LISTENING", "title": "Listening", "duration_min": 20, "question_count": 6},
    {"name": "WRITING", "title": "Writing (Essay)", "duration_min": 20, "question_count": 2},
    {"name": "SPEAKING", "title": "Speaking (Interview)", "duration_min": 5, "question_count": 2}
 ]}');

-- B1 VOCAB
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(22, 'VOCAB', '{"question":"The doctor advised me to ___ smoking.","options":["give up","give in","give out","give away"]}', '{"correct":0,"explanation":"give up = từ bỏ (phrasal verb B1)"}', 2, 1),
(22, 'VOCAB', '{"question":"She has a great ___ for languages.","options":["talent","skill","ability","experience"]}', '{"correct":0,"explanation":"have a talent for = có năng khiếu về"}', 2, 2),
(22, 'VOCAB', '{"question":"I''m really ___ in modern art.","options":["interested","interesting","interest","interestingly"]}', '{"correct":0,"explanation":"be interested IN sth"}', 1, 3),
(22, 'VOCAB', '{"question":"The film was so ___ that I fell asleep.","options":["boring","bored","bore","boredom"]}', '{"correct":0,"explanation":"-ing adj describes the thing (the film); -ed describes feelings"}', 2, 4),
(22, 'VOCAB', '{"question":"Choose the synonym of ''ancient''.","options":["very old","modern","new","young"]}', '{"correct":0,"explanation":"ancient = very old (cổ xưa)"}', 2, 5),
(22, 'VOCAB', '{"question":"The opposite of ''generous'' is ___.","options":["mean / stingy","kind","helpful","brave"]}', '{"correct":0,"explanation":"generous (rộng rãi) ↔ mean/stingy (keo kiệt)"}', 3, 6),
(22, 'VOCAB', '{"question":"After many hours of work, we finally ___ the project.","options":["completed","competed","computed","compelled"]}', '{"correct":0,"explanation":"completed = hoàn thành"}', 2, 7),
(22, 'VOCAB', '{"question":"The weather has been very ___ recently — sometimes hot, sometimes cold.","options":["unpredictable","predictable","reliable","stable"]}', '{"correct":0,"explanation":"unpredictable = khó đoán"}', 3, 8);

-- B1 GRAMMAR
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(22, 'GRAMMAR', '{"question":"If I ___ rich, I would travel around the world.","options":["were","am","was","be"]}', '{"correct":0,"explanation":"Second conditional: If + past simple, would + V (formal: were)"}', 3, 1),
(22, 'GRAMMAR', '{"question":"The book ___ by millions of people last year.","options":["was read","read","reads","reading"]}', '{"correct":0,"explanation":"Passive past simple: was/were + V3"}', 2, 2),
(22, 'GRAMMAR', '{"question":"I ___ to Paris three times.","options":["have been","went","go","am going"]}', '{"correct":0,"explanation":"Present perfect for life experience: have/has + V3"}', 2, 3),
(22, 'GRAMMAR', '{"question":"This is the man ___ helped me yesterday.","options":["who","which","whose","whom"]}', '{"correct":0,"explanation":"who refers to people as subject"}', 2, 4),
(22, 'GRAMMAR', '{"question":"You ___ smoke in this building. It''s forbidden.","options":["mustn''t","needn''t","don''t have to","could"]}', '{"correct":0,"explanation":"mustn''t = bị cấm"}', 2, 5),
(22, 'GRAMMAR', '{"question":"He told me he ___ tired.","options":["was","is","be","were"]}', '{"correct":0,"explanation":"Reported speech: present → past"}', 3, 6),
(22, 'GRAMMAR', '{"question":"By the time we arrived, the film ___ already ___.","options":["had / started","has / started","was / starting","is / started"]}', '{"correct":0,"explanation":"Past perfect for action before another past action"}', 3, 7),
(22, 'GRAMMAR', '{"question":"I''d rather you ___ smoke here.","options":["didn''t","don''t","won''t","not"]}', '{"correct":0,"explanation":"I''d rather + S + past simple = mong ai đó (đừng) làm gì"}', 4, 8);

-- B1 READING
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(22, 'READING', '{"passage":"Many young people today prefer to live in big cities. They believe cities offer more opportunities for jobs, education, and entertainment. However, life in a big city can be expensive and stressful. Pollution and noise are common problems. Some people start to move back to the countryside, where the air is cleaner and life is slower.","question":"Why do young people prefer big cities?","options":["More opportunities for jobs and education","Cleaner air","Cheaper housing","Less noise"]}', '{"correct":0,"explanation":"more opportunities for jobs, education, and entertainment"}', 2, 1),
(22, 'READING', '{"passage":"Many young people today prefer to live in big cities. Some people start to move back to the countryside, where the air is cleaner and life is slower.","question":"Why do some people return to the countryside?","options":["Cleaner air and slower life","Better jobs","More entertainment","Cheaper food"]}', '{"correct":0,"explanation":"the air is cleaner and life is slower"}', 2, 2),
(22, 'READING', '{"passage":"Climate change is one of the biggest challenges facing our planet. Scientists warn that if we don''t reduce greenhouse gases, the temperature will continue to rise. Each of us can help by using less energy, recycling, and using public transport instead of cars.","question":"What can individuals do to fight climate change?","options":["Use less energy and recycle","Plant trees","Eat less meat","Drink more water"]}', '{"correct":0,"explanation":"using less energy, recycling, and using public transport"}', 3, 3),
(22, 'READING', '{"passage":"Scientists warn that if we don''t reduce greenhouse gases, the temperature will continue to rise.","question":"What will happen if we don''t reduce greenhouse gases?","options":["Temperature will rise","Sea level falls","Air becomes cleaner","Plants grow faster"]}', '{"correct":0,"explanation":"temperature will continue to rise"}', 2, 4),
(22, 'READING', '{"passage":"Volunteering is becoming more popular among young adults. By giving their time to help others, volunteers gain valuable skills, make new friends, and feel satisfied. Common activities include teaching children, cleaning beaches, or visiting elderly people.","question":"What are the benefits of volunteering?","options":["Skills, friends, satisfaction","Money","Promotion","Free meals"]}', '{"correct":0,"explanation":"gain valuable skills, make new friends, and feel satisfied"}', 2, 5),
(22, 'READING', '{"passage":"Common volunteer activities include teaching children, cleaning beaches, or visiting elderly people.","question":"Which is NOT mentioned as a volunteer activity?","options":["Cooking food","Teaching children","Cleaning beaches","Visiting elderly people"]}', '{"correct":0,"explanation":"Cooking food is not mentioned"}', 2, 6);

-- B1 LISTENING
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(22, 'LISTENING', '{"audio_text":"Hi, I''m calling about the apartment for rent. I saw your advertisement online. Can I come and see it tomorrow afternoon, around 3 pm?","question":"When does the caller want to visit?","options":["Tomorrow at 3 pm","Today at 3 pm","Tomorrow morning","Tonight"]}', '{"correct":0,"explanation":"tomorrow afternoon, around 3 pm"}', 2, 1),
(22, 'LISTENING', '{"audio_text":"Attention please. Flight BA 234 to London has been delayed by two hours due to bad weather. We apologize for the inconvenience.","question":"Why was the flight delayed?","options":["Bad weather","Mechanical problem","Strike","Security issue"]}', '{"correct":0,"explanation":"due to bad weather"}', 2, 2),
(22, 'LISTENING', '{"audio_text":"A: How was your weekend? B: Great! I went hiking with my friends in the mountains. The weather was perfect.","question":"What did B do on the weekend?","options":["Went hiking","Stayed home","Went shopping","Visited family"]}', '{"correct":0,"explanation":"I went hiking with my friends"}', 2, 3),
(22, 'LISTENING', '{"audio_text":"Today''s recipe is for chocolate cake. You need 200 grams of flour, 150 grams of sugar, 100 grams of butter, and 3 eggs. Mix everything together and bake for 45 minutes.","question":"How long do you bake the cake?","options":["45 minutes","30 minutes","60 minutes","20 minutes"]}', '{"correct":0,"explanation":"bake for 45 minutes"}', 2, 4),
(22, 'LISTENING', '{"audio_text":"The library will be closed from December 25th to January 1st for the winter holidays. We will reopen on January 2nd at 9 am.","question":"When will the library reopen?","options":["January 2nd at 9 am","December 25th","January 1st","December 26th"]}', '{"correct":0,"explanation":"reopen on January 2nd at 9 am"}', 2, 5),
(22, 'LISTENING', '{"audio_text":"Excuse me, where can I find the history books? — They are on the second floor, in section C, next to the language section.","question":"Where are the history books?","options":["Second floor, section C","First floor","Third floor","Ground floor"]}', '{"correct":0,"explanation":"second floor, in section C"}', 2, 6);

-- B1 WRITING (Essay)
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(22, 'WRITING', '{"question":"Write an essay (120-150 words) on the topic: ''The advantages and disadvantages of social media''","input_type":"writing","min_words":120,"max_words":180,"hint":"Structure: Introduction → Advantages → Disadvantages → Conclusion. Use linking words: firstly, however, on the other hand, in conclusion."}', '{"correct":"Social media has changed the way we communicate. On one hand, it has many advantages. Firstly, it allows us to stay in touch with friends and family across the world. Secondly, it provides quick access to news and information. Many people also use it to promote their businesses. On the other hand, social media has some disadvantages. People can become addicted, spending hours scrolling instead of doing useful activities. There is also a risk of fake news and cyberbullying. In conclusion, while social media offers many benefits, we should use it carefully and not let it control our lives.","explanation":"Tiêu chí: 1) Có introduction-body-conclusion; 2) Linking words; 3) Min 120 từ; 4) Argument 2 chiều."}', 3, 1),
(22, 'WRITING', '{"question":"Write an informal email (80-100 words) to your friend, inviting them to your birthday party.","input_type":"writing","min_words":60,"max_words":120,"hint":"Include: greeting, invitation, date/time/place, what to bring, closing"}', '{"correct":"Hi Sarah, How are you? I hope you''re doing well. I''m writing to invite you to my birthday party next Saturday, the 15th, at my house. The party starts at 7 pm. We''ll have food, music, and some fun games. You don''t need to bring anything, just yourself! Please let me know if you can come. Looking forward to seeing you! Best wishes, Anna","explanation":"Tiêu chí: 1) Greeting + closing thân mật; 2) Đầy đủ thông tin (when/where/what); 3) Tone friendly."}', 2, 2);

-- B1 SPEAKING
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(22, 'SPEAKING', '{"question":"Talk about yourself for 1 minute. Include: your name, where you''re from, your job/studies, your hobbies, and your future plans.","input_type":"speaking","prep_seconds":30,"speak_seconds":60,"audio_text":"Talk about yourself for 1 minute"}', '{"correct":"Hello, my name is [your name]. I''m from Vietnam, but I currently live in Hanoi. I''m a university student studying business. In my free time, I enjoy reading books, watching movies, and playing badminton with my friends. In the future, I hope to work in marketing for an international company and travel to many countries to learn about different cultures.","explanation":"Tiêu chí: 1) Đủ 5 nội dung yêu cầu; 2) Ngữ pháp B1 (present simple, will/hope to + V); 3) Phát âm rõ; 4) 60-90 giây."}', 2, 1),
(22, 'SPEAKING', '{"question":"Describe a memorable trip you have taken (2 minutes). Include: where you went, who you went with, what you did, and why it was memorable.","input_type":"speaking","prep_seconds":60,"speak_seconds":120,"audio_text":"Describe a memorable trip you have taken"}', '{"correct":"Last summer, I took a memorable trip to Da Nang, a beautiful coastal city in central Vietnam. I went with my family — my parents and my younger sister. We stayed there for five days. We did many things: we swam at My Khe Beach, visited the Marble Mountains, ate amazing seafood, and went to the famous Golden Bridge. The trip was memorable because it was the first time we had traveled together as a family in many years. I felt very happy and relaxed. I will never forget it.","explanation":"Tiêu chí: 1) Có cấu trúc storytelling (where-who-what-why); 2) Past simple consistent; 3) Đủ 2 phút; 4) Có chi tiết và cảm xúc."}', 3, 2);

-- =====================================================
-- 4) Bổ sung cho JLPT N5 (id=1) - thêm WRITING + SPEAKING
-- =====================================================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(1, 'WRITING', '{"question":"100字程度で「私の家族」について書いてください。","input_type":"writing","min_words":50,"max_words":150,"hint":"父、母、兄弟姉妹について"}', '{"correct":"わたしのかぞくは4にんです。ちちとははとあねとわたしです。ちちはせんせいです。ははは いしゃです。あねは だいがくせいです。わたしは こうこうせいです。わたしのかぞくは みんな しんせつです。","explanation":"Tiêu chí: dùng です/ます, ít nhất 4-5 câu, nội dung gắn kết."}', 1, 1),
(1, 'SPEAKING', '{"question":"自己紹介してください (30秒)。名前、国、学校または仕事。","input_type":"speaking","prep_seconds":15,"speak_seconds":30,"audio_text":"自己紹介してください"}', '{"correct":"はじめまして。わたしはヒエンです。ベトナムから きました。だいがくせいです。にほんごをべんきょうしています。よろしくおねがいします。","explanation":"Đủ 4 nội dung, dùng dạng です."}', 1, 1);

-- =====================================================
-- 5) Bổ sung HSK1 (id=11) - WRITING ESSAY + SPEAKING
-- =====================================================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(11, 'ESSAY', '{"question":"用50个汉字写: 我的爱好 (sở thích của tôi)","input_type":"writing","min_words":30,"max_words":80,"hint":"我喜欢..., 我每天..., 因为..."}', '{"correct":"我的爱好是看书。我每天晚上看一个小时书。我喜欢中文书，因为我可以学习汉语。看书让我很高兴。","explanation":"Tiêu chí: 30-80 chữ, dùng từ HSK1 cơ bản."}', 1, 1),
(11, 'SPEAKING', '{"question":"请你说说你自己 (30秒): 名字、年龄、学习什么","input_type":"speaking","prep_seconds":15,"speak_seconds":30,"audio_text":"请你说说你自己"}', '{"correct":"我叫小明。我今年二十岁。我是大学生。我学习汉语。很高兴认识你。","explanation":"Tên + tuổi + sở học + lời chào."}', 1, 1);

-- =====================================================
-- 6) Bổ sung CEFR A1 (id=13) - WRITING + SPEAKING
-- =====================================================
INSERT INTO mock_test_questions (mock_test_id, section, question_json, answer_json, difficulty, order_index) VALUES
(13, 'WRITING', '{"question":"Write 50-80 words about yourself. Include: name, age, country, family, hobbies.","input_type":"writing","min_words":40,"max_words":100,"hint":"Use present simple. Examples: My name is..., I am... years old, I live in..."}', '{"correct":"Hello! My name is Mai. I am 18 years old. I am from Vietnam. I live in Hanoi with my family. I have a mother, a father and a brother. I am a student. I like reading books and watching movies. My favorite color is blue. I have a small dog. His name is Lucky.","explanation":"A1: present simple, basic vocabulary, simple sentences."}', 1, 1),
(13, 'SPEAKING', '{"question":"Introduce yourself in 30 seconds. Tell me your name, age, where you are from, and what you like.","input_type":"speaking","prep_seconds":15,"speak_seconds":30,"audio_text":"Introduce yourself in 30 seconds"}', '{"correct":"Hello! My name is Mai. I am 18 years old. I am from Vietnam. I am a student. I like music and reading. Nice to meet you!","explanation":"4 nội dung + lời chào. Phát âm rõ ràng."}', 1, 1);

-- =====================================================
-- INDEX bổ sung tăng tốc query
-- =====================================================
ALTER TABLE mock_test_questions
    ADD INDEX idx_mtq_section_order (mock_test_id, section, order_index);