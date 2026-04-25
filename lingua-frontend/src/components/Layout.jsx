import { Outlet, Link, useLocation } from 'react-router-dom'
import { useAppStore, useGamificationStore } from '../store'
import { BookOpen, GraduationCap, Languages, Brain, FlaskConical, FileText, LayoutDashboard, Menu, X, Flame, Heart, Gem, Zap, Moon, Sun, BookMarked } from 'lucide-react'

const navItems = [
  { path: '/', icon: LayoutDashboard, label: 'Trang chủ' },
  { path: '/courses', icon: GraduationCap, label: 'Khóa học' },
  { path: '/vocabulary', icon: BookOpen, label: 'Từ vựng' },
  { path: '/kanji', icon: Languages, label: 'Hán tự' },
  { path: '/grammar', icon: BookMarked, label: 'Ngữ pháp' },
  { path: '/flashcard', icon: Brain, label: 'SRS Flashcard' },
  { path: '/mock-tests', icon: FileText, label: 'Thi thử' },
]

export default function Layout() {
  const location = useLocation()
  const { sidebarOpen, toggleSidebar, darkMode, toggleDarkMode } = useAppStore()
  const { xp, gems, hearts, streak, level } = useGamificationStore()

  return (
    <div className={`min-h-screen ${darkMode ? 'dark bg-gray-900' : 'bg-gray-50'}`}>
      {/* Sidebar */}
      <aside className={`fixed top-0 left-0 h-full z-40 transition-all duration-300 ${sidebarOpen ? 'w-64' : 'w-16'} ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border-r shadow-sm`}>
        {/* Logo */}
        <div className="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-700">
          {sidebarOpen && (
            <Link to="/" className="flex items-center gap-2">
              <span className="text-2xl">🌐</span>
              <span className={`text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent`}>Lingua</span>
            </Link>
          )}
          <button onClick={toggleSidebar} className="p-1 rounded hover:bg-gray-100 dark:hover:bg-gray-700">
            {sidebarOpen ? <X size={20} /> : <Menu size={20} />}
          </button>
        </div>

        {/* Navigation */}
        <nav className="p-2 space-y-1 mt-2">
          {navItems.map(item => {
            const isActive = location.pathname === item.path
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

        {/* Dark mode toggle */}
        <div className="absolute bottom-4 left-0 right-0 px-4">
          <button onClick={toggleDarkMode}
            className={`flex items-center gap-2 w-full px-3 py-2 rounded-xl text-sm ${darkMode ? 'text-gray-300 hover:bg-gray-700' : 'text-gray-600 hover:bg-gray-100'}`}>
            {darkMode ? <Sun size={18} /> : <Moon size={18} />}
            {sidebarOpen && <span>{darkMode ? 'Sáng' : 'Tối'}</span>}
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <div className={`transition-all duration-300 ${sidebarOpen ? 'ml-64' : 'ml-16'}`}>
        {/* Top Bar */}
        <header className={`sticky top-0 z-30 ${darkMode ? 'bg-gray-800/95 border-gray-700' : 'bg-white/95 border-gray-200'} border-b backdrop-blur-sm`}>
          <div className="flex items-center justify-between px-6 py-3">
            {/* Search */}
            <div className={`relative flex-1 max-w-md`}>
              <input type="text" placeholder="Tìm từ vựng, kanji, ngữ pháp..."
                className={`w-full pl-10 pr-4 py-2 rounded-xl border text-sm ${darkMode ? 'bg-gray-700 border-gray-600 text-white placeholder-gray-400' : 'bg-gray-50 border-gray-200 text-gray-900 placeholder-gray-500'} focus:outline-none focus:ring-2 focus:ring-blue-500`} />
              <svg className="absolute left-3 top-2.5 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
            </div>

            {/* Stats Bar */}
            <div className="flex items-center gap-4 ml-6">
              <div className="flex items-center gap-1.5 px-3 py-1.5 bg-orange-50 rounded-full" title="Streak">
                <Flame size={18} className="text-orange-500" />
                <span className="text-sm font-bold text-orange-600">{streak}</span>
              </div>
              <div className="flex items-center gap-1.5 px-3 py-1.5 bg-yellow-50 rounded-full" title="XP">
                <Zap size={18} className="text-yellow-500" />
                <span className="text-sm font-bold text-yellow-600">{xp}</span>
              </div>
              <div className="flex items-center gap-1.5 px-3 py-1.5 bg-red-50 rounded-full" title="Hearts">
                <Heart size={18} className="text-red-500 fill-red-500" />
                <span className="text-sm font-bold text-red-600">{hearts}</span>
              </div>
              <div className="flex items-center gap-1.5 px-3 py-1.5 bg-blue-50 rounded-full" title="Gems">
                <Gem size={18} className="text-blue-500" />
                <span className="text-sm font-bold text-blue-600">{gems}</span>
              </div>
              <div className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold text-white bg-gradient-to-r from-blue-500 to-purple-500`} title={`Level ${level}`}>
                {level}
              </div>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="p-6">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
