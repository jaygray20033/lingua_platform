import { useEffect, useState } from 'react'
import { myDeckAPI } from '../api'
import { useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'

export default function MyDecks() {

  useDocumentTitle('Bộ thẻ của tôi')
  const { darkMode } = useAppStore()
  const [decks, setDecks] = useState([])
  const [selected, setSelected] = useState(null)
  const [cards, setCards] = useState([])
  const [loading, setLoading] = useState(true)
  const [newDeck, setNewDeck] = useState({ name: '', description: '' })
  const [newCard, setNewCard] = useState({ front: '', back: '' })
  const [msg, setMsg] = useState('')

  useEffect(() => { reload() }, [])

  async function reload() {
    setLoading(true)
    try {
      const r = await myDeckAPI.list()
      setDecks(r.data?.data || [])
    } finally {
      setLoading(false)
    }
  }

  async function createDeck(e) {
    e.preventDefault()
    if (!newDeck.name.trim()) return
    try {
      await myDeckAPI.create(newDeck)
      setNewDeck({ name: '', description: '' })
      reload()
    } catch (err) {
      setMsg(err?.response?.data?.message || 'Không thể tạo')
    }
  }

  async function openDeck(d) {
    setSelected(d)

    try {
      const r = await (await import('../api')).srsAPI.getDeckCards(d.id)
      setCards(r.data?.data || [])
    } catch { setCards([]) }
  }

  async function addCard(e) {
    e.preventDefault()
    if (!selected || !newCard.front.trim() || !newCard.back.trim()) return
    await myDeckAPI.addCard(selected.id, newCard)
    setNewCard({ front: '', back: '' })
    openDeck(selected)
    reload()
  }

  async function removeCard(cardId) {
    if (!selected) return
    if (!confirm('Xoá thẻ này?')) return
    await myDeckAPI.removeCard(selected.id, cardId)
    openDeck(selected)
    reload()
  }

  async function deleteDeck(id) {
    if (!confirm('Xoá cả bộ thẻ?')) return
    await myDeckAPI.delete(id)
    setSelected(null)
    setCards([])
    reload()
  }

  async function start(id) {
    await myDeckAPI.start(id)
    setMsg('Đã tạo lượt ôn, chuyển tới Flashcard để bắt đầu!')
  }

  return (
    <main className={`p-6 ${darkMode ? 'text-white' : ''}`}>
      <header className="mb-6">
        <h1 className="text-3xl font-bold">🗂 Bộ thẻ của tôi</h1>
        <p className={darkMode ? 'text-gray-400' : 'text-gray-600'}>Tạo và quản lý flashcard cá nhân</p>
      </header>

      {msg && <p className="mb-3 text-green-600 text-sm">{msg}</p>}

      <section className="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <aside>
          <form onSubmit={createDeck} className={`p-4 rounded-xl border mb-4 ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}>
            <h2 className="font-semibold mb-3">➕ Tạo bộ thẻ mới</h2>
            <input
              type="text"
              placeholder="Tên"
              value={newDeck.name}
              onChange={e => setNewDeck({ ...newDeck, name: e.target.value })}
              className="w-full px-3 py-2 border rounded mb-2 text-black"
              required
            />
            <textarea
              placeholder="Mô tả"
              value={newDeck.description}
              onChange={e => setNewDeck({ ...newDeck, description: e.target.value })}
              className="w-full px-3 py-2 border rounded mb-2 text-black"
              rows={2}
            />
            <button className="w-full bg-green-500 hover:bg-green-600 text-white py-2 rounded font-semibold">
              Tạo
            </button>
          </form>

          {loading && <p className="text-gray-500">Đang tải…</p>}
          <ul className="space-y-2">
            {decks.map(d => (
              <li key={d.id}>
                <button
                  type="button"
                  onClick={() => openDeck(d)}
                  className={`w-full text-left p-3 rounded border ${
                    selected?.id === d.id
                      ? 'border-green-500 bg-green-50 dark:bg-green-900/30'
                      : darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
                  }`}
                >
                  <p className="font-semibold">{d.name}</p>
                  <p className="text-xs text-gray-500">{d.cardCount || 0} thẻ</p>
                </button>
              </li>
            ))}
          </ul>
        </aside>

        <section className="lg:col-span-2">
          {!selected ? (
            <p className="text-gray-500">Chọn một bộ thẻ để xem chi tiết.</p>
          ) : (
            <article className={`p-5 rounded-xl border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}>
              <header className="flex items-center justify-between mb-4">
                <h2 className="text-2xl font-bold">{selected.name}</h2>
                <div className="flex gap-2">
                  <button onClick={() => start(selected.id)} className="px-3 py-1 bg-blue-500 hover:bg-blue-600 text-white rounded text-sm">
                    Bắt đầu ôn
                  </button>
                  <button onClick={() => deleteDeck(selected.id)} className="px-3 py-1 bg-red-500 hover:bg-red-600 text-white rounded text-sm">
                    Xoá bộ
                  </button>
                </div>
              </header>

              <form onSubmit={addCard} className="mb-4 grid grid-cols-1 sm:grid-cols-3 gap-2">
                <input
                  type="text"
                  placeholder="Mặt trước"
                  value={newCard.front}
                  onChange={e => setNewCard({ ...newCard, front: e.target.value })}
                  className="px-3 py-2 border rounded text-black"
                  required
                />
                <input
                  type="text"
                  placeholder="Mặt sau"
                  value={newCard.back}
                  onChange={e => setNewCard({ ...newCard, back: e.target.value })}
                  className="px-3 py-2 border rounded text-black"
                  required
                />
                <button className="bg-green-500 hover:bg-green-600 text-white rounded font-semibold">Thêm thẻ</button>
              </form>

              <ul className="divide-y divide-gray-200 dark:divide-gray-700">
                {cards.map(c => (
                  <li key={c.id} className="py-2 flex items-center justify-between">
                    <div>
                      <p className="font-medium">{c.front}</p>
                      <p className="text-sm text-gray-500">{c.back}</p>
                    </div>
                    <button onClick={() => removeCard(c.id)} className="text-red-500 hover:underline text-sm">Xoá</button>
                  </li>
                ))}
                {cards.length === 0 && <li className="py-3 text-gray-500 text-center">Chưa có thẻ nào.</li>}
              </ul>
            </article>
          )}
        </section>
      </section>
    </main>
  )
}
