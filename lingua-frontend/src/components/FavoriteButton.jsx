import { useEffect, useState } from 'react'
import { favoriteAPI } from '../api'

export default function FavoriteButton({ itemType, itemId, size = 'md' }) {
  const [favorited, setFavorited] = useState(false)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    let cancelled = false
    async function check() {
      if (!itemType || !itemId) return
      try {
        const r = await favoriteAPI.check(itemType, itemId)
        if (!cancelled) setFavorited(!!r.data?.data?.favorited)
      } catch {  }
    }
    check()
    return () => { cancelled = true }
  }, [itemType, itemId])

  async function toggle(e) {
    e.stopPropagation()
    e.preventDefault()
    if (loading || !itemType || !itemId) return
    const wasFavorited = favorited
    setFavorited(!wasFavorited)
    setLoading(true)
    try {
      if (wasFavorited) await favoriteAPI.remove(itemType, itemId)
      else await favoriteAPI.add(itemType, itemId)
    } catch {
      setFavorited(wasFavorited)
    } finally {
      setLoading(false)
    }
  }

  const cls = size === 'sm' ? 'text-lg' : 'text-2xl'
  return (
    <button
      type="button"
      onClick={toggle}
      disabled={loading}
      aria-pressed={favorited}
      aria-label={favorited ? 'Bỏ đánh dấu' : 'Đánh dấu yêu thích'}
      className={`${cls} transition-transform hover:scale-110 disabled:opacity-50`}
      title={favorited ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}
    >
      {favorited ? '★' : '☆'}
    </button>
  )
}
