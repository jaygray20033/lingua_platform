import { useEffect, useRef, useState } from 'react'

export default function ListeningPlayer({ audioUrl, text, lang = 'ja-JP' }) {
  const audioRef = useRef(null)
  const [speed, setSpeed] = useState(1.0)
  const [isPlaying, setIsPlaying] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    if (audioRef.current) audioRef.current.playbackRate = speed
  }, [speed])

  function playNative() {
    if (!audioRef.current) return
    setError(null)
    audioRef.current.playbackRate = speed
    audioRef.current.play().then(() => setIsPlaying(true)).catch(e => setError(e.message))
  }
  function pauseNative() {
    audioRef.current?.pause()
    setIsPlaying(false)
  }
  function playTts() {
    if (!('speechSynthesis' in window) || !text) {
      setError('Trình duyệt không hỗ trợ phát giọng nói')
      return
    }
    window.speechSynthesis.cancel()
    const u = new SpeechSynthesisUtterance(text)
    u.lang = lang
    u.rate = speed
    u.onend = () => setIsPlaying(false)
    u.onerror = () => setIsPlaying(false)
    window.speechSynthesis.speak(u)
    setIsPlaying(true)
  }

  const hasAudio = !!audioUrl
  const speeds = [0.5, 0.75, 1.0, 1.25, 1.5]

  return (
    <section className="bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-700 rounded-xl p-5 border border-blue-100 dark:border-gray-700">
      <div className="flex items-center gap-4">
        {!isPlaying ? (
          <button
            type="button"
            onClick={hasAudio ? playNative : playTts}
            aria-label="Phát"
            className="w-14 h-14 bg-blue-500 hover:bg-blue-600 text-white rounded-full flex items-center justify-center text-2xl"
          >
            ▶
          </button>
        ) : (
          <button
            type="button"
            onClick={hasAudio ? pauseNative : () => { window.speechSynthesis?.cancel(); setIsPlaying(false) }}
            aria-label="Dừng"
            className="w-14 h-14 bg-gray-700 text-white rounded-full flex items-center justify-center text-2xl"
          >
            ■
          </button>
        )}
        <div className="flex-1">
          <p className="text-sm text-gray-500 dark:text-gray-400">Tốc độ phát</p>
          <div className="flex gap-2 mt-1 flex-wrap">
            {speeds.map(s => (
              <button
                key={s}
                type="button"
                onClick={() => setSpeed(s)}
                className={`px-3 py-1 rounded text-sm font-medium ${
                  speed === s
                    ? 'bg-blue-500 text-white'
                    : 'bg-white text-gray-700 border border-gray-200 hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-200 dark:border-gray-600'
                }`}
              >
                {s}×
              </button>
            ))}
          </div>
        </div>
      </div>
      {hasAudio && (
        <audio
          ref={audioRef}
          src={audioUrl}
          onEnded={() => setIsPlaying(false)}
          onError={() => setError('Không thể tải audio')}
          preload="auto"
          className="hidden"
        />
      )}
      {!hasAudio && text && (
        <p className="mt-3 text-xs text-gray-500">Dùng giọng đọc trình duyệt (TTS)</p>
      )}
      {error && <p className="mt-2 text-sm text-red-600">⚠ {error}</p>}
    </section>
  )
}
