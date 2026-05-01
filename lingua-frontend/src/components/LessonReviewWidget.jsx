import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { lessonAPI } from '../api'
import { useAppStore } from '../store'
import { RefreshCw, AlertTriangle, ChevronRight } from 'lucide-react'

export default function LessonReviewWidget() {
  const { darkMode } = useAppStore()
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let cancelled = false
    lessonAPI.getReviewQueue()
      .then(res => {
        if (!cancelled) setItems(res.data?.data || [])
      })
      .catch(() => { if (!cancelled) setItems([]) })
      .finally(() => { if (!cancelled) setLoading(false) })
    return () => { cancelled = true }
  }, [])

  if (loading || !items.length) return null

  return (
    <section
      id="lesson-review-widget"
      aria-label="Bài cần ôn lại"
      className={`rounded-xl p-5 border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}
    >
      <header className="flex items-center justify-between mb-4">
        <h2 className={`font-bold text-lg flex items-center gap-2 ${darkMode ? 'text-white' : ''}`}>
          <RefreshCw size={20} className="text-orange-500" /> Bài cần ôn lại
        </h2>
        <span className={`text-sm font-medium px-2 py-1 rounded-full ${darkMode ? 'bg-orange-500/20 text-orange-300' : 'bg-orange-50 text-orange-600'}`}>
          {items.length} bài
        </span>
      </header>

      <p className={`text-sm mb-3 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
        Bạn đã làm bài dưới 70% — hãy ôn lại để củng cố kiến thức.
      </p>

      <ul className="space-y-2">
        {items.slice(0, 5).map(it => (
          <li key={it.id}>
            <Link
              to={`/lessons/${it.lessonId}`}
              className={`flex items-center justify-between gap-3 p-3 rounded-lg border transition ${
                darkMode
                  ? 'border-gray-700 hover:bg-gray-700/50'
                  : 'border-gray-100 hover:bg-orange-50'
              }`}
            >
              <div className="flex items-center gap-3 min-w-0">
                <AlertTriangle size={18} className="text-orange-500 shrink-0" />
                <div className="min-w-0">
                  <p className={`font-medium truncate ${darkMode ? 'text-white' : 'text-gray-800'}`}>
                    {it.lessonTitle}
                  </p>
                  <p className={`text-xs ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
                    Điểm gần nhất: {Math.round(it.lastScore || 0)}% • Thất bại {it.failCount || 1} lần
                  </p>
                </div>
              </div>
              <ChevronRight size={18} className={darkMode ? 'text-gray-500' : 'text-gray-400'} />
            </Link>
          </li>
        ))}
      </ul>
    </section>
  )
}
