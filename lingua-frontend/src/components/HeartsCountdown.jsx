import { useEffect, useState } from 'react'
import { Heart } from 'lucide-react'
import { useGamificationStore } from '../store'

export default function HeartsCountdown({ nextHeartAt, regenMinutes = 30, compact = false }) {
  const { hearts } = useGamificationStore()
  const MAX = 5
  const [now, setNow] = useState(() => Date.now())

  useEffect(() => {
    if (!nextHeartAt) return
    const id = setInterval(() => setNow(Date.now()), 1000)
    return () => clearInterval(id)
  }, [nextHeartAt])

  const fullHearts = hearts >= MAX
  let remainingMs = 0
  let progressPct = 0

  if (nextHeartAt && !fullHearts) {
    const target = new Date(nextHeartAt).getTime()
    remainingMs = Math.max(0, target - now)
    const totalMs = Math.max(1, regenMinutes * 60 * 1000)
    progressPct = Math.min(100, Math.max(0, 100 - (remainingMs / totalMs) * 100))
  }

  const mm = String(Math.floor(remainingMs / 60000)).padStart(2, '0')
  const ss = String(Math.floor((remainingMs % 60000) / 1000)).padStart(2, '0')

  return (
    <div
      className={compact ? 'flex items-center gap-1.5' : 'flex flex-col gap-2 p-3 rounded-xl bg-rose-50 dark:bg-rose-900/20 border border-rose-200 dark:border-rose-800'}
      aria-label={`${hearts}/${MAX} trái tim`}
    >
      <div className="flex items-center gap-1">
        {Array.from({ length: MAX }).map((_, i) => (
          <Heart
            key={i}
            size={compact ? 16 : 20}
            className={i < hearts ? 'text-rose-500 fill-rose-500' : 'text-gray-300 dark:text-gray-600'}
          />
        ))}
      </div>

      {!fullHearts && nextHeartAt && (
        compact ? (
          <span className="text-xs font-mono text-rose-600 dark:text-rose-300" aria-live="polite">
            +❤ {mm}:{ss}
          </span>
        ) : (
          <>
            <p className="text-sm text-rose-700 dark:text-rose-200" aria-live="polite">
              Trái tim mới sau <span className="font-mono font-semibold">{mm}:{ss}</span>
            </p>
            <div className="h-1.5 w-full rounded-full bg-rose-200 dark:bg-rose-800 overflow-hidden">
              <div
                className="h-full bg-rose-500 transition-all duration-1000 ease-linear"
                style={{ width: `${progressPct}%` }}
                role="progressbar"
                aria-valuenow={Math.round(progressPct)}
                aria-valuemin="0"
                aria-valuemax="100"
              />
            </div>
          </>
        )
      )}

      {fullHearts && !compact && (
        <p className="text-sm text-emerald-600 dark:text-emerald-400">Đầy ❤️ — sẵn sàng học!</p>
      )}
    </div>
  )
}
