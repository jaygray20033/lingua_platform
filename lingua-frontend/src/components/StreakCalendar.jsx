import { useEffect, useState, useMemo } from 'react'
import { gamificationAPI } from '../api'
import { useAppStore } from '../store'
import { Flame, Calendar } from 'lucide-react'

export default function StreakCalendar({ days = 90 }) {
  const { darkMode } = useAppStore()
  const [series, setSeries] = useState([])
  const [stats, setStats] = useState({ streakCount: 0, longestStreak: 0, goalDaysMet: 0 })
  const [loading, setLoading] = useState(true)
  const [hover, setHover] = useState(null)

  useEffect(() => {
    setLoading(true)
    gamificationAPI.getAnalytics(days)
      .then(r => {
        const d = r.data?.data
        if (d) {
          setSeries(d.series || [])
          setStats({
            streakCount: d.streakCount || 0,
            longestStreak: d.longestStreak || 0,
            goalDaysMet: d.goalDaysMet || 0,
          })
        }
      })
      .catch(() => {  })
      .finally(() => setLoading(false))
  }, [days])

  const { weeks, maxXp } = useMemo(() => {
    if (!series.length) return { weeks: [], maxXp: 0 }
    let max = 0
    const cells = series.map(s => {
      const d = new Date(s.date + 'T00:00:00')
      max = Math.max(max, s.xp || 0)
      return { ...s, dow: (d.getDay() + 6) % 7 }
    })

    const pad = cells[0].dow
    const padded = [...Array(pad).fill(null), ...cells]
    const cols = []
    for (let i = 0; i < padded.length; i += 7) cols.push(padded.slice(i, i + 7))
    return { weeks: cols, maxXp: max }
  }, [series])

  const bucket = (xp) => {
    if (!xp || xp <= 0) return 0
    if (!maxXp) return 1
    const r = xp / maxXp
    if (r >= 0.75) return 4
    if (r >= 0.5) return 3
    if (r >= 0.25) return 2
    return 1
  }

  const cellColor = (b, goalMet) => {
    if (b === 0) return darkMode ? 'bg-gray-700/40' : 'bg-gray-100'

    if (goalMet) {
      return ['', 'bg-orange-200', 'bg-orange-300', 'bg-orange-400', 'bg-orange-500'][b]
    }
    return ['', 'bg-emerald-200', 'bg-emerald-300', 'bg-emerald-400', 'bg-emerald-600'][b]
  }

  const dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']

  return (
    <section
      id="streak-calendar"
      aria-label="Lịch streak"
      className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border rounded-2xl p-5`}
    >
      <header className="flex items-center justify-between mb-4 flex-wrap gap-2">
        <h2 className={`font-bold flex items-center gap-2 ${darkMode ? 'text-white' : 'text-gray-800'}`}>
          <Calendar size={18} className="text-orange-500" /> Lịch học {days} ngày
        </h2>
        <div className="flex items-center gap-3 text-xs">
          <span className="flex items-center gap-1 px-2 py-1 rounded-full bg-orange-50 text-orange-700 dark:bg-orange-900/30 dark:text-orange-300">
            <Flame size={14} /> {stats.streakCount} ngày
          </span>
          <span className={darkMode ? 'text-gray-400' : 'text-gray-500'}>
            Kỷ lục: <strong>{stats.longestStreak}</strong>
          </span>
          <span className={darkMode ? 'text-gray-400' : 'text-gray-500'}>
            Đạt mục tiêu: <strong>{stats.goalDaysMet}</strong>
          </span>
        </div>
      </header>

      {loading ? (
        <div className="h-32 flex items-center justify-center text-sm text-gray-400">Đang tải…</div>
      ) : weeks.length === 0 ? (
        <p className="text-sm text-gray-400">Chưa có dữ liệu học. Bắt đầu một bài học để xuất hiện ở đây!</p>
      ) : (
        <div className="relative">
          <div className="flex gap-3">

            <div className="flex flex-col gap-[3px] pt-[1px] text-[10px] text-gray-400 select-none">
              {dayLabels.map((d, i) => (
                <span key={d} className="h-3 leading-3" style={{ visibility: i % 2 === 0 ? 'visible' : 'hidden' }}>{d}</span>
              ))}
            </div>

            <div className="flex gap-[3px] overflow-x-auto pb-1 flex-1">
              {weeks.map((col, ci) => (
                <div key={ci} className="flex flex-col gap-[3px]">
                  {Array.from({ length: 7 }).map((_, ri) => {
                    const cell = col[ri]
                    if (!cell) return <div key={ri} className="w-3 h-3 rounded-sm bg-transparent" />
                    const b = bucket(cell.xp)
                    return (
                      <button
                        key={ri}
                        type="button"
                        aria-label={`${cell.date}: ${cell.xp} XP${cell.goalMet ? ', đạt mục tiêu' : ''}`}
                        onMouseEnter={(e) => setHover({ ...cell, x: e.clientX, y: e.clientY })}
                        onMouseMove={(e) => setHover(h => h ? { ...h, x: e.clientX, y: e.clientY } : h)}
                        onMouseLeave={() => setHover(null)}
                        className={`w-3 h-3 rounded-sm transition hover:ring-2 hover:ring-blue-400 ${cellColor(b, cell.goalMet)}`}
                      />
                    )
                  })}
                </div>
              ))}
            </div>
          </div>

          <div className={`flex items-center gap-2 mt-3 text-xs ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
            <span>Ít</span>
            {[0, 1, 2, 3, 4].map(b => (
              <span key={b} className={`w-3 h-3 rounded-sm ${cellColor(b, false)}`} />
            ))}
            <span>Nhiều</span>
            <span className="ml-3 inline-flex items-center gap-1">
              <span className="w-3 h-3 rounded-sm bg-orange-400" /> Đạt mục tiêu
            </span>
          </div>

          {hover && (
            <div
              role="tooltip"
              className="fixed z-40 pointer-events-none px-2 py-1 rounded-md text-xs bg-gray-900 text-white shadow-lg"
              style={{ left: hover.x + 12, top: hover.y + 12 }}
            >
              <div className="font-semibold">{hover.date}</div>
              <div>{hover.xp || 0} XP {hover.goalMet ? '· 🎯 đạt mục tiêu' : ''}</div>
            </div>
          )}
        </div>
      )}
    </section>
  )
}
