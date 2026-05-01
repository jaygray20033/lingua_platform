-- =====================================================================
-- V15__seed_vocab_extended.sql
-- UPGRADE-04: Seed N3 Japanese, A2/B1 English, HSK2/HSK3 Chinese vocab.
-- Compact essentials list to bootstrap higher levels (admin can extend later).
-- =====================================================================

SET @lang_jp := (SELECT id FROM languages WHERE code = 'ja' LIMIT 1);
SET @lang_en := (SELECT id FROM languages WHERE code = 'en' LIMIT 1);
SET @lang_zh := (SELECT id FROM languages WHERE code = 'zh' LIMIT 1);

-- ----- Japanese N3 (selection of 80 high-frequency N3 words) -----------
INSERT IGNORE INTO words (language_id, text, reading, romaji, pos, jlpt_level, frequency_rank) VALUES
(@lang_jp, '相手', 'あいて', 'aite', 'NOUN', 'N3', 800),
(@lang_jp, '握手', 'あくしゅ', 'akushu', 'NOUN', 'N3', 801),
(@lang_jp, '汗', 'あせ', 'ase', 'NOUN', 'N3', 802),
(@lang_jp, '与える', 'あたえる', 'ataeru', 'VERB', 'N3', 803),
(@lang_jp, '辺り', 'あたり', 'atari', 'NOUN', 'N3', 804),
(@lang_jp, '扱う', 'あつかう', 'atsukau', 'VERB', 'N3', 805),
(@lang_jp, '当てる', 'あてる', 'ateru', 'VERB', 'N3', 806),
(@lang_jp, '宛名', 'あてな', 'atena', 'NOUN', 'N3', 807),
(@lang_jp, '溢れる', 'あふれる', 'afureru', 'VERB', 'N3', 808),
(@lang_jp, '余る', 'あまる', 'amaru', 'VERB', 'N3', 809),
(@lang_jp, '怪しい', 'あやしい', 'ayashii', 'ADJ', 'N3', 810),
(@lang_jp, '案外', 'あんがい', 'angai', 'ADV', 'N3', 811),
(@lang_jp, '安心', 'あんしん', 'anshin', 'NOUN', 'N3', 812),
(@lang_jp, '安全', 'あんぜん', 'anzen', 'NOUN', 'N3', 813),
(@lang_jp, '位', 'い', 'i', 'NOUN', 'N3', 814),
(@lang_jp, '言い出す', 'いいだす', 'iidasu', 'VERB', 'N3', 815),
(@lang_jp, '言い付ける', 'いいつける', 'iitsukeru', 'VERB', 'N3', 816),
(@lang_jp, '生きる', 'いきる', 'ikiru', 'VERB', 'N3', 817),
(@lang_jp, '幾つ', 'いくつ', 'ikutsu', 'NOUN', 'N3', 818),
(@lang_jp, '幾ら', 'いくら', 'ikura', 'NOUN', 'N3', 819),
(@lang_jp, '居酒屋', 'いざかや', 'izakaya', 'NOUN', 'N3', 820),
(@lang_jp, '勇ましい', 'いさましい', 'isamashii', 'ADJ', 'N3', 821),
(@lang_jp, '意識', 'いしき', 'ishiki', 'NOUN', 'N3', 822),
(@lang_jp, '意地悪', 'いじわる', 'ijiwaru', 'NOUN', 'N3', 823),
(@lang_jp, '泉', 'いずみ', 'izumi', 'NOUN', 'N3', 824),
(@lang_jp, '依然', 'いぜん', 'izen', 'ADV', 'N3', 825),
(@lang_jp, '板', 'いた', 'ita', 'NOUN', 'N3', 826),
(@lang_jp, '至る', 'いたる', 'itaru', 'VERB', 'N3', 827),
(@lang_jp, '位置', 'いち', 'ichi', 'NOUN', 'N3', 828),
(@lang_jp, '一応', 'いちおう', 'ichiou', 'ADV', 'N3', 829),
(@lang_jp, '一時', 'いちじ', 'ichiji', 'NOUN', 'N3', 830),
(@lang_jp, '市場', 'いちば', 'ichiba', 'NOUN', 'N3', 831),
(@lang_jp, '一部', 'いちぶ', 'ichibu', 'NOUN', 'N3', 832),
(@lang_jp, '一流', 'いちりゅう', 'ichiryuu', 'NOUN', 'N3', 833),
(@lang_jp, '一家', 'いっか', 'ikka', 'NOUN', 'N3', 834),
(@lang_jp, '一種', 'いっしゅ', 'isshu', 'NOUN', 'N3', 835),
(@lang_jp, '一瞬', 'いっしゅん', 'isshun', 'NOUN', 'N3', 836),
(@lang_jp, '一生', 'いっしょう', 'isshou', 'NOUN', 'N3', 837),
(@lang_jp, '一致', 'いっち', 'icchi', 'NOUN', 'N3', 838),
(@lang_jp, '移動', 'いどう', 'idou', 'NOUN', 'N3', 839),
(@lang_jp, '稲', 'いね', 'ine', 'NOUN', 'N3', 840),
(@lang_jp, '居眠り', 'いねむり', 'inemuri', 'NOUN', 'N3', 841),
(@lang_jp, '違反', 'いはん', 'ihan', 'NOUN', 'N3', 842),
(@lang_jp, '衣服', 'いふく', 'ifuku', 'NOUN', 'N3', 843),
(@lang_jp, '今に', 'いまに', 'imani', 'ADV', 'N3', 844),
(@lang_jp, '今にも', 'いまにも', 'imanimo', 'ADV', 'N3', 845),
(@lang_jp, '依頼', 'いらい', 'irai', 'NOUN', 'N3', 846),
(@lang_jp, '医療', 'いりょう', 'iryou', 'NOUN', 'N3', 847),
(@lang_jp, '岩', 'いわ', 'iwa', 'NOUN', 'N3', 848),
(@lang_jp, '祝う', 'いわう', 'iwau', 'VERB', 'N3', 849),
(@lang_jp, '印刷', 'いんさつ', 'insatsu', 'NOUN', 'N3', 850),
(@lang_jp, '引退', 'いんたい', 'intai', 'NOUN', 'N3', 851),
(@lang_jp, '引用', 'いんよう', 'inyou', 'NOUN', 'N3', 852),
(@lang_jp, '請ける', 'うける', 'ukeru', 'VERB', 'N3', 853),
(@lang_jp, '受け取る', 'うけとる', 'uketoru', 'VERB', 'N3', 854),
(@lang_jp, '宇宙', 'うちゅう', 'uchuu', 'NOUN', 'N3', 855),
(@lang_jp, '腕', 'うで', 'ude', 'NOUN', 'N3', 856),
(@lang_jp, '裏', 'うら', 'ura', 'NOUN', 'N3', 857),
(@lang_jp, '売り上げ', 'うりあげ', 'uriage', 'NOUN', 'N3', 858),
(@lang_jp, '映像', 'えいぞう', 'eizou', 'NOUN', 'N3', 859),
(@lang_jp, '影響', 'えいきょう', 'eikyou', 'NOUN', 'N3', 860),
(@lang_jp, '営業', 'えいぎょう', 'eigyou', 'NOUN', 'N3', 861),
(@lang_jp, '描く', 'えがく', 'egaku', 'VERB', 'N3', 862),
(@lang_jp, '笑顔', 'えがお', 'egao', 'NOUN', 'N3', 863),
(@lang_jp, '宴会', 'えんかい', 'enkai', 'NOUN', 'N3', 864),
(@lang_jp, '延期', 'えんき', 'enki', 'NOUN', 'N3', 865),
(@lang_jp, '演技', 'えんぎ', 'engi', 'NOUN', 'N3', 866),
(@lang_jp, '応援', 'おうえん', 'ouen', 'NOUN', 'N3', 867),
(@lang_jp, '応募', 'おうぼ', 'oubo', 'NOUN', 'N3', 868),
(@lang_jp, '大いに', 'おおいに', 'ooini', 'ADV', 'N3', 869),
(@lang_jp, '覆う', 'おおう', 'oou', 'VERB', 'N3', 870),
(@lang_jp, '大家', 'おおや', 'ooya', 'NOUN', 'N3', 871),
(@lang_jp, '丘', 'おか', 'oka', 'NOUN', 'N3', 872),
(@lang_jp, '行い', 'おこない', 'okonai', 'NOUN', 'N3', 873),
(@lang_jp, '幼い', 'おさない', 'osanai', 'ADJ', 'N3', 874),
(@lang_jp, '収める', 'おさめる', 'osameru', 'VERB', 'N3', 875),
(@lang_jp, '恐らく', 'おそらく', 'osoraku', 'ADV', 'N3', 876),
(@lang_jp, '恐れる', 'おそれる', 'osoreru', 'VERB', 'N3', 877),
(@lang_jp, '恐ろしい', 'おそろしい', 'osoroshii', 'ADJ', 'N3', 878),
(@lang_jp, '落ち着く', 'おちつく', 'ochitsuku', 'VERB', 'N3', 879);

