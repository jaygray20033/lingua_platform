import { useState, useEffect } from 'react'
import { srsAPI } from '../api'
import { useAppStore, useGamificationStore } from '../store'
import { RotateCcw, Volume2, ChevronLeft, ChevronRight } from 'lucide-react'

export default function FlashcardSRS() {
  const [decks, setDecks] = useState([])
  const [dueCards, setDueCards] = useState([])
  const [currentIdx, setCurrentIdx] = useState(0)
  const [flipped, setFlipped] = useState(false)
  const [mode, setMode] = useState('decks') // 'decks' | 'review' | 'browse'
  const [browseDeck, setBrowseDeck] = useState(null)
  const [browseCards, setBrowseCards] = useState([])
  const { darkMode } = useAppStore()
  const { addXp } = useGamificationStore()

  useEffect(() => {
    srsAPI.getDecks().then(r => setDecks(r.data.data || []))
    srsAPI.getDue(2).then(r => setDueCards(r.data.data || []))
  }, [])

  const handleRating = async (rating) => {
    const card = dueCards[currentIdx]
    if (card?.reviewId) {
      await srsAPI.review(card.reviewId, rating)
      addXp(1)
    }
    setFlipped(false)
    if (currentIdx + 1 < dueCards.length) setCurrentIdx(currentIdx + 1)
    else { setMode('decks'); alert('🎉 Ôn tập xong! Tuyệt vời!') }
  }

  const startBrowse = (deck) => {
    srsAPI.getDeckCards(deck.id).then(r => {
      setBrowseCards(r.data.data || [])
      setBrowseDeck(deck)
      setMode('browse')
      setCurrentIdx(0); setFlipped(false)
    })
  }

  const speak = (text) => {
    const u = new SpeechSynthesisUtterance(text)
    u.lang = 'ja-JP'; u.rate = 0.7; speechSynthesis.speak(u)
  }

  const ratingButtons = [
    { label: 'Quên', rating: 'AGAIN', color: 'bg-red-500 hover:bg-red-600', desc: '< 1 ngày' },
    { label: 'Khó', rating: 'HARD', color: 'bg-orange-500 hover:bg-orange-600', desc: '1-2 ngày' },
    { label: 'Ổn', rating: 'GOOD', color: 'bg-green-500 hover:bg-green-600', desc: '3-7 ngày' },
    { label: 'Dễ', rating: 'EASY', color: 'bg-blue-500 hover:bg-blue-600', desc: '> 7 ngày' },
  ]

  if (mode === 'review' && dueCards.length > 0) {
    const card = dueCards[currentIdx]
    return (
      <div className="max-w-lg mx-auto">
        <div className="flex items-center justify-between mb-6">
          <button onClick={() => setMode('decks')} className="text-gray-400 hover:text-gray-600 flex items-center gap-1"><ChevronLeft size={18} /> Quay lại</button>
          <span className="text-sm text-gray-400">{currentIdx + 1} / {dueCards.length}</span>
        </div>

        {/* Card */}
        <div className="flip-card mb-8" style={{ minHeight: 320 }}>
          <div className={`flip-card-inner ${flipped ? 'flipped' : ''}`} style={{ minHeight: 320 }}>
            {/* Front */}
            <div className={`flip-card-front ${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl shadow-lg p-8 flex flex-col items-center justify-center border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}
              style={{ minHeight: 320 }} onClick={() => setFlipped(true)}>
              <p className={`text-4xl font-bold mb-4 ${darkMode ? 'text-white' : ''}`}>{card?.front}</p>
              <button onClick={(e) => { e.stopPropagation(); speak(card?.front) }} className="p-3 bg-blue-100 rounded-full hover:bg-blue-200">
                <Volume2 size={24} className="text-blue-600" />
              </button>
              <p className="text-sm text-gray-400 mt-4">Nhấn để lật thẻ</p>
            </div>
            {/* Back */}
            <div className={`flip-card-back ${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl shadow-lg p-8 flex flex-col items-center justify-center border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}
              style={{ minHeight: 320, position: 'absolute', top: 0, left: 0, right: 0 }}>
              <p className={`text-lg whitespace-pre-line text-center ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{card?.back}</p>
            </div>
          </div>
        </div>

        {/* Rating Buttons */}
        {flipped && (
          <div className="grid grid-cols-4 gap-2">
            {ratingButtons.map(btn => (
              <button key={btn.rating} onClick={() => handleRating(btn.rating)}
                className={`${btn.color} text-white py-3 rounded-xl font-semibold transition`}>
                <span className="block text-sm">{btn.label}</span>
                <span className="block text-xs opacity-75">{btn.desc}</span>
              </button>
            ))}
          </div>
        )}
      </div>
    )
  }

  if (mode === 'browse' && browseDeck) {
    const card = browseCards[currentIdx]
    return (
      <div className="max-w-lg mx-auto">
        <div className="flex items-center justify-between mb-6">
          <button onClick={() => setMode('decks')} className="text-gray-400 hover:text-gray-600 flex items-center gap-1"><ChevronLeft size={18} /> Quay lại</button>
          <span className={`font-semibold ${darkMode ? 'text-white' : ''}`}>{browseDeck.name}</span>
          <span className="text-sm text-gray-400">{currentIdx + 1}/{browseCards.length}</span>
        </div>

        <div className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl shadow-lg p-8 text-center min-h-[300px] flex flex-col items-center justify-center border ${darkMode ? 'border-gray-700' : 'border-gray-200'} cursor-pointer`}
          onClick={() => setFlipped(!flipped)}>
          {!flipped ? (
            <>
              <p className={`text-4xl font-bold mb-4 ${darkMode ? 'text-white' : ''}`}>{card?.front}</p>
              <button onClick={(e) => { e.stopPropagation(); speak(card?.front) }} className="p-3 bg-blue-100 rounded-full"><Volume2 size={24} className="text-blue-600" /></button>
              <p className="text-sm text-gray-400 mt-3">Nhấn để xem nghĩa</p>
            </>
          ) : (
            <p className={`text-lg whitespace-pre-line ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{card?.back}</p>
          )}
        </div>

        <div className="flex gap-3 mt-6 justify-center">
          <button disabled={currentIdx === 0} onClick={() => { setCurrentIdx(currentIdx - 1); setFlipped(false) }}
            className="px-6 py-2 bg-gray-200 rounded-xl disabled:opacity-30"><ChevronLeft size={20} /></button>
          <button disabled={currentIdx >= browseCards.length - 1} onClick={() => { setCurrentIdx(currentIdx + 1); setFlipped(false) }}
            className="px-6 py-2 bg-gray-200 rounded-xl disabled:opacity-30"><ChevronRight size={20} /></button>
        </div>
      </div>
    )
  }

  // Deck List
  return (
    <div className="max-w-4xl mx-auto">
      <h1 className={`text-2xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>🧠 SRS Flashcard</h1>

      {dueCards.length > 0 && (
        <button onClick={() => { setMode('review'); setCurrentIdx(0); setFlipped(false) }}
          className="w-full mb-6 p-6 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-2xl hover:shadow-lg transition text-left">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-xl font-bold">📋 Ôn tập ngay!</h2>
              <p className="text-purple-100">{dueCards.length} thẻ cần ôn tập hôm nay</p>
            </div>
            <RotateCcw size={32} className="text-white/80" />
          </div>
        </button>
      )}

      <h2 className={`text-lg font-semibold mb-4 ${darkMode ? 'text-white' : ''}`}>Bộ thẻ có sẵn</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {decks.map(deck => (
          <button key={deck.id} onClick={() => startBrowse(deck)}
            className={`${darkMode ? 'bg-gray-800 border-gray-700 hover:bg-gray-750' : 'bg-white border-gray-200 hover:shadow-md'} p-5 rounded-xl border transition text-left`}>
            <h3 className={`font-bold mb-1 ${darkMode ? 'text-white' : ''}`}>{deck.name}</h3>
            <p className="text-sm text-gray-400 mb-2">{deck.description}</p>
            <span className="text-xs px-2 py-1 bg-blue-100 text-blue-600 rounded-full">{deck.cardCount} thẻ</span>
          </button>
        ))}
      </div>
    </div>
  )
}
