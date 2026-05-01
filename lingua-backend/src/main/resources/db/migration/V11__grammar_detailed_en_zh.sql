-- =====================================================
-- V11: Grammar chi tiết ENGLISH (CEFR) + CHINESE (HSK)
-- explanation, examples, exercises
-- =====================================================

SET @lang_en = 2;
SET @lang_zh = 3;

-- ============================================================
-- ENGLISH GRAMMAR - chi tiết explanation
-- ============================================================

UPDATE grammars
SET explanation_vi = 'Thì hiện tại đơn (Present Simple) dùng để diễn tả:\n\n1️⃣ Thói quen, hành động lặp lại: I drink coffee every morning.\n2️⃣ Sự thật hiển nhiên, chân lý: The sun rises in the east.\n3️⃣ Lịch trình cố định: The train leaves at 8am.\n4️⃣ Cảm xúc, sở thích, trạng thái: I love music. She knows him.\n\n📐 Quy tắc chia ngôi 3 số ít (he/she/it):\n• Đa số: thêm -s (work → works)\n• Tận cùng -ss/-sh/-ch/-x/-o: thêm -es (watch → watches, go → goes)\n• Tận cùng phụ âm + y: đổi y thành i + es (study → studies)\n\n❓ Cấu trúc câu hỏi/phủ định:\n• I/You/We/They: Do + S + V? / S + don''t + V\n• He/She/It: Does + S + V? / S + doesn''t + V',
    explanation_en = 'Present Simple is used for habits, repeated actions, general truths, fixed schedules, and states. Add -s/-es for he/she/it. Use do/does for questions and negatives.',
    formation = '(+) S + V(s/es)\n(-) S + do/does + not + V\n(?) Do/Does + S + V?',
    usage_context = 'Văn nói và viết hằng ngày, mô tả thói quen, sự thật, kế hoạch cố định.',
    common_mistakes = '❌ He go to school → ✅ He goes to school\n❌ She don''t like → ✅ She doesn''t like\n❌ Do he work? → ✅ Does he work?\n❌ I am go → ✅ I go (không có am/is/are với động từ thường)',
    related_patterns = 'Present Continuous (đang ~), Present Perfect (đã ~)',
    difficulty_score = 1
WHERE language_id = @lang_en AND pattern = 'Present Simple';

UPDATE grammars
SET explanation_vi = 'Thì hiện tại tiếp diễn (Present Continuous) diễn tả:\n\n1️⃣ Hành động đang xảy ra ngay lúc nói: She is reading now.\n2️⃣ Hành động tạm thời trong giai đoạn này: I am living in Hanoi this month.\n3️⃣ Kế hoạch tương lai gần đã sắp xếp: We are meeting at 7pm tomorrow.\n4️⃣ Hành động lặp đi lặp lại với always (phàn nàn): He is always complaining!\n\n📐 Quy tắc thêm -ing:\n• Đa số: thêm -ing (work → working)\n• Tận cùng -e: bỏ e + ing (write → writing)\n• Phụ âm + nguyên âm + phụ âm: gấp đôi phụ âm cuối (run → running, sit → sitting)\n• Tận cùng -ie: đổi ie thành y + ing (lie → lying)\n\n⚠️ Động từ KHÔNG dùng tiếp diễn: love, like, know, want, need, see, hear, understand, believe...',
    explanation_en = 'Present Continuous expresses actions happening now, temporary situations, future arrangements, and repeated complaints with always. Use am/is/are + V-ing.',
    formation = '(+) S + am/is/are + V-ing\n(-) S + am/is/are + not + V-ing\n(?) Am/Is/Are + S + V-ing?',
    usage_context = 'Hành động ngay lúc này hoặc trong khoảng thời gian gần đây.',
    common_mistakes = '❌ I am know him → ✅ I know him (stative verb)\n❌ She is having a car → ✅ She has a car (sở hữu)\n❌ He runing → ✅ He running (gấp đôi n: running)',
    related_patterns = 'Present Simple, Past Continuous',
    difficulty_score = 1
