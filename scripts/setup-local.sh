#!/bin/bash
# =====================================================
# LINGUA - Setup local sandbox environment
# Idempotent: safe to run multiple times after sandbox reset
# =====================================================
set -e

echo "[1/6] Installing system packages (java, maven, mariadb, redis)..."
sudo apt-get install -y -q openjdk-21-jdk-headless maven mariadb-server redis-server 2>&1 | tail -3

echo "[2/6] Starting MariaDB & Redis..."
sudo service mariadb start 2>&1 | tail -1
sudo service redis-server start 2>&1 | tail -1
sleep 2

echo "[3/6] Creating database & user..."
sudo mariadb -e "
DROP DATABASE IF EXISTS lingua;
CREATE DATABASE lingua CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'lingua'@'localhost' IDENTIFIED BY 'lingua123';
CREATE USER IF NOT EXISTS 'lingua'@'127.0.0.1' IDENTIFIED BY 'lingua123';
GRANT ALL ON lingua.* TO 'lingua'@'localhost';
GRANT ALL ON lingua.* TO 'lingua'@'127.0.0.1';
FLUSH PRIVILEGES;"

echo "[4/6] Loading migrations (utf8mb4)..."
cd /home/user/webapp/lingua-backend/src/main/resources/db/migration
ALL_OK=1
for f in V1*.sql V2*.sql V3*.sql V4*.sql V5*.sql V6*.sql V7*.sql V8*.sql; do
  # IMPORTANT: --default-character-set=utf8mb4 to avoid double-encoding
  out=$(sudo mariadb --default-character-set=utf8mb4 lingua < "$f" 2>&1)
  if echo "$out" | grep -qi "error"; then
    echo "  FAIL: $f"
    echo "$out" | tail -3
    ALL_OK=0
  else
    echo "  OK: $f"
  fi
done

echo "[5/6] Counts:"
sudo mariadb lingua -e "
SELECT 'courses' AS tbl, COUNT(*) AS cnt FROM courses
UNION SELECT 'sections', COUNT(*) FROM sections
UNION SELECT 'units', COUNT(*) FROM units
UNION SELECT 'lessons', COUNT(*) FROM lessons
UNION SELECT 'exercises', COUNT(*) FROM exercises
UNION SELECT 'words', COUNT(*) FROM words
UNION SELECT 'word_meanings', COUNT(*) FROM word_meanings
UNION SELECT 'characters', COUNT(*) FROM characters_table
UNION SELECT 'grammars', COUNT(*) FROM grammars
UNION SELECT 'mock_tests', COUNT(*) FROM mock_tests
UNION SELECT 'mock_test_questions', COUNT(*) FROM mock_test_questions;"

if [ "$ALL_OK" = "1" ]; then
  echo "[6/6] All migrations passed!"
else
  echo "[6/6] Some migrations failed - check above"
  exit 1
fi
