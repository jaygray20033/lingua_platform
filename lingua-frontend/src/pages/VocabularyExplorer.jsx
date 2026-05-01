import { useState, useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'
import { vocabAPI } from '../api'
import { useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { Search, Volume2, BookOpen, ChevronLeft, ChevronRight } from 'lucide-react'
import FavoriteButton from '../components/FavoriteButton'

function buildPageList(current, total) {
  const pages = []
  if (total <= 7) {
    for (let i = 1; i <= total; i++) pages.push(i)
    return pages
  }
  const add = (p) => pages.push(p)
  add(1)
  if (current > 3) add('...')
  const start = Math.max(2, current - 1)
  const end = Math.min(total - 1, current + 1)
  for (let i = start; i <= end; i++) add(i)
  if (current < total - 2) add('...')
  add(total)
  return pages
}

export default function VocabularyExplorer() {

  useDocumentTitle('Từ vựng')
  const [searchParams] = useSearchParams()
  const [words, setWords] = useState([])
  const [search, setSearch] = useState(searchParams.get('q') || '')
  const [lang, setLang] = useState('ja')
  const [level, setLevel] = useState('N5')
  const [selected, setSelected] = useState(null)
  const [pagination, setPagination] = useState({})
  const [page, setPage] = useState(1)
  const PAGE_LIMIT = 50
  const { darkMode } = useAppStore()

  const levels = { ja: ['N5','N4','N3','N2','N1'], en: ['A1','A2','B1','B2','C1'], zh: ['HSK1','HSK2','HSK3','HSK4','HSK5','HSK6'] }
  const langNames = { ja: '🇯🇵 Tiếng Nhật', en: '🇬🇧 Tiếng Anh', zh: '🇨🇳 Tiếng Trung' }

  useEffect(() => { setPage(1) }, [lang, level, searchParams])

  useEffect(() => {
    const q = searchParams.get('q')
    if (q) {
      setSearch(q)
      loadWords(q, page)
    } else {
      loadWords(undefined, page)
    }

  }, [searchParams, lang, level, page])

  const loadWords = (q, p = page) => {
    const params = q
      ? { q, lang, page: p, limit: PAGE_LIMIT }
      : { lang, level, page: p, limit: PAGE_LIMIT }
    vocabAPI.search(params).then(r => {
      setWords(r.data.data || [])
      setPagination(r.data.pagination || {})
    })
  }

  const handleSearch = (e) => {
    e.preventDefault()
    setPage(1)
    if (search.trim()) loadWords(search.trim(), 1)
    else loadWords(undefined, 1)
  }

  const speak = (text, audioUrl) => {
    const target = lang === 'ja' ? 'ja-JP' : lang === 'zh' ? 'zh-CN' : 'en-US'
    import('../utils/tts').then(({ speak: ttsSpeak }) => ttsSpeak({ text, lang: target, audioUrl }))
  }

  const handleSelectWord = (word) => {
    if (selected?.id === word.id) {
      setSelected(null)
      return
    }
    setSelected(word)
    vocabAPI.getWord(word.id)
      .then(r => {
        const detail = r.data?.data
        if (detail) setSelected(prev => prev?.id === word.id ? { ...prev, ...detail } : prev)
      })
      .catch(() => {  })
  }

  return (
    <div className="max-w-6xl mx-auto">
      <h1 className={`text-2xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>📚 Từ vựng</h1>

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

      <form onSubmit={handleSearch} className="mb-6">
        <div className="relative">
          <input value={search} onChange={e => setSearch(e.target.value)}
            className={`w-full pl-12 pr-4 py-3 rounded-xl border text-sm ${darkMode ? 'bg-gray-800 border-gray-600 text-white' : 'bg-white border-gray-200'} focus:outline-none focus:ring-2 focus:ring-blue-500`}
            placeholder="Tìm kiếm từ vựng (kanji, kana, romaji, nghĩa)..." />
          <Search className="absolute left-4 top-3.5 text-gray-400" size={18} />
        </div>
      </form>

      <p className="text-sm text-gray-400 mb-4">
        {pagination.total || 0} từ vựng
        {pagination.totalPages > 1 && (
          <span className="ml-2">· Trang {pagination.page || page} / {pagination.totalPages}</span>
        )}
      </p>

      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3">
        {words.map(word => (
          <button key={word.id} onClick={() => handleSelectWord(word)}
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

      {(pagination.totalPages || 0) > 1 && (
        <nav
          aria-label="Phân trang từ vựng"
          className="flex items-center justify-center gap-2 mt-6"
        >
          <button
            type="button"
            onClick={() => setPage(p => Math.max(1, p - 1))}
            disabled={(pagination.page || page) <= 1}
            className={`px-3 py-2 rounded-xl flex items-center gap-1 text-sm font-medium border transition disabled:opacity-40 disabled:cursor-not-allowed
              ${darkMode ? 'bg-gray-800 border-gray-700 text-gray-200 hover:bg-gray-700' : 'bg-white border-gray-200 text-gray-700 hover:bg-gray-50'}`}
          >
            <ChevronLeft size={16} /> Trước
          </button>

          {buildPageList(pagination.page || page, pagination.totalPages || 1).map((p, i) =>
            p === '...' ? (
              <span key={`gap-${i}`} className="px-2 text-gray-400">…</span>
            ) : (
              <button
                key={p}
                type="button"
                onClick={() => setPage(p)}
                aria-current={(pagination.page || page) === p ? 'page' : undefined}
                className={`min-w-[2.5rem] px-3 py-2 rounded-xl text-sm font-medium border transition
                  ${(pagination.page || page) === p
                    ? 'bg-blue-500 border-blue-500 text-white'
                    : darkMode ? 'bg-gray-800 border-gray-700 text-gray-200 hover:bg-gray-700' : 'bg-white border-gray-200 text-gray-700 hover:bg-gray-50'}`}
              >
                {p}
              </button>
            )
          )}

          <button
            type="button"
            onClick={() => setPage(p => Math.min((pagination.totalPages || p), p + 1))}
            disabled={(pagination.page || page) >= (pagination.totalPages || 1)}
            className={`px-3 py-2 rounded-xl flex items-center gap-1 text-sm font-medium border transition disabled:opacity-40 disabled:cursor-not-allowed
              ${darkMode ? 'bg-gray-800 border-gray-700 text-gray-200 hover:bg-gray-700' : 'bg-white border-gray-200 text-gray-700 hover:bg-gray-50'}`}
          >
            Sau <ChevronRight size={16} />
          </button>
        </nav>
      )}

      {selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4" onClick={() => setSelected(null)}>
          <div className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-6 max-w-lg w-full max-h-[80vh] overflow-y-auto`} onClick={e => e.stopPropagation()}>
            <div className="flex items-center justify-between mb-4">
              <div>
                <h2 className={`text-3xl font-bold ${darkMode ? 'text-white' : ''}`}>{selected.text}</h2>
                {selected.reading && <p className="text-lg text-blue-500">{selected.reading}</p>}
                {selected.romaji && <p className="text-sm text-gray-400">{selected.romaji}</p>}
              </div>
              <button
                onClick={() => speak(selected.text, selected.audioUrl)}
                className="p-3 bg-blue-100 rounded-full hover:bg-blue-200"
                aria-label="Phát âm">
                <Volume2 size={24} className="text-blue-600" />
              </button>
            </div>
            <div className="flex gap-2 mb-4 flex-wrap">
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
                      <button onClick={() => speak(m.exampleSentence)} className="ml-1" aria-label="Phát âm câu ví dụ"><Volume2 size={14} className="text-blue-500" /></button>
                    </p>
                    {m.exampleTranslation && <p className="text-xs text-gray-400 mt-1 ml-6">→ {m.exampleTranslation}</p>}
                  </div>
                )}
              </div>
            ))}

            {selected.examples?.length > 0 && (
              <section aria-label="Ví dụ trong ngữ cảnh" className="mt-4">
                <h3 className={`font-semibold text-sm mb-2 flex items-center gap-2 ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>
                  <BookOpen size={16} /> Câu ví dụ trong ngữ cảnh
                </h3>
                <ul className="space-y-2">
                  {selected.examples.map(ex => (
                    <li
                      key={ex.id}
                      className={`p-3 rounded-xl border-l-4 border-blue-500 ${darkMode ? 'bg-gray-700/60' : 'bg-blue-50'}`}
                    >
                      <div className="flex items-start gap-2">
                        <p className={`flex-1 text-sm ${darkMode ? 'text-gray-100' : 'text-gray-800'}`}>
                          {ex.sentence}
                        </p>
                        <button
                          onClick={() => speak(ex.sentence, ex.audioUrl)}
                          className="shrink-0 p-1.5 hover:bg-blue-100 dark:hover:bg-blue-900/30 rounded"
                          aria-label="Phát âm câu này">
                          <Volume2 size={14} className="text-blue-500" />
                        </button>
                      </div>
                      {ex.reading && (
                        <p className={`text-xs mt-1 italic ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
                          {ex.reading}
                        </p>
                      )}
                      <p className={`text-xs mt-1 ${darkMode ? 'text-gray-300' : 'text-gray-600'}`}>
                        🇻🇳 {ex.translationVi}
                      </p>
                      {ex.translationEn && (
                        <p className={`text-xs ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
                          🇬🇧 {ex.translationEn}
                        </p>
                      )}
                    </li>
                  ))}
                </ul>
              </section>
            )}

            <button onClick={() => setSelected(null)} className="w-full mt-4 py-2 bg-gray-200 rounded-xl font-medium hover:bg-gray-300">Đóng</button>
          </div>
        </div>
      )}
    </div>
  )
}
