import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { courseAPI, gamificationAPI } from '../api'
import { useAppStore } from '../store'

export default function CourseCatalog() {
  const [courses, setCourses] = useState([])
  const [languages, setLanguages] = useState([])
  const [filter, setFilter] = useState({ lang: '', cert: '' })
  const { darkMode } = useAppStore()

  useEffect(() => {
    gamificationAPI.getLanguages().then(r => setLanguages(r.data.data || []))
    loadCourses()
  }, [])

  useEffect(() => { loadCourses() }, [filter])

  const loadCourses = () => {
    const params = {}
    if (filter.lang) params.language = filter.lang
    if (filter.cert) params.certification = filter.cert
    courseAPI.list(params).then(r => setCourses(r.data.data || []))
  }

  const langFlags = { JLPT: '🇯🇵', CEFR: '🇬🇧', HSK: '🇨🇳', TOPIK: '🇰🇷' }
  const certs = ['JLPT', 'CEFR', 'HSK']

  return (
    <div className="max-w-6xl mx-auto">
      <h1 className={`text-2xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>📚 Khóa học</h1>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 mb-6">
        <button onClick={() => setFilter({ lang: '', cert: '' })}
          className={`px-4 py-2 rounded-full text-sm font-medium transition ${!filter.cert && !filter.lang ? 'bg-blue-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}>
          Tất cả
        </button>
        {languages.filter(l => l.code !== 'vi').map(lang => (
          <button key={lang.code} onClick={() => setFilter({ ...filter, lang: lang.code })}
            className={`px-4 py-2 rounded-full text-sm font-medium transition ${filter.lang === lang.code ? 'bg-blue-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}>
            {lang.flagEmoji} {lang.nativeName}
          </button>
        ))}
        <div className="w-px bg-gray-300 mx-1" />
        {certs.map(cert => (
          <button key={cert} onClick={() => setFilter({ ...filter, cert })}
            className={`px-4 py-2 rounded-full text-sm font-medium transition ${filter.cert === cert ? 'bg-purple-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}>
            {cert}
          </button>
        ))}
      </div>

      {/* Courses Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {courses.map(course => (
          <Link to={`/courses/${course.id}/path`} key={course.id}
            className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl p-6 border hover:shadow-lg transition-all group`}>
            <div className="flex items-center gap-3 mb-4">
              <span className="text-4xl">{langFlags[course.certification] || '📖'}</span>
              <div>
                <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${course.certification === 'JLPT' ? 'bg-red-100 text-red-600' : course.certification === 'HSK' ? 'bg-orange-100 text-orange-600' : 'bg-blue-100 text-blue-600'}`}>
                  {course.certification} {course.levelCode}
                </span>
              </div>
            </div>
            <h3 className={`text-lg font-bold mb-2 group-hover:text-blue-500 ${darkMode ? 'text-white' : ''}`}>{course.title}</h3>
            <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'} line-clamp-2 mb-4`}>{course.description}</p>
            <div className="flex items-center justify-between text-xs text-gray-400">
              <div className="flex gap-3">
                <span>📖 {course.totalUnits} units</span>
                <span>⏱️ ~{course.estimatedHours}h</span>
              </div>
              <span className={`px-3 py-1 rounded-full ${course.isPremium ? 'bg-yellow-100 text-yellow-700' : 'bg-green-100 text-green-700'}`}>
                {course.isPremium ? '💎 Premium' : '✅ Free'}
              </span>
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
}