WHERE language_id = @lang_en AND pattern = 'Present Continuous';

UPDATE grammars
SET explanation_vi = 'Thì quá khứ đơn (Past Simple) diễn tả hành động đã hoàn thành trong quá khứ.\n\n📌 Dấu hiệu: yesterday, ago, last (week/month/year), in 2020, when I was young...\n\n📐 Cách chia động từ:\n• Động từ có quy tắc: thêm -ed (work → worked)\n• Tận cùng -e: thêm -d (live → lived)\n• Phụ âm + y: đổi y thành i + ed (study → studied)\n• Phụ âm-nguyên âm-phụ âm: gấp đôi (stop → stopped)\n• Động từ bất quy tắc: phải học thuộc (go → went, eat → ate, see → saw...)\n\n❓ Câu hỏi/phủ định DÙNG ''did'' và động từ trở về dạng nguyên:\n• Did + S + V? (Did she go? KHÔNG phải Did she went?)\n• S + did not (didn''t) + V',
    explanation_en = 'Past Simple is used for completed actions in the past. Regular verbs add -ed; irregular verbs must be memorized. Use did for questions and negatives, with the verb returning to base form.',
    formation = '(+) S + V2/V-ed\n(-) S + did not (didn''t) + V (base)\n(?) Did + S + V (base)?',
    usage_context = 'Kể chuyện, miêu tả sự kiện đã xảy ra và đã kết thúc.',
    common_mistakes = '❌ Did she went? → ✅ Did she go?\n❌ I didn''t went → ✅ I didn''t go\n❌ He goed → ✅ He went (irregular)\n❌ stoped → ✅ stopped (gấp đôi p)',
    related_patterns = 'Past Continuous, Present Perfect, Used to',
    difficulty_score = 1
WHERE language_id = @lang_en AND pattern = 'Past Simple';

UPDATE grammars
SET explanation_vi = 'Thì hiện tại hoàn thành (Present Perfect) dùng để diễn tả:\n\n1️⃣ Kinh nghiệm đến hiện tại: I have been to Japan. (đã từng)\n2️⃣ Hành động vừa hoàn thành: She has just finished. (vừa xong)\n3️⃣ Hành động bắt đầu trong quá khứ và còn tiếp diễn: I have lived here for 5 years. (5 năm vẫn đang sống)\n4️⃣ Sự thay đổi qua thời gian: He has grown a lot.\n\n📌 Dấu hiệu: ever, never, just, already, yet, recently, since, for, so far...\n\n🆚 Phân biệt với Past Simple:\n• Past Simple: hành động đã kết thúc, có thời điểm cụ thể\n  → I went to Paris last year.\n• Present Perfect: liên hệ với hiện tại, không cần thời điểm cụ thể\n  → I have been to Paris. (kinh nghiệm sống đến giờ)',
    explanation_en = 'Present Perfect connects past to present. Used for experiences (ever/never), recently completed actions (just/already), unfinished situations (since/for), and changes over time. Use have/has + past participle (V3).',
    formation = '(+) S + have/has + V3\n(-) S + have/has + not + V3\n(?) Have/Has + S + V3?',
    usage_context = 'Kết nối quá khứ với hiện tại, không xác định thời điểm cụ thể.',
    common_mistakes = '❌ I have seen him yesterday → ✅ I saw him yesterday (yesterday → past simple)\n❌ I have lived here since 5 years → ✅ since 2020 / for 5 years\n❌ She have done → ✅ She has done',
    related_patterns = 'Past Simple, Present Perfect Continuous',
    difficulty_score = 3
WHERE language_id = @lang_en AND pattern = 'Present Perfect';

