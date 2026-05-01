import { useEffect, useState } from 'react'
import { questAPI } from '../api'
import { useAppStore, useGamificationStore } from '../store'
import { useToast } from './Toast'
import { Trophy, CheckCircle2, Gift, Zap, Gem } from 'lucide-react'

export default function DailyQuestWidget() {
  const { darkMode } = useAppStore()
  const { setGamification } = useGamificationStore()
  const toast = useToast()
  const [quests, setQuests] = useState([])
  const [loading, setLoading] = useState(true)
  const [claimingId, setClaimingId] = useState(null)

  useEffect(() => {
    let cancelled = false
    questAPI.getToday()
      .then(res => {
        if (!cancelled) setQuests(res.data?.data || [])
      })
      .catch(() => { if (!cancelled) setQuests([]) })
      .finally(() => { if (!cancelled) setLoading(false) })
    return () => { cancelled = true }
  }, [])

  const handleClaim = async (quest) => {
    if (claimingId || quest.claimed) return
    setClaimingId(quest.id)
    try {
      const res = await questAPI.claim(quest.id)
      const reward = res.data?.data
      if (reward) {
        setGamification({
          xp: reward.totalXp,
          gems: reward.gems,
          level: reward.level,
        })
        toast.success(`+${reward.rewardXp} XP, +${reward.rewardGems} Gems`)
      }
      setQuests(qs => qs.map(q => q.id === quest.id ? { ...q, claimed: true } : q))
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Không thể nhận thưởng')
    } finally {
      setClaimingId(null)
    }
  }

  if (loading) {
    return (
      <section
        id="daily-quest-widget"
        aria-label="Nhiệm vụ hàng ngày"
        className={`rounded-xl p-5 border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}
      >
        <div className={`h-5 w-40 rounded animate-pulse ${darkMode ? 'bg-gray-700' : 'bg-gray-200'}`}></div>
        <div className="mt-4 space-y-3">
          {[0, 1, 2].map(i => (
            <div key={i} className={`h-14 rounded-lg animate-pulse ${darkMode ? 'bg-gray-700' : 'bg-gray-100'}`}></div>
          ))}
        </div>
      </section>
    )
  }

  if (!quests.length) return null

  const completed = quests.filter(q => q.completed).length

  return (
    <section
      id="daily-quest-widget"
      aria-label="Nhiệm vụ hàng ngày"
      className={`rounded-xl p-5 border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}
    >
      <header className="flex items-center justify-between mb-4">
        <h2 className={`font-bold text-lg flex items-center gap-2 ${darkMode ? 'text-white' : ''}`}>
          <Trophy size={20} className="text-amber-500" /> Nhiệm vụ hôm nay
        </h2>
        <span className={`text-sm font-medium px-2 py-1 rounded-full ${darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'}`}>
          {completed}/{quests.length}
        </span>
      </header>

      <ul className="space-y-3">
        {quests.map(q => {
          const pct = Math.min(100, Math.round(((q.progress || 0) / Math.max(1, q.target || 1)) * 100))
          const done = q.completed
          const claimed = q.claimed
          return (
            <li
              key={q.id}
              className={`p-3 rounded-lg border ${darkMode ? 'border-gray-700 bg-gray-900/40' : 'border-gray-100 bg-gray-50'}`}
            >
              <div className="flex items-center justify-between gap-3 mb-2">
                <div className="flex items-center gap-2 min-w-0">
                  <span className="text-2xl shrink-0" aria-hidden="true">{q.icon || '🎯'}</span>
                  <div className="min-w-0">
                    <p className={`font-medium truncate ${darkMode ? 'text-white' : 'text-gray-800'}`}>
                      {q.title}
                    </p>
                    <p className={`text-xs ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
                      {q.progress || 0}/{q.target}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-3 shrink-0">
                  <span className="flex items-center gap-1 text-xs text-amber-600 dark:text-amber-400">
                    <Zap size={14} /> +{q.rewardXp || 0}
                  </span>
                  <span className="flex items-center gap-1 text-xs text-blue-600 dark:text-blue-400">
                    <Gem size={14} /> +{q.rewardGems || 0}
                  </span>
                  {done && !claimed && (
                    <button
                      onClick={() => handleClaim(q)}
                      disabled={claimingId === q.id}
                      className="px-3 py-1.5 bg-amber-500 hover:bg-amber-600 disabled:opacity-50 text-white text-xs font-semibold rounded-lg flex items-center gap-1"
                    >
                      <Gift size={14} /> Nhận
                    </button>
                  )}
                  {claimed && (
                    <span className="flex items-center gap-1 text-xs text-green-600 dark:text-green-400">
                      <CheckCircle2 size={14} /> Đã nhận
                    </span>
                  )}
                </div>
              </div>
              <div
                className={`h-2 rounded-full overflow-hidden ${darkMode ? 'bg-gray-700' : 'bg-gray-200'}`}
                role="progressbar"
                aria-valuenow={pct}
                aria-valuemin={0}
                aria-valuemax={100}
                aria-label={q.title}
              >
                <div
                  className={`h-full transition-all ${done ? 'bg-green-500' : 'bg-amber-500'}`}
                  style={{ width: `${pct}%` }}
                />
              </div>
            </li>
          )
        })}
      </ul>
    </section>
  )
}
