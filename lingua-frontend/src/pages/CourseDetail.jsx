import { useState, useEffect } from 'react'
import { useParams, Link, useNavigate } from 'react-router-dom'
import { courseAPI, vocabAPI, mockTestAPI } from '../api'
import { useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { SkeletonText } from '../components/Skeleton'
import { BookOpen, Clock, Award, Layers, ChevronRight, Star, Users, FileText, Languages, BookMarked, ArrowLeft, PlayCircle, AlertTriangle } from 'lucide-react'

const LANG_FLAGS_BY_CODE = {
  ja: '🇯🇵',
  zh: '🇨🇳',
  ko: '🇰🇷',
  en: '🇬🇧',
  fr: '🇫🇷',
  de: '🇩🇪',
  es: '🇪🇸',
  it: '🇮🇹',
  pt: '🇵🇹',
  ru: '🇷🇺',
  vi: '🇻🇳',
}

const LANG_FLAGS_BY_CERT = { JLPT: '🇯🇵', HSK: '🇨🇳', TOPIK: '🇰🇷' }

function normalizeLevel(certification, levelCode) {
  if (!levelCode) return levelCode
  const lvl = String(levelCode).trim()
  if (certification === 'HSK') {
    const m = lvl.match(/HSK\s*(\d+)/i)
    if (m) return m[1]
    return lvl
  }
  return lvl
}

function getLangFlag(course) {
  if (!course) return '📚'
  const code = course.targetLanguage?.code
  if (code && LANG_FLAGS_BY_CODE[code]) return LANG_FLAGS_BY_CODE[code]
  if (course.certification && LANG_FLAGS_BY_CERT[course.certification]) return LANG_FLAGS_BY_CERT[course.certification]
  return '📚'
}

function formatPercent(value) {
  if (value == null || isNaN(value)) return 0
  const n = Number(value)
  if (n <= 0) return 0
  if (n < 1) return 1
  return Math.round(n)
}

export default function CourseDetail() {
  const { id } = useParams()
  const navigate = useNavigate()
  const [course, setCourse] = useState(null)
  const [pathData, setPathData] = useState(null)
  const [error, setError] = useState(null)
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('overview')
  const [vocabPreview, setVocabPreview] = useState([])
  const [grammarPreview, setGrammarPreview] = useState([])
  const [kanjiPreview, setKanjiPreview] = useState([])
  const [mockTests, setMockTests] = useState([])
  const { darkMode } = useAppStore()
  useDocumentTitle(course?.title ? `Khóa học · ${course.title}` : null)

  useEffect(() => {
    setCourse(null)
    setPathData(null)
    setError(null)
    setLoading(true)
    setVocabPreview([])
    setGrammarPreview([])
    setKanjiPreview([])
    setMockTests([])
    setActiveTab('overview')

    let cancelled = false

    Promise.all([
      courseAPI.get(id).then(r => r.data?.data),
      courseAPI.getPath(id).then(r => r.data?.data).catch(err => {
        if (err?.response?.status === 404) throw err
        return null
      }),
    ])
      .then(([courseData, pathDataResult]) => {
        if (cancelled) return
        if (!courseData) {
          setError('Khóa học không tồn tại')
        } else {
          setCourse(courseData)
          setPathData(pathDataResult)
        }
      })
      .catch(err => {
        if (cancelled) return
        if (err?.response?.status === 404) {
          setError('Khóa học không tồn tại')
        } else {
          setError('Không tải được khóa học. Vui lòng thử lại.')
        }
      })
      .finally(() => {
        if (!cancelled) setLoading(false)
      })

    return () => { cancelled = true }
  }, [id])

  useEffect(() => {
    if (!course) return
    const langCode = course.targetLanguage?.code
    const level = course.levelCode
    let cancelled = false

    if (langCode && level) {
      const lvl = normalizeLevel(course.certification, level)
      vocabAPI.search({ lang: langCode, level: lvl })
        .then(r => { if (!cancelled) setVocabPreview((r.data.data || []).slice(0, 12)) })
        .catch(() => {})
      vocabAPI.getGrammars({ lang: langCode, level: lvl })
        .then(r => { if (!cancelled) setGrammarPreview((r.data.data || []).slice(0, 8)) })
        .catch(() => {})
      if (langCode === 'ja') {
        vocabAPI.getCharacters({ level })
          .then(r => { if (!cancelled) setKanjiPreview((r.data.data || []).slice(0, 24)) })
          .catch(() => {})
      }
    }

    mockTestAPI.list({ cert: course.certification, level: course.levelCode })
      .then(r => { if (!cancelled) setMockTests(r.data.data || []) })
      .catch(() => {})

    return () => { cancelled = true }
  }, [course])

  if (loading && !course && !error) {
    return (
      <div className="flex justify-center py-20">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="max-w-2xl mx-auto py-16">
        <div className={`rounded-2xl p-8 text-center border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}>
          <AlertTriangle size={48} className="mx-auto mb-4 text-red-500" />
          <h2 className={`text-xl font-bold mb-2 ${darkMode ? 'text-white' : ''}`}>Có lỗi xảy ra</h2>
          <p className={`mb-6 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>{error}</p>
          <div className="flex gap-3 justify-center">
            <button
              onClick={() => navigate('/courses')}
              className="px-5 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-200 hover:bg-gray-300 dark:hover:bg-gray-600 transition">
              Quay lại danh sách
            </button>
            <button
              onClick={() => window.location.reload()}
              className="px-5 py-2 rounded-lg bg-blue-500 text-white hover:bg-blue-600 transition">
              Thử lại
            </button>
          </div>
        </div>
      </div>
    )
  }

  if (!course) return null

  const certColors = {
    JLPT: 'from-red-500 to-pink-500',
    CEFR: 'from-blue-500 to-cyan-500',
    HSK: 'from-orange-500 to-yellow-500',
    TOPIK: 'from-purple-500 to-indigo-500'
  }

  const totalSections = pathData?.path?.length || 0
  const totalUnits = pathData?.path?.reduce((s, sec) => s + (sec.units?.length || 0), 0) || 0
  const totalLessons = pathData?.path?.reduce((s, sec) =>
    s + (sec.units?.reduce((u, unit) => u + (unit.lessons?.length || 0), 0) || 0), 0) || 0
  const pathLoading = pathData == null

  const tabs = [
    { id: 'overview', label: 'Tổng quan', icon: BookOpen },
    { id: 'curriculum', label: 'Lộ trình', icon: Layers },
    { id: 'vocabulary', label: 'Từ vựng', icon: BookMarked },
    ...(course.targetLanguage?.code === 'ja' ? [{ id: 'kanji', label: 'Hán tự', icon: Languages }] : []),
    { id: 'grammar', label: 'Ngữ pháp', icon: BookMarked },
    { id: 'tests', label: 'Đề thi thử', icon: FileText },
  ]

  return (
    <div className="max-w-6xl mx-auto">
      <button id="back-button" onClick={() => navigate('/courses')}
        className={`flex items-center gap-2 mb-4 text-sm ${darkMode ? 'text-gray-400 hover:text-white' : 'text-gray-500 hover:text-gray-800'}`}>
        <ArrowLeft size={16} /> Quay lại danh sách khóa học
      </button>

      <header id="course-hero" className={`rounded-2xl bg-gradient-to-br ${certColors[course.certification] || 'from-gray-500 to-gray-600'} p-8 mb-6 text-white shadow-lg`}>
        <div className="flex items-start gap-4 mb-4">
          <span className="text-7xl">{getLangFlag(course)}</span>
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-2">
              <span className="px-3 py-1 bg-white/20 backdrop-blur rounded-full text-xs font-bold">
                {course.certification} {course.levelCode}
              </span>
              {course.isPremium ? (
                <span className="px-3 py-1 bg-yellow-400 text-yellow-900 rounded-full text-xs font-bold">💎 Premium</span>
              ) : (
                <span className="px-3 py-1 bg-green-400 text-green-900 rounded-full text-xs font-bold">✅ Miễn phí</span>
              )}
            </div>
            <h1 className="text-3xl md:text-4xl font-bold mb-2">{course.title}</h1>
            <p className="opacity-90 text-base">{course.description}</p>
          </div>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-5 gap-3 mt-6">
          <div className="bg-white/10 backdrop-blur rounded-xl p-3 text-center">
            <Layers size={20} className="mx-auto mb-1 opacity-80" />
            {pathLoading
              ? <SkeletonText width="w-10 mx-auto" height="h-6" className="mb-1 bg-white/30" />
              : <p className="text-xl font-bold">{totalSections}</p>}
            <p className="text-xs opacity-80">Chương</p>
          </div>
          <div className="bg-white/10 backdrop-blur rounded-xl p-3 text-center">
            <BookOpen size={20} className="mx-auto mb-1 opacity-80" />
            {pathLoading
              ? <SkeletonText width="w-10 mx-auto" height="h-6" className="mb-1 bg-white/30" />
              : <p className="text-xl font-bold">{totalUnits || course.totalUnits || 0}</p>}
            <p className="text-xs opacity-80">Bài học chính</p>
          </div>
          <div className="bg-white/10 backdrop-blur rounded-xl p-3 text-center">
            <PlayCircle size={20} className="mx-auto mb-1 opacity-80" />
            {pathLoading
              ? <SkeletonText width="w-10 mx-auto" height="h-6" className="mb-1 bg-white/30" />
              : <p className="text-xl font-bold">{totalLessons}</p>}
            <p className="text-xs opacity-80">Lessons</p>
          </div>
          <div className="bg-white/10 backdrop-blur rounded-xl p-3 text-center">
            <Clock size={20} className="mx-auto mb-1 opacity-80" />
            <p className="text-xl font-bold">~{course.estimatedHours}h</p>
            <p className="text-xs opacity-80">Thời lượng</p>
          </div>
          <div className="bg-white/10 backdrop-blur rounded-xl p-3 text-center">
            <Star size={20} className="mx-auto mb-1 opacity-80" />
            <p className="text-xl font-bold">{course.ratingAvg || 4.8}</p>
            <p className="text-xs opacity-80">Đánh giá</p>
          </div>
        </div>

        <div className="flex flex-wrap gap-3 mt-6">
          <Link to={`/courses/${id}/path`}
            className="px-6 py-3 bg-white text-gray-800 rounded-xl font-bold flex items-center gap-2 hover:shadow-xl transition">
            <PlayCircle size={20} /> Bắt đầu học
          </Link>
          {mockTests[0] && (
            <Link to={`/mock-tests/${mockTests[0].id}`}
              className="px-6 py-3 bg-white/20 backdrop-blur text-white rounded-xl font-bold flex items-center gap-2 hover:bg-white/30 transition">
              <FileText size={20} /> Làm đề thi thử
            </Link>
          )}
        </div>
      </header>

      <nav id="course-tabs" className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-xl border p-1 mb-6 flex flex-wrap gap-1`}>
        {tabs.map(tab => (
          <button key={tab.id} onClick={() => setActiveTab(tab.id)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition ${
              activeTab === tab.id
                ? 'bg-gradient-to-r from-blue-500 to-purple-500 text-white shadow-md'
                : darkMode ? 'text-gray-300 hover:bg-gray-700' : 'text-gray-600 hover:bg-gray-100'
            }`}>
            <tab.icon size={16} /> {tab.label}
          </button>
        ))}
      </nav>

      {activeTab === 'overview' && (
        <section id="tab-overview" className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-6`}>
          <h2 className={`text-xl font-bold mb-4 ${darkMode ? 'text-white' : ''}`}>📖 Giới thiệu khóa học</h2>
          <p className={`mb-6 leading-relaxed ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>{course.description}</p>

          <h3 className={`font-bold mb-3 ${darkMode ? 'text-white' : ''}`}>🎯 Bạn sẽ học được gì?</h3>
          <ul className={`space-y-2 mb-6 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>
            <li className="flex gap-2"><span>✅</span> Nắm vững từ vựng cơ bản theo chuẩn {course.certification} {course.levelCode}</li>
            <li className="flex gap-2"><span>✅</span> Hiểu và sử dụng được các mẫu ngữ pháp quan trọng</li>
            {course.targetLanguage?.code === 'ja' && <li className="flex gap-2"><span>✅</span> Nhớ và viết được Kanji thuộc cấp độ {course.levelCode}</li>}
            {course.targetLanguage?.code === 'zh' && <li className="flex gap-2"><span>✅</span> Đọc và viết được chữ Hán cấp độ {course.levelCode}</li>}
            <li className="flex gap-2"><span>✅</span> Phát âm chuẩn theo {course.targetLanguage?.code === 'ja' ? 'Romaji (Hepburn)' : course.targetLanguage?.code === 'zh' ? 'Pinyin (có thanh điệu)' : 'IPA'}</li>
            <li className="flex gap-2"><span>✅</span> Tự tin làm đề thi thử với điểm số dự đoán</li>
            <li className="flex gap-2"><span>✅</span> Hệ thống lặp lại ngắt quãng (SRS) ghi nhớ lâu dài</li>
          </ul>

          <h3 className={`font-bold mb-3 ${darkMode ? 'text-white' : ''}`}>📋 Yêu cầu</h3>
          <ul className={`space-y-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>
            <li className="flex gap-2"><span>📚</span> Trình độ hiện tại: {
              course.levelCode === 'N5' || course.levelCode === 'A1' || course.levelCode === 'HSK1' ? 'Người mới bắt đầu' :
              course.levelCode === 'N4' || course.levelCode === 'A2' || course.levelCode === 'HSK2' ? 'Đã hoàn thành level cơ bản' :
              'Đã có nền tảng vững'
            }</li>
            <li className="flex gap-2"><span>⏱️</span> Cam kết học: ~{Math.ceil((course.estimatedHours || 60) / 30)} giờ/tuần trong {Math.ceil((course.estimatedHours || 60) / 7)} tuần</li>
            <li className="flex gap-2"><span>💪</span> Tinh thần kiên trì học mỗi ngày để giữ streak</li>
          </ul>
        </section>
      )}

      {activeTab === 'curriculum' && (
        <section id="tab-curriculum" className="space-y-4">
          {pathLoading ? (
            <div className={`text-center py-12 ${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto mb-3"></div>
              <p className="text-gray-400">Đang tải lộ trình…</p>
            </div>
          ) : (
            <>
              {pathData?.summary && pathData.summary.totalLessons > 0 && (
                <article
                  id="course-progress-summary"
                  aria-label="Tiến độ tổng"
                  className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-5`}>
                  <div className="flex items-center justify-between mb-2">
                    <h3 className={`font-bold ${darkMode ? 'text-white' : 'text-gray-800'}`}>📈 Tiến độ tổng</h3>
                    <span className={`text-sm font-semibold ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>
                      {pathData.summary.completedLessons}/{pathData.summary.totalLessons} bài · {formatPercent(pathData.summary.progressPercent)}%
                    </span>
                  </div>
                  <div className="h-3 w-full rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden">
                    <div
                      className="h-full bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 transition-all"
                      style={{ width: `${formatPercent(pathData.summary.progressPercent)}%` }}
                      role="progressbar"
                      aria-valuenow={formatPercent(pathData.summary.progressPercent)}
                      aria-valuemin="0"
                      aria-valuemax="100"
                    />
                  </div>
                </article>
              )}

              {pathData?.path?.length > 0 ? pathData.path.map((section, sIdx) => (
                <article key={section.id} className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-5`}>
                  <div className="flex items-center gap-3 mb-3">
                    <div className="w-10 h-10 rounded-xl bg-gradient-to-r from-blue-500 to-purple-500 flex items-center justify-center text-white font-bold">{sIdx + 1}</div>
                    <div className="flex-1">
                      <h3 className={`font-bold ${darkMode ? 'text-white' : ''}`}>{section.title}</h3>
                      <p className="text-sm text-gray-400">{section.description}</p>
                    </div>
                    {section.totalLessons > 0 && (
                      <div className="text-right shrink-0">
                        <span className={`text-xs font-semibold ${
                          section.progressPercent === 100 ? 'text-green-500' :
                          section.progressPercent > 0 ? 'text-blue-500' :
                          darkMode ? 'text-gray-400' : 'text-gray-500'
                        }`}>
                          {section.completedLessons}/{section.totalLessons} ({formatPercent(section.progressPercent)}%)
                        </span>
                        <div className="mt-1 h-1.5 w-24 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden">
                          <div
                            className={`h-full transition-all ${section.progressPercent === 100 ? 'bg-green-500' : 'bg-blue-500'}`}
                            style={{ width: `${formatPercent(section.progressPercent)}%` }}
                          />
                        </div>
                      </div>
                    )}
                  </div>
                  <div className="ml-13 space-y-2 text-sm">
                    {section.units?.map(unit => (
                      <div key={unit.id} className={`p-3 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-gray-50'}`}>
                        <div className="flex items-center gap-2 font-medium mb-1">
                          <span className="text-xl">{unit.icon || '📘'}</span>
                          <span className={darkMode ? 'text-gray-200' : 'text-gray-700'}>{unit.title}</span>
                          {unit.totalLessons > 0 && (
                            <span className={`text-[10px] px-2 py-0.5 rounded-full font-semibold ${
                              unit.progressPercent === 100 ? 'bg-green-100 text-green-700 dark:bg-green-900/40 dark:text-green-300' :
                              unit.progressPercent > 0 ? 'bg-blue-100 text-blue-700 dark:bg-blue-900/40 dark:text-blue-300' :
                              'bg-gray-200 text-gray-500 dark:bg-gray-600 dark:text-gray-300'
                            }`}>
                              {unit.completedLessons}/{unit.totalLessons}
                            </span>
                          )}
                          <span className="ml-auto text-xs text-yellow-500 font-bold">+{unit.xpReward} XP</span>
                        </div>
                        {unit.communicationGoal && <p className="text-xs text-gray-400 ml-7 mb-2">🎯 {unit.communicationGoal}</p>}
                        <div className="ml-7 flex flex-wrap gap-2">
                          {unit.lessons?.map(lesson => (
                            <Link
                              key={lesson.id}
                              to={`/lessons/${lesson.id}`}
                              title={lesson.bestScore != null ? `Điểm cao nhất: ${Math.round(lesson.bestScore)}%` : ''}
                              className={`text-xs px-2 py-1 rounded-md flex items-center gap-1 transition ${
                                lesson.completed
                                  ? (darkMode ? 'bg-green-900/40 text-green-300 hover:bg-green-900/60' : 'bg-green-100 text-green-700 hover:bg-green-200')
                                  : (darkMode ? 'bg-gray-600 text-gray-200 hover:bg-blue-700' : 'bg-white text-gray-600 hover:bg-blue-100 hover:text-blue-700')
                              }`}>
                              {lesson.completed && <span aria-label="đã hoàn thành">✅</span>}
                              {lesson.title}
                            </Link>
                          ))}
                        </div>
                      </div>
                    ))}
                  </div>
                </article>
              )) : (
                <div className={`text-center py-12 ${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
                  <p className="text-gray-400">Đang cập nhật lộ trình học cho khóa này...</p>
                </div>
              )}
            </>
          )}
        </section>
      )}

      {activeTab === 'vocabulary' && (
        <section id="tab-vocabulary" className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-6`}>
          <div className="flex items-center justify-between mb-4">
            <h2 className={`text-xl font-bold ${darkMode ? 'text-white' : ''}`}>📚 Từ vựng tiêu biểu</h2>
            <Link to="/vocabulary" className="text-sm text-blue-500 hover:underline">Xem tất cả →</Link>
          </div>
          {vocabPreview.length === 0 ? (
            <p className="text-gray-400 text-center py-8">Đang cập nhật từ vựng...</p>
          ) : (
            <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
              {vocabPreview.map(w => (
                <div key={w.id} className={`p-3 rounded-xl border ${darkMode ? 'border-gray-700 bg-gray-700' : 'border-gray-200 bg-gray-50'}`}>
                  <p className={`text-lg font-bold mb-1 ${darkMode ? 'text-white' : ''}`}>{w.text}</p>
                  {w.reading && <p className="text-sm text-blue-500">{w.reading}</p>}
                  {w.romaji && <p className="text-xs text-gray-400">{w.romaji}</p>}
                  {w.meanings?.[0]?.meaning && <p className={`text-xs mt-1 ${darkMode ? 'text-gray-300' : 'text-gray-600'}`}>{w.meanings[0].meaning}</p>}
                </div>
              ))}
            </div>
          )}
        </section>
      )}

      {activeTab === 'kanji' && (
        <section id="tab-kanji" className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-6`}>
          <div className="flex items-center justify-between mb-4">
            <h2 className={`text-xl font-bold ${darkMode ? 'text-white' : ''}`}>🈶 Kanji tiêu biểu - {course.levelCode}</h2>
            <Link to="/kanji" className="text-sm text-blue-500 hover:underline">Xem tất cả →</Link>
          </div>
          {kanjiPreview.length === 0 ? (
            <p className="text-gray-400 text-center py-8">Đang cập nhật Kanji...</p>
          ) : (
            <div className="grid grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-2">
              {kanjiPreview.map(k => (
                <div key={k.id} className={`aspect-square flex flex-col items-center justify-center rounded-xl border p-2 ${darkMode ? 'border-gray-700 bg-gray-700' : 'border-gray-200 bg-white'}`}
                     title={`${k.hanViet} - ${k.meaningVi}`}>
                  <span className={`text-2xl font-bold ${darkMode ? 'text-white' : 'text-gray-800'}`}>{k.character}</span>
                  <span className="text-xs text-gray-400 mt-0.5 truncate w-full text-center">{k.hanViet}</span>
                </div>
              ))}
            </div>
          )}
        </section>
      )}

      {activeTab === 'grammar' && (
        <section id="tab-grammar" className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-6`}>
          <div className="flex items-center justify-between mb-4">
            <h2 className={`text-xl font-bold ${darkMode ? 'text-white' : ''}`}>📖 Ngữ pháp tiêu biểu</h2>
            <Link to="/grammar" className="text-sm text-blue-500 hover:underline">Xem tất cả →</Link>
          </div>
          {grammarPreview.length === 0 ? (
            <p className="text-gray-400 text-center py-8">Đang cập nhật ngữ pháp...</p>
          ) : (
            <div className="space-y-3">
              {grammarPreview.map(g => (
                <article key={g.id} className={`p-4 rounded-xl border ${darkMode ? 'border-gray-700 bg-gray-700' : 'border-gray-200 bg-gray-50'}`}>
                  <div className="flex items-center justify-between mb-2">
                    <p className={`font-bold text-lg ${darkMode ? 'text-white' : ''}`}>{g.pattern}</p>
                    {g.jlptLevel && <span className="text-xs px-2 py-0.5 bg-purple-100 text-purple-700 rounded">{g.jlptLevel}</span>}
                  </div>
                  <p className={`text-sm mb-1 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>📌 {g.meaningVi}</p>
                  {g.structure && <p className="text-xs text-gray-400 mb-1">Cấu trúc: <code className={`px-1 rounded ${darkMode ? 'bg-gray-800' : 'bg-white'}`}>{g.structure}</code></p>}
                  {g.exampleSentence && (
                    <div className={`mt-2 p-2 rounded ${darkMode ? 'bg-gray-800' : 'bg-white'} text-sm`}>
                      <p>📝 {g.exampleSentence}</p>
                      {g.exampleTranslation && <p className="text-gray-400 text-xs mt-1">→ {g.exampleTranslation}</p>}
                    </div>
                  )}
                </article>
              ))}
            </div>
          )}
        </section>
      )}

      {activeTab === 'tests' && (
        <section id="tab-tests" className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-6`}>
          <h2 className={`text-xl font-bold mb-4 ${darkMode ? 'text-white' : ''}`}>📝 Đề thi thử</h2>
          {mockTests.length === 0 ? (
            <p className="text-gray-400 text-center py-8">Chưa có đề thi cho khóa này.</p>
          ) : (
            <div className="space-y-3">
              {mockTests.map(test => (
                <Link key={test.id} to={`/mock-tests/${test.id}`}
                  className={`block p-4 rounded-xl border ${darkMode ? 'border-gray-700 bg-gray-700 hover:bg-gray-600' : 'border-gray-200 bg-gray-50 hover:bg-gray-100'} transition`}>
                  <div className="flex items-center gap-4">
                    <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${certColors[test.certification]} flex items-center justify-center`}>
                      <FileText size={24} className="text-white" />
                    </div>
                    <div className="flex-1">
                      <h3 className={`font-bold ${darkMode ? 'text-white' : ''}`}>{test.title}</h3>
                      <div className="flex gap-3 text-xs text-gray-400 mt-1">
                        <span>⏱️ {test.totalDurationMin} phút</span>
                        <span>🎯 Đạt: {test.passScore} điểm</span>
                      </div>
                    </div>
                    <ChevronRight size={20} className="text-gray-400" />
                  </div>
                </Link>
              ))}
            </div>
          )}
        </section>
      )}
    </div>
  )
}
