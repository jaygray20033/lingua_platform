import { useState, useEffect } from 'react'
import { vocabAPI } from '../api'
import { useAppStore } from '../store'
import { Volume2, BookOpen } from 'lucide-react'

export default function GrammarExplorer() {
  const [grammars, setGrammars] = useState([])
  const [level, setLevel] = useState('N5')
  const [expanded, setExpanded] = useState(null)
  const { darkMode } = useAppStore()
  const levels = ['N5','N4','N3','N2','N1']

  useEffect(() => {
    vocabAPI.getGrammars({ lang: 'ja', level }).then(r => setGrammars(r.data.data || []))
  }, [level])

  const speak = (text) => {
    const u = new SpeechSynthesisUtterance(text)
    u.lang = 'ja-JP'; u.rate = 0.7; speechSynthesis.speak(u)
  }

  return (
    <div className="max-w-4xl mx-auto">
      <h1 className={`text-2xl font-bold mb-6 ${darkMode ? 'text-white' : ''}`}>📖 Ngữ pháp tiếng Nhật</h1>

      <div className="flex gap-2 mb-6">
        {levels.map(l => (
          <button key={l} onClick={() => setLevel(l)}
            className={`px-4 py-2 rounded-full text-sm font-medium transition ${level === l ? 'bg-green-500 text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'}`}>
            {l}
          </button>
        ))}
      </div>

      <div className="space-y-3">
        {grammars.map((g, idx) => (
          <div key={g.id} className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} rounded-xl border overflow-hidden`}>
            <button onClick={() => setExpanded(expanded === g.id ? null : g.id)}
              className={`w-full flex items-center gap-4 p-4 text-left hover:bg-opacity-80 transition ${darkMode ? 'hover:bg-gray-750' : 'hover:bg-gray-50'}`}>
              <span className="w-8 h-8 rounded-full bg-gradient-to-r from-green-400 to-blue-500 flex items-center justify-center text-white text-sm font-bold">
                {idx + 1}
              </span>
              <div className="flex-1">
                <p className={`font-bold text-lg ${darkMode ? 'text-white' : ''}`}>{g.pattern}</p>
                <p className="text-sm text-gray-400">{g.meaningVi} | {g.meaningEn}</p>
              </div>
              <span className={`text-xs px-2 py-1 rounded-full ${darkMode ? 'bg-gray-700' : 'bg-gray-100'} text-gray-500`}>{g.jlptLevel}</span>
            </button>

            {expanded === g.id && (
              <div className={`px-4 pb-4 border-t ${darkMode ? 'border-gray-700' : 'border-gray-100'}`}>
                <div className="mt-3 space-y-3">
                  <div className={`p-3 rounded-lg ${darkMode ? 'bg-gray-700' : 'bg-blue-50'}`}>
                    <p className="text-xs text-gray-400 mb-1">📐 Cấu trúc</p>
                    <p className={`font-medium ${darkMode ? 'text-blue-300' : 'text-blue-700'}`}>{g.structure}</p>
                  </div>

                  {g.exampleSentence && (
                    <div className={`p-3 rounded-lg ${darkMode ? 'bg-gray-700' : 'bg-green-50'}`}>
                      <p className="text-xs text-gray-400 mb-1">✏️ Ví dụ</p>
                      <div className="flex items-center gap-2">
                        <p className={`font-medium text-lg ${darkMode ? 'text-green-300' : 'text-green-700'}`}>{g.exampleSentence}</p>
                        <button onClick={() => speak(g.exampleSentence)} className="p-1 hover:bg-green-100 rounded-full">
                          <Volume2 size={16} className="text-green-500" />
                        </button>
                      </div>
                      {g.exampleTranslation && <p className="text-sm text-gray-400 mt-1">→ {g.exampleTranslation}</p>}
                    </div>
                  )}

                  {g.note && (
                    <div className={`p-3 rounded-lg ${darkMode ? 'bg-gray-700' : 'bg-yellow-50'}`}>
                      <p className="text-xs text-gray-400 mb-1">💡 Ghi chú</p>
                      <p className={`text-sm ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>{g.note}</p>
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}
