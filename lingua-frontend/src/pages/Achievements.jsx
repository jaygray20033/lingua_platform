import { useEffect, useState } from 'react'
import { gamificationAPI } from '../api'
import { useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'

export default function Achievements() {

  useDocumentTitle('Thành tựu')
  const { darkMode } = useAppStore()
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let cancelled = false
    async function load() {
      try {

        try { await gamificationAPI.evaluateAchievements() } catch {}
        const r = await gamificationAPI.getAchievements()
        if (!cancelled) setItems(r.data?.data || [])
      } finally {
        if (!cancelled) setLoading(false)
      }
    }
    load()
    return () => { cancelled = true }
  }, [])

  const rarityStyle = (r) => {
    switch ((r || '').toUpperCase()) {
      case 'LEGENDARY': return 'from-yellow-400 to-amber-600 text-white'
      case 'EPIC':      return 'from-purple-500 to-pink-500 text-white'
      case 'RARE':      return 'from-blue-500 to-indigo-500 text-white'
      case 'UNCOMMON':  return 'from-green-400 to-emerald-500 text-white'
      default:          return 'from-gray-200 to-gray-300 text-gray-800'
    }
  }

  const unlockedCount = items.filter(i => i.unlocked).length

  return (
    <main className={`p-6 ${darkMode ? 'text-white' : ''}`}>
      <header className="mb-6">
        <h1 className="text-3xl font-bold">🎖 Thành tựu</h1>
        <p className={darkMode ? 'text-gray-400' : 'text-gray-600'}>
          Đã mở khoá {unlockedCount}/{items.length} thành tựu
        </p>
      </header>

      {loading && <p className="text-gray-500">Đang tải…</p>}

      <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {items.map(a => (
          <article
            key={a.id}
            className={`rounded-xl border p-5 relative overflow-hidden ${
              a.unlocked
                ? 'border-transparent'
                : darkMode ? 'border-gray-700 bg-gray-800 opacity-60' : 'border-gray-200 bg-white opacity-60'
            }`}
          >
            {a.unlocked && (
              <div className={`absolute inset-0 bg-gradient-to-br ${rarityStyle(a.rarity)} opacity-20`} aria-hidden="true" />
            )}
            <div className="relative">
              <div className="flex items-center justify-between">
                <span className="text-4xl">{a.unlocked ? '🏆' : '🔒'}</span>
                <span className={`text-xs px-2 py-1 rounded-full bg-gradient-to-r ${rarityStyle(a.rarity)}`}>
                  {a.rarity}
                </span>
              </div>
              <h2 className="mt-3 font-bold text-lg">{a.title}</h2>
              <p className={`mt-1 text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>{a.description}</p>
              {a.unlocked && a.unlockedAt && (
                <p className="mt-2 text-xs text-green-600">Đã đạt: {new Date(a.unlockedAt).toLocaleDateString('vi-VN')}</p>
              )}
            </div>
          </article>
        ))}
      </section>
    </main>
  )
}
