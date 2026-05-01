import { useEffect, useState } from 'react'
import { Zap, Star } from 'lucide-react'

export default function XpLevelUpToast() {
  const [flashes, setFlashes] = useState([])
  const [levelUp, setLevelUp] = useState(null)

  useEffect(() => {
    function onXp(e) {
      const { amount, prevLevel, newLevel } = e.detail || {}
      if (amount && amount > 0) {
        const id = `xp-${Date.now()}-${Math.random().toString(36).slice(2, 6)}`
        setFlashes(prev => [...prev, { id, amount }])

        setTimeout(() => {
          setFlashes(prev => prev.filter(f => f.id !== id))
        }, 1300)
      }
      if (prevLevel != null && newLevel != null && newLevel > prevLevel) {
        setLevelUp({ newLevel })
      }
    }
    window.addEventListener('lingua:xp-gain', onXp)
    return () => window.removeEventListener('lingua:xp-gain', onXp)
  }, [])

  return (
    <>

      <div
        className="fixed top-20 left-1/2 -translate-x-1/2 pointer-events-none z-[60] flex flex-col items-center gap-1"
        aria-live="polite"
        aria-atomic="true"
      >
        {flashes.map(f => (
          <span
            key={f.id}
            className="xp-flash-pill flex items-center gap-1 px-3 py-1.5 rounded-full bg-amber-400 text-amber-900 font-bold text-sm shadow-lg ring-2 ring-amber-300"
          >
            <Zap size={16} /> +{f.amount} XP
          </span>
        ))}
      </div>

      {levelUp && (
        <div
          role="dialog"
          aria-modal="true"
          aria-label="Lên cấp"
          className="fixed inset-0 z-[70] flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"
          onClick={() => setLevelUp(null)}
        >
          <div
            onClick={(e) => e.stopPropagation()}
            className="relative max-w-md w-full bg-gradient-to-br from-yellow-400 via-amber-500 to-orange-500 text-white rounded-3xl p-8 text-center shadow-2xl level-up-pop"
          >
            <div className="absolute -top-6 left-1/2 -translate-x-1/2">
              <div className="w-16 h-16 rounded-full bg-white text-amber-500 flex items-center justify-center shadow-lg level-up-star-spin">
                <Star size={36} fill="currentColor" />
              </div>
            </div>
            <h2 className="text-3xl font-extrabold mt-6 mb-2">🎉 Lên cấp!</h2>
            <p className="text-lg opacity-95">Bạn đã đạt</p>
            <p className="text-6xl font-black my-4 drop-shadow">Cấp {levelUp.newLevel}</p>
            <p className="text-sm opacity-90 mb-6">Tiếp tục giữ chuỗi học và mở khoá thêm tính năng nhé!</p>
            <button
              onClick={() => setLevelUp(null)}
              className="px-6 py-3 bg-white text-amber-600 font-bold rounded-2xl hover:bg-amber-50 transition shadow"
            >
              Tuyệt vời!
            </button>
          </div>
        </div>
      )}

      <style>{`
        @keyframes xpFloatUp {
          0%   { opacity: 0; transform: translateY(20px) scale(0.8); }
          15%  { opacity: 1; transform: translateY(0)    scale(1.05); }
          80%  { opacity: 1; transform: translateY(-30px) scale(1); }
          100% { opacity: 0; transform: translateY(-60px) scale(0.95); }
        }
        .xp-flash-pill { animation: xpFloatUp 1.2s ease-out forwards; }

        @keyframes levelUpPop {
          0%   { opacity: 0; transform: scale(0.7) translateY(20px); }
          60%  { opacity: 1; transform: scale(1.05) translateY(-4px); }
          100% { opacity: 1; transform: scale(1)    translateY(0); }
        }
        .level-up-pop { animation: levelUpPop 0.45s cubic-bezier(.2,.8,.2,1) forwards; }

        @keyframes levelUpStarSpin {
          0%   { transform: rotate(-30deg) scale(0.6); }
          50%  { transform: rotate(15deg)  scale(1.15); }
          100% { transform: rotate(0)      scale(1); }
        }
        .level-up-star-spin { animation: levelUpStarSpin 0.6s ease-out 0.15s forwards; }
      `}</style>
    </>
  )
}
