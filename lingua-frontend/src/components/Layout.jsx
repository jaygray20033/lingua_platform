import { Outlet, Link, useLocation, useNavigate } from 'react-router-dom'
import { useEffect, useState, useRef } from 'react'
import { useAppStore, useGamificationStore, useAuthStore } from '../store'
import { authAPI, gamificationAPI } from '../api'
import { BookOpen, GraduationCap, Languages, Brain, FileText, LayoutDashboard, Menu, X, Flame, Heart, Gem, Zap, Moon, Sun, BookMarked, User, LogOut, Settings, ChevronDown, Trophy, Award, BarChart3, FolderHeart, Star } from 'lucide-react'
import XpLevelUpToast from './XpLevelUpToast'
import HeartsCountdown from './HeartsCountdown'

const navItems = [
  { path: '/', icon: LayoutDashboard, label: 'Trang chủ' },
  { path: '/courses', icon: GraduationCap, label: 'Khóa học' },
  { path: '/vocabulary', icon: BookOpen, label: 'Từ vựng' },
  { path: '/kanji', icon: Languages, label: 'Hán tự' },
  { path: '/grammar', icon: BookMarked, label: 'Ngữ pháp' },
  { path: '/flashcard', icon: Brain, label: 'SRS Flashcard' },
  { path: '/my-decks', icon: FolderHeart, label: 'Bộ thẻ của tôi' },
  { path: '/favorites', icon: Star, label: 'Yêu thích' },
  { path: '/leaderboard', icon: Trophy, label: 'Bảng xếp hạng' },
  { path: '/achievements', icon: Award, label: 'Thành tựu' },
  { path: '/analytics', icon: BarChart3, label: 'Phân tích' },
  { path: '/mock-tests', icon: FileText, label: 'Thi thử' },
]