UPDATE grammars
SET explanation_vi = 'Câu điều kiện loại 1 (First Conditional) diễn tả tình huống có khả năng xảy ra trong tương lai.\n\n📐 Cấu trúc:\n  If + S + V (hiện tại đơn), S + will/can/may + V (nguyên)\n\n📌 Ví dụ:\n• If it rains tomorrow, we will stay home. (Nếu mai mưa, chúng tôi sẽ ở nhà)\n• If you study hard, you will pass the exam.\n• If I have time, I''ll call you.\n\n💡 Có thể đảo vị trí mệnh đề (không cần dấu phẩy):\n  We will stay home if it rains tomorrow.\n\n🆚 Phân biệt:\n• Loại 1 (real): If + V hiện tại, will + V → khả năng có thể\n• Loại 2 (unreal present): If + V quá khứ, would + V → giả định trái thực tế\n• Loại 3 (unreal past): If + had + V3, would have + V3 → quá khứ trái thực tế',
    explanation_en = 'First Conditional describes possible/realistic future situations. Structure: If + present simple, will + verb. Used for real possibilities.',
    formation = 'If + S + V (present), S + will/can/may + V (base)',
    usage_context = 'Dự đoán tương lai có khả năng xảy ra, lời khuyên, cảnh báo, hứa hẹn.',
    common_mistakes = '❌ If I will see him → ✅ If I see him (mệnh đề if dùng hiện tại)\n❌ If he comes, I going → ✅ I will go\n❌ If I would have time → ✅ If I have time',
    related_patterns = 'Second/Third Conditional, Zero Conditional, Unless',
    difficulty_score = 2
WHERE language_id = @lang_en AND pattern = 'First Conditional';

-- ============================================================
-- ENGLISH GRAMMAR - examples
-- ============================================================
INSERT INTO grammar_examples (grammar_id, sentence, translation_vi, translation_en, note, order_index) VALUES
(300, 'I work in a hospital.', 'Tôi làm việc ở bệnh viện.', 'I work in a hospital.', 'Hiện tại đơn - thói quen', 1),
(300, 'She speaks three languages.', 'Cô ấy nói 3 ngôn ngữ.', 'She speaks three languages.', '3 ngôi: thêm -s', 2),
(300, 'Water boils at 100 degrees Celsius.', 'Nước sôi ở 100 độ C.', 'Water boils at 100 degrees Celsius.', 'Sự thật khoa học', 3),
(300, 'Does he play tennis?', 'Anh ấy có chơi tennis không?', 'Does he play tennis?', 'Câu hỏi với does', 4),
(300, 'They don''t live in Hanoi.', 'Họ không sống ở Hà Nội.', 'They don''t live in Hanoi.', 'Phủ định với don''t', 5);

INSERT INTO grammar_examples (grammar_id, sentence, translation_vi, translation_en, note, order_index) VALUES
(301, 'She is studying English now.', 'Cô ấy đang học tiếng Anh bây giờ.', 'She is studying English now.', 'Đang xảy ra', 1),
(301, 'They are working on a new project.', 'Họ đang làm một dự án mới.', 'They are working on a new project.', 'Trong giai đoạn này', 2),
(301, 'I am meeting John at 5pm.', 'Tôi sẽ gặp John lúc 5h chiều.', 'I am meeting John at 5pm.', 'Kế hoạch sắp xếp sẵn', 3),
(301, 'He is always losing his keys!', 'Anh ấy luôn mất chìa khóa!', 'He is always losing his keys!', 'Phàn nàn với always', 4);

INSERT INTO grammar_examples (grammar_id, sentence, translation_vi, translation_en, note, order_index) VALUES
(302, 'I visited Paris last summer.', 'Tôi đã thăm Paris hè năm ngoái.', 'I visited Paris last summer.', 'Quá khứ + last', 1),
(302, 'She didn''t come to the party.', 'Cô ấy đã không đến bữa tiệc.', 'She didn''t come to the party.', 'Phủ định với didn''t', 2),
(302, 'Did you watch the movie?', 'Bạn đã xem bộ phim chưa?', 'Did you watch the movie?', 'Câu hỏi với did', 3),
(302, 'He went to school by bus.', 'Anh ấy đã đi học bằng xe buýt.', 'He went to school by bus.', 'Bất quy tắc: go → went', 4);

