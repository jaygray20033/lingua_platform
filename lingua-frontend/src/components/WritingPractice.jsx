import { useEffect, useRef, useState } from 'react'

export default function WritingPractice({ character, size = 240 }) {
  const canvasRef = useRef(null)
  const guideRef = useRef(null)
  const writerRef = useRef(null)
  const drawingRef = useRef(false)
  const [mode, setMode] = useState('free')
  const [ready, setReady] = useState(false)

  useEffect(() => {
    const c = canvasRef.current
    if (!c) return
    const ctx = c.getContext('2d')
    ctx.lineWidth = 6
    ctx.lineCap = 'round'
    ctx.lineJoin = 'round'
    ctx.strokeStyle = '#111827'
    clear()
  }, [size])

  useEffect(() => {
    if (!character || !guideRef.current) return
    let cancelled = false

    async function loadHW() {
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
      try {
        const HW = await loadHW()
        if (cancelled) return
        guideRef.current.innerHTML = ''
        writerRef.current = HW.create(guideRef.current, character, {
          width: size,
          height: size,
          padding: 10,
          showOutline: true,
          strokeColor: 'rgba(34,197,94,0.35)',
          outlineColor: 'rgba(107,114,128,0.4)',
        })
        setReady(true)
      } catch {}
    }
    init()
    return () => { cancelled = true }
  }, [character, size])

  function pos(e) {
    const rect = canvasRef.current.getBoundingClientRect()
    const p = e.touches ? e.touches[0] : e
    return { x: p.clientX - rect.left, y: p.clientY - rect.top }
  }
  function begin(e) {
    e.preventDefault()
    drawingRef.current = true
    const ctx = canvasRef.current.getContext('2d')
    const { x, y } = pos(e)
    ctx.beginPath()
    ctx.moveTo(x, y)
  }
  function move(e) {
    if (!drawingRef.current) return
    e.preventDefault()
    const ctx = canvasRef.current.getContext('2d')
    const { x, y } = pos(e)
    ctx.lineTo(x, y)
    ctx.stroke()
  }
  function end() { drawingRef.current = false }

  function clear() {
    const c = canvasRef.current
    if (!c) return
    const ctx = c.getContext('2d')
    ctx.clearRect(0, 0, c.width, c.height)
  }

  function playGuide() {
    try { writerRef.current?.animateCharacter() } catch {}
  }

  return (
    <section className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-100 dark:border-gray-700">
      <header className="mb-4 flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-500">Luyện viết ký tự:</p>
          <p className="text-3xl font-semibold">{character || '—'}</p>
        </div>
        <div className="flex gap-2">
          <button
            type="button"
            onClick={() => setMode(mode === 'free' ? 'guided' : 'free')}
            className="px-3 py-1 bg-gray-200 dark:bg-gray-700 rounded text-sm"
          >
            {mode === 'free' ? 'Bật hướng dẫn' : 'Tắt hướng dẫn'}
          </button>
          {ready && (
            <button
              type="button"
              onClick={playGuide}
              className="px-3 py-1 bg-blue-500 hover:bg-blue-600 text-white rounded text-sm"
            >
              ▶ Xem thứ tự
            </button>
          )}
          <button
            type="button"
            onClick={clear}
            className="px-3 py-1 bg-red-100 hover:bg-red-200 text-red-700 rounded text-sm"
          >
            Xoá
          </button>
        </div>
      </header>

      <div className="relative mx-auto border-2 border-dashed border-gray-300 rounded-lg" style={{ width: size, height: size }}>

        {mode === 'guided' && (
          <div
            ref={guideRef}
            aria-hidden="true"
            className="absolute inset-0"
            style={{ pointerEvents: 'none' }}
          />
        )}

        <canvas
          ref={canvasRef}
          width={size}
          height={size}
          className="absolute inset-0 touch-none cursor-crosshair"
          onMouseDown={begin}
          onMouseMove={move}
          onMouseUp={end}
          onMouseLeave={end}
          onTouchStart={begin}
          onTouchMove={move}
          onTouchEnd={end}
        />
      </div>
      <p className="mt-3 text-xs text-gray-500 text-center">
        Dùng chuột hoặc ngón tay để vẽ. Nhấn "Xem thứ tự" để xem mẫu nét đúng.
      </p>
    </section>
  )
}
