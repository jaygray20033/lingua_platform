#!/usr/bin/env python3
"""
UPGRADE-07: Pre-generate TTS audio files for vocabulary words.

Reads words that have NULL audio_url from the lingua_db, calls Google's
free Translate-TTS endpoint (or `gTTS` if installed locally), saves the
resulting MP3 under  /uploads/tts/<lang>/<word_id>.mp3, then writes the
relative URL back to the words.audio_url column.

Usage:
    pip install gtts mysql-connector-python
    python3 scripts/generate_audio_tts.py \
        --host localhost --port 3307 \
        --user root --password lingua123 \
        --db lingua_db \
        --output /home/user/webapp/lingua-backend/uploads/tts \
        --base-url /uploads/tts \
        --limit 200

Notes:
  - Idempotent: only processes rows where audio_url IS NULL.
  - Rate-limited: sleeps 0.4s between requests (Google TTS courtesy).
  - You can re-run this safely after seeding new vocabulary.
"""
from __future__ import annotations

import argparse
import os
import sys
import time
from pathlib import Path

# Map our internal language codes -> gTTS language codes.
LANG_MAP = {"ja": "ja", "en": "en", "zh": "zh-CN", "ko": "ko", "vi": "vi"}


def main() -> int:
    parser = argparse.ArgumentParser(description="Pre-generate TTS audio for words")
    parser.add_argument("--host", default="localhost")
    parser.add_argument("--port", type=int, default=3307)
    parser.add_argument("--user", default="root")
    parser.add_argument("--password", default="lingua123")
    parser.add_argument("--db", default="lingua_db")
    parser.add_argument("--output", required=True, help="Filesystem dir to write MP3 files")
    parser.add_argument("--base-url", default="/uploads/tts",
                        help="URL prefix saved in audio_url (e.g. /uploads/tts)")
    parser.add_argument("--limit", type=int, default=200,
                        help="Max number of words to process this run")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    try:
        import mysql.connector
        from gtts import gTTS  # type: ignore
    except ImportError as e:
        print(f"❌ Missing dependency: {e}", file=sys.stderr)
        print("    Install with: pip install gtts mysql-connector-python",
              file=sys.stderr)
        return 1

    out_root = Path(args.output)
    out_root.mkdir(parents=True, exist_ok=True)

    cnx = mysql.connector.connect(
        host=args.host, port=args.port,
        user=args.user, password=args.password, database=args.db,
        charset="utf8mb4", use_unicode=True,
    )
    cursor = cnx.cursor(dictionary=True)

    cursor.execute("""
        SELECT w.id, w.text, w.reading, l.code AS lang_code
          FROM words w
          JOIN languages l ON l.id = w.language_id
         WHERE w.audio_url IS NULL
         ORDER BY w.frequency_rank ASC
         LIMIT %s
    """, (args.limit,))
    rows = cursor.fetchall()
    print(f"Found {len(rows)} words without audio.")

    processed, failed = 0, 0
    for r in rows:
        wid = r["id"]
        text = r["text"]
        lang = LANG_MAP.get(r["lang_code"], "en")
        lang_dir = out_root / r["lang_code"]
        lang_dir.mkdir(parents=True, exist_ok=True)
        mp3_path = lang_dir / f"{wid}.mp3"

        if args.dry_run:
            print(f"  would generate {mp3_path} for «{text}» ({lang})")
            continue

        try:
            tts = gTTS(text=text, lang=lang, slow=False)
            tts.save(str(mp3_path))
            url = f"{args.base_url.rstrip('/')}/{r['lang_code']}/{wid}.mp3"
            cursor.execute(
                "UPDATE words SET audio_url = %s WHERE id = %s",
                (url, wid),
            )
            cnx.commit()
            processed += 1
            print(f"  ✅ {wid:6d} «{text}» -> {url}")
        except Exception as exc:
            failed += 1
            print(f"  ❌ {wid:6d} «{text}» failed: {exc}", file=sys.stderr)
        time.sleep(0.4)  # be polite to Google

    cursor.close()
    cnx.close()
    print(f"Done — processed {processed}, failed {failed}, total {len(rows)}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