INSERT INTO grammar_examples (grammar_id, sentence, translation_vi, translation_en, note, order_index) VALUES
(320, 'I have visited Japan twice.', 'Tôi đã thăm Nhật 2 lần.', 'I have visited Japan twice.', 'Kinh nghiệm', 1),
(320, 'She has just finished her homework.', 'Cô ấy vừa làm xong bài tập.', 'She has just finished her homework.', 'Vừa hoàn thành với just', 2),
(320, 'We have lived here since 2020.', 'Chúng tôi sống ở đây từ 2020.', 'We have lived here since 2020.', 'Bắt đầu trong quá khứ - vẫn còn', 3),
(320, 'Have you ever been to London?', 'Bạn đã từng đến London chưa?', 'Have you ever been to London?', 'Hỏi kinh nghiệm với ever', 4);

INSERT INTO grammar_examples (grammar_id, sentence, translation_vi, translation_en, note, order_index) VALUES
(323, 'If it rains, we will stay home.', 'Nếu trời mưa, chúng tôi sẽ ở nhà.', 'If it rains, we will stay home.', 'First conditional cơ bản', 1),
(323, 'If you study hard, you will pass.', 'Nếu bạn học chăm, bạn sẽ đỗ.', 'If you study hard, you will pass.', 'Hậu quả tích cực', 2),
(323, 'I won''t go out if I''m tired.', 'Tôi sẽ không đi nếu mệt.', 'I won''t go out if I''m tired.', 'Đảo vị trí mệnh đề', 3),
(323, 'If she calls, tell her I''m busy.', 'Nếu cô ấy gọi, hãy nói tôi đang bận.', 'If she calls, tell her I''m busy.', 'Mệnh lệnh ở mệnh đề chính', 4);

-- ============================================================
-- ENGLISH GRAMMAR - exercises
-- ============================================================
INSERT INTO grammar_exercises (grammar_id, type, question_json, answer_json, explanation, difficulty, order_index) VALUES
(300, 'MULTIPLE_CHOICE',
 '{"question":"Choose the correct sentence.","options":["He go to school every day.","He goes to school every day.","He going to school every day.","He gone to school every day."]}',
 '{"correct":1}', 'Với he/she/it phải thêm -s/-es: go → goes.', 1, 1),
(300, 'FILL_BLANK',
 '{"question":"Fill in: She _____ (study) English on Mondays."}',
 '{"correct":"studies","alternatives":["studies."]}', 'study → studies (phụ âm+y → đổi y thành i+es).', 1, 2),
(300, 'MULTIPLE_CHOICE',
 '{"question":"Choose the correct question form.","options":["Do he like coffee?","Does he likes coffee?","Does he like coffee?","Is he like coffee?"]}',
 '{"correct":2}', 'Câu hỏi với he/she/it: Does + S + V (base form).', 1, 3),

(301, 'MULTIPLE_CHOICE',
 '{"question":"Right now, the children _____ in the garden.","options":["play","plays","are playing","is playing"]}',
 '{"correct":2}', 'Right now → present continuous. Children = số nhiều → are.', 1, 1),
(301, 'FILL_BLANK',
 '{"question":"Fill in: Look! It _____ (rain)."}',
 '{"correct":"is raining","alternatives":["is raining."]}', 'Look! → đang xảy ra → is raining.', 1, 2),

(302, 'MULTIPLE_CHOICE',
 '{"question":"_____ you watch the movie last night?","options":["Do","Does","Did","Are"]}',
 '{"correct":2}', 'last night → quá khứ → Did.', 1, 1),
(302, 'FILL_BLANK',
 '{"question":"Fill in: She _____ (go) to Paris in 2019."}',
 '{"correct":"went","alternatives":["went."]}', 'go là động từ bất quy tắc: go → went.', 1, 2),

(320, 'MULTIPLE_CHOICE',
 '{"question":"I _____ never _____ sushi.","options":["have / eat","have / eaten","has / eaten","am / eating"]}',
 '{"correct":1}', 'Present perfect: have/has + V3. eat → eaten.', 2, 1),
