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

---

## 🆕 Recent Upgrades (Sprint 2)

### UPGRADE-04: Seed Vocabulary
- `V14__seed_vocab_jp_n4.sql` — ~200 N4 Japanese words with Vietnamese meanings
- `V15__seed_vocab_extended.sql` — N3 Japanese / A2-B1 English / HSK2-HSK3 Chinese
- All inserts use `INSERT IGNORE` so re-runs are safe.

### UPGRADE-05: Kanji Stroke Order
- `characters_table.stroke_order_json` (added in V13) is now seeded with sample
  HanziWriter-shape JSON for `一 二 三 人 日 月` in V17.
- Frontend `KanjiStrokeOrder.jsx` already lazy-loads HanziWriter from CDN as
  fallback when the column is NULL.

### UPGRADE-06: Lesson Spaced Repetition
- New table `lesson_review_queue` (V18). Lessons completed with score < 70%
  are upserted into the queue with an increasing back-off (1d → 2d → 3d).
- Re-passing a queued lesson with score ≥ 70% marks the row resolved.
- Endpoint `GET /api/lessons/review-queue` returns pending entries.
- Dashboard widget **"Bài cần ôn lại"** (`LessonReviewWidget.jsx`) surfaces them.

### UPGRADE-07: Audio Pronunciation
- `words.audio_url` column added in V18 (nullable).
- Both `/api/words/search` and `/api/words/{id}` now expose `audioUrl`.
- Frontend TTS helper (`utils/tts.js`) prefers `audioUrl` and falls back to
  Web Speech API → Google Translate TTS.

### UPGRADE-08: Contextual Sentence Mining
- New table `example_sentences` (V16) with `sentence`, `reading`,
  `translation_vi`, `translation_en`, optional `audio_url`.
- Seed examples for ~15 high-frequency JP/EN/ZH words.
- `/api/words/{id}` now returns up to 3 `examples`.
- VocabularyExplorer modal renders "Câu ví dụ trong ngữ cảnh" with TTS button.

### UPGRADE-09: Daily Quest System
- New tables `quest_templates` + `daily_quests.template_id/reward_xp/claimed`
  in V17. 10 quest templates seeded (LEARN_10_WORDS, SRS_REVIEW_20, …).
- Service `QuestService` rolls 3 deterministic quests/day per user, bumps
  category counters from `LessonResource`, `SRSResource`, `GamificationService`.
- Endpoints:
  - `GET  /api/quests/today` — list today's quests with progress + rewards.
  - `POST /api/quests/{id}/claim` — claim XP+gem rewards once completed.
  - `POST /api/quests/event` — generic progress hook.
- Dashboard widget **"Nhiệm vụ hôm nay"** (`DailyQuestWidget.jsx`) shows progress bars + claim button.

### UPGRADE-10: Streak Freeze UI
- Backend already had `POST /api/gamification/streak-freeze/buy`
  (100 gems, max 2 stockpiled). Profile page now has a **"Lá chắn streak"**
  section with inventory pips + buy button + toast feedback.

### UPGRADE-12: XP Animation & Level-Up Overlay
- New `XpLevelUpToast.jsx` mounted globally in `Layout.jsx`.
- Listens for `window` `lingua:xp-gain` `CustomEvent` with
  `{ amount, prevLevel, newLevel }` and renders a floating "+N XP" pill plus a
  celebratory level-up modal when `newLevel > prevLevel`.
- `LessonPractice.jsx` now dispatches the event after a successful
  `POST /api/lessons/{id}/complete` (skipped on duplicate / 5-second replay).
- Stable client-side `idempotencyKey` (UUID) sent with every completion so
  refresh / retry never double-credits XP.

### UPGRADE-13: Hearts Regeneration Countdown
- Backend (`/api/gamification/me`) now also returns
  `nextHeartAt` (ISO timestamp) and `heartRegenMinutes`.