-- ----- English A2 / B1 (60 words) ---------------------------------------
INSERT IGNORE INTO words (language_id, text, reading, romaji, pos, cefr_level, frequency_rank) VALUES
(@lang_en, 'achievement', NULL, 'achievement', 'NOUN', 'A2', 100),
(@lang_en, 'advantage', NULL, 'advantage', 'NOUN', 'A2', 101),
(@lang_en, 'advice', NULL, 'advice', 'NOUN', 'A2', 102),
(@lang_en, 'allow', NULL, 'allow', 'VERB', 'A2', 103),
(@lang_en, 'amazing', NULL, 'amazing', 'ADJ', 'A2', 104),
(@lang_en, 'announce', NULL, 'announce', 'VERB', 'A2', 105),
(@lang_en, 'available', NULL, 'available', 'ADJ', 'A2', 106),
(@lang_en, 'borrow', NULL, 'borrow', 'VERB', 'A2', 107),
(@lang_en, 'celebrate', NULL, 'celebrate', 'VERB', 'A2', 108),
(@lang_en, 'choice', NULL, 'choice', 'NOUN', 'A2', 109),
(@lang_en, 'comfortable', NULL, 'comfortable', 'ADJ', 'A2', 110),
(@lang_en, 'community', NULL, 'community', 'NOUN', 'A2', 111),
(@lang_en, 'confident', NULL, 'confident', 'ADJ', 'A2', 112),
(@lang_en, 'creative', NULL, 'creative', 'ADJ', 'A2', 113),
(@lang_en, 'culture', NULL, 'culture', 'NOUN', 'A2', 114),
(@lang_en, 'decision', NULL, 'decision', 'NOUN', 'A2', 115),
(@lang_en, 'develop', NULL, 'develop', 'VERB', 'A2', 116),
(@lang_en, 'discover', NULL, 'discover', 'VERB', 'A2', 117),
(@lang_en, 'effective', NULL, 'effective', 'ADJ', 'A2', 118),
(@lang_en, 'environment', NULL, 'environment', 'NOUN', 'A2', 119),
(@lang_en, 'experience', NULL, 'experience', 'NOUN', 'A2', 120),
(@lang_en, 'foreign', NULL, 'foreign', 'ADJ', 'A2', 121),
(@lang_en, 'generous', NULL, 'generous', 'ADJ', 'A2', 122),
(@lang_en, 'health', NULL, 'health', 'NOUN', 'A2', 123),
(@lang_en, 'imagine', NULL, 'imagine', 'VERB', 'A2', 124),
(@lang_en, 'improve', NULL, 'improve', 'VERB', 'A2', 125),
(@lang_en, 'invent', NULL, 'invent', 'VERB', 'A2', 126),
(@lang_en, 'journey', NULL, 'journey', 'NOUN', 'A2', 127),
(@lang_en, 'language', NULL, 'language', 'NOUN', 'A2', 128),
(@lang_en, 'memory', NULL, 'memory', 'NOUN', 'A2', 129),
-- B1
(@lang_en, 'analyze', NULL, 'analyze', 'VERB', 'B1', 130),
(@lang_en, 'appreciate', NULL, 'appreciate', 'VERB', 'B1', 131),
(@lang_en, 'argument', NULL, 'argument', 'NOUN', 'B1', 132),
(@lang_en, 'awareness', NULL, 'awareness', 'NOUN', 'B1', 133),
(@lang_en, 'behaviour', NULL, 'behaviour', 'NOUN', 'B1', 134),
(@lang_en, 'challenge', NULL, 'challenge', 'NOUN', 'B1', 135),
(@lang_en, 'circumstance', NULL, 'circumstance', 'NOUN', 'B1', 136),
(@lang_en, 'consider', NULL, 'consider', 'VERB', 'B1', 137),
(@lang_en, 'consequence', NULL, 'consequence', 'NOUN', 'B1', 138),
(@lang_en, 'considerable', NULL, 'considerable', 'ADJ', 'B1', 139),
(@lang_en, 'contribute', NULL, 'contribute', 'VERB', 'B1', 140),
(@lang_en, 'demonstrate', NULL, 'demonstrate', 'VERB', 'B1', 141),
(@lang_en, 'eliminate', NULL, 'eliminate', 'VERB', 'B1', 142),
(@lang_en, 'establish', NULL, 'establish', 'VERB', 'B1', 143),
(@lang_en, 'evaluate', NULL, 'evaluate', 'VERB', 'B1', 144),
(@lang_en, 'evidence', NULL, 'evidence', 'NOUN', 'B1', 145),
(@lang_en, 'familiar', NULL, 'familiar', 'ADJ', 'B1', 146),
(@lang_en, 'identify', NULL, 'identify', 'VERB', 'B1', 147),
(@lang_en, 'illustrate', NULL, 'illustrate', 'VERB', 'B1', 148),
(@lang_en, 'impact', NULL, 'impact', 'NOUN', 'B1', 149),
(@lang_en, 'involve', NULL, 'involve', 'VERB', 'B1', 150),
(@lang_en, 'maintain', NULL, 'maintain', 'VERB', 'B1', 151),
(@lang_en, 'negotiate', NULL, 'negotiate', 'VERB', 'B1', 152),
(@lang_en, 'observation', NULL, 'observation', 'NOUN', 'B1', 153),
(@lang_en, 'opportunity', NULL, 'opportunity', 'NOUN', 'B1', 154),
(@lang_en, 'previous', NULL, 'previous', 'ADJ', 'B1', 155),
(@lang_en, 'proportion', NULL, 'proportion', 'NOUN', 'B1', 156),
(@lang_en, 'recognize', NULL, 'recognize', 'VERB', 'B1', 157),
(@lang_en, 'sufficient', NULL, 'sufficient', 'ADJ', 'B1', 158),
(@lang_en, 'tendency', NULL, 'tendency', 'NOUN', 'B1', 159);

