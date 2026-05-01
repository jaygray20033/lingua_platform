import { useEffect, useRef, useState } from 'react'

export default function AudioRecorder({ targetText, onScore, maxSeconds = 30 }) {
  const [status, setStatus] = useState('idle')
  const [error, setError] = useState(null)
  const [audioUrl, setAudioUrl] = useState(null)
  const [duration, setDuration] = useState(0)
  const recorderRef = useRef(null)
  const chunksRef = useRef([])
  const startTsRef = useRef(0)
  const autoStopRef = useRef(null)

  useEffect(() => () => {
    if (audioUrl) URL.revokeObjectURL(audioUrl)
    if (autoStopRef.current) clearTimeout(autoStopRef.current)
  }, [audioUrl])

  async function start() {
    setError(null)
    try {
      if (!navigator.mediaDevices || !window.MediaRecorder) {
        throw new Error('Trình duyệt không hỗ trợ ghi âm')
      }
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
      const mr = new MediaRecorder(stream)
      chunksRef.current = []
      mr.ondataavailable = e => { if (e.data.size > 0) chunksRef.current.push(e.data) }
      mr.onstop = () => {
        stream.getTracks().forEach(t => t.stop())
        const blob = new Blob(chunksRef.current, { type: mr.mimeType || 'audio/webm' })
        const url = URL.createObjectURL(blob)
        setAudioUrl(prev => {
          if (prev) URL.revokeObjectURL(prev)
          return url
        })
        const dur = (Date.now() - startTsRef.current) / 1000
        setDuration(dur)
        setStatus('stopped')
        if (typeof onScore === 'function') {
          try { onScore(blob, dur) } catch {}
        }
      }
      mr.start()
      recorderRef.current = mr
      startTsRef.current = Date.now()
      setStatus('recording')
      autoStopRef.current = setTimeout(() => {
        if (recorderRef.current?.state === 'recording') stop()
      }, maxSeconds * 1000)
    } catch (e) {
      setError(e.message || 'Không thể truy cập micro')
      setStatus('error')
    }
  }

  function stop() {
    if (autoStopRef.current) clearTimeout(autoStopRef.current)
    const mr = recorderRef.current
    if (mr && mr.state !== 'inactive') mr.stop()
  }

  function speakTarget() {
    if (!targetText || !('speechSynthesis' in window)) return
    const u = new SpeechSynthesisUtterance(targetText)
    u.rate = 0.9
    window.speechSynthesis.speak(u)
  }

  return (
    <section className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-100 dark:border-gray-700">
      <header className="mb-4">
        <p className="text-sm text-gray-500 dark:text-gray-400">Hãy đọc to câu sau:</p>
        <p className="text-2xl font-semibold text-gray-900 dark:text-white mt-1">{targetText}</p>
        <button
          type="button"
          onClick={speakTarget}
          className="mt-2 text-sm text-blue-600 hover:underline"
        >
          🔊 Nghe mẫu
        </button>
      </header>

      <div className="flex items-center gap-3">
        {status !== 'recording' ? (
          <button
            type="button"
            onClick={start}
            className="flex items-center gap-2 px-5 py-3 bg-red-500 hover:bg-red-600 text-white rounded-full font-semibold"
          >
            <span className="text-lg">●</span> Bắt đầu ghi âm
          </button>
        ) : (
          <button
            type="button"
            onClick={stop}
            className="flex items-center gap-2 px-5 py-3 bg-gray-700 hover:bg-gray-800 text-white rounded-full font-semibold animate-pulse"
          >
            <span className="text-lg">■</span> Dừng ghi âm
          </button>
        )}
        {status === 'recording' && (
          <span className="text-sm text-gray-500">Đang ghi… tối đa {maxSeconds}s</span>
        )}
        {status === 'stopped' && duration > 0 && (
          <span className="text-sm text-gray-500">Đã ghi {duration.toFixed(1)}s</span>
        )}
      </div>

      {audioUrl && (
        <div className="mt-4">
          <p className="text-sm text-gray-500 mb-2">Phát lại giọng của bạn:</p>
          <audio controls src={audioUrl} className="w-full" />
        </div>
      )}

      {error && (
        <p className="mt-3 text-sm text-red-600">⚠ {error}</p>
      )}
    </section>
  )
}
