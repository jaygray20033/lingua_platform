import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { lessonAPI } from '../api'
import { useGamificationStore, useAppStore } from '../store'
import { X, Heart, Volume2, Check, ArrowRight, RefreshCcw } from 'lucide-react'

export default function LessonPractice() {
  const { id } = useParams()
  const navigate = useNavigate()
  const [lesson, setLesson] = useState(null)
  const [exercises, setExercises] = useState([])
  const [currentIdx, setCurrentIdx] = useState(0)
  const [selectedAnswer, setSelectedAnswer] = useState(null)
  const [userInput, setUserInput] = useState('')
  const [matchedPairs, setMatchedPairs] = useState([])
  const [matchLeft, setMatchLeft] = useState(null)
  const [feedback, setFeedback] = useState(null) // 'correct' | 'wrong' | null
  const [score, setScore] = useState({ correct: 0, wrong: 0, xp: 0 })
  const [completed, setCompleted] = useState(false)
  const { hearts, loseHeart, addXp, darkMode: dm } = { ...useGamificationStore(), ...useAppStore() }
  const darkMode = useAppStore(s => s.darkMode)

  useEffect(() => {
    lessonAPI.get(id).then(r => {
      setLesson(r.data.data)
      setExercises(r.data.data.exercises || [])
    })
  }, [id])

  const currentExercise = exercises[currentIdx]

  const speak = (text, lang = 'ja-JP') => {
    const u = new SpeechSynthesisUtterance(text)
    u.lang = lang; u.rate = 0.8
    speechSynthesis.speak(u)
  }

  const checkAnswer = () => {
    if (!currentExercise) return
    const prompt = JSON.parse(currentExercise.promptJson || '{}')
    const answer = JSON.parse(currentExercise.answerJson || '{}')
    let isCorrect = false

    switch (currentExercise.type) {
      case 'MULTIPLE_CHOICE':
        isCorrect = selectedAnswer === answer.correct
        break
      case 'FILL_BLANK':
      case 'TRANSLATE_TO_TARGET':
      case 'TRANSLATE_TO_SOURCE':
        const userAns = userInput.trim().toLowerCase()
        const correctAns = (answer.correct || '').toLowerCase()
        const alts = (answer.alternatives || []).map(a => a.toLowerCase())
        isCorrect = userAns === correctAns || alts.includes(userAns)
        break
      case 'MATCH_PAIRS':
        isCorrect = matchedPairs.length === (prompt.pairs?.length || 0)
        break
    }

    if (isCorrect) {
      setFeedback('correct')
      setScore(s => ({ ...s, correct: s.correct + 1, xp: s.xp + 2 }))
    } else {
      setFeedback('wrong')
      setScore(s => ({ ...s, wrong: s.wrong + 1 }))
      loseHeart()
    }
  }

  const nextExercise = () => {
    setFeedback(null); setSelectedAnswer(null); setUserInput(''); setMatchedPairs([]); setMatchLeft(null)
    if (currentIdx + 1 >= exercises.length) {
      setCompleted(true)
      addXp(score.xp + 10)
    } else {
      setCurrentIdx(currentIdx + 1)
    }
  }

  const handleMatchClick = (side, idx) => {
    if (side === 'left') { setMatchLeft(idx); return }
    if (matchLeft !== null && side === 'right') {
      const answer = JSON.parse(currentExercise.answerJson || '{}')
      const correctPairs = answer.correct_pairs || []
      const isMatch = correctPairs.some(p => p[0] === matchLeft && p[1] === idx)
      if (isMatch) setMatchedPairs([...matchedPairs, [matchLeft, idx]])
      setMatchLeft(null)
    }
  }

  if (!lesson) return <div className="flex justify-center py-20"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div></div>

  if (completed) return (
    <div className="max-w-lg mx-auto text-center py-16">
      <div className="text-6xl mb-4">🎉</div>
      <h1 className={`text-3xl font-bold mb-4 ${darkMode ? 'text-white' : ''}`}>Hoàn thành!</h1>
      <div className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-8 shadow-lg mb-6`}>
        <div className="grid grid-cols-3 gap-4 mb-6">
          <div><p className="text-3xl font-bold text-lingua-green">{score.correct}</p><p className="text-sm text-gray-400">Đúng</p></div>
          <div><p className="text-3xl font-bold text-lingua-red">{score.wrong}</p><p className="text-sm text-gray-400">Sai</p></div>
          <div><p className="text-3xl font-bold text-lingua-orange">{score.xp + 10}</p><p className="text-sm text-gray-400">XP</p></div>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-3 mb-2">
          <div className="bg-lingua-green h-3 rounded-full transition-all" style={{ width: `${(score.correct / exercises.length) * 100}%` }}></div>
        </div>
        <p className="text-sm text-gray-400">{Math.round((score.correct / exercises.length) * 100)}% chính xác</p>
      </div>
      <div className="flex gap-3 justify-center">
        <button onClick={() => navigate(-1)} className="px-6 py-3 bg-gray-200 rounded-xl font-semibold hover:bg-gray-300">Quay lại</button>
        <button onClick={() => { setCurrentIdx(0); setCompleted(false); setScore({ correct: 0, wrong: 0, xp: 0 }) }}
          className="px-6 py-3 bg-blue-500 text-white rounded-xl font-semibold hover:bg-blue-600 flex items-center gap-2"><RefreshCcw size={18} /> Làm lại</button>
      </div>
    </div>
  )

  const prompt = currentExercise ? JSON.parse(currentExercise.promptJson || '{}') : {}
  const answer = currentExercise ? JSON.parse(currentExercise.answerJson || '{}') : {}
  const hint = currentExercise ? JSON.parse(currentExercise.hintJson || '{}') : {}
  const progress = ((currentIdx + 1) / exercises.length) * 100

  return (
    <div className="max-w-2xl mx-auto">
      {/* Top Bar */}
      <div className="flex items-center gap-4 mb-8">
        <button onClick={() => navigate(-1)} className="p-2 hover:bg-gray-100 rounded-full"><X size={24} className="text-gray-400" /></button>
        <div className="flex-1 bg-gray-200 rounded-full h-3">
          <div className="bg-lingua-green h-3 rounded-full progress-bar-fill" style={{ width: `${progress}%` }}></div>
        </div>
        <div className="flex items-center gap-1"><Heart size={20} className="text-red-500 fill-red-500" /><span className="font-bold text-red-500">{hearts}</span></div>
      </div>

      {/* Exercise Content */}
      <div className={`exercise-enter ${feedback === 'correct' ? 'feedback-correct' : feedback === 'wrong' ? 'feedback-wrong' : ''}`}>
        {currentExercise?.type === 'MULTIPLE_CHOICE' && (
          <div>
            <h2 className={`text-xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>{prompt.question}</h2>
            <div className="space-y-3">
              {prompt.options?.map((opt, i) => (
                <button key={i} onClick={() => !feedback && setSelectedAnswer(i)}
                  className={`w-full text-left p-4 rounded-xl border-2 transition font-medium ${
                    feedback
                      ? i === answer.correct ? 'border-green-500 bg-green-50 text-green-700' :
                        i === selectedAnswer && i !== answer.correct ? 'border-red-500 bg-red-50 text-red-700' :
                        darkMode ? 'border-gray-600 text-gray-400' : 'border-gray-200 text-gray-400'
                      : selectedAnswer === i
                        ? 'border-blue-500 bg-blue-50 text-blue-700'
                        : darkMode ? 'border-gray-600 hover:border-gray-500 text-gray-200' : 'border-gray-200 hover:border-gray-400'
                  }`}>{opt}</button>
              ))}
            </div>
          </div>
        )}

        {(currentExercise?.type === 'FILL_BLANK') && (
          <div>
            <h2 className={`text-xl font-bold mb-2 ${darkMode ? 'text-white' : ''}`}>Điền vào chỗ trống</h2>
            <p className={`text-lg mb-6 ${darkMode ? 'text-gray-300' : 'text-gray-600'}`}>{prompt.context}</p>
            <div className={`text-2xl font-medium mb-6 p-4 rounded-xl ${darkMode ? 'bg-gray-800' : 'bg-gray-100'}`}>
              {prompt.sentence?.replace('____', feedback ? `【${answer.correct}】` : '______')}
            </div>
            {!feedback && <input value={userInput} onChange={e => setUserInput(e.target.value)} onKeyDown={e => e.key === 'Enter' && checkAnswer()}
              className={`w-full p-4 rounded-xl border-2 text-lg ${darkMode ? 'bg-gray-800 border-gray-600 text-white' : 'border-gray-300'} focus:border-blue-500 focus:outline-none`}
              placeholder="Nhập câu trả lời..." autoFocus />}
          </div>
        )}

        {(currentExercise?.type === 'TRANSLATE_TO_SOURCE' || currentExercise?.type === 'TRANSLATE_TO_TARGET') && (
          <div>
            <h2 className={`text-xl font-bold mb-2 ${darkMode ? 'text-white' : ''}`}>
              {currentExercise.type === 'TRANSLATE_TO_SOURCE' ? 'Dịch sang tiếng Việt' : 'Dịch sang ngôn ngữ đích'}
            </h2>
            <div className={`text-2xl font-medium mb-6 p-4 rounded-xl ${darkMode ? 'bg-gray-800' : 'bg-gray-100'} flex items-center gap-3`}>
              <span>{prompt.sentence}</span>
              <button onClick={() => speak(prompt.sentence)} className="p-2 hover:bg-blue-100 rounded-full"><Volume2 size={20} className="text-blue-500" /></button>
            </div>
            {feedback && <div className={`p-4 rounded-xl mb-4 ${feedback === 'correct' ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'} border`}>
              <p className="font-semibold">{feedback === 'correct' ? '✅ Chính xác!' : '❌ Chưa đúng'}</p>
              <p className="text-sm">Đáp án: {answer.correct}</p>
              {answer.explanation && <p className="text-sm text-gray-500 mt-1">{answer.explanation}</p>}
            </div>}
            {!feedback && <input value={userInput} onChange={e => setUserInput(e.target.value)} onKeyDown={e => e.key === 'Enter' && checkAnswer()}
              className={`w-full p-4 rounded-xl border-2 text-lg ${darkMode ? 'bg-gray-800 border-gray-600 text-white' : 'border-gray-300'} focus:border-blue-500 focus:outline-none`}
              placeholder="Nhập bản dịch..." autoFocus />}
          </div>
        )}

        {currentExercise?.type === 'MATCH_PAIRS' && (
          <div>
            <h2 className={`text-xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>Nối cặp tương ứng</h2>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-3">
                {prompt.pairs?.map((p, i) => {
                  const isMatched = matchedPairs.some(m => m[0] === i)
                  return (
                    <button key={i} onClick={() => !isMatched && handleMatchClick('left', i)}
                      className={`w-full p-3 rounded-xl border-2 text-left transition ${
                        isMatched ? 'border-green-500 bg-green-50 text-green-700' :
                        matchLeft === i ? 'border-blue-500 bg-blue-50' :
                        darkMode ? 'border-gray-600 text-gray-200 hover:border-gray-500' : 'border-gray-200 hover:border-gray-400'
                      }`}>{p.left}</button>
                  )
                })}
              </div>
              <div className="space-y-3">
                {prompt.pairs?.map((p, i) => {
                  const isMatched = matchedPairs.some(m => m[1] === i)
                  return (
                    <button key={i} onClick={() => !isMatched && handleMatchClick('right', i)}
                      className={`w-full p-3 rounded-xl border-2 text-left transition ${
                        isMatched ? 'border-green-500 bg-green-50 text-green-700' :
                        darkMode ? 'border-gray-600 text-gray-200 hover:border-gray-500' : 'border-gray-200 hover:border-gray-400'
                      }`}>{p.right}</button>
                  )
                })}
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Feedback & Actions */}
      {feedback && (
        <div className={`mt-6 p-4 rounded-xl ${feedback === 'correct' ? 'bg-green-50 border-green-300' : 'bg-red-50 border-red-300'} border`}>
          <div className="flex items-center gap-2 mb-1">
            {feedback === 'correct' ? <Check className="text-green-600" size={20} /> : <X className="text-red-600" size={20} />}
            <span className={`font-bold ${feedback === 'correct' ? 'text-green-700' : 'text-red-700'}`}>
              {feedback === 'correct' ? 'Tuyệt vời! 🎉' : 'Chưa đúng rồi 😅'}
            </span>
          </div>
          {answer.explanation && <p className="text-sm text-gray-600">{answer.explanation}</p>}
        </div>
      )}

      {/* Bottom Action */}
      <div className="mt-8 flex justify-between items-center">
        <button className="text-sm text-gray-400 hover:text-gray-600">💡 Gợi ý: {hint.hint || ''}</button>
        {!feedback ? (
          <button onClick={checkAnswer} disabled={selectedAnswer === null && !userInput && matchedPairs.length === 0}
            className="px-8 py-3 bg-lingua-green text-white rounded-xl font-bold text-lg hover:bg-green-600 disabled:opacity-50 disabled:cursor-not-allowed transition flex items-center gap-2">
            Kiểm tra <Check size={20} />
          </button>
        ) : (
          <button onClick={nextExercise}
            className="px-8 py-3 bg-blue-500 text-white rounded-xl font-bold text-lg hover:bg-blue-600 transition flex items-center gap-2">
            Tiếp tục <ArrowRight size={20} />
          </button>
        )}
      </div>
    </div>
  )
}
