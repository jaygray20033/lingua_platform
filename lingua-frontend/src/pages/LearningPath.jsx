import { useState, useEffect } from 'react'
import { useParams, Link } from 'react-router-dom'
import { courseAPI } from '../api'
import { useAppStore } from '../store'
import { Lock, CheckCircle2, PlayCircle, ChevronDown, ChevronRight } from 'lucide-react'

export default function LearningPath() {
  const { id } = useParams()
  const [data, setData] = useState(null)
  const [expandedSections, setExpandedSections] = useState({})
  const { darkMode } = useAppStore()

  useEffect(() => {
    courseAPI.getPath(id).then(r => {
      setData(r.data.data)
      // Expand first section by default
      if (r.data.data?.path?.length > 0) {
        setExpandedSections({ [r.data.data.path[0].id]: true })
      }
    })
  }, [id])

  const toggleSection = (sectionId) => {
    setExpandedSections(prev => ({ ...prev, [sectionId]: !prev[sectionId] }))
  }

  if (!data) return <div className="flex justify-center py-20"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div></div>

  return (
    <div className="max-w-3xl mx-auto">
      {/* Course Header */}
      <div className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-6 mb-6 border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
        <h1 className={`text-2xl font-bold mb-2 ${darkMode ? 'text-white' : ''}`}>{data.course?.title}</h1>
        <p className={`${darkMode ? 'text-gray-400' : 'text-gray-500'} mb-3`}>{data.course?.description}</p>
        <div className="flex gap-4 text-sm text-gray-400">
          <span>📊 {data.course?.levelCode}</span>
          <span>📖 {data.course?.totalUnits} units</span>
        </div>
      </div>

      {/* Learning Path */}
      <div className="space-y-4">
        {data.path?.map((section, sIdx) => (
          <div key={section.id} className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border overflow-hidden`}>
            {/* Section Header */}
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

            {/* Units & Lessons */}
            {expandedSections[section.id] && (
              <div className="px-5 pb-5 space-y-4">
                {section.units?.map((unit, uIdx) => (
                  <div key={unit.id} className="ml-4">
                    <div className="flex items-center gap-2 mb-3">
                      <span className="text-2xl">{unit.icon || '📘'}</span>
                      <div>
                        <h3 className={`font-semibold ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{unit.title}</h3>
                        {unit.communicationGoal && <p className="text-xs text-gray-400">{unit.communicationGoal}</p>}
                      </div>
                    </div>

                    {/* Lessons */}
                    <div className="ml-6 space-y-2">
                      {unit.lessons?.map((lesson, lIdx) => {
                        const isFirst = sIdx === 0 && uIdx === 0 && lIdx < 3
                        const isCheckpoint = lesson.type === 'CHECKPOINT'
                        return (
                          <Link to={`/lessons/${lesson.id}`} key={lesson.id}
                            className={`flex items-center gap-3 p-3 rounded-xl transition group ${
                              isCheckpoint
                                ? `${darkMode ? 'bg-yellow-900/20 border-yellow-700/50' : 'bg-yellow-50 border-yellow-200'} border`
                                : isFirst
                                  ? `${darkMode ? 'bg-green-900/20 hover:bg-green-900/30' : 'bg-green-50 hover:bg-green-100'}`
                                  : `${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'}`
                            }`}>
                            <div className={`w-9 h-9 rounded-full flex items-center justify-center ${
                              isCheckpoint ? 'bg-yellow-500' : isFirst ? 'bg-lingua-green' : darkMode ? 'bg-gray-600' : 'bg-gray-200'
                            }`}>
                              {isCheckpoint ? <CheckCircle2 size={18} className="text-white" /> :
                               isFirst ? <PlayCircle size={18} className="text-white" /> :
                               <Lock size={14} className="text-gray-400" />}
                            </div>
                            <div className="flex-1">
                              <span className={`text-sm font-medium ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{lesson.title}</span>
                              <div className="flex gap-2 text-xs text-gray-400 mt-0.5">
                                <span>+{lesson.xpReward} XP</span>
                                <span>{lesson.exerciseCount} câu</span>
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
