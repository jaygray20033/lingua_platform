import { useState, useEffect, useRef, useMemo, useCallback } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { mockTestAPI } from '../api'
import { useAppStore } from '../store'
import { useToast } from '../components/Toast'
import { speak as ttsSpeak, stopSpeaking, certToLang } from '../utils/tts'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { Clock, Check, ChevronLeft, ChevronRight, AlertCircle, X, BookOpen, Volume2, Lightbulb, Flag, Mic, MicOff, PenTool, Headphones } from 'lucide-react'

const SECTION_LABELS = {
  VOCAB: '📝 Từ vựng',
  VOCABULARY: '📝 Từ vựng',
  GRAMMAR: '📐 Ngữ pháp',
  READING: '📖 Đọc hiểu (読解 / Reading)',
  LISTENING: '🎧 Nghe hiểu (聴解 / Listening)',
  WRITING: '✏️ Viết (作文 / Writing)',
  SPEAKING: '🎤 Nói (会話 / Speaking)',
}

const SECTION_ICONS = {
  LISTENING: Headphones, READING: BookOpen, WRITING: PenTool, SPEAKING: Mic
}

export default function MockTestTake() {

  useDocumentTitle('Làm bài thi thử')
  const { id } = useParams()
  const navigate = useNavigate()
  const [test, setTest] = useState(null)
  const [sections, setSections] = useState({})
  const [currentSection, setCurrentSection] = useState(null)
  const [currentQIdx, setCurrentQIdx] = useState(0)
  const [answers, setAnswers] = useState({})
  const [flagged, setFlagged] = useState({})
  const [timeLeft, setTimeLeft] = useState(0)
  const [submitted, setSubmitted] = useState(false)
  const [results, setResults] = useState(null)
  const [showConfirmSubmit, setShowConfirmSubmit] = useState(false)
  const [reviewMode, setReviewMode] = useState(false)
  const [showStartScreen, setShowStartScreen] = useState(true)
  const { darkMode } = useAppStore()
  const toast = useToast()
  const timerRef = useRef(null)
  const questionRef = useRef(null)

  const startedAtRef = useRef(Date.now())

  const submittedRef = useRef(false)

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
    if (!showStartScreen) {
      startedAtRef.current = Date.now()
      submittedRef.current = false
    }
  }, [showStartScreen])

  useEffect(() => {
    if (questionRef.current) questionRef.current.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }, [currentQIdx, currentSection])

  const formatTime = (s) => `${Math.floor(s / 60).toString().padStart(2, '0')}:${(s % 60).toString().padStart(2, '0')}`

  const handleAnswer = (questionId, answerIdx) => {
    setAnswers(prev => ({ ...prev, [questionId]: answerIdx }))
  }

  const toggleFlag = (questionId) => {
    setFlagged(prev => ({ ...prev, [questionId]: !prev[questionId] }))
  }

  const handleSubmit = useCallback(() => {
    if (submittedRef.current) return
    submittedRef.current = true
    clearTimeout(timerRef.current)
    stopSpeaking()
    let totalCorrect = 0; let totalQuestions = 0
    const sectionResults = {}

    Object.entries(sections).forEach(([sectionName, questions]) => {
      let correct = 0; let manualCount = 0
      questions.forEach(q => {
        totalQuestions++
        let qData = {}, answer = {}
        try { qData = JSON.parse(q.questionJson || '{}') } catch (_) {}
        try { answer = JSON.parse(q.answerJson || '{}') } catch (_) {}

        const userAns = answers[q.id]
        const inputType = qData.input_type || 'multiple_choice'

        if (inputType === 'multiple_choice') {
          if (userAns === answer.correct) { correct++; totalCorrect++ }
        } else if (inputType === 'fill_blank') {
          const ua = (userAns || '').toString().trim().toLowerCase()
          const ref = (answer.correct || '').toString().toLowerCase()
          const alts = (answer.alternatives || []).map(a => a.toLowerCase())
          if (ua && (ua === ref || alts.includes(ua))) { correct++; totalCorrect++ }
        } else if (inputType === 'writing' || inputType === 'speaking') {

          const ua = (userAns || '').toString().trim()
          const minWords = qData.min_words || 20
          const wordCount = ua.split(/\s+/).filter(Boolean).length
          if (wordCount >= minWords) { correct++; totalCorrect++ }
          manualCount++
        }
      })
      sectionResults[sectionName] = {
        correct,
        total: questions.length,
        manualCount,
        percent: questions.length > 0 ? Math.round(correct / questions.length * 100) : 0
      }
    })

    const scorePercent = totalQuestions > 0 ? Math.round(totalCorrect / totalQuestions * 100) : 0
    const passed = scorePercent >= (test?.passScore || 60)
    setResults({
      totalCorrect, totalQuestions, scorePercent, sectionResults, passed
    })
    setSubmitted(true)
    setShowConfirmSubmit(false)

    if (test?.id) {
      const durationSec = Math.max(
        1,
        Math.round((Date.now() - startedAtRef.current) / 1000)
      )
      const payload = {
        scoreTotal: scorePercent,
        scoreBySection: sectionResults,
        passed,
        durationSec,
        answers,
      }
      mockTestAPI.submit(test.id, payload)
        .then(() => toast.success('✅ Kết quả bài thi đã được lưu'))
        .catch(err => {
          console.warn('Failed to save mock test attempt', err)
          toast.warn('⚠️ Không lưu được kết quả lên server (kết nối kém). Bạn vẫn xem được kết quả tạm.')
        })
    }
  }, [answers, sections, test, toast])

  useEffect(() => {
    if (showStartScreen || submitted) return
    if (timeLeft > 0) {
      timerRef.current = setTimeout(() => setTimeLeft(t => t - 1), 1000)
    } else if (timeLeft === 0 && test) {
      handleSubmit()
    }
    return () => clearTimeout(timerRef.current)
  }, [timeLeft, submitted, showStartScreen, test, handleSubmit])

  const speak = (text, audioUrl) => {
    if (!text && !audioUrl) return
    const lang = certToLang(test?.certification)

    ttsSpeak({ text, audioUrl, lang })
  }

  useEffect(() => () => stopSpeaking(), [])

  const totalAnswered = useMemo(() => Object.keys(answers).length, [answers])
  const totalQ = useMemo(() => Object.values(sections).reduce((s, q) => s + q.length, 0), [sections])

  if (!test) return <div className="flex justify-center py-20"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div></div>

  if (showStartScreen) {
    return (
      <div className="max-w-2xl mx-auto">
        <article className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-8 text-center`}>
          <div className="text-6xl mb-4">📝</div>
          <h1 className={`text-2xl font-bold mb-2 ${darkMode ? 'text-white' : ''}`}>{test.title}</h1>
          <p className="text-gray-400 mb-6">Đề thi thử {test.certification} {test.levelCode}</p>

          <div className="grid grid-cols-3 gap-3 mb-6">
            <div className={`p-4 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-blue-50'}`}>
              <p className="text-2xl font-bold text-blue-600">{test.totalDurationMin}</p>
              <p className="text-xs text-gray-500">phút làm bài</p>
            </div>
            <div className={`p-4 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-purple-50'}`}>
              <p className="text-2xl font-bold text-purple-600">{totalQ}</p>
              <p className="text-xs text-gray-500">câu hỏi</p>
            </div>
            <div className={`p-4 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-green-50'}`}>
              <p className="text-2xl font-bold text-green-600">{test.passScore}</p>
              <p className="text-xs text-gray-500">điểm để đậu</p>
            </div>
          </div>

          <div className={`p-4 rounded-xl mb-6 text-left text-sm ${darkMode ? 'bg-gray-700 text-gray-300' : 'bg-yellow-50 text-yellow-900'}`}>
            <h3 className="font-bold mb-2">📋 Hướng dẫn làm bài:</h3>
            <ul className="space-y-1 list-disc list-inside">
              <li>Đọc kỹ từng câu hỏi và chọn đáp án đúng nhất</li>
              <li>Có thể đánh dấu (cờ 🚩) câu hỏi để xem lại</li>
              <li>Có thể chuyển đổi giữa các phần (sections) tự do</li>
              <li>Khi hết giờ, bài thi sẽ tự động được nộp</li>
              <li>Sau khi nộp, bạn có thể xem giải thích chi tiết từng câu</li>
            </ul>
          </div>

          <div className="flex gap-3 justify-center">
            <button onClick={() => navigate('/mock-tests')}
              className={`px-6 py-3 rounded-xl font-semibold ${darkMode ? 'bg-gray-700 text-white' : 'bg-gray-200 text-gray-700'}`}>
              Quay lại
            </button>
            <button onClick={() => setShowStartScreen(false)}
              className="px-8 py-3 bg-gradient-to-r from-blue-500 to-purple-500 text-white rounded-xl font-bold shadow-lg hover:shadow-xl transition">
              🚀 Bắt đầu làm bài
            </button>
          </div>
        </article>
      </div>
    )
  }

  if (submitted && results && !reviewMode) {
    return (
      <div className="max-w-2xl mx-auto">
        <header className="text-center mb-8">
          <span className="text-7xl">{results.passed ? '🎉' : '😢'}</span>
          <h1 className={`text-3xl font-bold mt-4 ${darkMode ? 'text-white' : ''}`}>{results.passed ? 'Chúc mừng! Bạn đã đậu!' : 'Chưa đạt yêu cầu'}</h1>
          <p className={`text-6xl font-bold mt-4 ${results.passed ? 'text-green-500' : 'text-red-500'}`}>{results.scorePercent}%</p>
          <p className="text-gray-400 mt-2">{results.totalCorrect}/{results.totalQuestions} câu đúng</p>
        </header>

        <section className="space-y-3 mb-8">
          {Object.entries(results.sectionResults).map(([section, r]) => (
            <article key={section} className={`${darkMode ? 'bg-gray-800' : 'bg-white'} p-4 rounded-xl border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
              <div className="flex items-center justify-between mb-2">
                <span className={`font-semibold ${darkMode ? 'text-white' : ''}`}>{SECTION_LABELS[section] || section}</span>
                <span className={`font-bold ${r.percent >= 60 ? 'text-green-500' : 'text-red-500'}`}>{r.correct}/{r.total} ({r.percent}%)</span>
              </div>
              <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                <div className={`h-2 rounded-full ${r.percent >= 80 ? 'bg-green-500' : r.percent >= 60 ? 'bg-yellow-500' : 'bg-red-500'}`} style={{ width: `${r.percent}%` }}></div>
              </div>
            </article>
          ))}
        </section>

        <div className="flex flex-wrap gap-3 justify-center">
          <button onClick={() => navigate('/mock-tests')}
            className={`px-6 py-3 rounded-xl font-semibold ${darkMode ? 'bg-gray-700 text-white' : 'bg-gray-200 text-gray-700'}`}>
            Quay lại danh sách
          </button>
          <button onClick={() => setReviewMode(true)}
            className="px-6 py-3 bg-blue-500 text-white rounded-xl font-semibold flex items-center gap-2">
            <BookOpen size={18} /> Xem giải thích chi tiết
          </button>
          <button onClick={() => {
            setSubmitted(false); setReviewMode(false); setAnswers({}); setFlagged({});
            setTimeLeft(test.totalDurationMin * 60); setShowStartScreen(true);
          }}
            className="px-6 py-3 bg-green-500 text-white rounded-xl font-semibold">
            🔄 Làm lại
          </button>
        </div>
      </div>
    )
  }

  if (reviewMode && results) {
    return (
      <div className="max-w-3xl mx-auto">
        <header className={`flex items-center justify-between mb-6 sticky top-0 z-10 py-3 ${darkMode ? 'bg-gray-900' : 'bg-gray-50'}`}>
          <button onClick={() => setReviewMode(false)}
            className={`flex items-center gap-2 px-4 py-2 rounded-xl ${darkMode ? 'bg-gray-700 text-white' : 'bg-white border'}`}>
            <ChevronLeft size={18} /> Về trang kết quả
          </button>
          <p className={`font-bold ${darkMode ? 'text-white' : ''}`}>📊 Đánh giá chi tiết: {results.scorePercent}%</p>
        </header>

        <section className="space-y-4">
          {Object.entries(sections).map(([sectionName, questions]) => (
            <div key={sectionName}>
              <h2 className={`text-lg font-bold mb-3 mt-4 ${darkMode ? 'text-white' : ''}`}>
                📑 {SECTION_LABELS[sectionName] || sectionName} - {results.sectionResults[sectionName].correct}/{results.sectionResults[sectionName].total}
              </h2>
              {questions.map((q, idx) => {
                const qData = JSON.parse(q.questionJson || '{}')
                const aData = JSON.parse(q.answerJson || '{}')
                const userAns = answers[q.id]
                const isCorrect = userAns === aData.correct
                const wasAnswered = userAns !== undefined

                return (
                  <article key={q.id} className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-5 mb-3 ${isCorrect ? 'border-l-4 border-l-green-500' : wasAnswered ? 'border-l-4 border-l-red-500' : 'border-l-4 border-l-gray-400'}`}>
                    <div className="flex items-start gap-3 mb-3">
                      <span className={`px-2 py-1 text-xs font-bold rounded ${isCorrect ? 'bg-green-100 text-green-700' : wasAnswered ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-700'}`}>
                        Câu {idx + 1} {isCorrect ? '✓' : wasAnswered ? '✗' : '—'}
                      </span>
                    </div>

                    {qData.passage && <div className={`p-3 rounded-xl mb-3 ${darkMode ? 'bg-gray-700' : 'bg-gray-50'} text-sm leading-relaxed`}>{qData.passage}</div>}
                    {qData.audio_text && <div className={`p-3 rounded-xl mb-3 ${darkMode ? 'bg-gray-700' : 'bg-blue-50'} text-sm italic flex items-start gap-2`}>
                      <Volume2 size={16} className="mt-1 flex-shrink-0 text-blue-500" />
                      <div className="flex-1"><p>{qData.audio_text}</p>
                        <button onClick={() => speak(qData.audio_text)} className="text-xs text-blue-500 mt-1 hover:underline">▶ Nghe lại</button></div>
                    </div>}

                    <p className={`font-semibold mb-3 ${darkMode ? 'text-white' : ''}`}>{qData.question}</p>

                    <div className="space-y-2 mb-3">
                      {qData.options?.map((opt, i) => {
                        const isUserChoice = userAns === i
                        const isCorrectChoice = aData.correct === i
                        return (
                          <div key={i}
                            className={`p-3 rounded-xl border-2 text-sm ${
                              isCorrectChoice ? 'border-green-500 bg-green-50 dark:bg-green-900/20 text-green-700 dark:text-green-300' :
                              isUserChoice ? 'border-red-500 bg-red-50 dark:bg-red-900/20 text-red-700 dark:text-red-300' :
                              darkMode ? 'border-gray-600 text-gray-300' : 'border-gray-200 text-gray-700'
                            }`}>
                            {String.fromCharCode(65 + i)}. {opt}
                            {isCorrectChoice && <span className="ml-2 font-bold">✓ Đáp án đúng</span>}
                            {isUserChoice && !isCorrectChoice && <span className="ml-2 font-bold">← Bạn chọn</span>}
                          </div>
                        )
                      })}
                    </div>

                    {aData.explanation && (
                      <aside className={`p-3 rounded-xl text-sm flex items-start gap-2 ${darkMode ? 'bg-yellow-900/20 text-yellow-200' : 'bg-yellow-50 text-yellow-900'}`}>
                        <Lightbulb size={16} className="mt-0.5 flex-shrink-0" />
                        <div><strong>Giải thích:</strong> {aData.explanation}</div>
                      </aside>
                    )}
                  </article>
                )
              })}
            </div>
          ))}
        </section>
      </div>
    )
  }

  const sectionKeys = Object.keys(sections)
  const currentQuestions = sections[currentSection] || []
  const currentQ = currentQuestions[currentQIdx]
  const questionData = currentQ ? JSON.parse(currentQ.questionJson || '{}') : {}

  return (
    <div className="max-w-3xl mx-auto" ref={questionRef}>

      <header className="mb-6 space-y-3">
        <div className="flex items-center justify-between flex-wrap gap-3">
          <div className={`flex items-center gap-2 px-4 py-2 rounded-full ${timeLeft < 300 ? 'bg-red-100 text-red-600 animate-pulse' : 'bg-blue-100 text-blue-600'}`}>
            <Clock size={18} /><span className="font-mono font-bold text-lg">{formatTime(timeLeft)}</span>
          </div>
          <div className={`text-sm ${darkMode ? 'text-gray-300' : 'text-gray-600'}`}>
            Đã trả lời: <strong className="text-blue-600">{totalAnswered}</strong>/{totalQ}
          </div>
          <button onClick={() => setShowConfirmSubmit(true)}
            className="px-4 py-2 bg-green-500 text-white rounded-xl text-sm font-bold hover:bg-green-600 transition">
            <Check size={16} className="inline" /> Nộp bài
          </button>
        </div>

        <nav className="flex flex-wrap gap-2">
          {sectionKeys.map(s => {
            const sQuestions = sections[s] || []
            const answered = sQuestions.filter(q => answers[q.id] !== undefined).length
            return (
              <button key={s} onClick={() => { setCurrentSection(s); setCurrentQIdx(0) }}
                className={`px-3 py-1.5 rounded-lg text-xs font-medium flex items-center gap-2 ${currentSection === s ? 'bg-blue-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-200 text-gray-700'}`}>
                {SECTION_LABELS[s] || s}
                <span className="px-1.5 py-0.5 bg-white/20 rounded text-[10px]">{answered}/{sQuestions.length}</span>
              </button>
            )
          })}
        </nav>
      </header>

      {currentQ && (
        <article className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-6 border ${darkMode ? 'border-gray-700' : 'border-gray-200'} mb-6`}>
          <div className="flex items-center justify-between mb-3">
            <p className="text-sm text-gray-400">
              Câu {currentQIdx + 1}/{currentQuestions.length} | <strong>{SECTION_LABELS[currentSection] || currentSection}</strong>
            </p>
            <button onClick={() => toggleFlag(currentQ.id)}
              className={`p-2 rounded-lg ${flagged[currentQ.id] ? 'bg-yellow-100 text-yellow-600' : darkMode ? 'bg-gray-700 text-gray-400' : 'bg-gray-100 text-gray-500'}`}
              title="Đánh dấu để xem lại">
              <Flag size={16} />
            </button>
          </div>

          {questionData.passage && (
            <div className={`p-4 rounded-xl mb-4 ${darkMode ? 'bg-gray-700' : 'bg-gray-50'} text-sm leading-relaxed border-l-4 border-blue-500`}>
              <p className="text-xs text-gray-400 mb-1">📖 Đoạn văn</p>
              {questionData.passage}
            </div>
          )}
          {questionData.audio_text && (
            <div className={`p-4 rounded-xl mb-4 ${darkMode ? 'bg-gray-700' : 'bg-blue-50'} text-sm`}>
              <div className="flex items-start gap-2">
                <Headphones size={18} className="mt-0.5 flex-shrink-0 text-blue-500" />
                <div className="flex-1">
                  <p className="text-xs text-blue-600 dark:text-blue-400 font-bold mb-1">🎧 Đoạn audio (nghe và trả lời)</p>
                  <button onClick={() => speak(questionData.audio_text, questionData.audio_url)}
                    className="px-3 py-1.5 bg-blue-500 hover:bg-blue-600 text-white rounded-lg text-xs font-bold inline-flex items-center gap-1">
                    <Volume2 size={14} /> ▶ Phát audio
                  </button>
                  {currentSection !== 'LISTENING' && (
                    <p className={`mt-2 italic ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>"{questionData.audio_text}"</p>
                  )}
                </div>
              </div>
            </div>
          )}

          {questionData.image_url && (
            <div className="mb-4">
              <img src={questionData.image_url} alt="" className="rounded-xl max-w-full mx-auto" />
            </div>
          )}

          <h3 className={`text-lg font-semibold mb-4 ${darkMode ? 'text-white' : ''}`}>{questionData.question}</h3>

          {(!questionData.input_type || questionData.input_type === 'multiple_choice') && (
            <div className="space-y-2">
              {questionData.options?.map((opt, i) => (
                <button key={i} onClick={() => handleAnswer(currentQ.id, i)}
                  className={`w-full text-left p-3 rounded-xl border-2 transition ${
                    answers[currentQ.id] === i ? 'border-blue-500 bg-blue-50 text-blue-700 dark:bg-blue-900/30 dark:text-blue-300 dark:border-blue-400' :
                    darkMode ? 'border-gray-600 hover:border-gray-500 text-gray-200' : 'border-gray-200 hover:border-gray-300'
                  }`}>
                  <span className="font-bold mr-2">{String.fromCharCode(65 + i)}.</span> {opt}
                </button>
              ))}
            </div>
          )}

          {questionData.input_type === 'writing' && (
            <div>
              <p className={`text-xs mb-2 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
                ✏️ Viết câu trả lời (gợi ý: {questionData.min_words || 30}-{questionData.max_words || 200} từ)
              </p>
              <textarea
                value={typeof answers[currentQ.id] === 'string' ? answers[currentQ.id] : ''}
                onChange={e => setAnswers(prev => ({ ...prev, [currentQ.id]: e.target.value }))}
                rows={6}
                placeholder="Nhập câu trả lời của bạn..."
                className={`w-full p-3 rounded-xl border-2 ${darkMode ? 'bg-gray-700 border-gray-600 text-white' : 'border-gray-200'} focus:outline-none focus:ring-2 focus:ring-blue-500`} />
              <p className={`text-xs mt-1 text-right ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
                {(typeof answers[currentQ.id] === 'string' ? answers[currentQ.id] : '').trim().split(/\s+/).filter(Boolean).length} từ
              </p>
            </div>
          )}

          {questionData.input_type === 'speaking' && (
            <SpeakingRecorder
              questionId={currentQ.id}
              prompt={questionData.question}
              answers={answers}
              setAnswers={setAnswers}
              darkMode={darkMode} />
          )}

          {questionData.input_type === 'fill_blank' && (
            <input
              value={typeof answers[currentQ.id] === 'string' ? answers[currentQ.id] : ''}
              onChange={e => setAnswers(prev => ({ ...prev, [currentQ.id]: e.target.value }))}
              placeholder="Nhập đáp án..."
              className={`w-full p-3 rounded-xl border-2 ${darkMode ? 'bg-gray-700 border-gray-600 text-white' : 'border-gray-200'} focus:outline-none focus:ring-2 focus:ring-blue-500`} />
          )}
        </article>
      )}

      <nav className="flex items-center justify-between mb-6">
        <button disabled={currentQIdx === 0}
          onClick={() => setCurrentQIdx(currentQIdx - 1)}
          className={`px-4 py-2 rounded-xl flex items-center gap-1 disabled:opacity-30 ${darkMode ? 'bg-gray-700 text-white' : 'bg-gray-200'}`}>
          <ChevronLeft size={18} /> Trước
        </button>

        {currentQIdx < currentQuestions.length - 1 ? (
          <button onClick={() => setCurrentQIdx(currentQIdx + 1)}
            className="px-6 py-2 bg-blue-500 text-white rounded-xl flex items-center gap-1 font-medium">
            Tiếp <ChevronRight size={18} />
          </button>
        ) : sectionKeys.indexOf(currentSection) < sectionKeys.length - 1 ? (
          <button onClick={() => { setCurrentSection(sectionKeys[sectionKeys.indexOf(currentSection) + 1]); setCurrentQIdx(0) }}
            className="px-6 py-2 bg-purple-500 text-white rounded-xl font-medium">
            Section tiếp theo →
          </button>
        ) : (
          <button onClick={() => setShowConfirmSubmit(true)}
            className="px-6 py-2 bg-green-500 text-white rounded-xl font-bold flex items-center gap-1">
            <Check size={18} /> Hoàn thành & Nộp bài
          </button>
        )}
      </nav>

      <aside className={`p-4 rounded-xl ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border`}>
        <p className="text-xs text-gray-400 mb-2">📊 Bản đồ câu hỏi - {SECTION_LABELS[currentSection] || currentSection}</p>
        <div className="flex flex-wrap gap-1.5">
          {currentQuestions.map((q, i) => {
            const isCurrent = i === currentQIdx
            const isAnswered = answers[q.id] !== undefined
            const isFlagged = flagged[q.id]
            return (
              <button key={q.id} onClick={() => setCurrentQIdx(i)}
                className={`w-9 h-9 rounded-lg text-xs font-bold flex items-center justify-center relative ${
                  isCurrent ? 'bg-blue-500 text-white ring-2 ring-blue-300' :
                  isAnswered ? 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400' :
                  darkMode ? 'bg-gray-700 text-gray-400' : 'bg-gray-100 text-gray-600'
                }`}>
                {i + 1}
                {isFlagged && <Flag size={10} className="absolute -top-1 -right-1 text-yellow-500 fill-yellow-500" />}
              </button>
            )
          })}
        </div>
      </aside>

      {showConfirmSubmit && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
          <article className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-6 max-w-md w-full`}>
            <header className="flex items-center gap-3 mb-4">
              <AlertCircle size={32} className="text-yellow-500" />
              <h2 className={`text-xl font-bold ${darkMode ? 'text-white' : ''}`}>Nộp bài?</h2>
            </header>
            <p className={`mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-600'}`}>
              Bạn đã trả lời <strong className="text-blue-600">{totalAnswered}/{totalQ}</strong> câu hỏi.
            </p>
            {totalAnswered < totalQ && (
              <p className="mb-4 text-sm text-yellow-600">⚠️ Còn {totalQ - totalAnswered} câu chưa trả lời. Các câu này sẽ bị tính sai.</p>
            )}
            <div className="flex gap-3 mt-4">
              <button onClick={() => setShowConfirmSubmit(false)}
                className={`flex-1 py-2.5 rounded-xl font-semibold ${darkMode ? 'bg-gray-700 text-white' : 'bg-gray-200'}`}>
                Tiếp tục làm
              </button>
              <button onClick={handleSubmit} className="flex-1 py-2.5 bg-green-500 text-white rounded-xl font-bold">
                Nộp bài
              </button>
            </div>
          </article>
        </div>
      )}
    </div>
  )
}

