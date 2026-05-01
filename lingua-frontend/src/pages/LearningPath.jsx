import { useState, useEffect } from 'react'
import { useParams, Link, useNavigate } from 'react-router-dom'
import { courseAPI } from '../api'
import { useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { Lock, CheckCircle2, PlayCircle, ChevronDown, ChevronRight, AlertTriangle } from 'lucide-react'

export default function LearningPath() {
  useDocumentTitle('Lộ trình học')
  const { id } = useParams()
  const navigate = useNavigate()
  const [data, setData] = useState(null)
  const [error, setError] = useState(null)
  const [loading, setLoading] = useState(true)
  const [expandedSections, setExpandedSections] = useState({})
  const { darkMode } = useAppStore()

  useEffect(() => {
    let cancelled = false
    setData(null)
    setError(null)
    setLoading(true)

    courseAPI.getPath(id)
      .then(r => {
        if (cancelled) return
        const payload = r.data?.data
        setData(payload)
        if (payload?.path?.length > 0) {
          setExpandedSections({ [payload.path[0].id]: true })
        }
      })
      .catch(err => {
        if (cancelled) return
        if (err?.response?.status === 404) {
          setError('Khóa học không tồn tại hoặc chưa có lộ trình.')
        } else {
          setError('Không tải được lộ trình. Vui lòng thử lại.')
        }
      })
      .finally(() => {
        if (!cancelled) setLoading(false)
      })

    return () => { cancelled = true }
  }, [id])

  const toggleSection = (sectionId) => {
    setExpandedSections(prev => ({ ...prev, [sectionId]: !prev[sectionId] }))
  }

  if (loading) {
    return <div className="flex justify-center py-20"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div></div>
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

  if (!data) return null

  const flattenedLessons = []
  data.path?.forEach(section => {
    section.units?.forEach(unit => {
      unit.lessons?.forEach(lesson => {
        flattenedLessons.push({ ...lesson, sectionId: section.id, unitId: unit.id })
      })
    })
  })
  const firstUncompletedIndex = flattenedLessons.findIndex(l => !l.completed)
  const currentLessonId = firstUncompletedIndex >= 0 ? flattenedLessons[firstUncompletedIndex].id : null

  return (
    <div className="max-w-3xl mx-auto">
      <div className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-6 mb-6 border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
        <h1 className={`text-2xl font-bold mb-2 ${darkMode ? 'text-white' : ''}`}>{data.course?.title}</h1>
        <p className={`${darkMode ? 'text-gray-400' : 'text-gray-500'} mb-3`}>{data.course?.description}</p>
        <div className="flex gap-4 text-sm text-gray-400">
          <span>📊 {data.course?.levelCode}</span>
          <span>📖 {data.course?.totalUnits} units</span>
          {data.summary?.totalLessons > 0 && (
            <span>✅ {data.summary.completedLessons}/{data.summary.totalLessons} bài</span>
          )}
        </div>
      </div>

      <div className="space-y-4">
        {data.path?.map((section, sIdx) => (
          <div key={section.id} className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border overflow-hidden`}>
            <button onClick={() => toggleSection(section.id)}
              className={`w-full flex items-center justify-between p-5 hover:bg-opacity-50 transition ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'}`}>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-gradient-to-r from-blue-500 to-purple-500 flex items-center justify-center text-white font-bold">
                  {sIdx + 1}
                </div>
                <div className="text-left">
                  <h2 className={`font-bold ${darkMode ? 'text-white' : ''}`}>{section.title}</h2>
                  <p className="text-sm text-gray-400">{section.description}</p>
                </div>
              </div>
              {expandedSections[section.id] ? <ChevronDown size={20} className="text-gray-400" /> : <ChevronRight size={20} className="text-gray-400" />}
            </button>

            {expandedSections[section.id] && (
              <div className="px-5 pb-5 space-y-4">
                {section.units?.map((unit) => (
                  <div key={unit.id} className="ml-4">
                    <div className="flex items-center gap-2 mb-3">
                      <span className="text-2xl">{unit.icon || '📘'}</span>
                      <div>
                        <h3 className={`font-semibold ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{unit.title}</h3>
                        {unit.communicationGoal && <p className="text-xs text-gray-400">{unit.communicationGoal}</p>}
                      </div>
                    </div>

                    <div className="ml-6 space-y-2">
                      {unit.lessons?.map((lesson) => {
                        const isCheckpoint = lesson.type === 'CHECKPOINT'
                        const isCompleted = !!lesson.completed
                        const isCurrent = lesson.id === currentLessonId
                        const isPlayable = isCompleted || isCurrent
                        const isLocked = !isPlayable

                        return (
                          <Link
                            to={`/lessons/${lesson.id}`}
                            key={lesson.id}
                            onClick={(e) => { if (isLocked) e.preventDefault() }}
                            aria-disabled={isLocked}
                            className={`flex items-center gap-3 p-3 rounded-xl transition group ${
                              isCompleted
                                ? `${darkMode ? 'bg-green-900/20 hover:bg-green-900/30' : 'bg-green-50 hover:bg-green-100'}`
                                : isCheckpoint
                                  ? `${darkMode ? 'bg-yellow-900/20 border-yellow-700/50' : 'bg-yellow-50 border-yellow-200'} border`
                                  : isCurrent
                                    ? `${darkMode ? 'bg-blue-900/20 hover:bg-blue-900/30' : 'bg-blue-50 hover:bg-blue-100'}`
                                    : `${darkMode ? 'opacity-60' : 'opacity-70'} cursor-not-allowed`
                            }`}>
                            <div className={`w-9 h-9 rounded-full flex items-center justify-center ${
                              isCompleted ? 'bg-green-500' :
                              isCheckpoint ? 'bg-yellow-500' :
                              isCurrent ? 'bg-blue-500' :
                              darkMode ? 'bg-gray-600' : 'bg-gray-200'
                            }`}>
                              {isCompleted ? <CheckCircle2 size={18} className="text-white" /> :
                               isCheckpoint ? <CheckCircle2 size={18} className="text-white" /> :
                               isCurrent ? <PlayCircle size={18} className="text-white" /> :
                               <Lock size={14} className="text-gray-400" />}
                            </div>
                            <div className="flex-1">
                              <span className={`text-sm font-medium ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{lesson.title}</span>
                              <div className="flex gap-2 text-xs text-gray-400 mt-0.5">
                                <span>+{lesson.xpReward} XP</span>
                                <span>{lesson.exerciseCount} câu</span>
                                {lesson.bestScore != null && <span>★ {Math.round(lesson.bestScore)}%</span>}
                              </div>
                            </div>
                            <ChevronRight size={16} className="text-gray-400 group-hover:text-blue-500" />
                          </Link>
                        )
                      })}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}
