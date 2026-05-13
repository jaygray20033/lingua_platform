# 🌐 LINGUA PLATFORM

## Nền tảng học ngoại ngữ toàn diện (Nhật / Anh / Trung)

Lingua là nền tảng học ngoại ngữ đa ngôn ngữ lấy cảm hứng từ Duolingo, Memrise, Busuu và nhaikanji.com.

---

## 🏗️ Tech Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | Java 17 + Quarkus 3.8 (RESTEasy, Hibernate ORM Panache, Flyway) |
| **Frontend** | ReactJS 18 (Vite) + React Router v6 + Tailwind CSS + Zustand |
| **Database** | MySQL 8.0 |
| **Cache** | Redis 7 |
| **Infrastructure** | Docker Compose |

---

## 📁 Cấu trúc dự án

```
lingua/
├── docker-compose.yml          # MySQL 8 + Redis
├── lingua-backend/             # Java Quarkus Backend
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/lingua/
│       │   ├── entity/         # 15+ JPA Entities (User, Course, Word, etc.)
│       │   ├── resource/       # REST Controllers (6 resources)
│       │   ├── service/        # Business Logic (AuthService, SRSService)
│       │   ├── dto/            # Data Transfer Objects
│       │   └── config/         # Configuration
│       └── resources/
│           ├── application.properties
│           ├── privateKey.pem  # JWT signing key
│           ├── META-INF/resources/publicKey.pem
│           └── db/migration/
│               ├── V1__initial_schema.sql            # 30+ tables
│               ├── V2__seed_data.sql                 # Seed data cơ bản
│               ├── V3__seed_vocabulary_jp.sql        # JP N5/N4/N3 (~600 từ)
│               ├── V4__seed_vocabulary_en_zh.sql     # EN A1-B1 + ZH HSK1-3
│               ├── V5__seed_kanji_grammar.sql        # Kanji + grammar cơ bản
│               ├── V6__seed_mock_tests.sql           # Mock tests N5, HSK1-2, A1-A2
│               ├── V7__seed_courses_extended.sql     # Courses mở rộng
│               ├── V8__seed_hanzi_chinese.sql        # Hán tự HSK
│               ├── V9__grammar_extension.sql         # Schema: examples + exercises + explanation
│               ├── V10__grammar_detailed_jp.sql      # Grammar JP chi tiết (Minna no Nihongo, Genki)
│               ├── V11__grammar_detailed_en_zh.sql   # Grammar EN/ZH chi tiết (Cambridge, HSK SC)
│               └── V12__mock_tests_full_skills.sql   # JLPT N3, HSK3, CEFR B1 với 4 kỹ năng + N5/HSK1/A1 thêm Speaking/Writing
│
├── lingua-frontend/            # ReactJS Frontend
│   ├── package.json
│   ├── vite.config.js
│   ├── tailwind.config.js
│   └── src/
│       ├── main.jsx
│       ├── App.jsx             # Router configuration
│       ├── index.css           # Global styles + animations
│       ├── api/index.js        # Axios API client
│       ├── store/index.js      # Zustand state management
│       ├── components/
│       │   └── Layout.jsx      # Sidebar + Topbar + Status bar
│       └── pages/
│           ├── Dashboard.jsx           # Trang chủ
│           ├── Login.jsx               # Đăng nhập / Đăng ký
│           ├── CourseCatalog.jsx       # Danh sách khóa học
│           ├── LearningPath.jsx        # Lộ trình học (Duolingo-style)
│           ├── LessonPractice.jsx      # Engine bài tập (4 loại)
│           ├── VocabularyExplorer.jsx   # Từ vựng + tìm kiếm
│           ├── KanjiExplorer.jsx       # Hán tự (nhaikanji-style)
│           ├── GrammarExplorer.jsx     # Ngữ pháp
│           ├── FlashcardSRS.jsx        # SRS Flashcard (SM-2)
│           ├── MockTestList.jsx        # Danh sách đề thi
│           └── MockTestTake.jsx        # Làm đề thi thử
└── README.md
```

---

## 🚀 HƯỚNG DẪN CHẠY LOCAL

### Yêu cầu
- **Docker** & **Docker Compose** (cho MySQL + Redis)
- **Java 17+** & **Maven 3.8+** (cho Quarkus backend)
- **Node.js 18+** & **npm** (cho React frontend)

### Bước 1: Khởi động Database

```bash
cd lingua
docker-compose up -d
```

Đợi MySQL khởi động hoàn tất (~10-20 giây):
```bash
docker-compose logs -f mysql
# Đợi thấy dòng: "ready for connections"
```

### Bước 2: Chạy Backend (Quarkus)

