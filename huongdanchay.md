# 🚀 Hướng dẫn chạy dự án Lingua Platform

> **Phiên bản**: 1.3.0 · **Cập nhật**: 2026‑05‑01
> Tài liệu này tổng hợp toàn bộ các bước cài đặt, chạy, các bug đã sửa trong bản patch mới nhất (BUG‑01 → BUG‑15, TECH‑01, TECH‑07, BUG‑C00 → BUG‑L02) và hướng dẫn deploy với Docker Compose.

---

## ⚡ TL;DR — Chạy nhanh nhất bằng Docker Compose

Nếu bạn chỉ cần chạy được dự án ngay, làm 4 bước sau:

```bash
# 1) Vào thư mục dự án
cd webapp

# 2) Đảm bảo có file .env (bản zip đã có sẵn). Nếu chưa, copy từ example:
[ -f .env ] || cp .env.example .env

# 3) Build & start tất cả services (MySQL, Redis, Backend, Frontend)
docker compose up -d --build

# 4) Đợi ~60s rồi xem trạng thái
docker compose ps
docker compose logs -f backend     # Đợi tới khi thấy "Listening on: http://0.0.0.0:8080"
```

Sau khi xong:
- Frontend: http://localhost
- Backend health: http://localhost:8080/api/health
- API: http://localhost:8080/api/...

> Nếu container backend báo lỗi build (`./mvnw not found`) hoặc chạy báo `Communications link failure` thì bạn đang dùng phiên bản code **trước** patch BUG‑C00/C01/C02. Đảm bảo đã pull bản patch mới nhất.

---

## 📋 Mục lục

