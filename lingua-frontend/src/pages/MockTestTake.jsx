import { useState, useEffect, useRef } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { mockTestAPI } from '../api'
import { useAppStore } from '../store'
import { Clock, Check, ChevronRight, AlertCircle } from 'lucide-react'

export default function MockTestTake() {
  const { id } = useParams()
  const navigate = useNavigate()
  const [test, setTest] = useState(null)
  const [sections, setSections] = useState({})
  const [currentSection, setCurrentSection] = useState(null)
  const [currentQIdx, setCurrentQIdx] = useState(0)
  const [answers, setAnswers] = useState({})
  const [timeLeft, setTimeLeft] = useState(0)
  const [submitted, setSubmitted] = useState(false)
  const [results, setResults] = useState(null)
  const { darkMode } = useAppStore()
  const timerRef = useRef(null)

  useEffect(() => {
    mockTestAPI.get(id).then(r => {
      const data = r.data.data
      setTest(data)
      setSections(data.sections || {})
      const sectionKeys = Object.keys(data.sections || {})
      if (sectionKeys.length > 0) setCurrentSection(sectionKeys[0])
      setTimeLeft((data.totalDurationMin || 60) * 60)
    })
  }, [id])

  useEffect(() => {
    if (timeLeft > 0 && !submitted) {
      timerRef.current = setTimeout(() => setTimeLeft(timeLeft - 1), 1000)
    } else if (timeLeft === 0 && test && !submitted) {
      handleSubmit()
    }
    return () => clearTimeout(timerRef.current)
  }, [timeLeft, submitted])

  const formatTime = (s) => `${Math.floor(s/60).toString().padStart(2,'0')}:${(s%60).toString().padStart(2,'0')}`

  const handleAnswer = (questionId, answerIdx) => {
    setAnswers(prev => ({ ...prev, [questionId]: answerIdx }))
  }

  const handleSubmit = () => {
    clearTimeout(timerRef.current)
    let totalCorrect = 0; let totalQuestions = 0
    const sectionResults = {}

    Object.entries(sections).forEach(([sectionName, questions]) => {
      let correct = 0
      questions.forEach(q => {
        totalQuestions++
        const answer = JSON.parse(q.answerJson || '{}')
        if (answers[q.id] === answer.correct) { correct++; totalCorrect++ }
      })
      sectionResults[sectionName] = { correct, total: questions.length, percent: Math.round(correct / questions.length * 100) }
    })

    const scorePercent = Math.round(totalCorrect / totalQuestions * 100)
    setResults({ totalCorrect, totalQuestions, scorePercent, sectionResults, passed: scorePercent >= (test?.passScore || 60) })
    setSubmitted(true)
  }

  if (!test) return <div className="flex justify-center py-20"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div></div>

  if (submitted && results) return (
    <div className="max-w-2xl mx-auto">
      <div className="text-center mb-8">
        <span className="text-6xl">{results.passed ? '🎉' : '😢'}</span>
        <h1 className={`text-3xl font-bold mt-4 ${darkMode ? 'text-white' : ''}`}>{results.passed ? 'Đậu rồi!' : 'Chưa đậu'}</h1>
        <p className={`text-5xl font-bold mt-4 ${results.passed ? 'text-lingua-green' : 'text-lingua-red'}`}>{results.scorePercent}%</p>
        <p className="text-gray-400">{results.totalCorrect}/{results.totalQuestions} câu đúng</p>
      </div>

      <div className="space-y-3 mb-8">
        {Object.entries(results.sectionResults).map(([section, r]) => (
          <div key={section} className={`${darkMode ? 'bg-gray-800' : 'bg-white'} p-4 rounded-xl border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
            <div className="flex items-center justify-between mb-2">
              <span className={`font-semibold ${darkMode ? 'text-white' : ''}`}>{section}</span>
              <span className={`font-bold ${r.percent >= 60 ? 'text-green-500' : 'text-red-500'}`}>{r.correct}/{r.total} ({r.percent}%)</span>
            </div>
            <div className="w-full bg-gray-200 rounded-full h-2"><div className={`h-2 rounded-full ${r.percent >= 60 ? 'bg-green-500' : 'bg-red-500'}`} style={{ width: `${r.percent}%` }}></div></div>
          </div>
        ))}
      </div>

      <div className="flex gap-3 justify-center">
        <button onClick={() => navigate('/mock-tests')} className="px-6 py-3 bg-gray-200 rounded-xl font-semibold">Quay lại</button>
        <button onClick={() => { setSubmitted(false); setAnswers({}); setTimeLeft(test.totalDurationMin * 60) }}
          className="px-6 py-3 bg-blue-500 text-white rounded-xl font-semibold">Làm lại</button>
      </div>
    </div>
  )

  const sectionKeys = Object.keys(sections)
  const currentQuestions = sections[currentSection] || []
  const currentQ = currentQuestions[currentQIdx]
  const questionData = currentQ ? JSON.parse(currentQ.questionJson || '{}') : {}

  return (
    <div className="max-w-2xl mx-auto">
      {/* Timer & Progress */}
      <div className="flex items-center justify-between mb-6">
        <div className={`flex items-center gap-2 px-4 py-2 rounded-full ${timeLeft < 300 ? 'bg-red-100 text-red-600' : 'bg-blue-100 text-blue-600'}`}>
          <Clock size={18} /><span className="font-mono font-bold">{formatTime(timeLeft)}</span>
        </div>
        <div className="flex gap-1">
          {sectionKeys.map(s => (
            <button key={s} onClick={() => { setCurrentSection(s); setCurrentQIdx(0) }}
              className={`px-3 py-1 rounded text-xs font-medium ${currentSection === s ? 'bg-blue-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-200'}`}>
              {s}
            </button>
          ))}
        </div>
      </div>

      {/* Question */}
      {currentQ && (
        <div className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-6 border ${darkMode ? 'border-gray-700' : 'border-gray-200'} mb-6`}>
          <p className="text-sm text-gray-400 mb-2">Câu {currentQIdx + 1}/{currentQuestions.length} | {currentSection}</p>

          {questionData.passage && <div className={`p-4 rounded-xl mb-4 ${darkMode ? 'bg-gray-700' : 'bg-gray-50'} text-sm leading-relaxed`}>{questionData.passage}</div>}
          {questionData.audio_text && <div className={`p-4 rounded-xl mb-4 ${darkMode ? 'bg-gray-700' : 'bg-blue-50'} text-sm italic`}>🔊 {questionData.audio_text}</div>}

          <h3 className={`text-lg font-semibold mb-4 ${darkMode ? 'text-white' : ''}`}>{questionData.question}</h3>

          <div className="space-y-2">
            {questionData.options?.map((opt, i) => (
              <button key={i} onClick={() => handleAnswer(currentQ.id, i)}
                className={`w-full text-left p-3 rounded-xl border-2 transition ${
                  answers[currentQ.id] === i ? 'border-blue-500 bg-blue-50 text-blue-700 dark:bg-blue-900/30 dark:text-blue-300' :
                  darkMode ? 'border-gray-600 hover:border-gray-500 text-gray-200' : 'border-gray-200 hover:border-gray-300'
                }`}>{String.fromCharCode(65 + i)}. {opt}</button>
            ))}
          </div>
        </div>
      )}

      {/* Navigation */}
      <div className="flex items-center justify-between">
        <button disabled={currentQIdx === 0}
          onClick={() => setCurrentQIdx(currentQIdx - 1)}
          className="px-4 py-2 bg-gray-200 rounded-xl disabled:opacity-30">← Trước</button>

        {currentQIdx < currentQuestions.length - 1 ? (
          <button onClick={() => setCurrentQIdx(currentQIdx + 1)}
            className="px-6 py-2 bg-blue-500 text-white rounded-xl flex items-center gap-1">Tiếp <ChevronRight size={18} /></button>
        ) : sectionKeys.indexOf(currentSection) < sectionKeys.length - 1 ? (
          <button onClick={() => { setCurrentSection(sectionKeys[sectionKeys.indexOf(currentSection) + 1]); setCurrentQIdx(0) }}
            className="px-6 py-2 bg-purple-500 text-white rounded-xl">Section tiếp →</button>
        ) : (
          <button onClick={handleSubmit}
            className="px-6 py-2 bg-lingua-green text-white rounded-xl font-bold flex items-center gap-1"><Check size={18} /> Nộp bài</button>
        )}
      </div>
    </div>
  )
}
