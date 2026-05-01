#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

exec java \
  -Dfile.encoding=UTF-8 \
  -Dquarkus.profile=local \
  -Dquarkus.http.host=0.0.0.0 \
  -Dquarkus.datasource.jdbc.url='jdbc:mysql://127.0.0.1:3307/lingua_db?useUnicode=true&characterEncoding=UTF-8&connectionCollation=utf8mb4_unicode_ci&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false' \
  -Dquarkus.datasource.username=lingua \
  -Dquarkus.datasource.password=lingua123 \
  -Dquarkus.redis.hosts=redis://127.0.0.1:6380 \
  -jar lingua-backend/target/quarkus-app/quarkus-run.jar
