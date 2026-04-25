import { useState, useEffect } from 'react'
import { vocabAPI } from '../api'
import { useAppStore } from '../store'
import { Volume2 } from 'lucide-react'

export default function KanjiExplorer() {
  const [kanjis, setKanjis] = useState([])
  const [level, setLevel] = useState('N5')
  const [selected, setSelected] = useState(null)
  const { darkMode } = useAppStore()
  const levels = ['N5','N4','N3','N2','N1']

  useEffect(() => {
    vocabAPI.getCharacters({ level }).then(r => setKanjis(r.data.data || []))
  }, [level])

  const speak = (text) => {
    const u = new SpeechSynthesisUtterance(text)
    u.lang = 'ja-JP'; u.rate = 0.7; speechSynthesis.speak(u)
  }

  return (
    <div className="max-w-6xl mx-auto">
      <h1 className={`text-2xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>🈶 Hán tự (Kanji)</h1>

      {/* Level tabs */}
      <div className="flex gap-2 mb-6">
        {levels.map(l => (
          <button key={l} onClick={() => setLevel(l)}
            className={`px-4 py-2 rounded-full text-sm font-medium transition ${level === l ? 'bg-red-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'}`}>
            {l}
          </button>
        ))}
      </div>

      {/* Kanji Grid - nhaikanji.com style */}
      <div className="grid grid-cols-4 md:grid-cols-6 lg:grid-cols-8 xl:grid-cols-10 gap-2">
        {kanjis.map(k => (
          <button key={k.id} onClick={() => setSelected(k)}
            className={`aspect-square flex flex-col items-center justify-center rounded-xl border transition hover:shadow-lg ${
              selected?.id === k.id ? 'border-red-500 bg-red-50 dark:bg-red-900/20' :
              darkMode ? 'bg-gray-800 border-gray-700 hover:border-gray-500' : 'bg-white border-gray-200 hover:border-red-300'
            }`}>
            <span className={`text-3xl font-bold ${darkMode ? 'text-white' : 'text-gray-800'}`}>{k.character}</span>
            <span className="text-xs text-gray-400 mt-1">{k.hanViet}</span>
          </button>
        ))}
      </div>

      {/* Kanji Detail */}
      {selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4" onClick={() => setSelected(null)}>
          <div className={`${darkMode ? 'bg-gray-800' : 'bg-white'} rounded-2xl p-8 max-w-xl w-full`} onClick={e => e.stopPropagation()}>
            <div className="text-center mb-6">
              <p className={`text-8xl font-bold mb-2 ${darkMode ? 'text-white' : ''}`}>{selected.character}</p>
              <div className="flex items-center justify-center gap-2">
                <span className="px-3 py-1 bg-red-100 text-red-600 rounded-full text-sm font-medium">{selected.jlptLevel}</span>
                <span className="px-3 py-1 bg-gray-100 text-gray-600 rounded-full text-sm">{selected.strokeCount} nét</span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4 mb-6">
              <div className={`p-4 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-blue-50'}`}>
                <p className="text-xs text-gray-400 mb-1">Âm On (音)</p>
                <p className={`font-semibold text-lg ${darkMode ? 'text-white' : 'text-blue-700'}`}>{selected.onReading}</p>
              </div>
              <div className={`p-4 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-green-50'}`}>
                <p className="text-xs text-gray-400 mb-1">Âm Kun (訓)</p>
                <p className={`font-semibold text-lg ${darkMode ? 'text-white' : 'text-green-700'}`}>{selected.kunReading}</p>
              </div>
              <div className={`p-4 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-purple-50'}`}>
                <p className="text-xs text-gray-400 mb-1">Hán Việt</p>
                <p className={`font-semibold text-lg ${darkMode ? 'text-white' : 'text-purple-700'}`}>{selected.hanViet}</p>
              </div>
              <div className={`p-4 rounded-xl ${darkMode ? 'bg-gray-700' : 'bg-orange-50'}`}>
                <p className="text-xs text-gray-400 mb-1">Nghĩa</p>
                <p className={`font-semibold ${darkMode ? 'text-white' : 'text-orange-700'}`}>{selected.meaningVi} / {selected.meaningEn}</p>
              </div>
            </div>

            {selected.mnemonic && (
              <div className={`p-4 rounded-xl mb-4 ${darkMode ? 'bg-gray-700' : 'bg-yellow-50'} border ${darkMode ? 'border-gray-600' : 'border-yellow-200'}`}>
                <p className="text-xs text-gray-400 mb-1">💡 Mẹo nhớ</p>
                <p className={`${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{selected.mnemonic}</p>
              </div>
            )}

            <div className="flex gap-3">
              <button onClick={() => speak(selected.onReading)} className="flex-1 py-2 bg-blue-100 text-blue-600 rounded-xl font-medium hover:bg-blue-200 flex items-center justify-center gap-2">
                <Volume2 size={18} /> Phát âm
              </button>
              <button onClick={() => setSelected(null)} className="flex-1 py-2 bg-gray-200 rounded-xl font-medium hover:bg-gray-300">Đóng</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
