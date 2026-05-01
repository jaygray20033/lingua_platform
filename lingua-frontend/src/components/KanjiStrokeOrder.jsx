import { useEffect, useRef, useState } from 'react'

export default function KanjiStrokeOrder({
  character,
  strokeOrderJson,
  size = 220,
  showOutline = true,
  autoPlay = true,
}) {
  const containerRef = useRef(null)
  const writerRef = useRef(null)
  const [error, setError] = useState(null)
  const [ready, setReady] = useState(false)

  const [visibleStrokes, setVisibleStrokes] = useState(0)
  const animTimerRef = useRef(null)

  const parsedStrokes = parseStrokes(strokeOrderJson)
  const useInlineSvg = parsedStrokes.length > 0

  useEffect(() => {
    if (!useInlineSvg) return undefined
    setVisibleStrokes(0)
    if (animTimerRef.current) clearInterval(animTimerRef.current)
    if (!autoPlay) {
      setVisibleStrokes(parsedStrokes.length)
      return undefined
    }
    let i = 0
    animTimerRef.current = setInterval(() => {
      i += 1
      setVisibleStrokes(i)
      if (i >= parsedStrokes.length) {
        clearInterval(animTimerRef.current)
        animTimerRef.current = null
      }
    }, 450)
    return () => {
      if (animTimerRef.current) clearInterval(animTimerRef.current)
    }
  }, [character, strokeOrderJson, autoPlay, useInlineSvg, parsedStrokes.length])

  useEffect(() => {
    if (useInlineSvg) return undefined
    let cancelled = false

    async function ensureHanziWriter() {
      if (window.HanziWriter) return window.HanziWriter
      return new Promise((resolve, reject) => {
        const existing = document.getElementById('hanzi-writer-cdn')
        if (existing) {
          existing.addEventListener('load', () => resolve(window.HanziWriter))
          existing.addEventListener('error', reject)
          return
        }
        const s = document.createElement('script')
        s.id = 'hanzi-writer-cdn'
        s.src = 'https://cdn.jsdelivr.net/npm/hanzi-writer@3.5/dist/hanzi-writer.min.js'
        s.async = true
        s.onload = () => resolve(window.HanziWriter)
        s.onerror = () => reject(new Error('Could not load HanziWriter CDN'))
        document.head.appendChild(s)
      })
    }

    async function init() {
      if (!character || !containerRef.current) return
      try {
        const HW = await ensureHanziWriter()
        if (cancelled) return
        containerRef.current.innerHTML = ''
        writerRef.current = HW.create(containerRef.current, character, {
          width: size,
          height: size,
          padding: 5,
          showOutline,
          strokeAnimationSpeed: 1,
          delayBetweenStrokes: 200,
          strokeColor: '#16a34a',
          outlineColor: '#d1d5db',
          radicalColor: '#2563eb',
        })
        setReady(true)
        if (autoPlay) {
          setTimeout(() => {
            try { writerRef.current?.animateCharacter() } catch {}
          }, 200)
        }
      } catch (e) {
        if (!cancelled) setError(e.message || 'Không thể tải stroke order')
      }
    }

    init()
    return () => { cancelled = true }
  }, [character, size, showOutline, autoPlay, useInlineSvg])

  function replay() {
    if (useInlineSvg) {
      setVisibleStrokes(0)
      let i = 0
      if (animTimerRef.current) clearInterval(animTimerRef.current)
      animTimerRef.current = setInterval(() => {
        i += 1
        setVisibleStrokes(i)
        if (i >= parsedStrokes.length) {
          clearInterval(animTimerRef.current)
          animTimerRef.current = null
        }
      }, 450)
      return
    }
    try { writerRef.current?.animateCharacter() } catch {}
  }
  function quiz() {
    try { writerRef.current?.quiz({ showHintAfterMisses: 2 }) } catch {}
  }

  return (
    <figure className="inline-flex flex-col items-center gap-3">
      {useInlineSvg ? (
        <svg
          width={size}
          height={size}
          viewBox="0 0 109 109"
          role="img"
          aria-label={`Stroke order animation for ${character}`}
          className="bg-white border-2 border-gray-200 rounded-lg shadow-sm dark:bg-gray-800 dark:border-gray-700"
        >

          {showOutline && (
            <g stroke="#d1d5db" fill="none" strokeWidth={3} strokeLinecap="round" strokeLinejoin="round">
              {parsedStrokes.map((d, i) => (
                <path key={`outline-${i}`} d={d} />
              ))}
            </g>
          )}

          <g stroke="#16a34a" fill="none" strokeWidth={4} strokeLinecap="round" strokeLinejoin="round">
            {parsedStrokes.slice(0, visibleStrokes).map((d, i) => (
              <path
                key={`stroke-${i}`}
                d={d}
                style={{
                  strokeDasharray: 1000,
                  strokeDashoffset: 0,
                  animation: 'kanji-stroke-draw 0.4s ease-out',
                }}
              />
            ))}
          </g>

          <text x={4} y={104} fontSize={8} fill="#9ca3af">
            {visibleStrokes}/{parsedStrokes.length}
          </text>
          <style>{`
            @keyframes kanji-stroke-draw {
              from { stroke-dashoffset: 1000; opacity: 0.4; }
              to   { stroke-dashoffset: 0;    opacity: 1;   }
            }
          `}</style>
        </svg>
      ) : (
        <div
          ref={containerRef}
          role="img"
          aria-label={`Stroke order animation for ${character}`}
          style={{ width: size, height: size }}
          className="bg-white border-2 border-gray-200 rounded-lg shadow-sm dark:bg-gray-800 dark:border-gray-700"
        />
      )}
      {error && <p className="text-red-500 text-sm">{error}</p>}
      {(ready || useInlineSvg) && !error && (
        <div className="flex gap-2">
          <button
            type="button"
            onClick={replay}
            className="px-3 py-1 bg-green-500 hover:bg-green-600 text-white text-sm rounded"
          >
            ▶ Xem lại
          </button>
          {!useInlineSvg && (
            <button
              type="button"
              onClick={quiz}
              className="px-3 py-1 bg-blue-500 hover:bg-blue-600 text-white text-sm rounded"
            >
              ✏ Luyện viết
            </button>
          )}
          {useInlineSvg && (
            <span className="text-xs text-gray-400 self-center" title="Dữ liệu KanjiVG đã được nạp sẵn">
              ⚡ KanjiVG
            </span>
          )}
        </div>
      )}
    </figure>
  )
}

function parseStrokes(input) {
  if (!input) return []
  if (Array.isArray(input)) return input.filter(Boolean)
  if (typeof input === 'string') {
    const trimmed = input.trim()
    if (!trimmed) return []
    try {
      const parsed = JSON.parse(trimmed)
      if (Array.isArray(parsed)) return parsed.filter(Boolean)

      if (parsed && Array.isArray(parsed.strokes)) return parsed.strokes.filter(Boolean)
    } catch {
      return []
    }
  }
  return []
}