-- ----- Chinese HSK2/HSK3 (60 words) -------------------------------------
INSERT IGNORE INTO words (language_id, text, reading, romaji, pos, hsk_level, frequency_rank) VALUES
-- HSK2
(@lang_zh, '帮助', 'bāngzhù', 'bangzhu', 'VERB', 'HSK2', 200),
(@lang_zh, '报纸', 'bàozhǐ', 'baozhi', 'NOUN', 'HSK2', 201),
(@lang_zh, '比', 'bǐ', 'bi', 'PARTICLE', 'HSK2', 202),
(@lang_zh, '别', 'bié', 'bie', 'ADV', 'HSK2', 203),
(@lang_zh, '宾馆', 'bīnguǎn', 'binguan', 'NOUN', 'HSK2', 204),
(@lang_zh, '长', 'cháng', 'chang', 'ADJ', 'HSK2', 205),
(@lang_zh, '唱歌', 'chànggē', 'changge', 'VERB', 'HSK2', 206),
(@lang_zh, '出', 'chū', 'chu', 'VERB', 'HSK2', 207),
(@lang_zh, '穿', 'chuān', 'chuan', 'VERB', 'HSK2', 208),
(@lang_zh, '次', 'cì', 'ci', 'CLASSIFIER', 'HSK2', 209),
(@lang_zh, '从', 'cóng', 'cong', 'PREP', 'HSK2', 210),
(@lang_zh, '错', 'cuò', 'cuo', 'ADJ', 'HSK2', 211),
(@lang_zh, '打篮球', 'dǎ lánqiú', 'da lanqiu', 'VERB', 'HSK2', 212),
(@lang_zh, '大家', 'dàjiā', 'dajia', 'PRON', 'HSK2', 213),
(@lang_zh, '到', 'dào', 'dao', 'VERB', 'HSK2', 214),
(@lang_zh, '得', 'de', 'de', 'PARTICLE', 'HSK2', 215),
(@lang_zh, '等', 'děng', 'deng', 'VERB', 'HSK2', 216),
(@lang_zh, '弟弟', 'dìdi', 'didi', 'NOUN', 'HSK2', 217),
(@lang_zh, '第一', 'dì yī', 'di yi', 'NUM', 'HSK2', 218),
(@lang_zh, '懂', 'dǒng', 'dong', 'VERB', 'HSK2', 219),
(@lang_zh, '对', 'duì', 'dui', 'ADJ', 'HSK2', 220),
(@lang_zh, '房间', 'fángjiān', 'fangjian', 'NOUN', 'HSK2', 221),
(@lang_zh, '非常', 'fēicháng', 'feichang', 'ADV', 'HSK2', 222),
(@lang_zh, '服务员', 'fúwùyuán', 'fuwuyuan', 'NOUN', 'HSK2', 223),
(@lang_zh, '高', 'gāo', 'gao', 'ADJ', 'HSK2', 224),
(@lang_zh, '告诉', 'gàosù', 'gaosu', 'VERB', 'HSK2', 225),
(@lang_zh, '哥哥', 'gēge', 'gege', 'NOUN', 'HSK2', 226),
(@lang_zh, '给', 'gěi', 'gei', 'VERB', 'HSK2', 227),
(@lang_zh, '公司', 'gōngsī', 'gongsi', 'NOUN', 'HSK2', 228),
(@lang_zh, '贵', 'guì', 'gui', 'ADJ', 'HSK2', 229),
-- HSK3
(@lang_zh, '阿姨', 'āyí', 'ayi', 'NOUN', 'HSK3', 300),
(@lang_zh, '安静', 'ānjìng', 'anjing', 'ADJ', 'HSK3', 301),
(@lang_zh, '把', 'bǎ', 'ba', 'PARTICLE', 'HSK3', 302),
(@lang_zh, '搬', 'bān', 'ban', 'VERB', 'HSK3', 303),
(@lang_zh, '办法', 'bànfǎ', 'banfa', 'NOUN', 'HSK3', 304),
(@lang_zh, '办公室', 'bàngōngshì', 'bangongshi', 'NOUN', 'HSK3', 305),
(@lang_zh, '半', 'bàn', 'ban', 'NUM', 'HSK3', 306),
(@lang_zh, '帮忙', 'bāngmáng', 'bangmang', 'VERB', 'HSK3', 307),
(@lang_zh, '包', 'bāo', 'bao', 'NOUN', 'HSK3', 308),
(@lang_zh, '饱', 'bǎo', 'bao', 'ADJ', 'HSK3', 309),
(@lang_zh, '北方', 'běifāng', 'beifang', 'NOUN', 'HSK3', 310),
(@lang_zh, '被', 'bèi', 'bei', 'PARTICLE', 'HSK3', 311),
(@lang_zh, '鼻子', 'bízi', 'bizi', 'NOUN', 'HSK3', 312),
(@lang_zh, '比较', 'bǐjiào', 'bijiao', 'ADV', 'HSK3', 313),
(@lang_zh, '比赛', 'bǐsài', 'bisai', 'NOUN', 'HSK3', 314),
(@lang_zh, '必须', 'bìxū', 'bixu', 'AUX', 'HSK3', 315),
(@lang_zh, '变化', 'biànhuà', 'bianhua', 'NOUN', 'HSK3', 316),
(@lang_zh, '别人', 'biérén', 'bieren', 'PRON', 'HSK3', 317),
(@lang_zh, '冰箱', 'bīngxiāng', 'bingxiang', 'NOUN', 'HSK3', 318),
(@lang_zh, '不但', 'bùdàn', 'budan', 'CONJ', 'HSK3', 319),
(@lang_zh, '菜单', 'càidān', 'caidan', 'NOUN', 'HSK3', 320),
(@lang_zh, '参加', 'cānjiā', 'canjia', 'VERB', 'HSK3', 321),
(@lang_zh, '草', 'cǎo', 'cao', 'NOUN', 'HSK3', 322),
(@lang_zh, '层', 'céng', 'ceng', 'CLASSIFIER', 'HSK3', 323),
(@lang_zh, '差', 'chà', 'cha', 'ADJ', 'HSK3', 324),
(@lang_zh, '超市', 'chāoshì', 'chaoshi', 'NOUN', 'HSK3', 325),
(@lang_zh, '衬衫', 'chènshān', 'chenshan', 'NOUN', 'HSK3', 326),
(@lang_zh, '城市', 'chéngshì', 'chengshi', 'NOUN', 'HSK3', 327),
(@lang_zh, '迟到', 'chídào', 'chidao', 'VERB', 'HSK3', 328),
(@lang_zh, '除了', 'chúle', 'chule', 'PREP', 'HSK3', 329);

