import { createContext, useContext, useState, useCallback, useEffect } from 'react'
import { CheckCircle2, AlertCircle, Info, XCircle, X } from 'lucide-react'

const ToastContext = createContext(null)

let _id = 0

export function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([])

  const remove = useCallback((id) => {
    setToasts(t => t.filter(x => x.id !== id))
  }, [])

  const push = useCallback((type, message, duration = 3000) => {
    const id = ++_id
    setToasts(t => [...t, { id, type, message }])
    if (duration > 0) setTimeout(() => remove(id), duration)
    return id
  }, [remove])

  const api = {
    success: (msg, d) => push('success', msg, d),
    error:   (msg, d) => push('error', msg, d ?? 4500),
    info:    (msg, d) => push('info', msg, d),
    warn:    (msg, d) => push('warn', msg, d),
    dismiss: remove,
  }

  return (
    <ToastContext.Provider value={api}>
      {children}
      <ToastViewport toasts={toasts} onClose={remove} />
    </ToastContext.Provider>
  )
}

function ToastViewport({ toasts, onClose }) {
  return (
    <div
      role="region"
      aria-label="Thông báo"
      aria-live="polite"
      className="fixed top-4 right-4 z-[9999] flex flex-col gap-2 pointer-events-none max-w-sm w-[calc(100%-2rem)]"
    >
      {toasts.map(t => (
        <ToastItem key={t.id} toast={t} onClose={() => onClose(t.id)} />
      ))}
    </div>
  )
}

function ToastItem({ toast, onClose }) {
  const [visible, setVisible] = useState(false)
  useEffect(() => {

    const r = requestAnimationFrame(() => setVisible(true))
    return () => cancelAnimationFrame(r)
  }, [])

  const styles = {
    success: { Icon: CheckCircle2, bar: 'bg-green-500',  ring: 'ring-green-200',  iconCls: 'text-green-500' },
    error:   { Icon: XCircle,      bar: 'bg-red-500',    ring: 'ring-red-200',    iconCls: 'text-red-500' },
    warn:    { Icon: AlertCircle,  bar: 'bg-yellow-500', ring: 'ring-yellow-200', iconCls: 'text-yellow-500' },
    info:    { Icon: Info,         bar: 'bg-blue-500',   ring: 'ring-blue-200',   iconCls: 'text-blue-500' },
  }
  const s = styles[toast.type] || styles.info
  const { Icon } = s

  return (
    <div
      role="status"
      className={`pointer-events-auto flex items-start gap-3 p-3 pr-2 rounded-xl shadow-lg ring-1 ${s.ring}
        bg-white dark:bg-gray-800 dark:ring-gray-700 transition-all duration-200
        ${visible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-4'}`}
    >
      <span className={`mt-0.5 ${s.iconCls}`}><Icon size={20} /></span>
      <p className="flex-1 text-sm text-gray-800 dark:text-gray-100 leading-snug">{toast.message}</p>
      <button
        type="button"
        onClick={onClose}
        aria-label="Đóng thông báo"
        className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 p-1"
      >
        <X size={16} />
      </button>
    </div>
  )
}

export function useToast() {
  const ctx = useContext(ToastContext)

  if (!ctx) {
    return {
      success: (m) => console.log('[toast.success]', m),
      error:   (m) => console.error('[toast.error]', m),
      info:    (m) => console.info('[toast.info]', m),
      warn:    (m) => console.warn('[toast.warn]', m),
      dismiss: () => {},
    }
  }
  return ctx
}

export default ToastProvider
