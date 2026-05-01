import { useEffect, useState } from 'react'
import { gamificationAPI } from '../api'
import { useAppStore } from '../store'
import StreakCalendar from '../components/StreakCalendar'
import { useDocumentTitle } from '../hooks/useDocumentTitle'

export default function Analytics() {

  useDocumentTitle('Phân tích')
  const { darkMode } = useAppStore()
  const [days, setDays] = useState(14)
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let cancelled = false
    async function load() {
      setLoading(true)
      try {
        const r = await gamificationAPI.getAnalytics(days)
        if (!cancelled) setData(r.data?.data)
      } finally {
        if (!cancelled) setLoading(false)
      }
    }
    load()
    return () => { cancelled = true }
  }, [days])

  const series = data?.series || []
  const maxXp = Math.max(10, ...series.map(s => s.xp || 0))

  return (
    <main className={`p-6 ${darkMode ? 'text-white' : ''}`}>
      <header className="mb-6 flex items-start justify-between flex-wrap gap-3">
        <div>
          <h1 className="text-3xl font-bold">📊 Phân tích tiến độ</h1>
          <p className={darkMode ? 'text-gray-400' : 'text-gray-600'}>XP hàng ngày và tổng quan hoạt động</p>
        </div>
        <nav className="flex gap-2" aria-label="Khoảng thời gian">
          {[7, 14, 30].map(n => (
            <button
              key={n}
              type="button"
              onClick={() => setDays(n)}
              className={`px-3 py-1 rounded text-sm font-medium ${
                days === n ? 'bg-green-500 text-white' : 'bg-gray-100 hover:bg-gray-200 dark:bg-gray-700'
              }`}
            >
              {n} ngày
            </button>
          ))}
        </nav>
      </header>

      {loading && <p className="text-gray-500">Đang tải…</p>}

      {data && (
        <>
          <section className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
            <StatBox label="Tổng XP" value={data.totalXp} darkMode={darkMode} />
            <StatBox label="Level" value={data.level} darkMode={darkMode} />
            <StatBox label="Streak" value={`${data.streakCount}🔥`} darkMode={darkMode} />
            <StatBox label="Streak dài nhất" value={data.longestStreak} darkMode={darkMode} />
            <StatBox label={`XP ${days} ngày qua`} value={data.totalXpPeriod} darkMode={darkMode} />
            <StatBox label="Ngày đạt mục tiêu" value={`${data.goalDaysMet}/${days}`} darkMode={darkMode} />
            <StatBox label="Bài học hoàn thành" value={data.lessonsCompleted} darkMode={darkMode} />
            <StatBox label="Lượt ôn SRS" value={data.srsReviews} darkMode={darkMode} />
          </section>

          <div className="mb-6">
            <StreakCalendar days={90} />
          </div>

          <section className={`rounded-xl p-5 border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}>
            <h2 className="font-semibold mb-4">XP mỗi ngày</h2>
            <div className="flex items-end gap-1 h-40" role="img" aria-label="Biểu đồ XP theo ngày">
              {series.map((d, i) => {
                const h = Math.max(4, (d.xp / maxXp) * 100)
                return (
                  <div key={i} className="flex-1 flex flex-col items-center justify-end group relative">
                    <div
                      className={`w-full rounded-t ${d.goalMet ? 'bg-green-500' : d.xp > 0 ? 'bg-blue-400' : 'bg-gray-200 dark:bg-gray-700'}`}
                      style={{ height: `${h}%` }}
                      title={`${d.date}: ${d.xp} XP${d.goalMet ? ' ✓' : ''}`}
                    />
                  </div>
                )
              })}
            </div>
            <div className="flex justify-between text-[10px] text-gray-400 mt-2">
              {series.filter((_, i) => i === 0 || i === series.length - 1 || i % Math.ceil(series.length / 5) === 0).map((d, i) => (
                <span key={i}>{d.date.slice(5)}</span>
              ))}
            </div>
          </section>
        </>
      )}
    </main>
  )
}

function StatBox({ label, value, darkMode }) {
  return (
    <div className={`rounded-xl p-4 border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}>
      <p className={`text-xs uppercase ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>{label}</p>
      <p className="text-2xl font-bold mt-1">{value}</p>
    </div>
  )
}
