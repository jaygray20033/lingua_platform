import { useEffect, useState } from 'react'
import { gamificationAPI } from '../api'
import { useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'

export default function Leaderboard() {

  useDocumentTitle('Bảng xếp hạng')
  const { darkMode } = useAppStore()
  const [period, setPeriod] = useState('weekly')
  const [rows, setRows] = useState([])
  const [loading, setLoading] = useState(true)
  const [weekStart, setWeekStart] = useState(null)

  useEffect(() => {
    let cancelled = false
    async function load() {
      setLoading(true)
      try {
        const r = await gamificationAPI.getLeaderboard(period, 25)
        if (cancelled) return
        setRows(r.data?.data || [])
        setWeekStart(r.data?.weekStart || null)
      } finally {
        if (!cancelled) setLoading(false)
      }
    }
    load()
    return () => { cancelled = true }
  }, [period])

  const rankEmoji = (r) => r === 1 ? '🥇' : r === 2 ? '🥈' : r === 3 ? '🥉' : `#${r}`

  return (
    <main className={`p-6 ${darkMode ? 'text-white' : ''}`}>
      <header className="mb-6">
        <h1 className="text-3xl font-bold">🏆 Bảng xếp hạng</h1>
        <p className={darkMode ? 'text-gray-400' : 'text-gray-600'}>
          {period === 'weekly' ? `Tuần bắt đầu ${weekStart || ''}` : 'Tổng XP từ khi đăng ký'}
        </p>
      </header>

      <nav className="mb-4 flex gap-2" aria-label="Giai đoạn bảng xếp hạng">
        <button
          type="button"
          onClick={() => setPeriod('weekly')}
          className={`px-4 py-2 rounded-lg font-medium ${
            period === 'weekly' ? 'bg-green-500 text-white' : 'bg-gray-100 hover:bg-gray-200 dark:bg-gray-700'
          }`}
        >
          Tuần này
        </button>
        <button
          type="button"
          onClick={() => setPeriod('all')}
          className={`px-4 py-2 rounded-lg font-medium ${
            period === 'all' ? 'bg-green-500 text-white' : 'bg-gray-100 hover:bg-gray-200 dark:bg-gray-700'
          }`}
        >
          Mọi lúc
        </button>
      </nav>

      <section className={`rounded-xl border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} overflow-hidden`}>
        {loading && <p className="p-6 text-center text-gray-500">Đang tải…</p>}
        {!loading && rows.length === 0 && (
          <p className="p-6 text-center text-gray-500">Chưa có dữ liệu xếp hạng.</p>
        )}
        {!loading && rows.length > 0 && (
          <ul>
            {rows.map(r => (
              <li
                key={r.userId}
                className={`flex items-center gap-4 px-4 py-3 border-b ${darkMode ? 'border-gray-700' : 'border-gray-100'} last:border-0`}
              >
                <span className="w-10 text-center text-xl font-bold">{rankEmoji(r.rank)}</span>
                {r.avatarUrl ? (
                  <img src={r.avatarUrl} alt="" className="w-10 h-10 rounded-full" />
                ) : (
                  <div className="w-10 h-10 rounded-full bg-green-100 text-green-700 flex items-center justify-center font-semibold">
                    {(r.displayName || '?').charAt(0).toUpperCase()}
                  </div>
                )}
                <div className="flex-1">
                  <p className="font-semibold">{r.displayName}</p>
                  {r.level != null && (
                    <p className="text-xs text-gray-500">Level {r.level}</p>
                  )}
                </div>
                <span className="font-bold text-green-600">
                  {period === 'weekly' ? `${r.weeklyXp} XP` : `${r.totalXp} XP`}
                </span>
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  )
}
