import { useEffect } from 'react'

const DEFAULT_TITLE = 'Lingua — Nền tảng học ngoại ngữ'

export function useDocumentTitle(title) {
  useEffect(() => {
    if (typeof document === 'undefined') return undefined
    const previous = document.title
    document.title = title ? `${title} — Lingua` : DEFAULT_TITLE
    return () => {
      document.title = previous
    }
  }, [title])
}

export default useDocumentTitle