function SpeakingRecorder({ questionId, prompt, answers, setAnswers, darkMode }) {
  const [recording, setRecording] = useState(false)
  const [audioUrl, setAudioUrl] = useState(null)
  const [error, setError] = useState(null)
  const [transcript, setTranscript] = useState(answers[questionId] || '')
  const mediaRecorderRef = useRef(null)
  const chunksRef = useRef([])

  const startRecording = async () => {
    setError(null)
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
      const mr = new MediaRecorder(stream)
      mediaRecorderRef.current = mr
      chunksRef.current = []
      mr.ondataavailable = (e) => { if (e.data.size > 0) chunksRef.current.push(e.data) }
      mr.onstop = () => {
        const blob = new Blob(chunksRef.current, { type: 'audio/webm' })
        const url = URL.createObjectURL(blob)
        setAudioUrl(url)
        stream.getTracks().forEach(t => t.stop())
      }
      mr.start()
      setRecording(true)
    } catch (e) {
      setError('Không thể truy cập microphone. Vui lòng cho phép quyền và thử lại.')
    }
  }

  const stopRecording = () => {
    try { mediaRecorderRef.current?.stop() } catch (_) {}
    setRecording(false)
  }

  const saveTranscript = (val) => {
    setTranscript(val)
    setAnswers(prev => ({ ...prev, [questionId]: val }))
  }

  return (
    <div className="space-y-3">
      <div className={`p-3 rounded-xl text-sm ${darkMode ? 'bg-purple-900/20 text-purple-200' : 'bg-purple-50 text-purple-900'}`}>
        🎤 <strong>Phần thi nói:</strong> Bạn có 1-2 phút để chuẩn bị, sau đó ghi âm câu trả lời (30-60 giây).
        Ngoài ra hãy gõ bản ghi (transcript) để hệ thống chấm sơ bộ.
      </div>

      <div className="flex items-center gap-3 flex-wrap">
        {!recording ? (
          <button onClick={startRecording}
            className="px-5 py-2.5 bg-red-500 hover:bg-red-600 text-white rounded-xl font-bold flex items-center gap-2">
            <Mic size={18} /> Bắt đầu ghi âm
          </button>
        ) : (
          <button onClick={stopRecording}
            className="px-5 py-2.5 bg-gray-700 hover:bg-gray-800 text-white rounded-xl font-bold flex items-center gap-2 animate-pulse">
            <MicOff size={18} /> Dừng ghi âm
          </button>
        )}
        {audioUrl && (
          <audio src={audioUrl} controls className="h-9" />
        )}
      </div>

      {error && <p className="text-sm text-red-500">{error}</p>}

      <div>
        <label className={`text-xs font-semibold ${darkMode ? 'text-gray-300' : 'text-gray-600'}`}>
          📝 Bản ghi (transcript) — gõ lại nội dung bạn vừa nói:
        </label>
        <textarea
          value={transcript}
          onChange={e => saveTranscript(e.target.value)}
          rows={4}
          placeholder="Gõ lại nội dung bạn đã nói..."
          className={`w-full mt-1 p-3 rounded-xl border-2 ${darkMode ? 'bg-gray-700 border-gray-600 text-white' : 'border-gray-200'} focus:outline-none focus:ring-2 focus:ring-purple-500`} />
        <p className={`text-xs mt-1 text-right ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
          {transcript.trim().split(/\s+/).filter(Boolean).length} từ
        </p>
      </div>
    </div>
  )
}