```bash
cd lingua-backend

# Cài đặt dependencies và chạy dev mode
./mvnw quarkus:dev
# Hoặc nếu dùng Maven global:
mvn quarkus:dev
```

> **Lưu ý:** Nếu chưa có Maven wrapper (`mvnw`), hãy chạy:
> ```bash
> mvn -N io.takari:maven:wrapper
> ```

Backend sẽ chạy tại: **http://localhost:8080**

Flyway sẽ tự động:
1. Tạo 30+ bảng (V1__initial_schema.sql)
2. Seed 500+ records data (V2__seed_data.sql)

### Bước 3: Chạy Frontend (React)

```bash
cd lingua-frontend

# Cài đặt dependencies
npm install

# Chạy dev server
npm run dev
```

Frontend sẽ chạy tại: **http://localhost:3000**

> Vite proxy tự động chuyển tiếp `/api/*` requests sang backend port 8080.

### Bước 4: Mở trình duyệt

Truy cập **http://localhost:3000**

**Tài khoản demo:** `demo@lingua.com` / `password`

---

## ✅ Tính năng đã hoàn thành

### 🔐 Auth & User
- [x] Đăng ký / Đăng nhập (JWT)
- [x] Quản lý token
- [x] Tài khoản demo có sẵn

### 📚 Khóa học & Lộ trình
- [x] 9 khóa học (JLPT N5-N3, English A1-B1, HSK 1-3)
- [x] Cấu trúc: Course → Section → Unit → Lesson → Exercise
- [x] Lộ trình học dạng Duolingo (scroll dọc, expand/collapse)
- [x] Hiển thị trạng thái lesson (available/locked/checkpoint)

### 💪 Practice Engine (Bài tập)
- [x] Multiple Choice (Trắc nghiệm)
- [x] Fill in the Blank (Điền chỗ trống)
- [x] Match Pairs (Ghép cặp)
- [x] Translate to Source/Target (Dịch)
- [x] Progress bar, Heart system, XP tracking
- [x] Feedback correct/wrong với animation
- [x] Kết quả lesson (đúng/sai/XP/% chính xác)

### 📖 Từ vựng
- [x] 200+ từ tiếng Nhật (N5) với nghĩa tiếng Việt, ví dụ, phiên âm
- [x] 40+ từ tiếng Anh (A1)
- [x] 40+ từ tiếng Trung (HSK1) với Pinyin
- [x] Grid hiển thị kiểu nhaikanji.com
- [x] Modal chi tiết từ (nghĩa, ví dụ, phát âm TTS)
- [x] Tìm kiếm từ vựng
- [x] Lọc theo ngôn ngữ & cấp độ

### 🈶 Hán tự (Kanji)
- [x] 30 Kanji N5 với đầy đủ thông tin
- [x] Âm On/Kun, Hán Việt, nghĩa, số nét
- [x] Mẹo nhớ (Mnemonic)
- [x] Grid kiểu nhaikanji.com
- [x] Phát âm TTS

### 📖 Ngữ pháp
- [x] 20 mẫu ngữ pháp N5
- [x] Cấu trúc, ví dụ, ghi chú
- [x] Expand/collapse chi tiết
- [x] Phát âm ví dụ

### 🧠 SRS Flashcard
- [x] Thuật toán SM-2 (SuperMemo-2)
- [x] 4 bộ thẻ hệ thống (JLPT N5 Vocab, N5 Kanji, English A1, HSK1)
- [x] Flip card animation 3D
- [x] 4 nút rating: Again/Hard/Good/Easy
- [x] Duyệt thẻ (Browse mode)
- [x] Ôn tập (Review mode) cho thẻ đến hạn

### 📝 Thi thử (Mock Test) — ĐẦY ĐỦ 4 KỸ NĂNG
- [x] **JLPT N5** — Vocab, Grammar, Reading, Listening + WRITING (作文) + SPEAKING (会話)
- [x] **JLPT N4** — Vocab, Grammar, Reading, Listening
- [x] **JLPT N3** (V12) — 6 sections: Vocab, Grammar, Reading, Listening, **Writing essay**, **Speaking interview** (140 phút, chuẩn JLPT)
- [x] **HSK 1** — 听力, 阅读, 书写 + ESSAY + SPEAKING
- [x] **HSK 2** — 听力, 阅读, 书写
- [x] **HSK 3** (V12) — 5 sections: Listening, Reading, Writing, **Essay 短文**, **Speaking 口语** (90 phút, chuẩn HSK)
- [x] **CEFR A1** — Vocab, Grammar, Reading, Listening + WRITING + SPEAKING
- [x] **CEFR A2** — Vocab, Grammar, Reading, Listening
- [x] **CEFR B1** (V12) — 6 sections: Vocab, Grammar, Reading, Listening, **Writing essay**, **Speaking interview** (120 phút, chuẩn Cambridge PET)
- [x] Bộ đếm ngược thời gian + auto-submit khi hết giờ
- [x] Chuyển đổi section tự do
- [x] Đánh dấu cờ (flag) câu hỏi để xem lại
- [x] Bản đồ câu hỏi (palette) - hiển thị câu đã/chưa làm
- [x] **Speaking section**: ghi âm bằng MediaRecorder + transcript + TTS phát đề
- [x] **Writing essay**: textarea + đếm số từ + hint từ chuẩn
- [x] Kết quả: Điểm tổng, điểm từng phần, Đậu/Rớt + giải thích chi tiết
- [x] Review mode sau khi nộp (xem đáp án + giải thích)
- [x] Làm lại đề

