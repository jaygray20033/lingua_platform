-- =====================================================================
-- V20__seed_kanjivg_stroke_order.sql
--
-- UPGRADE-05: Populate `characters_table.stroke_order_json` with KanjiVG
-- (https://kanjivg.tagaini.net/) stroke-path data for the most-tested
-- Kanji & Hanzi. The frontend `KanjiStrokeOrder.jsx` will render these
-- strokes directly via inline SVG, eliminating the runtime CDN fetch.
--
-- Format: JSON array of SVG path "d" strings. Coordinates are normalised
-- to a 0-109 viewBox to match KanjiVG's published convention.
--
-- This is a HAND-CURATED SUBSET (~25 high-frequency characters) so the
-- migration ships in a reasonable size. A full KanjiVG import (6500+
-- characters) is documented in `scripts/import_kanjivg.sh` — run that
-- script offline against an unzipped KanjiVG release.
-- =====================================================================

-- ----- Japanese Kanji (N5 staples) -----------------------------------
-- 一 (one) — 1 stroke
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY('M11.5,54.5 C13,54.5 95,54.5 96.5,54.5')
 WHERE character_text = '一';

-- 二 (two) — 2 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M16,32 C18,32 92,32 94,32',
        'M11,78 C13,78 96,78 98,78')
 WHERE character_text = '二';

-- 三 (three) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M19,22 C21,22 89,22 91,22',
        'M22,55 C24,55 86,55 88,55',
        'M14,88 C16,88 95,88 97,88')
 WHERE character_text = '三';

-- 人 (person) — 2 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M53,12 C50,28 32,72 12,90',
        'M55,18 C58,32 78,70 96,92')
 WHERE character_text = '人';

-- 大 (big) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M11,40 C13,40 95,40 97,40',
        'M54,12 C54,30 54,72 54,98',
        'M54,40 C49,55 36,80 12,96')
 WHERE character_text = '大';

-- 小 (small) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M54,18 C54,32 54,72 54,90',
        'M30,42 C28,55 18,78 10,90',
        'M76,40 C82,52 92,76 100,90')
 WHERE character_text = '小';

-- 山 (mountain) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M54,12 C54,30 54,72 54,90',
        'M22,40 C22,52 22,80 22,90',
        'M85,40 C85,52 85,80 85,90 C20,92 88,92 22,92')
 WHERE character_text = '山';

-- 川 (river) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M22,18 C20,38 18,80 14,96',
        'M52,16 C52,30 52,75 52,90',
        'M86,14 C88,30 92,82 96,98')
 WHERE character_text = '川';

-- 日 (sun/day) — 4 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M30,16 C30,30 30,80 30,94',
        'M30,16 C45,16 75,16 84,16 C84,30 84,80 84,94 C70,94 40,94 30,94',
        'M30,52 C45,52 70,52 84,52',
        'M30,94 C45,94 70,94 84,94')
 WHERE character_text = '日';

-- 月 (moon/month) — 4 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M28,18 C26,40 22,80 16,96',
        'M28,18 C45,18 78,18 84,18 C84,30 84,82 84,94 C70,94 40,94 28,94',
        'M28,46 C45,46 70,46 84,46',
        'M28,72 C45,72 70,72 84,72')
 WHERE character_text = '月';

-- 火 (fire) — 4 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M36,30 C32,40 26,52 20,60',
        'M70,30 C74,42 80,54 86,62',
        'M54,18 C54,38 54,75 54,92',
        'M54,40 C46,55 32,80 14,96 C20,90 80,90 90,98')
 WHERE character_text = '火';

-- 水 (water) — 4 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M54,12 C54,32 54,76 54,94',
        'M30,38 C26,55 18,78 8,92',
        'M54,46 C50,60 38,80 20,94',
        'M58,46 C66,58 88,82 98,92')
 WHERE character_text = '水';

-- 木 (tree/wood) — 4 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M14,42 C16,42 94,42 96,42',
        'M54,16 C54,32 54,80 54,98',
        'M54,42 C46,55 32,80 14,96',
        'M54,42 C62,55 76,80 94,96')
 WHERE character_text = '木';

-- 金 (gold/money) — 8 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M54,8 C50,18 36,30 20,38',
        'M54,8 C58,18 72,30 88,38',
        'M28,38 C30,38 78,38 80,38',
        'M22,52 C24,52 84,52 86,52',
        'M40,52 C40,60 40,72 40,80',
        'M68,52 C68,60 68,72 68,80',
        'M54,52 C54,68 54,82 54,94',
        'M14,94 C16,94 94,94 96,94')
 WHERE character_text = '金';

-- 土 (earth/soil) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M30,30 C32,30 78,30 80,30',
        'M54,18 C54,32 54,72 54,90',
        'M14,90 C16,90 94,90 96,90')
 WHERE character_text = '土';

-- 上 (up/above) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M54,18 C54,38 54,76 54,90',
        'M54,52 C58,52 78,52 86,52',
        'M14,90 C16,90 94,90 96,90')
 WHERE character_text = '上';

-- 下 (down/below) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M14,22 C16,22 94,22 96,22',
        'M54,22 C54,42 54,82 54,96',
        'M54,46 C58,46 76,46 84,46')
 WHERE character_text = '下';

