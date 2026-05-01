import { useState, useEffect, useRef } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { lessonAPI } from '../api'
import { useGamificationStore, useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { X, Heart, Volume2, Check, ArrowRight, RefreshCcw } from 'lucide-react'
import AudioRecorder from '../components/AudioRecorder'
import WritingPractice from '../components/WritingPractice'
import ListeningPlayer from '../components/ListeningPlayer'

export default function LessonPractice() {

  useDocumentTitle('Luyện tập bài học')
  const { id } = useParams()
  const navigate = useNavigate()
  const [lesson, setLesson] = useState(null)
  const [exercises, setExercises] = useState([])
  const [currentIdx, setCurrentIdx] = useState(0)
  const [selectedAnswer, setSelectedAnswer] = useState(null)
  const [userInput, setUserInput] = useState('')
  const [matchedPairs, setMatchedPairs] = useState([])
  const [matchLeft, setMatchLeft] = useState(null)

  const [wrongMatch, setWrongMatch] = useState(null)
  const [feedback, setFeedback] = useState(null)
  const [score, setScore] = useState({ correct: 0, wrong: 0, xp: 0 })
  const [completed, setCompleted] = useState(false)

  const { hearts, loseHeart, addXp } = useGamificationStore()
  const { darkMode } = useAppStore()

  const startedAtRef = useRef(Date.now())
  const heartsLostRef = useRef(0)
  const completionPostedRef = useRef(false)

  const idempotencyRef = useRef(null)

  useEffect(() => {
    lessonAPI.get(id).then(r => {
      setLesson(r.data.data)
      setExercises(r.data.data.exercises || [])
      startedAtRef.current = Date.now()
      heartsLostRef.current = 0
      completionPostedRef.current = false
      idempotencyRef.current = null
    })
  }, [id])

  const currentExercise = exercises[currentIdx]

  const speak = (text, lang = 'ja-JP') => {

    import('../utils/tts').then(({ speak: ttsSpeak }) => ttsSpeak({ text, lang }))
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
      heartsLostRef.current += 1
      loseHeart()
    }
  }

  const postCompletion = async (finalScore) => {
    if (completionPostedRef.current) return
    completionPostedRef.current = true
    try {
      const total = exercises.length || 1
      const scorePercent = Math.round((finalScore.correct / total) * 100)
      const durationSec = Math.max(1, Math.round((Date.now() - startedAtRef.current) / 1000))
      const xpEarned = finalScore.xp + 10

      const idempotencyKey =
        idempotencyRef.current ||
        (idempotencyRef.current = `${id}-${startedAtRef.current}-${Math.random().toString(36).slice(2, 8)}`)
      const prevLevel = useGamificationStore.getState().level
      const res = await lessonAPI.complete(id, {
        score: scorePercent,
        xpEarned,
        heartsLost: heartsLostRef.current,
        durationSec,
        correct: finalScore.correct,
        wrong: finalScore.wrong,
        idempotencyKey,
      })

      const data = res?.data?.data || {}
      if (!data.duplicate) {
        const newLevel = data.level != null ? data.level : prevLevel
        const xpGained = data.xpEarned != null ? data.xpEarned : xpEarned
        window.dispatchEvent(new CustomEvent('lingua:xp-gain', {
          detail: { amount: xpGained, prevLevel, newLevel }
        }))
        if (data.level != null) {

          useGamificationStore.setState({ level: data.level })
        }
      }
    } catch (err) {

      console.warn('Failed to record lesson completion', err)
    }
  }

  const nextExercise = () => {
    setFeedback(null); setSelectedAnswer(null); setUserInput(''); setMatchedPairs([]); setMatchLeft(null); setWrongMatch(null)
    if (currentIdx + 1 >= exercises.length) {
      setCompleted(true)
      addXp(score.xp + 10)
      postCompletion(score)
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
      if (isMatch) {
        setMatchedPairs([...matchedPairs, [matchLeft, idx]])
        setMatchLeft(null)
      } else {

        const pair = [matchLeft, idx]
        setWrongMatch(pair)
        setMatchLeft(null)
        setTimeout(() => {
          setWrongMatch(prev =>
            prev && prev[0] === pair[0] && prev[1] === pair[1] ? null : prev
          )
        }, 600)
      }
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
        <button onClick={() => {
          setCurrentIdx(0)
          setCompleted(false)
          setScore({ correct: 0, wrong: 0, xp: 0 })
          startedAtRef.current = Date.now()
          heartsLostRef.current = 0
          completionPostedRef.current = false
          idempotencyRef.current = null
        }}
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

      <div className="flex items-center gap-4 mb-8">
        <button onClick={() => navigate(-1)} className="p-2 hover:bg-gray-100 rounded-full"><X size={24} className="text-gray-400" /></button>
        <div className="flex-1 bg-gray-200 rounded-full h-3">
          <div className="bg-lingua-green h-3 rounded-full progress-bar-fill" style={{ width: `${progress}%` }}></div>
        </div>
        <div className="flex items-center gap-1"><Heart size={20} className="text-red-500 fill-red-500" /><span className="font-bold text-red-500">{hearts}</span></div>
      </div>

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

        {currentExercise?.type === 'SPEAKING' && (
          <section>
            <h2 className={`text-xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>🎤 Luyện phát âm</h2>
            <AudioRecorder
              targetText={prompt.sentence || prompt.text || prompt.question || ''}
              onScore={() => setSelectedAnswer('self-ok')}
            />
            <p className="text-xs text-gray-500 mt-3">
              Ghi âm đọc to câu trên, rồi nghe lại để tự so sánh. Nhấn "Kiểm tra" khi xong.
            </p>
          </section>
        )}

        {currentExercise?.type === 'WRITING' && (
          <section>
            <h2 className={`text-xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>✏️ Luyện viết</h2>
            <WritingPractice character={prompt.character || prompt.text || ''} />
            <button
              type="button"
              onClick={() => setSelectedAnswer('self-ok')}
              className="mt-3 text-sm text-blue-600 hover:underline"
            >
              Tôi đã viết xong
            </button>
          </section>
        )}

        {currentExercise?.type === 'LISTENING' && (
          <section>
            <h2 className={`text-xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>🎧 Luyện nghe</h2>
            <ListeningPlayer audioUrl={currentExercise.audioUrl} text={prompt.sentence || prompt.text || ''} />
            {!feedback && (
              <input
                type="text"
                value={userInput}
                onChange={e => setUserInput(e.target.value)}
                onKeyDown={e => e.key === 'Enter' && checkAnswer()}
                placeholder="Gõ lại câu bạn nghe được…"
                className={`mt-4 w-full p-4 rounded-xl border-2 text-lg ${darkMode ? 'bg-gray-800 border-gray-600 text-white' : 'border-gray-300'} focus:border-blue-500 focus:outline-none`}
                autoFocus
              />
            )}
          </section>
        )}

        {currentExercise?.type === 'MATCH_PAIRS' && (
          <div>
            <h2 className={`text-xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>Nối cặp tương ứng</h2>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-3">
                {prompt.pairs?.map((p, i) => {
                  const isMatched = matchedPairs.some(m => m[0] === i)

                  const isWrong = wrongMatch && wrongMatch[0] === i
                  return (
                    <button key={i} onClick={() => !isMatched && handleMatchClick('left', i)}
                      className={`w-full p-3 rounded-xl border-2 text-left transition ${
                        isMatched ? 'border-green-500 bg-green-50 text-green-700 dark:bg-green-900/30 dark:text-green-300' :
                        isWrong ? 'border-red-500 bg-red-50 text-red-700 dark:bg-red-900/30 dark:text-red-300 animate-pulse' :
                        matchLeft === i ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/30 dark:text-blue-200' :
                        darkMode ? 'border-gray-600 text-gray-200 hover:border-gray-500' : 'border-gray-200 hover:border-gray-400'
                      }`}>{p.left}</button>
                  )
                })}
              </div>
              <div className="space-y-3">
                {prompt.pairs?.map((p, i) => {
                  const isMatched = matchedPairs.some(m => m[1] === i)
                  const isWrong = wrongMatch && wrongMatch[1] === i
                  return (
                    <button key={i} onClick={() => !isMatched && handleMatchClick('right', i)}
                      className={`w-full p-3 rounded-xl border-2 text-left transition ${
                        isMatched ? 'border-green-500 bg-green-50 text-green-700 dark:bg-green-900/30 dark:text-green-300' :
                        isWrong ? 'border-red-500 bg-red-50 text-red-700 dark:bg-red-900/30 dark:text-red-300 animate-pulse' :
                        darkMode ? 'border-gray-600 text-gray-200 hover:border-gray-500' : 'border-gray-200 hover:border-gray-400'
                      }`}>{p.right}</button>
                  )
                })}
              </div>
            </div>
          </div>
        )}
      </div>

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