(320, 'MULTIPLE_CHOICE',
 '{"question":"Which sentence is correct?","options":["I have seen him yesterday.","I saw him yesterday.","I have see him yesterday.","I has saw him yesterday."]}',
 '{"correct":1}', 'yesterday đi với past simple, không phải present perfect.', 2, 2),

(323, 'MULTIPLE_CHOICE',
 '{"question":"If it _____ tomorrow, we _____ at home.","options":["will rain / stay","rains / will stay","rain / will stay","rained / would stay"]}',
 '{"correct":1}', 'First conditional: If + V hiện tại, will + V.', 2, 1),
(323, 'FILL_BLANK',
 '{"question":"If you _____ (work) hard, you will succeed."}',
 '{"correct":"work","alternatives":["work."]}', 'Mệnh đề if dùng hiện tại đơn (không dùng will).', 2, 2);

-- ============================================================
-- CHINESE GRAMMAR - chi tiết explanation
-- ============================================================
UPDATE grammars
SET explanation_vi = '是 (shì) là động từ "là" trong tiếng Trung, dùng để kết nối chủ ngữ với danh từ vị ngữ.\n\n📐 Cấu trúc: S + 是 + N\n• 我是学生。Wǒ shì xuéshēng. (Tôi là học sinh)\n• 他是医生。Tā shì yīshēng. (Anh ấy là bác sĩ)\n\n❌ Phủ định: S + 不是 + N (chỉ dùng 不, không dùng 没)\n• 我不是老师。 (Tôi không phải giáo viên)\n\n❓ Câu hỏi:\n• Có/không: S + 是不是 + N? hoặc S + 是 + N + 吗?\n• 你是不是学生？= 你是学生吗？\n\n⚠️ LƯU Ý QUAN TRỌNG:\n是 KHÔNG dùng trước tính từ trong câu khẳng định!\n❌ 我是高 → ✅ 我很高 (Tôi cao)\nVới tính từ, dùng 很 (hěn) làm liên từ.',
    explanation_en = '是 (shì) means "to be" and connects subject with a noun predicate. NEVER use 是 before adjectives — use 很 instead.',
    formation = '(+) S + 是 + N\n(-) S + 不是 + N\n(?) S + 是 + N + 吗?  /  S + 是不是 + N?',
    usage_context = 'Định nghĩa, giới thiệu thân phận, nghề nghiệp, quan hệ.',
    common_mistakes = '❌ 我是高 → ✅ 我很高 (tính từ không dùng 是)\n❌ 我没是 → ✅ 我不是 (是 phủ định bằng 不, không phải 没)\n❌ 你是学生不是 → ✅ 你是不是学生？',
    related_patterns = '不是, 很, 在 (ở)',
    difficulty_score = 1
WHERE language_id = @lang_zh AND pattern = '是 (shì)';

UPDATE grammars
SET explanation_vi = '有 (yǒu) nghĩa là "có" - thể hiện sự sở hữu hoặc tồn tại.\n\n📐 Cấu trúc:\n1️⃣ Sở hữu: S + 有 + N\n  • 我有一本书。(Tôi có một quyển sách)\n  • 他有两个孩子。(Anh ấy có 2 đứa con)\n\n2️⃣ Tồn tại: Place + 有 + N\n  • 桌子上有一本书。(Trên bàn có một quyển sách)\n  • 教室里有学生。(Trong lớp có học sinh)\n\n❌ Phủ định ĐẶC BIỆT: 没有 (méi yǒu) - KHÔNG dùng 不有!\n• 我没有钱。(Tôi không có tiền)\n• 没有 cũng có thể rút gọn thành 没\n\n❓ Câu hỏi:\n• 你有钱吗？= 你有没有钱？',
    explanation_en = '有 (yǒu) means "to have" or "there is/are". The negative form is 没有 (méi yǒu), NEVER 不有.',
    formation = '(+) S + 有 + N  /  Place + 有 + N\n(-) S + 没有 + N\n(?) S + 有 + N + 吗?  /  S + 有没有 + N?',
    usage_context = 'Diễn tả sở hữu, tồn tại, có/không có gì đó.',
    common_mistakes = '❌ 我不有 → ✅ 我没有 (有 phủ định bằng 没)\n❌ 我有了一本书 → ✅ 我有一本书 (有 thường không cần 了)',
    related_patterns = '没有, 在, 是',
    difficulty_score = 1
