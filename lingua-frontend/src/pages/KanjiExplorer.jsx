import { useState, useEffect, useMemo } from 'react'
import { vocabAPI } from '../api'
import { useAppStore } from '../store'
import { Volume2, Search, Filter, X } from 'lucide-react'
import KanjiStrokeOrder from '../components/KanjiStrokeOrder'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import FavoriteButton from '../components/FavoriteButton'

export default function KanjiExplorer() {

  useDocumentTitle('Hán tự')
  const [allKanji, setAllKanji] = useState([])
  const [level, setLevel] = useState('N5')
  const [lang, setLang] = useState('ja')
  const [selected, setSelected] = useState(null)
  const [search, setSearch] = useState('')
  const [sortBy, setSortBy] = useState('frequency')
  const { darkMode } = useAppStore()

  const jpLevels = ['N5', 'N4', 'N3', 'N2', 'N1']
  const zhLevels = ['HSK1', 'HSK2', 'HSK3', 'HSK4', 'HSK5', 'HSK6']
  const levels = lang === 'ja' ? jpLevels : zhLevels

  useEffect(() => {

    vocabAPI.getCharacters({ level, lang, limit: 200 })
      .then(r => setAllKanji(r.data.data || []))
      .catch(() => setAllKanji([]))
  }, [level, lang])

  const kanjis = useMemo(() => {
    let arr = [...allKanji]
    if (search.trim()) {
      const q = search.trim().toLowerCase()
      arr = arr.filter(k =>
        k.character?.includes(search) ||
        k.hanViet?.toLowerCase().includes(q) ||
        k.meaningVi?.toLowerCase().includes(q) ||
        k.meaningEn?.toLowerCase().includes(q) ||
        k.onReading?.toLowerCase().includes(q) ||
        k.kunReading?.toLowerCase().includes(q)
      )
    }
    if (sortBy === 'strokes') arr.sort((a, b) => (a.strokeCount || 0) - (b.strokeCount || 0))
    else if (sortBy === 'hanviet') arr.sort((a, b) => (a.hanViet || '').localeCompare(b.hanViet || ''))
    return arr
  }, [allKanji, search, sortBy])

  const speak = (text, langCode = 'ja-JP') => {
    if (!text) return
    const target = lang === 'zh' ? 'zh-CN' : langCode
    import('../utils/tts').then(({ speak: ttsSpeak }) => ttsSpeak({ text, lang: target }))
  }

  return (
    <div className="max-w-6xl mx-auto">
      <header className="mb-6">
        <h1 className={`text-2xl font-bold ${darkMode ? 'text-white' : ''}`}>
          🈶 {lang === 'ja' ? 'Hán tự (Kanji)' : 'Chữ Hán (Hanzi)'}
        </h1>
        <p className="text-sm text-gray-400 mt-1">
          Khám phá các ký tự với âm đọc, ý nghĩa và mẹo nhớ. Tổng: {allKanji.length} ký tự ở cấp độ {level}.
        </p>
      </header>

      <nav id="kanji-lang-tabs" className="flex gap-2 mb-4">
        <button onClick={() => { setLang('ja'); setLevel('N5') }}
          className={`px-4 py-2 rounded-full text-sm font-medium transition ${lang === 'ja' ? 'bg-red-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'}`}>
          🇯🇵 Kanji (Nhật)
        </button>
        <button onClick={() => { setLang('zh'); setLevel('HSK1') }}
          className={`px-4 py-2 rounded-full text-sm font-medium transition ${lang === 'zh' ? 'bg-orange-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'}`}>
          🇨🇳 Hanzi (Trung)
        </button>
      </nav>

      <nav id="kanji-level-tabs" className="flex flex-wrap gap-2 mb-4">
        {levels.map(l => (
          <button key={l} onClick={() => setLevel(l)}
            className={`px-4 py-2 rounded-full text-sm font-medium transition ${level === l ? (lang === 'ja' ? 'bg-red-500' : 'bg-orange-500') + ' text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'}`}>
            {l}
          </button>
        ))}
      </nav>

      <div className="flex flex-col md:flex-row gap-3 mb-6">
        <div className="relative flex-1">
          <input id="kanji-search-input" value={search} onChange={e => setSearch(e.target.value)}
            placeholder="Tìm theo ký tự, Hán Việt, nghĩa, âm đọc..."
            className={`w-full pl-10 pr-10 py-2.5 rounded-xl border text-sm ${darkMode ? 'bg-gray-800 border-gray-600 text-white' : 'bg-white border-gray-200'} focus:outline-none focus:ring-2 focus:ring-red-500`} />
          <Search className="absolute left-3 top-3 text-gray-400" size={18} />
          {search && <button onClick={() => setSearch('')} className="absolute right-3 top-3 text-gray-400 hover:text-gray-600"><X size={18} /></button>}
        </div>
        <div className="flex gap-2">
          <Filter className={`my-auto ${darkMode ? 'text-gray-400' : 'text-gray-500'}`} size={18} />
          <select value={sortBy} onChange={e => setSortBy(e.target.value)}
            className={`px-3 py-2 rounded-xl border text-sm ${darkMode ? 'bg-gray-800 border-gray-600 text-white' : 'bg-white border-gray-200'}`}>
            <option value="frequency">Theo độ phổ biến</option>
            <option value="strokes">Theo số nét</option>
            <option value="hanviet">Theo Hán Việt (A-Z)</option>
          </select>
        </div>
      </div>

      <p className="text-sm text-gray-400 mb-3">{kanjis.length} kết quả</p>

      {kanjis.length === 0 ? (
        <div className={`text-center py-16 rounded-2xl ${darkMode ? 'bg-gray-800' : 'bg-white'} border ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
          <p className="text-6xl mb-3">🔍</p>
          <p className="text-gray-400">Không tìm thấy ký tự phù hợp</p>
        </div>
      ) : (
        <div id="kanji-grid" className="grid grid-cols-4 md:grid-cols-6 lg:grid-cols-8 xl:grid-cols-10 gap-2">
          {kanjis.map(k => (
            <button key={k.id} onClick={() => setSelected(k)}
              className={`aspect-square flex flex-col items-center justify-center rounded-xl border transition hover:shadow-lg ${
                selected?.id === k.id ? 'border-red-500 bg-red-50 dark:bg-red-900/20 ring-2 ring-red-300' :
                darkMode ? 'bg-gray-800 border-gray-700 hover:border-gray-500' : 'bg-white border-gray-200 hover:border-red-300'
              }`}
              title={`${k.hanViet} - ${k.meaningVi}`}>
              <span className={`text-3xl font-bold ${darkMode ? 'text-white' : 'text-gray-800'}`}>{k.character}</span>
              <span className="text-xs text-gray-400 mt-1 truncate w-full px-1 text-center">{k.hanViet}</span>
              {k.strokeCount && <span className="text-[10px] text-gray-500">{k.strokeCount} nét</span>}
            </button>
          ))}
        </div>
      )}

      {selected && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4" onClick={() => setSelected(null)}>
          <article className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-8 max-w-xl w-full max-h-[90vh] overflow-y-auto shadow-2xl`} onClick={e => e.stopPropagation()}>
            <header className="text-center mb-6">
              <p className={`text-9xl font-bold mb-3 ${darkMode ? 'text-white' : ''}`}>{selected.character}</p>
              <div className="flex items-center justify-center gap-2 flex-wrap">
                <span className={`px-3 py-1 ${lang === 'ja' ? 'bg-red-100 text-red-600' : 'bg-orange-100 text-orange-600'} rounded-full text-sm font-medium`}>
                  {selected.jlptLevel}
                </span>
                {selected.strokeCount && <span className="px-3 py-1 bg-gray-100 text-gray-600 rounded-full text-sm">{selected.strokeCount} nét</span>}
                <button onClick={() => speak(selected.character)}
                  className="px-3 py-1 bg-blue-100 text-blue-600 rounded-full text-sm font-medium flex items-center gap-1 hover:bg-blue-200">
                  <Volume2 size={14} /> Nghe
                </button>
              </div>
            </header>

            <div className="grid grid-cols-2 gap-3 mb-4">
              {lang === 'ja' ? (
                <>
                  <div className={`p-3 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-blue-50'}`}>
                    <p className="text-xs text-gray-400 mb-1">Âm On (音読み)</p>
                    <p className={`font-semibold text-lg ${darkMode ? 'text-white' : 'text-blue-700'}`}>{selected.onReading || '—'}</p>
                    {selected.onReading && <button onClick={() => speak(selected.onReading)} className="text-xs text-blue-500 mt-1 flex items-center gap-1"><Volume2 size={12} />Nghe</button>}
                  </div>
                  <div className={`p-3 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-green-50'}`}>
                    <p className="text-xs text-gray-400 mb-1">Âm Kun (訓読み)</p>
                    <p className={`font-semibold text-lg ${darkMode ? 'text-white' : 'text-green-700'}`}>{selected.kunReading || '—'}</p>
                    {selected.kunReading && <button onClick={() => speak(selected.kunReading)} className="text-xs text-green-600 mt-1 flex items-center gap-1"><Volume2 size={12} />Nghe</button>}
                  </div>
                </>
              ) : (
                <div className={`col-span-2 p-3 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-blue-50'}`}>
                  <p className="text-xs text-gray-400 mb-1">Pinyin (拼音)</p>
                  <p className={`font-semibold text-2xl ${darkMode ? 'text-white' : 'text-blue-700'}`}>{selected.onReading}</p>
                </div>
              )}
              <div className={`p-3 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-purple-50'}`}>
                <p className="text-xs text-gray-400 mb-1">Hán Việt</p>
                <p className={`font-semibold text-lg ${darkMode ? 'text-white' : 'text-purple-700'}`}>{selected.hanViet || '—'}</p>
              </div>
              <div className={`p-3 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-orange-50'}`}>
                <p className="text-xs text-gray-400 mb-1">Nghĩa</p>
                <p className={`font-semibold ${darkMode ? 'text-white' : 'text-orange-700'}`}>{selected.meaningVi}</p>
                {selected.meaningEn && <p className="text-xs text-gray-500 mt-0.5">EN: {selected.meaningEn}</p>}
              </div>
            </div>

            {selected.mnemonic && (
              <aside className={`p-4 rounded-xl mb-4 ${darkMode ? 'bg-yellow-900/20 border-yellow-700/50' : 'bg-yellow-50 border-yellow-200'} border`}>
                <p className="text-xs text-gray-400 mb-1">💡 Mẹo nhớ</p>
                <p className={`text-sm leading-relaxed ${darkMode ? 'text-yellow-200' : 'text-yellow-900'}`}>{selected.mnemonic}</p>
              </aside>
            )}

            <aside className={`p-4 rounded-xl mb-4 ${darkMode ? 'bg-gray-700' : 'bg-gray-50'}`}>
              <p className="text-xs text-gray-400 mb-2">✏️ Thứ tự viết (tự động)</p>
              <div className="flex justify-center">

                <KanjiStrokeOrder
                  character={selected.character}
                  strokeOrderJson={selected.strokeOrderJson}
                  size={220}
                />
              </div>
              <p className="text-sm text-gray-400 italic mt-3">
                Tip: Nguyên tắc cơ bản: trên trước dưới sau, trái trước phải sau, ngang trước dọc sau.
              </p>

              {lang === 'ja' && (
                <a href={`https://jisho.org/search/${encodeURIComponent(selected.character)}%20%23kanji`} target="_blank" rel="noopener noreferrer"
                  className="text-xs text-blue-500 mt-2 inline-block hover:underline">
                  📖 Xem chi tiết trên Jisho.org →
                </a>
              )}
              {lang === 'zh' && (
                <a href={`https://www.mdbg.net/chinese/dictionary?wdqb=${encodeURIComponent(selected.character)}`} target="_blank" rel="noopener noreferrer"
                  className="text-xs text-blue-500 mt-2 inline-block hover:underline">
                  📖 Xem chi tiết trên MDBG.net →
                </a>
              )}
            </aside>

            <div className="flex gap-3 items-center">
              <button onClick={() => speak(selected.character)} className="flex-1 py-2.5 bg-blue-100 text-blue-600 rounded-xl font-medium hover:bg-blue-200 flex items-center justify-center gap-2">
                <Volume2 size={18} /> Phát âm
              </button>

              <div className="px-3">
                <FavoriteButton itemType="CHARACTER" itemId={selected.id} />
              </div>
              <button onClick={() => setSelected(null)} className="flex-1 py-2.5 bg-gray-200 rounded-xl font-medium hover:bg-gray-300">Đóng</button>
            </div>
          </article>
        </div>
      )}
    </div>
  )
}
