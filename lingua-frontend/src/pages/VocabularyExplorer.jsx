import { useState, useEffect } from 'react'
import { vocabAPI } from '../api'
import { useAppStore } from '../store'
import { Search, Volume2, BookOpen } from 'lucide-react'

export default function VocabularyExplorer() {
  const [words, setWords] = useState([])
  const [search, setSearch] = useState('')
  const [lang, setLang] = useState('ja')
  const [level, setLevel] = useState('N5')
  const [selected, setSelected] = useState(null)
  const [pagination, setPagination] = useState({})
  const { darkMode } = useAppStore()

  const levels = { ja: ['N5','N4','N3','N2','N1'], en: ['A1','A2','B1','B2','C1'], zh: ['HSK1','HSK2','HSK3','HSK4','HSK5','HSK6'] }
  const langNames = { ja: '🇯🇵 Tiếng Nhật', en: '🇬🇧 Tiếng Anh', zh: '🇨🇳 Tiếng Trung' }

  useEffect(() => { loadWords() }, [lang, level])

  const loadWords = (q) => {
    const params = q ? { q } : { lang, level }
    vocabAPI.search(params).then(r => {
      setWords(r.data.data || [])
      setPagination(r.data.pagination || {})
    })
  }

  const handleSearch = (e) => {
    e.preventDefault()
    if (search.trim()) loadWords(search.trim())
    else loadWords()
  }

  const speak = (text) => {
    const u = new SpeechSynthesisUtterance(text)
    u.lang = lang === 'ja' ? 'ja-JP' : lang === 'zh' ? 'zh-CN' : 'en-US'
    u.rate = 0.8; speechSynthesis.speak(u)
  }

  return (
    <div className="max-w-6xl mx-auto">
      <h1 className={`text-2xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>📚 Từ vựng</h1>

      {/* Language & Level Tabs */}
      <div className="flex flex-wrap gap-2 mb-4">
        {Object.entries(langNames).map(([code, name]) => (
          <button key={code} onClick={() => { setLang(code); setLevel(levels[code][0]) }}
            className={`px-4 py-2 rounded-full text-sm font-medium transition ${lang === code ? 'bg-blue-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}>
            {name}
          </button>
        ))}
      </div>
      <div className="flex flex-wrap gap-2 mb-6">
        {levels[lang]?.map(l => (
          <button key={l} onClick={() => setLevel(l)}
            className={`px-3 py-1.5 rounded-full text-xs font-medium transition ${level === l ? 'bg-purple-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}>
            {l}
          </button>
        ))}
      </div>

      {/* Search */}
      <form onSubmit={handleSearch} className="mb-6">
        <div className="relative">
          <input value={search} onChange={e => setSearch(e.target.value)}
            className={`w-full pl-12 pr-4 py-3 rounded-xl border text-sm ${darkMode ? 'bg-gray-800 border-gray-600 text-white' : 'bg-white border-gray-200'} focus:outline-none focus:ring-2 focus:ring-blue-500`}
            placeholder="Tìm kiếm từ vựng (kanji, kana, romaji, nghĩa)..." />
          <Search className="absolute left-4 top-3.5 text-gray-400" size={18} />
        </div>
      </form>

      <p className="text-sm text-gray-400 mb-4">{pagination.total || 0} từ vựng</p>

      {/* Word Grid */}
      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3">
        {words.map(word => (
          <button key={word.id} onClick={() => setSelected(selected?.id === word.id ? null : word)}
            className={`p-4 rounded-xl border text-center transition hover:shadow-md ${
              selected?.id === word.id
                ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/30 ring-2 ring-blue-300'
                : darkMode ? 'bg-gray-800 border-gray-700 hover:border-gray-600' : 'bg-white border-gray-200 hover:border-gray-400'
            }`}>
            <p className={`text-xl font-bold mb-1 ${darkMode ? 'text-white' : ''}`}>{word.text}</p>
            {word.reading && <p className="text-sm text-blue-500">{word.reading}</p>}
            {word.romaji && <p className="text-xs text-gray-400">{word.romaji}</p>}
            <span className={`inline-block mt-1 text-xs px-2 py-0.5 rounded-full ${darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-500'}`}>{word.pos}</span>
          </button>
        ))}
      </div>

      {/* Word Detail Modal */}
      {selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4" onClick={() => setSelected(null)}>
          <div className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-6 max-w-lg w-full max-h-[80vh] overflow-y-auto`} onClick={e => e.stopPropagation()}>
            <div className="flex items-center justify-between mb-4">
              <div>
                <h2 className={`text-3xl font-bold ${darkMode ? 'text-white' : ''}`}>{selected.text}</h2>
                {selected.reading && <p className="text-lg text-blue-500">{selected.reading}</p>}
                {selected.romaji && <p className="text-sm text-gray-400">{selected.romaji}</p>}
              </div>
              <button onClick={() => speak(selected.text)} className="p-3 bg-blue-100 rounded-full hover:bg-blue-200">
                <Volume2 size={24} className="text-blue-600" />
              </button>
            </div>
            <div className="flex gap-2 mb-4">
              <span className="px-2 py-1 bg-purple-100 text-purple-600 rounded text-xs font-medium">{selected.pos}</span>
              {selected.jlptLevel && <span className="px-2 py-1 bg-red-100 text-red-600 rounded text-xs font-medium">{selected.jlptLevel}</span>}
              {selected.cefrLevel && <span className="px-2 py-1 bg-blue-100 text-blue-600 rounded text-xs font-medium">{selected.cefrLevel}</span>}
              {selected.hskLevel && <span className="px-2 py-1 bg-orange-100 text-orange-600 rounded text-xs font-medium">{selected.hskLevel}</span>}
            </div>
            {selected.meanings?.map((m, i) => (
              <div key={i} className={`p-4 rounded-xl mb-3 ${darkMode ? 'bg-gray-700' : 'bg-gray-50'}`}>
                <p className={`font-semibold mb-2 ${darkMode ? 'text-white' : ''}`}>🔹 {m.meaning}</p>
                {m.exampleSentence && (
                  <div>
                    <p className={`text-sm flex items-center gap-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>
                      <BookOpen size={14} /> {m.exampleSentence}
                      <button onClick={() => speak(m.exampleSentence)} className="ml-1"><Volume2 size={14} className="text-blue-500" /></button>
                    </p>
                    {m.exampleTranslation && <p className="text-xs text-gray-400 mt-1 ml-6">→ {m.exampleTranslation}</p>}
                  </div>
                )}
              </div>
            ))}
            <button onClick={() => setSelected(null)} className="w-full mt-4 py-2 bg-gray-200 rounded-xl font-medium hover:bg-gray-300">Đóng</button>
          </div>
        </div>
      )}
    </div>
  )
}