-- Auto-generate base meanings for new words (Vietnamese)
SET @lang_vi := (SELECT id FROM languages WHERE code = 'vi' LIMIT 1);
INSERT IGNORE INTO word_meanings (word_id, translation_lang_id, meaning)
SELECT w.id, @lang_vi,
  CASE w.romaji
    -- N3 sample
    WHEN 'aite' THEN 'đối tác, đối phương' WHEN 'akushu' THEN 'bắt tay'
    WHEN 'ase' THEN 'mồ hôi' WHEN 'ataeru' THEN 'ban cho, cấp cho'
    WHEN 'atsukau' THEN 'xử lý' WHEN 'ateru' THEN 'đoán, áp vào'
    WHEN 'anshin' THEN 'an tâm' WHEN 'anzen' THEN 'an toàn'
    WHEN 'ikiru' THEN 'sống' WHEN 'ishiki' THEN 'ý thức'
    WHEN 'ichiba' THEN 'chợ' WHEN 'idou' THEN 'di chuyển'
    WHEN 'eikyou' THEN 'ảnh hưởng' WHEN 'eigyou' THEN 'kinh doanh'
    WHEN 'egao' THEN 'nụ cười' WHEN 'ouen' THEN 'cổ vũ'
    WHEN 'oubo' THEN 'đăng ký, ứng tuyển' WHEN 'osanai' THEN 'còn nhỏ, ngây thơ'
    WHEN 'osoreru' THEN 'sợ hãi'
    -- English A2/B1
    WHEN 'achievement' THEN 'thành tựu' WHEN 'advantage' THEN 'lợi thế'
    WHEN 'advice' THEN 'lời khuyên' WHEN 'allow' THEN 'cho phép'
    WHEN 'amazing' THEN 'tuyệt vời' WHEN 'announce' THEN 'thông báo'
    WHEN 'available' THEN 'sẵn có' WHEN 'borrow' THEN 'mượn'
    WHEN 'celebrate' THEN 'kỷ niệm, ăn mừng' WHEN 'choice' THEN 'lựa chọn'
    WHEN 'comfortable' THEN 'thoải mái' WHEN 'community' THEN 'cộng đồng'
    WHEN 'confident' THEN 'tự tin' WHEN 'creative' THEN 'sáng tạo'
    WHEN 'culture' THEN 'văn hóa' WHEN 'decision' THEN 'quyết định'
    WHEN 'develop' THEN 'phát triển' WHEN 'discover' THEN 'khám phá'
    WHEN 'effective' THEN 'hiệu quả' WHEN 'environment' THEN 'môi trường'
    WHEN 'experience' THEN 'trải nghiệm' WHEN 'foreign' THEN 'nước ngoài'
    WHEN 'generous' THEN 'hào phóng' WHEN 'health' THEN 'sức khỏe'
    WHEN 'imagine' THEN 'tưởng tượng' WHEN 'improve' THEN 'cải thiện'
    WHEN 'invent' THEN 'phát minh' WHEN 'journey' THEN 'hành trình'
    WHEN 'language' THEN 'ngôn ngữ' WHEN 'memory' THEN 'trí nhớ'
    WHEN 'analyze' THEN 'phân tích' WHEN 'appreciate' THEN 'đánh giá cao'
    WHEN 'argument' THEN 'lý lẽ, tranh luận' WHEN 'awareness' THEN 'sự nhận thức'
    WHEN 'behaviour' THEN 'hành vi' WHEN 'challenge' THEN 'thách thức'
    WHEN 'circumstance' THEN 'hoàn cảnh' WHEN 'consider' THEN 'xem xét'
    WHEN 'consequence' THEN 'hệ quả' WHEN 'considerable' THEN 'đáng kể'
    WHEN 'contribute' THEN 'đóng góp' WHEN 'demonstrate' THEN 'minh chứng'
    WHEN 'eliminate' THEN 'loại bỏ' WHEN 'establish' THEN 'thành lập'
    WHEN 'evaluate' THEN 'đánh giá' WHEN 'evidence' THEN 'bằng chứng'
    WHEN 'familiar' THEN 'quen thuộc' WHEN 'identify' THEN 'nhận dạng'
    WHEN 'illustrate' THEN 'minh họa' WHEN 'impact' THEN 'tác động'
    WHEN 'involve' THEN 'liên quan, bao hàm' WHEN 'maintain' THEN 'duy trì'
    WHEN 'negotiate' THEN 'thương lượng' WHEN 'observation' THEN 'sự quan sát'
    WHEN 'opportunity' THEN 'cơ hội' WHEN 'previous' THEN 'trước đó'
    WHEN 'proportion' THEN 'tỷ lệ' WHEN 'recognize' THEN 'công nhận'
    WHEN 'sufficient' THEN 'đủ' WHEN 'tendency' THEN 'xu hướng'
    -- Chinese HSK2/3
    WHEN 'bangzhu' THEN 'giúp đỡ' WHEN 'baozhi' THEN 'báo'
    WHEN 'bi' THEN 'so với' WHEN 'bie' THEN 'đừng'
    WHEN 'binguan' THEN 'khách sạn' WHEN 'chang' THEN 'dài'
    WHEN 'changge' THEN 'hát' WHEN 'chu' THEN 'ra ngoài'
    WHEN 'chuan' THEN 'mặc' WHEN 'ci' THEN 'lượt, lần'
    WHEN 'cong' THEN 'từ' WHEN 'cuo' THEN 'sai'
    WHEN 'da lanqiu' THEN 'chơi bóng rổ' WHEN 'dajia' THEN 'mọi người'
    WHEN 'dao' THEN 'đến' WHEN 'deng' THEN 'chờ đợi'
    WHEN 'didi' THEN 'em trai' WHEN 'di yi' THEN 'thứ nhất'
    WHEN 'dong' THEN 'hiểu' WHEN 'dui' THEN 'đúng'
    WHEN 'fangjian' THEN 'phòng' WHEN 'feichang' THEN 'rất, vô cùng'
    WHEN 'fuwuyuan' THEN 'nhân viên phục vụ' WHEN 'gao' THEN 'cao'
    WHEN 'gaosu' THEN 'nói cho biết' WHEN 'gege' THEN 'anh trai'
    WHEN 'gei' THEN 'đưa, cho' WHEN 'gongsi' THEN 'công ty'
    WHEN 'gui' THEN 'đắt' WHEN 'ayi' THEN 'cô, dì'
    WHEN 'anjing' THEN 'yên tĩnh' WHEN 'ban' THEN 'di chuyển'
    WHEN 'banfa' THEN 'cách thức' WHEN 'bangongshi' THEN 'văn phòng'
    WHEN 'bangmang' THEN 'giúp đỡ' WHEN 'bao' THEN 'túi, gói'
    WHEN 'beifang' THEN 'phương Bắc' WHEN 'bizi' THEN 'mũi'
    WHEN 'bijiao' THEN 'so sánh, tương đối' WHEN 'bisai' THEN 'cuộc thi'
    WHEN 'bixu' THEN 'phải' WHEN 'bianhua' THEN 'biến hóa, thay đổi'
    WHEN 'bieren' THEN 'người khác' WHEN 'bingxiang' THEN 'tủ lạnh'
    WHEN 'budan' THEN 'không những' WHEN 'caidan' THEN 'thực đơn'
    WHEN 'canjia' THEN 'tham gia' WHEN 'cao' THEN 'cỏ'
    WHEN 'ceng' THEN 'tầng (lượng từ)' WHEN 'cha' THEN 'kém, tệ'
    WHEN 'chaoshi' THEN 'siêu thị' WHEN 'chenshan' THEN 'áo sơ mi'
    WHEN 'chengshi' THEN 'thành phố' WHEN 'chidao' THEN 'đến muộn'
    WHEN 'chule' THEN 'ngoài ra'
    ELSE CONCAT('(', COALESCE(w.romaji, w.text), ')')
  END
FROM words w
WHERE (
       (w.language_id = @lang_jp AND w.jlpt_level = 'N3' AND w.frequency_rank BETWEEN 800 AND 879)
    OR (w.language_id = @lang_en AND w.cefr_level IN ('A2','B1') AND w.frequency_rank BETWEEN 100 AND 159)
    OR (w.language_id = @lang_zh AND w.hsk_level IN ('HSK2','HSK3') AND w.frequency_rank BETWEEN 200 AND 329)
)
AND NOT EXISTS (SELECT 1 FROM word_meanings wm WHERE wm.word_id = w.id);
