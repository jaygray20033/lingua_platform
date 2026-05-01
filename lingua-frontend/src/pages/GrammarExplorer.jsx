import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { vocabAPI } from '../api'
import { useAppStore } from '../store'
import { speak, certToLang } from '../utils/tts'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { Volume2, BookOpen, ChevronRight, Search, Filter } from 'lucide-react'

const LANG_LEVELS = {
  ja: ['N5', 'N4', 'N3', 'N2', 'N1'],
  en: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'],
  zh: ['HSK1', 'HSK2', 'HSK3', 'HSK4', 'HSK5', 'HSK6'],
}
const LANG_LABEL = { ja: '🇯🇵 Tiếng Nhật', en: '🇬🇧 Tiếng Anh', zh: '🇨🇳 Tiếng Trung' }
const LANG_TO_CERT = { ja: 'JLPT', en: 'CEFR', zh: 'HSK' }

export default function GrammarExplorer() {

  useDocumentTitle('Ngữ pháp')
  const [grammars, setGrammars] = useState([])
  const [lang, setLang] = useState('ja')
  const [level, setLevel] = useState('N5')
  const [query, setQuery] = useState('')
  const [loading, setLoading] = useState(true)
  const { darkMode } = useAppStore()

  const levels = LANG_LEVELS[lang]

  useEffect(() => {
    setLevel(levels[0])
  }, [lang])

  useEffect(() => {
    setLoading(true)
    vocabAPI.getGrammars({ lang, level, q: query || undefined })
      .then(r => setGrammars(r.data.data || []))
      .finally(() => setLoading(false))
  }, [lang, level, query])

  const ttsLang = certToLang(LANG_TO_CERT[lang])

  return (
    <div className="max-w-5xl mx-auto">
      <header className="mb-6">
        <h1 className={`text-2xl font-bold mb-2 ${darkMode ? 'text-white' : ''}`}>📖 Ngữ pháp toàn diện</h1>
        <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
          Học ngữ pháp đầy đủ cho 3 ngôn ngữ: Nhật (JLPT), Anh (CEFR), Trung (HSK)
        </p>
      </header>

      <div className="flex gap-2 mb-4 flex-wrap">
        {Object.keys(LANG_LEVELS).map(l => (
          <button key={l} onClick={() => setLang(l)}
            className={`px-4 py-2 rounded-xl text-sm font-semibold transition ${
              lang === l ? 'bg-blue-500 text-white shadow' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-white border border-gray-200 text-gray-700'
            }`}>
            {LANG_LABEL[l]}
          </button>
        ))}
      </div>

      <div className="flex gap-2 mb-6 flex-wrap items-center">
        {levels.map(l => (
          <button key={l} onClick={() => setLevel(l)}
            className={`px-4 py-1.5 rounded-full text-sm font-medium transition ${level === l ? 'bg-green-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'}`}>
            {l}
          </button>
        ))}
        <div className="flex-1 min-w-[180px] relative ml-auto">
          <Search size={16} className="absolute left-3 top-2.5 text-gray-400" />
          <input value={query} onChange={e => setQuery(e.target.value)}
            placeholder="Tìm pattern hoặc nghĩa..."
            className={`w-full pl-9 pr-3 py-2 rounded-xl border text-sm ${darkMode ? 'bg-gray-700 border-gray-600 text-white' : 'border-gray-200'} focus:outline-none focus:ring-2 focus:ring-blue-500`} />
        </div>
      </div>

      {loading ? (
        <div className="flex justify-center py-20"><div className="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-500"></div></div>
      ) : grammars.length === 0 ? (
        <div className={`text-center py-12 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
          <BookOpen size={40} className="mx-auto mb-3 opacity-40" />
          Chưa có ngữ pháp cho {LANG_LABEL[lang]} - {level}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
          {grammars.map((g, idx) => (
            <Link key={g.id} to={`/grammar/${g.id}`}
              className={`${darkMode ? 'bg-gray-800 border-gray-700 hover:bg-gray-700' : 'bg-white border-gray-200 hover:shadow-md'} rounded-xl border p-4 transition group`}>
              <div className="flex items-start gap-3">
                <span className="w-9 h-9 rounded-lg bg-gradient-to-br from-green-400 to-blue-500 flex items-center justify-center text-white text-sm font-bold flex-shrink-0">
                  {idx + 1}
                </span>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1">
                    <p className={`font-bold text-lg truncate ${darkMode ? 'text-white' : ''}`}>{g.pattern}</p>
                    <button onClick={(e) => { e.preventDefault(); speak({ text: g.pattern, lang: ttsLang, audioUrl: g.audioUrl }) }}
                      className="p-1 rounded-full hover:bg-blue-100 dark:hover:bg-blue-900/30 flex-shrink-0">
                      <Volume2 size={14} className="text-blue-500" />
                    </button>
                  </div>
                  <p className={`text-sm line-clamp-1 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>{g.meaningVi}</p>
                  {g.structure && <p className={`text-xs mt-1 line-clamp-1 ${darkMode ? 'text-gray-500' : 'text-gray-400'}`}>📐 {g.structure}</p>}
                </div>
                <div className="flex flex-col items-end gap-1 flex-shrink-0">
                  <span className={`text-[10px] px-2 py-0.5 rounded-full font-bold ${darkMode ? 'bg-gray-700 text-gray-300' : 'bg-blue-50 text-blue-600'}`}>
                    {g.jlptLevel || g.cefrLevel || g.hskLevel}
                  </span>
                  <ChevronRight size={16} className="text-gray-400 group-hover:text-blue-500 transition" />
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