- New `HeartsCountdown.jsx` shows a live `MM:SS` timer + progress bar.
- Wired in the header next to the heart pill (compact mode); a fuller variant
  is available for the Profile page.
- Auto-refetches when hearts drop, hides automatically when full.

### UPGRADE-14: Streak Calendar Heatmap
- New `StreakCalendar.jsx` — GitHub-style 90-day heatmap.
- Reads from existing `GET /api/gamification/analytics?days=90`.
- 5-bucket green ladder (regular days) + orange tint for
  goal-met days, hover tooltip with date and XP, day-of-week labels.
- Mounted at the top of the `Analytics.jsx` page.

### UPGRADE-15: Course Progress Visualization
- `GET /api/courses/{id}/path` now also returns:
  - `summary` — `{ totalLessons, completedLessons, progressPercent }`
  - per-section + per-unit `{ totalLessons, completedLessons, progressPercent }`
  - per-lesson `{ completed, bestScore, completionCount }`
- `CourseDetail.jsx` "Lộ trình" tab renders:
  - Course-level gradient progress bar at the top.
  - Per-section progress chip + mini bar.
  - Per-unit completion ratio chip.
  - Completed lessons get a green pill + ✅ icon.

### SEC-01: Global Rate Limiter
- New `GlobalRateLimitFilter.java` — a JAX-RS `ContainerRequestFilter`.
- Applies two coarse buckets to every `/api/*` request:
  - **per-IP** (default `120 req / 60s / IP`)
  - **per-user** when JWT is present (default `300 req / 60s / user`)
- Skips health, OpenAPI, swagger, static, OPTIONS pre-flight.
- Tighter per-route limits in `AuthResource` (login/register) still win.
- Returns `429 Too Many Requests` + `Retry-After` header.
- Configurable via env vars: `RATELIMIT_ENABLED`, `RATELIMIT_IP_MAX`,
  `RATELIMIT_IP_WINDOW`, `RATELIMIT_USER_MAX`, `RATELIMIT_USER_WINDOW`.
- IP source uses `X-Forwarded-For` → `X-Real-IP` → Vert.x remote address.

### UPGRADE-23: Health Endpoint
- `GET /api/health` (PermitAll) returns version + DB connectivity for load
  balancers / uptime monitors.

### Bug Fixes Carried Over
- BUG-FE-01..09 — toast system, language scoping, pagination, mock-test
  persistence, layout duplicate redirect, empty-state UX, etc.
- BUG-BE-01 — quoted Hibernate identifiers.
- BUG-BE-04 — `/api/srs/due` `limit` clamped to 1..200.
- BUG-BE-05 — `CORS_ORIGINS` honoured from env.
- BUG-BE-07 — Idempotency-Key + 5-second replay window on
  `POST /api/lessons/{id}/complete` (`lesson_attempts.idempotency_key` unique).

---

## 🔌 New API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET    | `/api/health` | Liveness + DB ping |
| GET    | `/api/lessons/review-queue` | UPGRADE-06: lessons that need re-attempt |
| GET    | `/api/quests/today` | UPGRADE-09: today's quest roll |
| POST   | `/api/quests/{id}/claim` | UPGRADE-09: claim quest reward |
| POST   | `/api/quests/event` | UPGRADE-09: generic progress hook |
| POST   | `/api/gamification/streak-freeze/buy` | UPGRADE-10: buy a freeze |

### Response shape additions
- `GET /api/gamification/me` now also returns `nextHeartAt` (ISO) and `heartRegenMinutes` (UPGRADE-13).
- `GET /api/courses/{id}/path` now also returns `summary` + per-section / per-unit / per-lesson progress (UPGRADE-15).
- `POST /api/lessons/{id}/complete` accepts `idempotencyKey` and returns `level`, `queuedForReview`, `duplicate` (BUG-BE-07 + UPGRADE-06 + UPGRADE-12).

---

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