WHERE language_id = @lang_zh AND pattern = '有 (yǒu)';

UPDATE grammars
SET explanation_vi = '了 (le) là một trong những trợ từ phức tạp nhất tiếng Trung. Có 2 cách dùng chính:\n\n1️⃣ 了₁ (sau động từ) - HOÀN THÀNH HÀNH ĐỘNG:\n• V + 了 + (tân ngữ)\n• 我吃了饭。(Tôi đã ăn cơm rồi)\n• 他买了一本书。(Anh ấy đã mua một quyển sách)\n\n2️⃣ 了₂ (cuối câu) - THAY ĐỔI TÌNH TRẠNG:\n• Câu + 了\n• 天气热了。(Trời nóng rồi - trước không nóng, giờ nóng)\n• 我会说汉语了。(Tôi đã có thể nói tiếng Trung rồi)\n\n3️⃣ Cả 2 dạng cùng lúc:\n• 我吃了饭了。(Tôi ăn cơm rồi - và bây giờ đã xong)\n\n❌ Phủ định KHÔNG DÙNG 了:\n• ❌ 我没吃了 → ✅ 我没吃 (没 + V, bỏ 了)',
    explanation_en = '了 (le) has two main uses: (1) after verb to indicate completion, (2) at sentence end to indicate change of state. Drop 了 in negative sentences with 没.',
    formation = 'V + 了: hoàn thành hành động\nCâu + 了: thay đổi tình trạng\n没 + V (bỏ 了): phủ định',
    usage_context = 'Diễn tả hoàn thành hành động hoặc thay đổi tình huống.',
    common_mistakes = '❌ 我没吃了饭 → ✅ 我没吃饭\n❌ 我每天吃了饭 → ✅ 我每天吃饭 (thói quen không dùng 了)\n❌ 我是学生了 → ✅ 我是学生 (是 thường không + 了)',
    related_patterns = '过 (kinh nghiệm), 着 (trạng thái), 的 (sở hữu)',
    difficulty_score = 3
WHERE language_id = @lang_zh AND pattern = '了 (le) - completion';

UPDATE grammars
SET explanation_vi = 'Cấu trúc 比 (bǐ) dùng để so sánh hơn giữa hai sự vật.\n\n📐 Cấu trúc cơ bản:\n  A + 比 + B + Adj\n  • 我比你高。(Tôi cao hơn bạn)\n  • 北京比上海冷。(Bắc Kinh lạnh hơn Thượng Hải)\n\n📐 So sánh hơn cụ thể bao nhiêu:\n  A + 比 + B + Adj + lượng từ\n  • 我比你高五厘米。(Tôi cao hơn bạn 5cm)\n  • 这本书比那本书贵十块钱。\n\n📐 So sánh hơn nhiều:\n  A + 比 + B + Adj + 多了/得多\n  • 他比我大多了。(Anh ấy lớn hơn tôi nhiều)\n\n❌ KHÔNG dùng 很/非常 với 比:\n• ❌ 我比你很高 → ✅ 我比你高\n\n❌ Phủ định: A + 没有 + B + (这么/那么) + Adj\n• 我没有他高。(Tôi không cao bằng anh ấy)',
    explanation_en = 'The 比 (bǐ) construction expresses comparison. NEVER combine with 很 or 非常. The negative form uses 没有, not 不比.',
    formation = '(+) A + 比 + B + Adj\nA + 比 + B + Adj + amount\n(-) A + 没有 + B + (这么/那么) + Adj',
    usage_context = 'So sánh chiều cao, tuổi, kích thước, nhiệt độ, giá cả...',
    common_mistakes = '❌ 我比你很高 → ✅ 我比你高\n❌ 我不比你高 (sai) → ✅ 我没有你高\n❌ 我比他大3岁多了 → ✅ 我比他大3岁',
    related_patterns = '没有 (so sánh không bằng), 一样 (giống nhau), 更 (càng)',
    difficulty_score = 2
