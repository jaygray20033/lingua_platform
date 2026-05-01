import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { vocabAPI } from '../api'
import { useAppStore } from '../store'
import { speak, certToLang } from '../utils/tts'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { ArrowLeft, Volume2, BookOpen, Lightbulb, AlertCircle, Link2, Target, Check, X, RotateCcw } from 'lucide-react'

export default function GrammarDetail() {

  useDocumentTitle('Chi tiết ngữ pháp')
  const { id } = useParams()
  const navigate = useNavigate()
  const [grammar, setGrammar] = useState(null)
  const [loading, setLoading] = useState(true)
  const [tab, setTab] = useState('overview')
  const { darkMode } = useAppStore()

  const [exIdx, setExIdx] = useState(0)
  const [selected, setSelected] = useState(null)
  const [userInput, setUserInput] = useState('')
  const [feedback, setFeedback] = useState(null)
  const [score, setScore] = useState({ correct: 0, wrong: 0 })

  useEffect(() => {
    setLoading(true)
    vocabAPI.getGrammarDetail(id)
      .then(r => setGrammar(r.data.data))
      .finally(() => setLoading(false))
  }, [id])

  if (loading) return <div className="flex justify-center py-20"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div></div>
  if (!grammar) return <div className={`text-center py-20 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>Không tìm thấy ngữ pháp</div>

  const cert = grammar.jlptLevel ? 'JLPT' : grammar.hskLevel ? 'HSK' : 'CEFR'
  const ttsLang = certToLang(cert)
  const examples = grammar.examples || []
  const exercises = grammar.exercises || []
  const currentEx = exercises[exIdx]

  const checkAnswer = () => {
    if (!currentEx) return
    let q, a
    try { q = typeof currentEx.questionJson === 'string' ? JSON.parse(currentEx.questionJson) : (currentEx.questionJson || {}) } catch { q = {} }
    try { a = typeof currentEx.answerJson === 'string' ? JSON.parse(currentEx.answerJson) : (currentEx.answerJson || {}) } catch { a = {} }

    let correct = false
    if (currentEx.type === 'MULTIPLE_CHOICE') {
      correct = selected === a.correct
    } else {
      const ans = (userInput || '').trim().toLowerCase()
      const ref = (a.correct || '').toString().toLowerCase()
      correct = ans === ref || (a.alternatives || []).some(x => x.toLowerCase() === ans)
    }
    setFeedback(correct ? 'correct' : 'wrong')
    setScore(s => ({ correct: s.correct + (correct ? 1 : 0), wrong: s.wrong + (correct ? 0 : 1) }))
  }

  const nextExercise = () => {
    setFeedback(null); setSelected(null); setUserInput('')
    setExIdx(i => (i + 1 < exercises.length ? i + 1 : i))
  }

  const restartPractice = () => {
    setExIdx(0); setSelected(null); setUserInput(''); setFeedback(null); setScore({ correct: 0, wrong: 0 })
  }

  return (
    <div className="max-w-4xl mx-auto">

      <button onClick={() => navigate(-1)}
        className={`flex items-center gap-2 mb-4 px-3 py-1.5 rounded-lg text-sm ${darkMode ? 'text-gray-300 hover:bg-gray-800' : 'text-gray-600 hover:bg-gray-100'}`}>
        <ArrowLeft size={16} /> Quay lại
      </button>

      <div className={`rounded-2xl p-6 mb-6 ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-gradient-to-r from-blue-50 to-purple-50 border-gray-200'} border`}>
        <div className="flex items-start gap-4">
          <div className="flex-1">
            <div className="flex items-center gap-3 flex-wrap">
              <h1 className={`text-3xl font-bold ${darkMode ? 'text-white' : 'text-gray-900'}`}>{grammar.pattern}</h1>
              <button onClick={() => speak({ text: grammar.pattern, lang: ttsLang, audioUrl: grammar.audioUrl })}
                className="p-2 rounded-full bg-blue-500 hover:bg-blue-600 text-white shadow">
                <Volume2 size={18} />
              </button>
              <span className="text-xs px-3 py-1 rounded-full bg-blue-500 text-white font-bold">
                {grammar.jlptLevel || grammar.cefrLevel || grammar.hskLevel}
              </span>
              {grammar.difficultyScore && (
                <span className="text-xs px-3 py-1 rounded-full bg-yellow-500 text-white font-bold">
                  Mức {grammar.difficultyScore}/5
                </span>
              )}
            </div>
            <p className={`text-lg mt-3 ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{grammar.meaningVi}</p>
            {grammar.meaningEn && <p className={`text-sm italic mt-1 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>{grammar.meaningEn}</p>}
            {grammar.structure && (
              <div className={`mt-3 inline-block px-4 py-2 rounded-lg ${darkMode ? 'bg-gray-700 text-blue-300' : 'bg-white text-blue-700'} font-mono text-sm`}>
                📐 {grammar.structure}
              </div>
            )}
          </div>
        </div>
      </div>

      <nav className="flex gap-2 mb-6 border-b border-gray-200 dark:border-gray-700">
        {[
          { key: 'overview', label: '📚 Giải thích', icon: BookOpen },
          { key: 'examples', label: `✏️ Ví dụ (${examples.length})`, icon: Lightbulb },
          { key: 'practice', label: `🎯 Luyện tập (${exercises.length})`, icon: Target },
        ].map(t => (
          <button key={t.key} onClick={() => setTab(t.key)}
            className={`px-4 py-2 text-sm font-semibold transition border-b-2 -mb-px ${
              tab === t.key
                ? 'border-blue-500 text-blue-500'
                : `border-transparent ${darkMode ? 'text-gray-400 hover:text-gray-200' : 'text-gray-500 hover:text-gray-800'}`
            }`}>
            {t.label}
          </button>
        ))}
      </nav>

      {tab === 'overview' && (
        <div className="space-y-4">
          {grammar.explanationVi && (
            <Section title="📖 Giải thích chi tiết" darkMode={darkMode} color="blue">
              <p className={`whitespace-pre-line leading-relaxed ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{grammar.explanationVi}</p>
              {grammar.explanationEn && (
                <p className={`mt-3 text-sm italic whitespace-pre-line ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>{grammar.explanationEn}</p>
              )}
            </Section>
          )}

          {grammar.formation && (
            <Section title="🔧 Cách thành lập" darkMode={darkMode} color="green">
              <p className={`whitespace-pre-line ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{grammar.formation}</p>
            </Section>
          )}

          {grammar.usageContext && (
            <Section title="💼 Ngữ cảnh sử dụng" darkMode={darkMode} color="purple">
              <p className={`whitespace-pre-line ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{grammar.usageContext}</p>
            </Section>
          )}

          {grammar.exampleSentence && (
            <Section title="✏️ Ví dụ minh họa" darkMode={darkMode} color="indigo">
              <div className="flex items-center gap-2 mb-1">
                <p className={`font-medium text-lg ${darkMode ? 'text-indigo-300' : 'text-indigo-700'}`}>{grammar.exampleSentence}</p>
                <button onClick={() => speak({ text: grammar.exampleSentence, lang: ttsLang })}
                  className="p-1 hover:bg-indigo-100 dark:hover:bg-indigo-900/30 rounded-full">
                  <Volume2 size={16} className="text-indigo-500" />
                </button>
              </div>
              {grammar.exampleTranslation && (
                <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>→ {grammar.exampleTranslation}</p>
              )}
            </Section>
          )}

          {grammar.commonMistakes && (
            <Section title="⚠️ Lỗi thường gặp" darkMode={darkMode} color="red" icon={AlertCircle}>
              <p className={`whitespace-pre-line ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{grammar.commonMistakes}</p>
            </Section>
          )}

          {grammar.relatedPatterns && (
            <Section title="🔗 Mẫu ngữ pháp liên quan" darkMode={darkMode} color="cyan" icon={Link2}>
              <p className={`whitespace-pre-line ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{grammar.relatedPatterns}</p>
            </Section>
          )}

          {grammar.note && (
            <Section title="💡 Ghi chú" darkMode={darkMode} color="yellow" icon={Lightbulb}>
              <p className={`whitespace-pre-line ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{grammar.note}</p>
            </Section>
          )}
        </div>
      )}

      {tab === 'examples' && (
        <div className="space-y-3">
          {examples.length === 0 ? (
            <p className={`text-center py-12 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>Chưa có ví dụ chi tiết</p>
          ) : examples.map((ex, i) => (
            <div key={ex.id} className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-xl p-5 border`}>
              <div className="flex items-start gap-3">
                <span className="w-8 h-8 rounded-lg bg-gradient-to-br from-green-400 to-blue-500 flex items-center justify-center text-white text-sm font-bold flex-shrink-0">
                  {i + 1}
                </span>
                <div className="flex-1">
                  <div className="flex items-center gap-2 flex-wrap">
                    <p className={`font-bold text-lg ${darkMode ? 'text-white' : ''}`}>{ex.sentence}</p>
                    <button onClick={() => speak({ text: ex.sentence, lang: ttsLang, audioUrl: ex.audioUrl })}
                      className="p-1.5 rounded-full bg-blue-500 hover:bg-blue-600 text-white">
                      <Volume2 size={14} />
                    </button>
                  </div>
                  {ex.reading && <p className={`text-sm mt-1 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>📝 {ex.reading}</p>}
                  {ex.romaji && <p className={`text-sm italic ${darkMode ? 'text-gray-500' : 'text-gray-400'}`}>{ex.romaji}</p>}
                  {ex.translationVi && <p className={`mt-2 ${darkMode ? 'text-blue-300' : 'text-blue-700'}`}>🇻🇳 {ex.translationVi}</p>}
                  {ex.translationEn && <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>🇬🇧 {ex.translationEn}</p>}
                  {ex.note && (
                    <div className={`mt-2 p-2 rounded-lg text-sm ${darkMode ? 'bg-yellow-900/20 text-yellow-200' : 'bg-yellow-50 text-yellow-800'}`}>
                      💡 {ex.note}
                    </div>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {tab === 'practice' && (
        exercises.length === 0 ? (
          <p className={`text-center py-12 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>Chưa có bài tập</p>
        ) : (
          <div className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-2xl border p-6`}>

            <div className="flex items-center justify-between mb-4">
              <span className={`text-sm font-semibold ${darkMode ? 'text-gray-300' : 'text-gray-600'}`}>
                Câu {exIdx + 1}/{exercises.length}
              </span>
              <div className="flex items-center gap-2">
                <span className="text-green-500 font-bold">✓ {score.correct}</span>
                <span className="text-red-500 font-bold">✗ {score.wrong}</span>
                <button onClick={restartPractice} className="p-1 rounded hover:bg-gray-100 dark:hover:bg-gray-700">
                  <RotateCcw size={14} className="text-gray-400" />
                </button>
              </div>
            </div>
            <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2 mb-6">
              <div className="bg-blue-500 h-2 rounded-full transition" style={{ width: `${((exIdx + 1) / exercises.length) * 100}%` }}></div>
            </div>

            {currentEx && (() => {
              let q
              try { q = typeof currentEx.questionJson === 'string' ? JSON.parse(currentEx.questionJson) : (currentEx.questionJson || {}) } catch { q = {} }
              let a
              try { a = typeof currentEx.answerJson === 'string' ? JSON.parse(currentEx.answerJson) : (currentEx.answerJson || {}) } catch { a = {} }
              return (
                <div>
                  <h3 className={`text-lg font-bold mb-4 ${darkMode ? 'text-white' : ''}`}>{q.question}</h3>

                  {currentEx.type === 'MULTIPLE_CHOICE' && (
                    <div className="space-y-2">
                      {(q.options || []).map((opt, i) => (
                        <button key={i} disabled={!!feedback}
                          onClick={() => setSelected(i)}
                          className={`w-full text-left p-3 rounded-xl border-2 transition font-medium ${
                            feedback
                              ? i === a.correct ? 'border-green-500 bg-green-50 text-green-700' :
                                i === selected ? 'border-red-500 bg-red-50 text-red-700' :
                                darkMode ? 'border-gray-600 text-gray-400' : 'border-gray-200 text-gray-400'
                              : selected === i
                                ? 'border-blue-500 bg-blue-50 text-blue-700'
                                : darkMode ? 'border-gray-600 hover:border-gray-500 text-gray-200' : 'border-gray-200 hover:border-gray-400'
                          }`}>
                          <span className="font-bold mr-2">{String.fromCharCode(65 + i)}.</span> {opt}
                        </button>
                      ))}
                    </div>
                  )}

                  {(currentEx.type === 'FILL_BLANK' || currentEx.type === 'TRANSLATE') && (
                    <input value={userInput} onChange={e => setUserInput(e.target.value)} disabled={!!feedback}
                      placeholder="Nhập đáp án..."
                      className={`w-full px-4 py-3 rounded-xl border-2 ${darkMode ? 'bg-gray-700 border-gray-600 text-white' : 'border-gray-200'} focus:outline-none focus:ring-2 focus:ring-blue-500`} />
                  )}

                  {feedback && (
                    <div className={`mt-4 p-4 rounded-xl ${feedback === 'correct' ? 'bg-green-50 border border-green-200 text-green-800' : 'bg-red-50 border border-red-200 text-red-800'}`}>
                      <div className="flex items-center gap-2 mb-1">
                        {feedback === 'correct' ? <Check size={18} /> : <X size={18} />}
                        <strong>{feedback === 'correct' ? 'Chính xác!' : `Đáp án đúng: ${a.correct}`}</strong>
                      </div>
                      {currentEx.explanation && <p className="text-sm mt-2">💡 {currentEx.explanation}</p>}
                    </div>
                  )}

                  <div className="flex gap-3 mt-6">
                    {!feedback ? (
                      <button onClick={checkAnswer}
                        disabled={selected === null && !userInput}
                        className="flex-1 py-3 bg-blue-500 text-white rounded-xl font-bold disabled:opacity-50">
                        Kiểm tra
                      </button>
                    ) : (
                      <button onClick={nextExercise}
                        disabled={exIdx + 1 >= exercises.length}
                        className="flex-1 py-3 bg-green-500 text-white rounded-xl font-bold disabled:opacity-50">
                        {exIdx + 1 >= exercises.length ? 'Hoàn thành 🎉' : 'Câu tiếp →'}
                      </button>
                    )}
                  </div>
                </div>
              )
            })()}
          </div>
        )
      )}
    </div>
  )
}

function Section({ title, darkMode, color = 'blue', icon: Icon, children }) {
  const colors = {
    blue: darkMode ? 'bg-blue-900/20 border-blue-800' : 'bg-blue-50 border-blue-200',
    green: darkMode ? 'bg-green-900/20 border-green-800' : 'bg-green-50 border-green-200',
    purple: darkMode ? 'bg-purple-900/20 border-purple-800' : 'bg-purple-50 border-purple-200',
    indigo: darkMode ? 'bg-indigo-900/20 border-indigo-800' : 'bg-indigo-50 border-indigo-200',
    red: darkMode ? 'bg-red-900/20 border-red-800' : 'bg-red-50 border-red-200',
    yellow: darkMode ? 'bg-yellow-900/20 border-yellow-800' : 'bg-yellow-50 border-yellow-200',
    cyan: darkMode ? 'bg-cyan-900/20 border-cyan-800' : 'bg-cyan-50 border-cyan-200',
  }
  return (
    <section className={`rounded-xl p-4 border ${colors[color]}`}>
      <h3 className={`font-bold mb-2 flex items-center gap-2 ${darkMode ? 'text-white' : 'text-gray-900'}`}>
        {Icon && <Icon size={16} />} {title}
      </h3>
      {children}
    </section>
  )
}