1. [Yêu cầu hệ thống](#1-yêu-cầu-hệ-thống)
2. [Cấu trúc dự án](#2-cấu-trúc-dự-án)
3. [Chuẩn bị file `.env`](#3-chuẩn-bị-file-env)
4. [Sinh khóa JWT mới](#4-sinh-khóa-jwt-mới)
5. [Cách 1 — Chạy bằng Docker Compose (one‑command, khuyến nghị)](#5-cách-1--chạy-bằng-docker-compose-one-command-khuyến-nghị)
6. [Cách 2 — Chạy từng phần (dev mode)](#6-cách-2--chạy-từng-phần-dev-mode)
7. [Áp dụng migration cơ sở dữ liệu](#7-áp-dụng-migration-cơ-sở-dữ-liệu)
8. [Kiểm tra hoạt động](#8-kiểm-tra-hoạt-động)
9. [Tổng hợp các bug đã sửa](#9-tổng-hợp-các-bug-đã-sửa)
10. [Tài khoản test](#10-tài-khoản-test)
11. [Khắc phục sự cố](#11-khắc-phục-sự-cố)

---

## 1. Yêu cầu hệ thống

| Thành phần | Phiên bản | Ghi chú |
|------------|-----------|---------|
| Java       | **17+**   | Khuyến nghị Temurin 17 hoặc 21 |
| Maven      | **3.9+**  | Cần cài thủ công (dự án không kèm `mvnw`). Hoặc dùng Docker Compose để khỏi cài. |
| Node.js    | **20 LTS** | Bắt buộc cho Vite 5 + esbuild 0.28 |
| Docker     | 24+       | Để chạy `docker compose up` (cách khuyến nghị) |
| Docker Compose | v2     | Đi kèm Docker Desktop / Docker Engine 24+ |
| MySQL      | 8.0       | Tự động qua Docker, cổng host **3307** |
| Redis      | 7         | Tự động qua Docker, cổng host **6380** |
| Python 3   | 3.9+      | Chỉ cần khi chạy `scripts/generate_audio_tts.py` để pre‑gen audio TTS |

> ⚠️ **Lưu ý quan trọng**: Phải sửa `BUG-02` ngay khi clone code về — file `secrets/privateKey.pem` cũ đã bị **rò rỉ** trong zip cũ. Xem mục [4. Sinh khóa JWT mới](#4-sinh-khóa-jwt-mới).

---

## 2. Cấu trúc dự án

```
webapp/
├── lingua-backend/                        # Quarkus 3.15 (LTS) + MySQL + Redis
│   ├── Dockerfile                         # ← MỚI (BUG-11): multi-stage build cho backend
│   ├── pom.xml                            # ← Đã sửa (BUG-01, TECH-01)
│   ├── secrets/                           # privateKey.pem & publicKey.pem (KHÔNG commit!)
│   │   ├── privateKey.pem                 # ← Sinh mới khi setup (BUG-02)
│   │   └── publicKey.pem
│   └── src/main/resources/
│       ├── application.properties         # ← Đã sửa (TECH-07: connection pool)
│       └── db/migration/
│           ├── V1__initial_schema.sql … V21__seed_vocab_extended_levels.sql
│           └── V22__add_performance_indexes.sql   # ← MỚI (BUG-14)
├── lingua-frontend/                       # React 18 + Vite + Tailwind
│   ├── Dockerfile                         # ← MỚI (BUG-11): build + Nginx serve
│   ├── package.json                       # ← Đã sửa (BUG-04, TECH-01)
│   └── src/
│       ├── App.jsx                        # ← Đã sửa (BUG-06: route /register)
│       ├── main.jsx                       # ← Đã sửa (BUG-03: init dark mode)
│       ├── store/index.js                 # ← Đã sửa (BUG-03: toggle <html>.dark)
│       ├── components/
│       │   └── Skeleton.jsx               # ← MỚI (BUG-15)
│       ├── hooks/
│       │   └── useDocumentTitle.js        # ← MỚI (BUG-13)
│       ├── pages/
│       │   ├── Login.jsx                  # ← Đã sửa (BUG-13, link /register)
│       │   ├── Register.jsx               # ← MỚI (BUG-06)
│       │   ├── FlashcardSRS.jsx           # ← Đã sửa (BUG-05, BUG-13)
│       │   └── … (Dashboard, Profile, Vocabulary…) # ← Đã thêm useDocumentTitle
│       └── utils/tts.js                   # ← Đã sửa (BUG-12: bỏ Google TTS)
├── docker-compose.yml                     # ← Đã sửa (BUG-11: thêm backend + frontend)
├── .env.example                           # ← Đã cập nhật (BUG-11)
└── .gitignore                             # ← Đã cập nhật (BUG-02: chặn *.pem)
```

---

## 3. Chuẩn bị file `.env`

```bash
cd webapp
cp .env.example .env
```

Chỉnh `.env` với các giá trị an toàn (ví dụ tối thiểu):

```env
# MySQL
MYSQL_ROOT_PASSWORD=ChangeMe_Root_StrongPwd!
MYSQL_DATABASE=lingua_db
MYSQL_USER=lingua
MYSQL_PASSWORD=ChangeMe_Lingua_StrongPwd!

# Backend
DB_USERNAME=lingua
DB_PASSWORD=ChangeMe_Lingua_StrongPwd!
DB_JDBC_URL=jdbc:mysql://mysql:3306/lingua_db?useUnicode=true&characterEncoding=UTF-8&connectionCollation=utf8mb4_unicode_ci&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false
REDIS_URL=redis://redis:6379

# CORS — frontend container
CORS_ORIGINS=http://localhost,http://localhost:5173,http://localhost:3000

# JWT
JWT_LIFESPAN_SECONDS=3600
JWT_ISSUER=lingua-platform
JWT_PRIVATE_KEY_LOCATION=/app/secrets/privateKey.pem
JWT_PUBLIC_KEY_LOCATION=META-INF/resources/publicKey.pem

# Docker compose ports
BACKEND_PORT=8080
FRONTEND_PORT=80

# Flyway (BUG-01: đã hỗ trợ MySQL 8.0)
FLYWAY_ENABLED=true
FLYWAY_MIGRATE_AT_START=true

# Connection pool (TECH-07)
DB_POOL_MIN=5
DB_POOL_MAX=20
DB_POOL_ACQ_TIMEOUT=30
```

> 🔒 File `.env` đã được liệt kê trong `.gitignore`, **tuyệt đối không commit lên git**.

---

## 4. Sinh khóa JWT mới

> **BUG-02**: Khóa cũ trong zip có thể đã lộ. Bắt buộc tạo cặp khóa mới trước khi chạy.

```bash
cd lingua-backend

# Xóa khóa cũ (nếu còn)
rm -f secrets/privateKey.pem secrets/publicKey.pem
rm -f src/main/resources/privateKey.pem

# Sinh cặp khóa RSA 2048-bit mới
mkdir -p secrets
openssl genrsa -out secrets/privateKey.pem 2048
openssl rsa -in secrets/privateKey.pem -pubout -out secrets/publicKey.pem

# Public key để Quarkus verify token: copy vào META-INF/resources
mkdir -p src/main/resources/META-INF/resources
cp secrets/publicKey.pem src/main/resources/META-INF/resources/publicKey.pem

cd ..
```

> ✅ Private key chỉ tồn tại tại `lingua-backend/secrets/privateKey.pem`. Trong Docker Compose nó được **mount read‑only** vào container — không bake vào image, không commit lên git (`.gitignore` đã chặn `*.pem` trừ `publicKey.pem`).

---

## 5. Cách 1 — Chạy bằng Docker Compose (one‑command, khuyến nghị)

> **BUG-11**: `docker-compose.yml` giờ đã có đầy đủ 4 service — `mysql`, `redis`, `backend`, `frontend`. Chỉ cần một câu lệnh là toàn bộ stack chạy.

```bash
cd webapp

# Build images (lần đầu hoặc khi đổi code) + start tất cả services
docker compose up -d --build

# Theo dõi logs (Ctrl+C để thoát log, container vẫn chạy)
docker compose logs -f

# Trạng thái health của từng container
docker compose ps
```

Sau khi tất cả các container chuyển sang `healthy` (~60 giây cho lần đầu vì backend chờ MySQL):

| Service   | URL truy cập                      |
|-----------|-----------------------------------|
| Frontend  | http://localhost                   |
| Backend   | http://localhost:8080/api/health   |
| API       | http://localhost:8080/api/...      |
| MySQL     | `localhost:3307` (user `lingua`)   |
| Redis     | `localhost:6380`                   |

**Tắt stack:**

```bash
docker compose down            # Giữ dữ liệu MySQL/Redis (volume)
docker compose down -v         # Xóa luôn volume (mất hết dữ liệu DB)
```

---

## 6. Cách 2 — Chạy từng phần (dev mode)

Chỉ dùng cách này khi bạn muốn hot‑reload backend / frontend trong khi phát triển.

### 6.1. Khởi động hạ tầng (MySQL + Redis)

```bash
cd webapp
docker compose up -d mysql redis
```

### 6.2. Chạy backend (Quarkus dev mode)

> ⚠️ Dự án **không kèm Maven wrapper** (`mvnw`). Phải cài Maven 3.9+ trên máy host (hoặc dùng `mvn` đi kèm IDE/IntelliJ).

```bash
cd lingua-backend

# Lần đầu: cài deps & build fast-jar
mvn clean package -DskipTests

# Dev mode với hot‑reload (port 8080)
mvn quarkus:dev

# Hoặc chạy fast-jar đã build (production-style)
java -jar target/quarkus-app/quarkus-run.jar
```

Backend sẽ:
- Kết nối MySQL trên `localhost:3307`
- Tự động chạy Flyway migrate (BUG‑01: đã hỗ trợ MySQL 8.0 với `flyway-mysql 10.10.0`)
- Load private key từ `secrets/privateKey.pem`

**Hoặc dùng PM2 (chạy production-style với log file):**

```bash
cd webapp
mvn -f lingua-backend/pom.xml clean package -DskipTests
pm2 start ecosystem.config.cjs
pm2 logs lingua-backend --nostream
```

`start-backend.sh` đã cấu hình đúng:
- MySQL `127.0.0.1:3307` / DB `lingua_db` / user `lingua` / pwd `lingua123`
- Redis `redis://127.0.0.1:6380`

### 6.3. Chạy frontend (Vite dev mode)

```bash
cd lingua-frontend
npm install      # Lần đầu
npm run dev      # Vite dev server, port 3000, có hot‑reload
```

Mở http://localhost:3000 (Vite proxy `/api/*` sang `http://localhost:8080`).

---

## 7. Áp dụng migration cơ sở dữ liệu

Mặc định Flyway tự chạy khi backend khởi động (`FLYWAY_MIGRATE_AT_START=true`). Nếu muốn chạy thủ công:

```bash
cd lingua-backend
mvn flyway:migrate \
  -Dflyway.url="jdbc:mysql://localhost:3307/lingua_db?allowPublicKeyRetrieval=true&useSSL=false" \
  -Dflyway.user=lingua \
  -Dflyway.password=lingua123
```

Danh sách migrations hiện có:

| Version | Mô tả |
|---------|------|
| V1 → V19 | Schema gốc, seed data, fixes (xem code) |
| V20 | KanjiVG stroke order |
| V21 | Seed vocab cho mọi level |
| **V22** | **MỚI** — Performance indexes (BUG‑14): `idx_words_lang_level`, `idx_flashcard_due`, `idx_daily_xp_user_date`, `idx_lesson_attempts_user`, `idx_favorites_user_type`, `idx_refresh_user_expires` |

---

## 8. Kiểm tra hoạt động

```bash
# Health check
curl http://localhost:8080/api/health

# Đăng ký user mới
curl -X POST http://localhost:8080/api/auth/register \
  -H 'Content-Type: application/json' \
  -d '{"email":"new@user.com","password":"123456","displayName":"Tester"}'

# Đăng nhập
curl -X POST http://localhost:8080/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"new@user.com","password":"123456"}'
```

Ở UI:

- ✅ Truy cập http://localhost → trang **Login** (title `Đăng nhập — Lingua` — BUG‑13)
- ✅ Click **"tạo tài khoản trên trang đăng ký riêng"** → trang **/register** (BUG‑06)
- ✅ Bật **dark mode** → toàn bộ trang (kể cả `<body>`) đổi sang nền tối (BUG‑03)
- ✅ Vào **SRS Flashcard** → load thẻ đến hạn ôn tập, không còn lỗi "param thừa" (BUG‑05)
- ✅ Tab browser hiển thị tiêu đề tương ứng với từng trang (BUG‑13)

---

## 9. Tổng hợp các bug đã sửa

| ID | Mô tả | File chính |
|----|-------|-----------|
| **BUG‑01** | Flyway crash với MySQL 8.0 → thêm `flyway-mysql 10.10.0` | `lingua-backend/pom.xml` |
| **BUG‑02** | Private key bị commit → xóa khỏi repo, sinh mới, mount qua secret | `secrets/`, `.gitignore` |
| **BUG‑03** | Dark mode không áp dụng cho `<body>` → toggle class trên `<html>` | `src/store/index.js`, `src/main.jsx` |
| **BUG‑04** | `esbuild` ở `dependencies` → di chuyển sang `devDependencies` | `lingua-frontend/package.json` |
| **BUG‑05** | `srsAPI.getDue(uid)` truyền tham số thừa → bỏ tham số | `src/pages/FlashcardSRS.jsx` |
| **BUG‑06** | Không có trang Register độc lập → tạo `/register` | `src/pages/Register.jsx`, `src/App.jsx` |
| **BUG‑11** | `docker-compose.yml` thiếu backend + frontend → thêm 2 service mới | `docker-compose.yml`, `Dockerfile`s |
| **BUG‑12** | Google Translate TTS vi phạm ToS → bỏ, dùng pre‑generated audio + Web Speech | `src/utils/tts.js` |
| **BUG‑13** | Title tab browser luôn cố định → hook `useDocumentTitle` cho mọi trang | `src/hooks/useDocumentTitle.js` |
| **BUG‑14** | Thiếu index DB cho query phổ biến → migration V22 | `db/migration/V22__add_performance_indexes.sql` |
| **BUG‑15** | Loading state không nhất quán → component `Skeleton*` dùng chung | `src/components/Skeleton.jsx` |
| **TECH‑01** | Quarkus 3.8.4 → 3.15.1 LTS, axios → 1.7.x, lucide → 0.400+, react-router → 6.28+ | `pom.xml`, `package.json` |
| **TECH‑07** | Connection pool DB rõ ràng (min=5, max=20, timeout=30s) | `application.properties` |
| **BUG‑C00** | Backend Dockerfile dùng `./mvnw` (không tồn tại) → đổi sang `maven:3.9-eclipse-temurin-17`, thêm `wget` | `lingua-backend/Dockerfile` |
| **BUG‑C01** | `.env` thiếu `http://localhost` trong `CORS_ORIGINS` → Docker frontend bị block CORS | `webapp/.env`, `.env.example` |
| **BUG‑C02** | `start-backend.sh` chưa có / sai port MySQL & Redis & DB name → tạo mới với cấu hình đúng (3307/lingua_db/6380) | `webapp/start-backend.sh` |
| **BUG‑H01** | `ecosystem.config.cjs` hardcode `/home/user/webapp` → đổi sang `path.resolve(__dirname)`, sửa frontend `error_file` | `webapp/ecosystem.config.cjs` |
| **BUG‑H02** | `isFromTrustedProxy()` luôn `true` → check IP thật vs danh sách trusted | `AuthResource.java` |
| **BUG‑H03** | `clientIp()` trả `"unknown"` khi không có `X-Forwarded-For` → fallback IP từ Vert.x socket | `AuthResource.java` |
| **BUG‑M01** | Tài liệu nói port 5173 trong khi config là 3000 → đồng bộ về `3000` | `huongdanchay.md` |
| **BUG‑M02** | `lingua.refresh.lifespan-seconds` không khai báo → thêm vào properties + `.env.example` | `application.properties`, `.env.example` |
| **BUG‑M03** | Dockerfile HEALTHCHECK dùng `/q/health` (không có) → đổi sang `/api/health` | `lingua-backend/Dockerfile` |
| **BUG‑L01** | Comment `BUG-15` sót trong `vite.config.js` | `lingua-frontend/vite.config.js` |
| **BUG‑L02** | `VITE_API_BASE_URL` trong `.env.example` không dùng đến → xóa | `webapp/.env.example` |

---

## 10. Tài khoản test

> Tài khoản mặc định trong seed data (V2):

| Email | Mật khẩu | Vai trò |
|-------|---------|---------|
| `admin@lingua.local` | `lingua123` | ADMIN |
| `student@lingua.local` | `lingua123` | USER |

Hoặc đăng ký tài khoản mới qua trang `/register`.

---

## 11. Khắc phục sự cố

### `docker compose up -d --build` báo `failed to compute cache key: "/.mvn": not found` hoặc `"/mvnw": not found`

→ Bạn đang dùng `lingua-backend/Dockerfile` cũ (trước BUG‑C00). Bản patch hiện tại đã đổi sang dùng image `maven:3.9-eclipse-temurin-17` để khỏi phụ thuộc Maven wrapper. Kiểm tra:

```bash
head -3 lingua-backend/Dockerfile
# Phải thấy:
# FROM maven:3.9-eclipse-temurin-17 AS builder
```

Nếu vẫn thấy `eclipse-temurin:17-jdk` + `COPY .mvn/ .mvn/` → kéo bản code mới nhất.

### Backend container `unhealthy` mãi không UP

Nguyên nhân thường gặp:

1. **MySQL chưa sẵn sàng** — backend đợi MySQL healthy, nhưng MySQL container còn đang init data (lần đầu mất ~30-60s). Cứ chờ thêm và `docker compose logs -f backend`.
2. **Healthcheck dùng sai endpoint** — bản cũ dùng `/q/health` (extension `quarkus-smallrye-health` không có trong `pom.xml`). Bản patch đã đổi sang `/api/health`. Kiểm tra:
   ```bash
   grep "wget" lingua-backend/Dockerfile
   # Phải thấy /api/health, KHÔNG phải /q/health
   ```
3. **Thiếu `wget` trong runtime image** — image `eclipse-temurin:17-jre` chính thức không có `wget`. Bản patch đã thêm `apt-get install wget`. Nếu đang dùng image custom khác, hãy chuyển HEALTHCHECK sang dùng `curl` hoặc `nc`.

### Backend báo `Communications link failure / Unknown database 'lingua'` khi chạy qua PM2

→ `start-backend.sh` cũ dùng port 3306 và DB `lingua`. Bản patch đã sửa thành 3307 và `lingua_db`. Kiểm tra:

```bash
grep "jdbc:mysql" start-backend.sh
# Phải thấy: jdbc:mysql://127.0.0.1:3307/lingua_db?...
```

### Browser báo lỗi CORS khi truy cập http://localhost

→ Bạn đang thiếu `http://localhost` trong `CORS_ORIGINS` của `.env`. Sửa lại:

```env
CORS_ORIGINS=http://localhost,http://localhost:5173,http://localhost:3000
```

Sau đó:
```bash
docker compose down
docker compose up -d --build
```

### Backend không kết nối được MySQL

```bash
docker compose ps                  # Trạng thái container
docker compose logs mysql           # Logs MySQL
docker compose logs backend         # Logs backend (tìm "Could not connect")
```

Nếu thấy `Public Key Retrieval is not allowed` → kiểm tra trong `.env` rằng `DB_JDBC_URL` có chứa `allowPublicKeyRetrieval=true`.

### Flyway báo `Unsupported Database: MySQL 8.0`

→ Bạn đang dùng pom.xml cũ. Đảm bảo đã pull bản patch BUG‑01:

```bash
grep -A3 "flyway-mysql" lingua-backend/pom.xml
# Phải thấy: <version>10.10.0</version>
```

### `JWT public key not found` khi gọi API auth

```bash
# Kiểm tra public key đã ở đúng vị trí
ls -la lingua-backend/src/main/resources/META-INF/resources/publicKey.pem

# Nếu thiếu, copy lại từ secrets/
cp lingua-backend/secrets/publicKey.pem \
   lingua-backend/src/main/resources/META-INF/resources/publicKey.pem
```

### Frontend hiển thị trắng / 404 khi reload page sub‑URL

Khi serve qua Nginx (Dockerfile trong BUG‑11) đã có sẵn `try_files $uri /index.html`, nên SPA fallback hoạt động. Nếu deploy sau reverse proxy khác, thêm rule tương tự.

### Dark mode không bật hết toàn trang

Bạn có đang chạy bản patch BUG‑03 không? Kiểm tra:

```bash
grep -n "documentElement.classList.toggle" lingua-frontend/src/store/index.js
# Phải thấy dòng: document.documentElement.classList.toggle('dark', next)
```

### TTS không phát tiếng Nhật/Trung

→ Đây là hành vi mong muốn sau BUG‑12 (đã bỏ Google Translate TTS không chính thức). Hai phương án:

1. **Cài voice pack hệ điều hành**: Windows → Settings → Time & Language → Speech → Add voices (Japanese/Chinese). macOS → System Settings → Accessibility → Spoken Content → System Voice → Customize.
2. **Pre‑gen audio offline** rồi serve từ CDN/back‑end:
   ```bash
   cd webapp/scripts
   pip install gTTS
   python generate_audio_tts.py        # Tạo file .mp3 cho mọi từ vựng
   ```
   Sau đó truyền `audioUrl` vào `speak({ text, audioUrl, lang })` thay vì để fallback Web Speech.

### Migration V22 báo "duplicate key name"

→ Hiếm gặp, nhưng nếu DB đã có sẵn index cùng tên thì stored procedure trong V22 đã có `IF NOT EXISTS` check — vẫn an toàn để chạy lại. Nếu vẫn lỗi:

```bash
# Reset Flyway history một version
docker compose exec mysql mysql -ulingua -p lingua_db \
  -e "DELETE FROM flyway_schema_history WHERE version='22';"
docker compose restart backend
```

---

## 📝 Ghi chú dành cho dev

- Khi commit code: **luôn kiểm tra** `git status` không thấy file `*.pem` nào ngoài `publicKey.pem`. Nếu thấy, bỏ ngay khỏi staging và rotate key.
- Khi nâng version Quarkus tiếp theo, kiểm tra lại tương thích của `flyway-mysql` (hiện gắn cứng `10.10.0`).
- Khi thêm trang mới: **luôn gọi** `useDocumentTitle('Tên trang')` ở đầu component để đồng nhất tiêu đề tab.
- Khi thêm API list mới: cân nhắc thêm index DB tương ứng trong migration `V23__...`.

---

**Chúc bạn coding vui vẻ! 🎉**
Mọi thắc mắc / bug mới: mở issue trong repo Second Brain hoặc liên hệ team.