WHERE language_id = @lang_zh AND pattern = '比 (bǐ)';

-- ============================================================
-- CHINESE GRAMMAR - examples
-- ============================================================
INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(400, '我是越南人。', 'wǒ shì yuènán rén', 'wǒ shì yuènán rén', 'Tôi là người Việt Nam.', 'I am Vietnamese.', 'Khẳng định thân phận', 1),
(400, '他是我的老师。', 'tā shì wǒ de lǎoshī', 'tā shì wǒ de lǎoshī', 'Anh ấy là giáo viên của tôi.', 'He is my teacher.', 'Có 的 sở hữu', 2),
(400, '这是什么？', 'zhè shì shénme', 'zhè shì shénme', 'Đây là gì?', 'What is this?', 'Câu hỏi với 什么', 3),
(400, '我不是医生。', 'wǒ bú shì yīshēng', 'wǒ bú shì yīshēng', 'Tôi không phải bác sĩ.', 'I am not a doctor.', 'Phủ định với 不是', 4);

INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(406, '我有一个哥哥。', 'wǒ yǒu yí ge gēge', 'wǒ yǒu yí ge gēge', 'Tôi có một anh trai.', 'I have an older brother.', 'Sở hữu', 1),
(406, '桌子上有书。', 'zhuōzi shàng yǒu shū', 'zhuōzi shàng yǒu shū', 'Trên bàn có sách.', 'There are books on the table.', 'Tồn tại', 2),
(406, '你有时间吗？', 'nǐ yǒu shíjiān ma', 'nǐ yǒu shíjiān ma', 'Bạn có thời gian không?', 'Do you have time?', 'Câu hỏi', 3),
(406, '我没有钱。', 'wǒ méi yǒu qián', 'wǒ méi yǒu qián', 'Tôi không có tiền.', 'I don''t have money.', 'Phủ định với 没有', 4);

INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(414, '我吃了饭。', 'wǒ chī le fàn', 'wǒ chī le fàn', 'Tôi đã ăn cơm.', 'I ate.', 'Hoàn thành', 1),
(414, '他买了三本书。', 'tā mǎi le sān běn shū', 'tā mǎi le sān běn shū', 'Anh ấy đã mua 3 quyển sách.', 'He bought 3 books.', 'V+了 + lượng từ', 2),
(414, '下雨了。', 'xià yǔ le', 'xià yǔ le', 'Trời mưa rồi.', 'It''s raining now / It started to rain.', 'Thay đổi tình trạng', 3);

INSERT INTO grammar_examples (grammar_id, sentence, reading, romaji, translation_vi, translation_en, note, order_index) VALUES
(419, '我比你大两岁。', 'wǒ bǐ nǐ dà liǎng suì', 'wǒ bǐ nǐ dà liǎng suì', 'Tôi lớn hơn bạn 2 tuổi.', 'I am 2 years older than you.', 'So sánh có lượng từ', 1),
(419, '今天比昨天热。', 'jīntiān bǐ zuótiān rè', 'jīntiān bǐ zuótiān rè', 'Hôm nay nóng hơn hôm qua.', 'Today is hotter than yesterday.', 'So sánh thời tiết', 2),
(419, '汉语比英语难。', 'hànyǔ bǐ yīngyǔ nán', 'hànyǔ bǐ yīngyǔ nán', 'Tiếng Trung khó hơn tiếng Anh.', 'Chinese is harder than English.', 'So sánh ngôn ngữ', 3);

