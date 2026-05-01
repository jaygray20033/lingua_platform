import { useEffect, useState } from 'react'
import { favoriteAPI } from '../api'
import { useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'

export default function Favorites() {

  useDocumentTitle('Yêu thích')
  const { darkMode } = useAppStore()
  const [type, setType] = useState('WORD')
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let cancelled = false
    async function load() {
      setLoading(true)
      try {
        const r = await favoriteAPI.list(type)
        if (!cancelled) setItems(r.data?.data || [])
      } finally {
        if (!cancelled) setLoading(false)
      }
    }
    load()
    return () => { cancelled = true }
  }, [type])

  async function remove(it) {
    await favoriteAPI.remove(it.itemType, it.itemId)
    setItems(items.filter(i => i.id !== it.id))
  }

  return (
    <main className={`p-6 ${darkMode ? 'text-white' : ''}`}>
      <header className="mb-6">
        <h1 className="text-3xl font-bold">⭐ Yêu thích</h1>
        <p className={darkMode ? 'text-gray-400' : 'text-gray-600'}>Danh sách từ / kanji / ngữ pháp đã lưu</p>
      </header>

      <nav className="mb-4 flex gap-2" aria-label="Loại yêu thích">
        {[
          { k: 'WORD', label: 'Từ vựng' },
          { k: 'CHARACTER', label: 'Kanji/Hán' },
          { k: 'GRAMMAR', label: 'Ngữ pháp' },
        ].map(t => (
          <button
            key={t.k}
            type="button"
            onClick={() => setType(t.k)}
            className={`px-4 py-2 rounded-lg font-medium ${
              type === t.k ? 'bg-green-500 text-white' : 'bg-gray-100 hover:bg-gray-200 dark:bg-gray-700'
            }`}
          >
            {t.label}
          </button>
        ))}
      </nav>

      {loading && <p className="text-gray-500">Đang tải…</p>}

      <ul className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
        {items.map(it => (
          <li
            key={it.id}
            className={`rounded-xl border p-4 flex items-start justify-between ${
              darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
            }`}
          >
            <div>
              {it.item ? (
                <>
                  <p className="text-xl font-semibold">
                    {it.item.text || it.item.character || it.item.pattern}
                  </p>
                  <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                    {it.item.reading || it.item.hanViet || ''}
                  </p>
                  <p className="text-sm mt-1">{it.item.meaningVi || ''}</p>
                </>
              ) : (
                <p className="text-sm text-gray-500">#{it.itemId} (đã xoá)</p>
              )}
            </div>
            <button onClick={() => remove(it)} className="text-yellow-500 text-xl" title="Bỏ yêu thích">★</button>
          </li>
        ))}
        {!loading && items.length === 0 && (
          <li className="col-span-full text-center text-gray-500 py-12">
            Chưa có mục nào. Hãy dùng nút ☆ ở các trang từ vựng/kanji/ngữ pháp.
          </li>
        )}
      </ul>
    </main>
  )
}