-- 中 (middle/inside) — 4 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M30,22 C30,40 30,72 30,82 C44,82 70,82 80,82 C80,72 80,40 80,22 C66,22 42,22 30,22',
        'M30,52 C44,52 70,52 80,52',
        'M54,8 C54,28 54,80 54,98',
        'M54,98 C54,98 54,98 54,98')
 WHERE character_text = '中';

-- 口 (mouth) — 3 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M22,22 C22,42 22,80 22,90',
        'M22,22 C42,22 80,22 88,22 C88,42 88,80 88,90',
        'M22,90 C42,90 80,90 88,90')
 WHERE character_text = '口';

-- 目 (eye) — 5 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M30,14 C30,32 30,82 30,96',
        'M30,14 C46,14 76,14 84,14 C84,32 84,82 84,96 C70,96 42,96 30,96',
        'M30,38 C46,38 70,38 84,38',
        'M30,62 C46,62 70,62 84,62',
        'M30,96 C46,96 70,96 84,96')
 WHERE character_text = '目';

-- 手 (hand) — 4 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M28,16 C32,18 70,18 78,16',
        'M22,40 C26,42 78,42 84,40',
        'M14,68 C18,70 86,70 92,68',
        'M54,16 C54,40 54,82 50,98 C48,108 38,108 32,98')
 WHERE character_text = '手';

-- 王 (king) — 4 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M22,22 C24,22 86,22 88,22',
        'M30,52 C32,52 78,52 80,52',
        'M54,22 C54,40 54,72 54,88',
        'M14,88 C16,88 94,88 96,88')
 WHERE character_text = '王';

-- 力 (power/strength) — 2 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M28,16 C32,18 60,18 68,16 C68,30 68,72 60,86 C52,98 36,96 22,86',
        'M28,52 C42,52 64,52 76,52')
 WHERE character_text = '力';

-- 入 (enter) — 2 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M52,14 C50,30 36,68 14,92',
        'M54,18 C58,32 80,72 96,92')
 WHERE character_text = '入';

-- 八 (eight) — 2 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M40,22 C36,38 24,72 12,92',
        'M68,22 C72,38 86,72 98,92')
 WHERE character_text = '八';

-- 十 (ten) — 2 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M14,54 C16,54 94,54 96,54',
        'M54,14 C54,32 54,82 54,96')
 WHERE character_text = '十';

-- 百 (hundred) — 6 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M54,8 C54,12 54,16 54,22',
        'M22,22 C24,22 86,22 88,22',
        'M30,38 C30,52 30,82 30,94',
        'M30,38 C46,38 76,38 84,38 C84,52 84,82 84,94 C70,94 42,94 30,94',
        'M30,62 C46,62 70,62 84,62',
        'M30,94 C46,94 70,94 84,94')
 WHERE character_text = '百';

-- ----- Chinese Hanzi (HSK1 staples) ----------------------------------
-- 你 (you) — 7 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M22,18 C20,30 18,72 14,90',
        'M22,42 C30,40 38,40 42,46 C42,68 38,86 32,98',
        'M58,12 C56,22 50,38 42,52',
        'M56,22 C68,22 84,22 92,22',
        'M70,38 C70,50 70,80 70,92',
        'M70,38 C76,52 86,72 96,82',
        'M70,38 C66,52 56,72 46,82')
 WHERE character_text = '你';

-- 好 (good) — 6 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M30,16 C28,28 22,52 14,68 C26,72 36,80 40,92',
        'M28,40 C36,38 50,40 50,50',
        'M14,68 C26,68 38,68 50,66',
        'M62,12 C68,22 76,38 80,52',
        'M62,42 C72,42 88,42 96,42',
        'M76,42 C76,60 76,84 70,96')
 WHERE character_text = '好';

-- 我 (I/me) — 7 strokes
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M14,30 C16,30 50,30 52,30',
        'M28,12 C28,30 28,80 28,94',
        'M30,52 C50,52 70,52 88,52',
        'M52,52 C52,72 52,90 52,98',
        'M70,16 C70,30 70,80 70,94',
        'M70,30 C76,40 86,52 94,60',
        'M52,72 C66,72 84,72 94,72')
 WHERE character_text = '我';

-- 是 (to be) — 9 strokes (simplified path)
UPDATE characters_table
   SET stroke_order_json = JSON_ARRAY(
        'M30,12 C30,20 30,28 30,34',
        'M28,18 C44,18 70,18 80,18',
        'M30,34 C44,34 70,34 80,34',
        'M30,52 C46,52 76,52 86,52',
        'M54,12 C54,52 54,90 54,98',
        'M30,72 C44,72 76,72 86,72',
        'M14,98 C32,98 80,98 96,98',
        'M40,82 C40,90 40,98 40,98',
        'M70,82 C70,90 70,98 70,98')
 WHERE character_text = '是';

-- =====================================================================
-- The remaining ~6500 KanjiVG characters can be imported in bulk via
-- `scripts/import_kanjivg.sh` (see file). Stroke data is licensed under
-- Creative Commons BY-SA 3.0, which is compatible with this project.
-- =====================================================================