-- ============================================================
-- CHINESE GRAMMAR - exercises
-- ============================================================
INSERT INTO grammar_exercises (grammar_id, type, question_json, answer_json, explanation, difficulty, order_index) VALUES
(400, 'MULTIPLE_CHOICE',
 '{"question":"Chọn câu đúng để nói: ''Tôi là sinh viên''.","options":["我是学生。","我有学生。","我在学生。","我很学生。"]}',
 '{"correct":0}', '是 + N: 我是学生 (Tôi là sinh viên).', 1, 1),
(400, 'MULTIPLE_CHOICE',
 '{"question":"Câu nào SAI?","options":["我是中国人。","我很高。","我是高。","他不是医生。"]}',
 '{"correct":2}', '是 KHÔNG dùng trước tính từ. Dùng 很 thay thế: 我很高 (đúng).', 2, 2),

(406, 'FILL_BLANK',
 '{"question":"Điền: 我_____钱。 (Tôi không có tiền)"}',
 '{"correct":"没有","alternatives":["没"]}', '有 phủ định bằng 没有, không phải 不有.', 1, 1),
(406, 'MULTIPLE_CHOICE',
 '{"question":"Chọn câu đúng:","options":["我不有时间。","我没有时间。","我无时间。","我没时间了。"]}',
 '{"correct":1}', '没有 = phủ định của 有.', 1, 2),

(414, 'MULTIPLE_CHOICE',
 '{"question":"Câu nào đúng nghĩa ''Tôi đã ăn cơm''?","options":["我吃饭。","我吃了饭。","我没吃了饭。","我在吃饭。"]}',
 '{"correct":1}', 'V + 了 chỉ hoàn thành hành động.', 1, 1),
(414, 'MULTIPLE_CHOICE',
 '{"question":"Phủ định của 我吃了饭 là gì?","options":["我没吃了饭。","我没吃饭。","我不吃了饭。","我没有吃了饭。"]}',
 '{"correct":1}', 'Phủ định với 没 phải BỎ 了: 我没吃饭.', 2, 2),

(419, 'MULTIPLE_CHOICE',
 '{"question":"Chọn câu đúng:","options":["我比你很高。","我比你高。","我很比你高。","我比你也高。"]}',
 '{"correct":1}', 'Cấu trúc 比 KHÔNG dùng với 很/非常.', 2, 1),
(419, 'FILL_BLANK',
 '{"question":"Điền: 哥哥_____弟弟大三岁。"}',
 '{"correct":"比","alternatives":["比 "]}', 'A + 比 + B + Adj + lượng: 哥哥比弟弟大三岁.', 2, 2);

-- Cập nhật difficulty_score cho EN và ZH
UPDATE grammars SET difficulty_score = 1 WHERE language_id = @lang_en AND cefr_level = 'A1' AND difficulty_score IS NULL;
UPDATE grammars SET difficulty_score = 2 WHERE language_id = @lang_en AND cefr_level = 'A2' AND difficulty_score IS NULL;
UPDATE grammars SET difficulty_score = 3 WHERE language_id = @lang_en AND cefr_level = 'B1' AND difficulty_score IS NULL;
UPDATE grammars SET difficulty_score = 1 WHERE language_id = @lang_zh AND hsk_level = 'HSK1' AND difficulty_score IS NULL;
UPDATE grammars SET difficulty_score = 2 WHERE language_id = @lang_zh AND hsk_level = 'HSK2' AND difficulty_score IS NULL;
UPDATE grammars SET difficulty_score = 3 WHERE language_id = @lang_zh AND hsk_level = 'HSK3' AND difficulty_score IS NULL;

-- Bổ sung explanation_vi cho các grammar còn lại
UPDATE grammars
SET explanation_vi = CONCAT('Mẫu ngữ pháp: ', pattern, '\n\n📌 Ý nghĩa: ', COALESCE(meaning_vi, ''), '\n\n📐 Cấu trúc: ', COALESCE(structure, ''), '\n\n💡 ', COALESCE(note, ''))
WHERE (language_id = @lang_en OR language_id = @lang_zh) AND (explanation_vi IS NULL OR explanation_vi = '');
