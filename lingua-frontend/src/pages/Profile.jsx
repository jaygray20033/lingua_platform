import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { authAPI, gamificationAPI } from '../api'
import { useAuthStore, useAppStore, useGamificationStore } from '../store'
import { useToast } from '../components/Toast'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { User, Mail, Award, LogOut, Edit3, Save, X, Globe, Shield, Calendar, Flame, Zap, Heart, Gem, Trophy, Snowflake } from 'lucide-react'

export default function Profile() {

  useDocumentTitle('Hồ sơ')
  const navigate = useNavigate()
  const toast = useToast()
  const { user, updateUser, logout } = useAuthStore()
  const { darkMode } = useAppStore()
  const { xp, gems, hearts, streak, level, setGamification } = useGamificationStore()

  const [editing, setEditing] = useState(false)
  const [displayName, setDisplayName] = useState(user?.displayName || '')
  const [uiLanguage, setUiLanguage] = useState(user?.uiLanguage || 'vi')
  const [loading, setLoading] = useState(true)
  const [profile, setProfile] = useState(null)
  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState('')

  const [freezeCount, setFreezeCount] = useState(0)
  const [buyingFreeze, setBuyingFreeze] = useState(false)
  const FREEZE_COST = 100
  const FREEZE_MAX = 2

  useEffect(() => {
    Promise.all([
      authAPI.me().catch(() => ({ data: { data: user } })),
      gamificationAPI.getMe().catch(() => ({ data: { data: null } })),
    ]).then(([meRes, gamRes]) => {
      const me = meRes.data?.data
      if (me) {
        setProfile(me)
        setDisplayName(me.displayName || '')
        setUiLanguage(me.uiLanguage || 'vi')
        updateUser(me)
      }
      if (gamRes.data?.data) {
        setGamification(gamRes.data.data)

        setFreezeCount(gamRes.data.data.streakFreezeCount || 0)
      }
    }).finally(() => setLoading(false))
  }, [])

  const handleBuyFreeze = async () => {
    if (buyingFreeze) return
    if (freezeCount >= FREEZE_MAX) {
      toast.warn(`Tối đa ${FREEZE_MAX} lá chắn streak`)
      return
    }
    if ((gems || 0) < FREEZE_COST) {
      toast.error(`Cần ${FREEZE_COST} gems để mua lá chắn streak`)
      return
    }
    setBuyingFreeze(true)
    try {
      const res = await gamificationAPI.buyStreakFreeze()
      const data = res.data?.data
      if (data) {
        setGamification({ gems: data.gems })
        setFreezeCount(data.streakFreezeCount || 0)
      }
      toast.success(res.data?.message || 'Đã mua lá chắn streak ❄️')
    } catch (err) {
      const msg = err?.response?.data?.message
      toast.error(msg === 'NOT_ENOUGH_GEMS' ? 'Không đủ gems' :
                  msg === 'MAX_FREEZE_REACHED' ? 'Đã đạt giới hạn dự trữ' :
                  msg || 'Không thể mua lá chắn streak')
    } finally {
      setBuyingFreeze(false)
    }
  }

  const handleLogout = async () => {
    try { await authAPI.logout() } catch (_) {}
    logout()
    navigate('/login')
  }

  const handleSave = async () => {
    setSaveError('')
    setSaving(true)
    try {
      const res = await authAPI.updateMe({ displayName, uiLanguage })
      const updated = res.data?.data || { displayName, uiLanguage }
      updateUser(updated)
      setProfile(p => ({ ...(p || {}), ...updated }))
      setEditing(false)
    } catch (err) {
      console.error('updateMe failed', err)
      setSaveError(err?.response?.data?.message || 'Không thể lưu thay đổi. Vui lòng thử lại.')
    } finally {
      setSaving(false)
    }
  }

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
    </div>
  )

  const u = profile || user || {}

  return (
    <div className="max-w-4xl mx-auto space-y-6">

      <div className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-500 rounded-2xl p-8 text-white relative overflow-hidden">
        <div className="flex items-center gap-5">
          <div className="w-24 h-24 rounded-full bg-white/20 backdrop-blur flex items-center justify-center text-4xl font-bold border-4 border-white/30">
            {(u.displayName || 'U').charAt(0).toUpperCase()}
          </div>
          <div className="flex-1">
            <h1 className="text-3xl font-bold">{u.displayName}</h1>
            <p className="text-blue-100 mt-1 flex items-center gap-2"><Mail size={16} /> {u.email}</p>
            <div className="flex items-center gap-2 mt-2 text-sm">
              <span className="px-2 py-1 bg-white/20 rounded-full"><Shield size={12} className="inline mr-1" /> {u.role || 'LEARNER'}</span>
              {u.emailVerified && <span className="px-2 py-1 bg-green-500/30 rounded-full">✓ Đã xác minh</span>}
            </div>
          </div>
          <button
            onClick={() => setEditing(e => !e)}
            className="p-3 bg-white/20 hover:bg-white/30 rounded-xl transition"
            title="Chỉnh sửa">
            {editing ? <X size={20} /> : <Edit3 size={20} />}
          </button>
        </div>
      </div>

      {editing && (
        <div className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl p-6 border`}>
          <h2 className={`font-bold text-lg mb-4 ${darkMode ? 'text-white' : ''}`}>✏️ Chỉnh sửa hồ sơ</h2>
          <div className="space-y-4">
            <div>
              <label className={`text-sm font-medium ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>Tên hiển thị</label>
              <input value={displayName} onChange={e => setDisplayName(e.target.value)}
                className={`w-full mt-1 px-4 py-2 rounded-xl border ${darkMode ? 'bg-gray-700 border-gray-600 text-white' : 'border-gray-200'} focus:outline-none focus:ring-2 focus:ring-blue-500`} />
            </div>
            <div>
              <label className={`text-sm font-medium ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>Ngôn ngữ giao diện</label>
              <select value={uiLanguage} onChange={e => setUiLanguage(e.target.value)}
                className={`w-full mt-1 px-4 py-2 rounded-xl border ${darkMode ? 'bg-gray-700 border-gray-600 text-white' : 'border-gray-200'} focus:outline-none focus:ring-2 focus:ring-blue-500`}>
                <option value="vi">🇻🇳 Tiếng Việt</option>
                <option value="en">🇬🇧 English</option>
                <option value="ja">🇯🇵 日本語</option>
              </select>
            </div>
            {saveError && (
              <p className="text-sm text-red-500" role="alert">{saveError}</p>
            )}
            <button onClick={handleSave} disabled={saving}
              className="px-5 py-2.5 bg-blue-500 hover:bg-blue-600 disabled:opacity-50 disabled:cursor-not-allowed text-white rounded-xl font-semibold flex items-center gap-2">
              <Save size={16} /> {saving ? 'Đang lưu...' : 'Lưu thay đổi'}
            </button>
          </div>
        </div>
      )}

      <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
        <StatCard icon={Trophy} color="yellow" label="Level" value={level} darkMode={darkMode} />
        <StatCard icon={Zap} color="orange" label="XP" value={xp} darkMode={darkMode} />
        <StatCard icon={Flame} color="red" label="Streak" value={`${streak} ngày`} darkMode={darkMode} />
        <StatCard icon={Heart} color="pink" label="Hearts" value={hearts} darkMode={darkMode} />
        <StatCard icon={Gem} color="blue" label="Gems" value={gems} darkMode={darkMode} />
      </div>

      <div className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl p-6 border`}>
        <h2 className={`font-bold text-lg mb-4 ${darkMode ? 'text-white' : ''}`}>📋 Thông tin tài khoản</h2>
        <div className="space-y-3">
          <InfoRow icon={User} label="ID người dùng" value={`#${u.id}`} darkMode={darkMode} />
          <InfoRow icon={Mail} label="Email" value={u.email} darkMode={darkMode} />
          <InfoRow icon={Globe} label="Ngôn ngữ mẹ đẻ" value={u.nativeLanguageCode || 'vi'} darkMode={darkMode} />
          <InfoRow icon={Shield} label="Vai trò" value={u.role || 'LEARNER'} darkMode={darkMode} />
          <InfoRow icon={Award} label="Trạng thái" value={u.status || 'ACTIVE'} darkMode={darkMode} />
        </div>
      </div>

      <section
        id="streak-freeze-section"
        aria-label="Lá chắn streak"
        className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl p-6 border`}
      >
        <header className="flex items-center justify-between mb-3">
          <h2 className={`font-bold text-lg flex items-center gap-2 ${darkMode ? 'text-white' : ''}`}>
            <Snowflake size={20} className="text-cyan-500" /> Lá chắn streak
          </h2>
          <span className={`text-sm px-2 py-1 rounded-full ${darkMode ? 'bg-cyan-500/20 text-cyan-300' : 'bg-cyan-50 text-cyan-700'}`}>
            {freezeCount}/{FREEZE_MAX}
          </span>
        </header>
        <p className={`text-sm mb-4 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
          Khi bạn lỡ một ngày, lá chắn sẽ tự động được dùng để giữ streak. Mỗi lá chắn tốn <strong>{FREEZE_COST} gems</strong>, có thể giữ tối đa {FREEZE_MAX} chiếc.
        </p>
        <div className="flex items-center gap-3 flex-wrap">
          {Array.from({ length: FREEZE_MAX }).map((_, i) => (
            <div
              key={i}
              className={`w-12 h-12 rounded-xl border-2 flex items-center justify-center text-2xl ${
                i < freezeCount
                  ? 'border-cyan-400 bg-cyan-50 dark:bg-cyan-900/30'
                  : darkMode ? 'border-gray-700 bg-gray-900/40 opacity-40' : 'border-gray-200 bg-gray-50 opacity-60'
              }`}
              aria-label={i < freezeCount ? 'Lá chắn streak đang giữ' : 'Ô trống'}
            >
              {i < freezeCount ? '❄️' : '➖'}
            </div>
          ))}
          <button
            onClick={handleBuyFreeze}
            disabled={buyingFreeze || freezeCount >= FREEZE_MAX || (gems || 0) < FREEZE_COST}
            className="ml-auto px-4 py-2.5 bg-cyan-500 hover:bg-cyan-600 disabled:opacity-50 disabled:cursor-not-allowed text-white rounded-xl font-semibold flex items-center gap-2"
          >
            <Gem size={16} /> {buyingFreeze ? 'Đang mua...' : `Mua (-${FREEZE_COST})`}
          </button>
        </div>
      </section>

      <button onClick={handleLogout}
        className="w-full px-5 py-3 bg-red-500 hover:bg-red-600 text-white rounded-xl font-bold flex items-center justify-center gap-2 transition">
        <LogOut size={18} /> Đăng xuất
      </button>
    </div>
  )
}

function StatCard({ icon: Icon, color, label, value, darkMode }) {
  const colors = {
    yellow: 'text-yellow-500 bg-yellow-50 dark:bg-yellow-900/20',
    orange: 'text-orange-500 bg-orange-50 dark:bg-orange-900/20',
    red: 'text-red-500 bg-red-50 dark:bg-red-900/20',
    pink: 'text-pink-500 bg-pink-50 dark:bg-pink-900/20',
    blue: 'text-blue-500 bg-blue-50 dark:bg-blue-900/20',
  }
  return (
    <div className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-xl p-4 border`}>
      <div className={`w-10 h-10 rounded-lg ${colors[color]} flex items-center justify-center mb-2`}>
        <Icon size={20} />
      </div>
      <p className={`text-xs ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>{label}</p>
      <p className={`text-xl font-bold ${darkMode ? 'text-white' : ''}`}>{value}</p>
    </div>
  )
}

function InfoRow({ icon: Icon, label, value, darkMode }) {
  return (
    <div className={`flex items-center justify-between py-2 border-b ${darkMode ? 'border-gray-700' : 'border-gray-100'}`}>
      <span className={`flex items-center gap-2 text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
        <Icon size={16} /> {label}
      </span>
      <span className={`font-medium ${darkMode ? 'text-white' : ''}`}>{value}</span>
    </div>
  )
}