### 🎮 Gamification
- [x] XP, Gems, Hearts, Streak
- [x] Status bar trên topbar
- [x] Level system
- [x] 13 Achievements (First Step, Streak Warrior, etc.)
- [x] 10 Leagues (Bronze → Diamond)

### 🎨 UI/UX
- [x] Sidebar navigation (expand/collapse)
- [x] Dark/Light mode
- [x] Responsive design (Tailwind CSS)
- [x] Animations (slide, pulse, shake)
- [x] Font: Inter + Noto Sans JP + Noto Sans SC

---

## 🔌 API Endpoints

| Method | Path | Mô tả |
|--------|------|--------|
| POST | `/api/auth/register` | Đăng ký |
| POST | `/api/auth/login` | Đăng nhập |
| GET | `/api/courses` | Danh sách khóa học |
| GET | `/api/courses/{id}` | Chi tiết khóa học |
| GET | `/api/courses/{id}/path` | Lộ trình học (Sections → Units → Lessons) |
| GET | `/api/lessons/{id}` | Chi tiết bài học + exercises |
| GET | `/api/words/search?q=&lang=&level=` | Tìm từ vựng |
| GET | `/api/characters?level=N5` | Danh sách Kanji |
| GET | `/api/characters/{char}` | Chi tiết Kanji |
| GET | `/api/grammars?lang=ja&level=N5` | Ngữ pháp |
| GET | `/api/srs/due?userId=2` | Thẻ cần ôn tập |
| POST | `/api/srs/{reviewId}/review` | Submit rating SRS |
| GET | `/api/srs/decks` | Danh sách bộ thẻ |
| GET | `/api/mock-tests` | Danh sách đề thi |
| GET | `/api/mock-tests/{id}` | Chi tiết đề + câu hỏi |
| GET | `/api/gamification/me?userId=2` | Thông tin gamification |
| GET | `/api/gamification/achievements` | Achievements |
| GET | `/api/gamification/languages` | Ngôn ngữ hỗ trợ |

---

## 📊 Database Schema (30+ bảng)

### Core Tables
- `users`, `refresh_tokens`, `otp_codes`
- `languages`, `user_languages`
- `courses`, `enrollments`
- `sections`, `units`, `lessons`, `exercises`
- `lesson_attempts`, `answer_logs`, `user_lesson_progress`

### Vocabulary & Character
- `words`, `word_meanings`
- `characters_table`, `character_components`, `word_characters`
- `user_known_words`
- `grammars`

### SRS / Flashcard
- `decks`, `cards`
- `flashcard_reviews`, `review_logs`

### Gamification
- `user_gamification`, `heart_logs`, `gem_transactions`
- `daily_xp_logs`, `achievements`, `user_achievements`
- `leagues`, `league_groups`, `user_leagues`
- `daily_quests`

### Mock Test
- `mock_tests`, `mock_test_questions`, `mock_test_attempts`

### Other
- `notifications`

## 🔮 Phát triển tiếp (Chưa implement)

- [ ] AI Roleplay Conversation (GPT-4)
- [ ] AI Video Call với avatar
- [ ] Shadowing (Recording + Speech-to-Text)
- [ ] Write Kanji on Web (Canvas HTML5)
- [ ] Import/Export Anki deck (.apkg)
- [ ] Community: Forum, Follow, Review
- [ ] Payment: Stripe/VNPay/MoMo
- [ ] Push Notification (FCM)
- [ ] Admin Dashboard & CMS
- [ ] Offline mode
- [ ] OAuth (Google/Facebook/Apple)
- [ ] TOPIK / Korean courses
- [ ] Pre-generate `audio_url` for all words via gTTS pipeline (UPGRADE-07 server-side)
- [ ] Full KanjiVG → `stroke_order_json` import (UPGRADE-05 dataset)
- [ ] Push notification when daily quest is completed

---

## 📝 License
MIT License - Lingua Platform 2026