export default function Layout() {
  const location = useLocation()
  const navigate = useNavigate()
  const { sidebarOpen, toggleSidebar, darkMode, toggleDarkMode } = useAppStore()
  const { xp, gems, hearts, streak, level, setGamification } = useGamificationStore()
  const { user, isLoggedIn, logout, updateUser } = useAuthStore()
  const [menuOpen, setMenuOpen] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')
  const menuRef = useRef(null)

  const [nextHeartAt, setNextHeartAt] = useState(null)
  const [heartRegenMinutes, setHeartRegenMinutes] = useState(30)

  useEffect(() => {
    if (!isLoggedIn) return
    authAPI.me().then(r => { if (r.data?.data) updateUser(r.data.data) }).catch(() => {})
    gamificationAPI.getMe().then(r => {
      const d = r.data?.data
      if (d) {
        setGamification(d)

        setNextHeartAt(d.nextHeartAt || null)
        if (d.heartRegenMinutes) setHeartRegenMinutes(d.heartRegenMinutes)
      }
    }).catch(() => {})
  }, [isLoggedIn])

  useEffect(() => {
    if (!isLoggedIn) return
    if (hearts >= 5) {
      setNextHeartAt(null)
      return
    }
    if (!nextHeartAt) {
      gamificationAPI.getMe().then(r => {
        const d = r.data?.data
        if (d) setNextHeartAt(d.nextHeartAt || null)
      }).catch(() => {})
    }
  }, [hearts, isLoggedIn])

  useEffect(() => {
    const handler = (e) => {
      if (menuRef.current && !menuRef.current.contains(e.target)) setMenuOpen(false)
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [])

  const handleLogout = async () => {
    try { await authAPI.logout() } catch (_) {}
    logout()
    navigate('/login')
  }

  const submitSearch = (e) => {
    if (e) e.preventDefault()
    const q = searchQuery.trim()
    if (!q) return
    navigate(`/vocabulary?q=${encodeURIComponent(q)}`)
  }

  return (
    <div className={`min-h-screen ${darkMode ? 'dark bg-gray-900' : 'bg-gray-50'}`}>

      <aside className={`fixed top-0 left-0 h-full z-40 transition-all duration-300 ${sidebarOpen ? 'w-64' : 'w-16'} ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border-r shadow-sm`}>
        <div className="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-700">
          {sidebarOpen && (
            <Link to="/" className="flex items-center gap-2">
              <span className="text-2xl">🌐</span>
              <span className="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">Lingua</span>
            </Link>
          )}
          <button onClick={toggleSidebar} className="p-1 rounded hover:bg-gray-100 dark:hover:bg-gray-700">
            {sidebarOpen ? <X size={20} /> : <Menu size={20} />}
          </button>
        </div>

        <nav className="p-2 space-y-1 mt-2">
          {navItems.map(item => {
            const isActive = location.pathname === item.path || (item.path !== '/' && location.pathname.startsWith(item.path))
            return (
              <Link key={item.path} to={item.path}
                className={`flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all ${
                  isActive
                    ? 'bg-blue-50 text-blue-600 dark:bg-blue-900/30 dark:text-blue-400 font-semibold'
                    : `${darkMode ? 'text-gray-300 hover:bg-gray-700' : 'text-gray-600 hover:bg-gray-100'}`
                }`}>
                <item.icon size={20} className={isActive ? 'text-blue-500' : ''} />
                {sidebarOpen && <span className="text-sm">{item.label}</span>}
              </Link>
            )
          })}
        </nav>

        <div className="absolute bottom-4 left-0 right-0 px-4">
          <button onClick={toggleDarkMode}
            className={`flex items-center gap-2 w-full px-3 py-2 rounded-xl text-sm ${darkMode ? 'text-gray-300 hover:bg-gray-700' : 'text-gray-600 hover:bg-gray-100'}`}>
            {darkMode ? <Sun size={18} /> : <Moon size={18} />}
            {sidebarOpen && <span>{darkMode ? 'Sáng' : 'Tối'}</span>}
          </button>
        </div>
      </aside>

      <div className={`transition-all duration-300 ${sidebarOpen ? 'ml-64' : 'ml-16'}`}>

        <header className={`sticky top-0 z-30 ${darkMode ? 'bg-gray-800/95 border-gray-700' : 'bg-white/95 border-gray-200'} border-b backdrop-blur-sm`}>
          <div className="flex items-center justify-between px-6 py-3">
            <form onSubmit={submitSearch} className="relative flex-1 max-w-md" role="search">
              <label htmlFor="global-search" className="sr-only">Tìm kiếm</label>
              <input
                id="global-search"
                type="search"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Tìm từ vựng, kanji, ngữ pháp..."
                className={`w-full pl-10 pr-4 py-2 rounded-xl border text-sm ${darkMode ? 'bg-gray-700 border-gray-600 text-white placeholder-gray-400' : 'bg-gray-50 border-gray-200 text-gray-900 placeholder-gray-500'} focus:outline-none focus:ring-2 focus:ring-blue-500`} />
              <button type="submit" aria-label="Tìm kiếm" className="absolute left-3 top-2.5 text-gray-400 hover:text-blue-500">
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
              </button>
            </form>

            <div className="flex items-center gap-4 ml-6">
              <div className="hidden md:flex items-center gap-1.5 px-3 py-1.5 bg-orange-50 rounded-full" title="Streak">
                <Flame size={18} className="text-orange-500" />
                <span className="text-sm font-bold text-orange-600">{streak}</span>
              </div>
              <div className="hidden md:flex items-center gap-1.5 px-3 py-1.5 bg-yellow-50 rounded-full" title="XP">
                <Zap size={18} className="text-yellow-500" />
                <span className="text-sm font-bold text-yellow-600">{xp}</span>
              </div>
              <div
                className="hidden md:flex items-center gap-1.5 px-3 py-1.5 bg-red-50 rounded-full"
                title={nextHeartAt ? `Trái tim mới sau ${heartRegenMinutes} phút` : 'Trái tim'}>
                <Heart size={18} className="text-red-500 fill-red-500" />
                <span className="text-sm font-bold text-red-600">{hearts}</span>
                {hearts < 5 && nextHeartAt && (
                  <HeartsCountdown nextHeartAt={nextHeartAt} regenMinutes={heartRegenMinutes} compact />
                )}
              </div>
              <div className="hidden md:flex items-center gap-1.5 px-3 py-1.5 bg-blue-50 rounded-full" title="Gems">
                <Gem size={18} className="text-blue-500" />
                <span className="text-sm font-bold text-blue-600">{gems}</span>
              </div>

              <div className="relative" ref={menuRef}>
                <button onClick={() => setMenuOpen(o => !o)}
                  className={`flex items-center gap-2 px-2 py-1 rounded-full ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}>
                  <div className="w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold text-white bg-gradient-to-r from-blue-500 to-purple-500">
                    {(user?.displayName || 'U').charAt(0).toUpperCase()}
                  </div>
                  <ChevronDown size={14} className={darkMode ? 'text-gray-300' : 'text-gray-600'} />
                </button>

                {menuOpen && (
                  <div className={`absolute right-0 mt-2 w-64 rounded-xl shadow-xl border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} z-50 overflow-hidden`}>
                    <div className={`p-3 border-b ${darkMode ? 'border-gray-700' : 'border-gray-100'}`}>
                      <p className={`font-semibold text-sm truncate ${darkMode ? 'text-white' : ''}`}>{user?.displayName || 'Khách'}</p>
                      <p className={`text-xs truncate ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>{user?.email || ''}</p>
                      <p className="text-xs mt-1">
                        <span className="px-2 py-0.5 rounded-full bg-blue-100 text-blue-600 text-[10px] font-bold">Lv {level}</span>
                        <span className="ml-2 text-yellow-600">⚡ {xp} XP</span>
                      </p>
                    </div>
                    <Link to="/profile" onClick={() => setMenuOpen(false)}
                      className={`flex items-center gap-2 px-4 py-2.5 text-sm ${darkMode ? 'text-gray-200 hover:bg-gray-700' : 'text-gray-700 hover:bg-gray-50'}`}>
                      <User size={16} /> Hồ sơ
                    </Link>
                    <button onClick={() => { setMenuOpen(false); toggleDarkMode() }}
                      className={`w-full flex items-center gap-2 px-4 py-2.5 text-sm text-left ${darkMode ? 'text-gray-200 hover:bg-gray-700' : 'text-gray-700 hover:bg-gray-50'}`}>
                      {darkMode ? <Sun size={16} /> : <Moon size={16} />} Chế độ {darkMode ? 'sáng' : 'tối'}
                    </button>
                    <button onClick={handleLogout}
                      className="w-full flex items-center gap-2 px-4 py-2.5 text-sm text-left text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 border-t border-gray-100 dark:border-gray-700">
                      <LogOut size={16} /> Đăng xuất
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
        </header>

        <main className="p-6"><Outlet /></main>
      </div>

      <XpLevelUpToast />
    </div>
  )
}
