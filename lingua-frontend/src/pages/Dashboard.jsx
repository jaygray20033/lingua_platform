import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { courseAPI, gamificationAPI } from '../api'
import { useGamificationStore, useAppStore } from '../store'
import { BookOpen, Flame, Trophy, Brain, Target, ChevronRight } from 'lucide-react'

export default function Dashboard() {
  const [courses, setCourses] = useState([])
  const [loading, setLoading] = useState(true)
  const { setGamification, xp, streak, hearts, gems, level } = useGamificationStore()
  const { darkMode } = useAppStore()

  useEffect(() => {
    Promise.all([
      courseAPI.list(),
      gamificationAPI.getMe(2)
    ]).then(([coursesRes, gamRes]) => {
      setCourses(coursesRes.data.data || [])
      if (gamRes.data.data) setGamification(gamRes.data.data)
    }).catch(() => {}).finally(() => setLoading(false))
  }, [])

  const langFlags = { JLPT: '🇯🇵', CEFR: '🇬🇧', HSK: '🇨🇳', TOPIK: '🇰🇷' }

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
    </div>
  )

  return (
    <div className="max-w-6xl mx-auto space-y-8">
      {/* Welcome Banner */}
      <div className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-500 rounded-2xl p-8 text-white relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-64 opacity-10">
          <svg viewBox="0 0 200 200" fill="white"><circle cx="100" cy="100" r="80" /></svg>
        </div>
        <h1 className="text-3xl font-bold mb-2">Chào mừng đến Lingua! 🌐</h1>
        <p className="text-blue-100 text-lg mb-4">Nền tảng học ngoại ngữ toàn diện - Nhật, Anh, Trung</p>
        <div className="flex gap-6 mt-4">
          <div className="bg-white/20 rounded-xl px-4 py-3 backdrop-blur-sm">
            <div className="flex items-center gap-2 mb-1"><Flame size={20} /><span className="font-semibold">Streak</span></div>
            <span className="text-2xl font-bold">{streak} ngày</span>
          </div>
          <div className="bg-white/20 rounded-xl px-4 py-3 backdrop-blur-sm">
            <div className="flex items-center gap-2 mb-1"><Trophy size={20} /><span className="font-semibold">XP</span></div>
            <span className="text-2xl font-bold">{xp}</span>
          </div>
          <div className="bg-white/20 rounded-xl px-4 py-3 backdrop-blur-sm">
            <div className="flex items-center gap-2 mb-1"><Target size={20} /><span className="font-semibold">Level</span></div>
            <span className="text-2xl font-bold">{level}</span>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Link to="/courses" className={`${darkMode ? 'bg-gray-800 hover:bg-gray-700' : 'bg-white hover:bg-gray-50'} rounded-xl p-5 shadow-sm border ${darkMode ? 'border-gray-700' : 'border-gray-200'} transition-all hover:shadow-md group`}>
          <BookOpen className="text-blue-500 mb-2" size={28} />
          <h3 className="font-semibold">Khóa học</h3>
          <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>Chọn ngôn ngữ</p>
        </Link>
        <Link to="/vocabulary" className={`${darkMode ? 'bg-gray-800 hover:bg-gray-700' : 'bg-white hover:bg-gray-50'} rounded-xl p-5 shadow-sm border ${darkMode ? 'border-gray-700' : 'border-gray-200'} transition-all hover:shadow-md`}>
          <span className="text-3xl mb-2 block">📚</span>
          <h3 className="font-semibold">Từ vựng</h3>
          <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>Khám phá từ mới</p>
        </Link>
        <Link to="/flashcard" className={`${darkMode ? 'bg-gray-800 hover:bg-gray-700' : 'bg-white hover:bg-gray-50'} rounded-xl p-5 shadow-sm border ${darkMode ? 'border-gray-700' : 'border-gray-200'} transition-all hover:shadow-md`}>
          <Brain className="text-purple-500 mb-2" size={28} />
          <h3 className="font-semibold">SRS Flashcard</h3>
          <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>Ôn tập thông minh</p>
        </Link>
        <Link to="/mock-tests" className={`${darkMode ? 'bg-gray-800 hover:bg-gray-700' : 'bg-white hover:bg-gray-50'} rounded-xl p-5 shadow-sm border ${darkMode ? 'border-gray-700' : 'border-gray-200'} transition-all hover:shadow-md`}>
          <span className="text-3xl mb-2 block">📝</span>
          <h3 className="font-semibold">Thi thử</h3>
          <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>JLPT, HSK, CEFR</p>
        </Link>
      </div>

      {/* Course List */}
      <div>
        <div className="flex items-center justify-between mb-4">
          <h2 className={`text-xl font-bold ${darkMode ? 'text-white' : 'text-gray-900'}`}>Khóa học có sẵn</h2>
          <Link to="/courses" className="text-blue-500 text-sm hover:underline flex items-center gap-1">Xem tất cả <ChevronRight size={16} /></Link>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {courses.map(course => (
            <Link to={`/courses/${course.id}/path`} key={course.id}
              className={`${darkMode ? 'bg-gray-800 border-gray-700 hover:bg-gray-750' : 'bg-white border-gray-200 hover:shadow-md'} rounded-xl p-5 border transition-all group`}>
              <div className="flex items-start justify-between mb-3">
                <span className="text-3xl">{langFlags[course.certification] || '📖'}</span>
                <span className={`text-xs px-2 py-1 rounded-full font-medium ${course.isPremium ? 'bg-yellow-100 text-yellow-700' : 'bg-green-100 text-green-700'}`}>
                  {course.isPremium ? 'Premium' : 'Miễn phí'}
                </span>
              </div>
              <h3 className={`font-semibold mb-1 group-hover:text-blue-500 transition ${darkMode ? 'text-white' : ''}`}>{course.title}</h3>
              <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'} line-clamp-2 mb-3`}>{course.description}</p>
              <div className="flex items-center gap-3 text-xs text-gray-400">
                <span>📊 {course.levelCode}</span>
                <span>📖 {course.totalUnits} units</span>
                <span>⏱️ ~{course.estimatedHours}h</span>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </div>
  )
}
