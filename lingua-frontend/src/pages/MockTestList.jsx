import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { mockTestAPI } from '../api'
import { useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { Clock, FileText, Target } from 'lucide-react'

export default function MockTestList() {

  useDocumentTitle('Thi thử')
  const [tests, setTests] = useState([])
  const [filter, setFilter] = useState('')
  const { darkMode } = useAppStore()

  useEffect(() => {
    const params = filter ? { cert: filter } : {}
    mockTestAPI.list(params).then(r => setTests(r.data.data || []))
  }, [filter])

  const certs = ['JLPT', 'HSK', 'CEFR']
  const certColors = { JLPT: 'from-red-500 to-pink-500', HSK: 'from-orange-500 to-yellow-500', CEFR: 'from-blue-500 to-cyan-500' }

  return (
    <div className="max-w-4xl mx-auto">
      <h1 className={`text-2xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>📝 Thi thử</h1>

      <div className="flex gap-2 mb-6">
        <button onClick={() => setFilter('')}
          className={`px-4 py-2 rounded-full text-sm font-medium ${!filter ? 'bg-blue-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100'}`}>
          Tất cả
        </button>
        {certs.map(c => (
          <button key={c} onClick={() => setFilter(c)}
            className={`px-4 py-2 rounded-full text-sm font-medium ${filter === c ? 'bg-blue-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100'}`}>
            {c}
          </button>
        ))}
      </div>

      <div className="space-y-4">
        {tests.map(test => (
          <Link to={`/mock-tests/${test.id}`} key={test.id}
            className={`block ${darkMode ? 'bg-gray-800 border-gray-700 hover:bg-gray-750' : 'bg-white border-gray-200 hover:shadow-md'} rounded-xl p-6 border transition`}>
            <div className="flex items-center gap-4">
              <div className={`w-14 h-14 rounded-xl bg-gradient-to-br ${certColors[test.certification] || 'from-gray-400 to-gray-500'} flex items-center justify-center`}>
                <FileText size={24} className="text-white" />
              </div>
              <div className="flex-1">
                <h3 className={`font-bold text-lg ${darkMode ? 'text-white' : ''}`}>{test.title}</h3>
                <div className="flex items-center gap-4 text-sm text-gray-400 mt-1">
                  <span className="flex items-center gap-1"><Clock size={14} /> {test.totalDurationMin} phút</span>
                  <span className="flex items-center gap-1"><Target size={14} /> Đạt: {test.passScore} điểm</span>
                  <span className="px-2 py-0.5 bg-gray-100 rounded text-xs">{test.certification} {test.levelCode}</span>
                </div>
              </div>
              <span className="text-blue-500 font-medium text-sm">Làm bài →</span>
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
}
