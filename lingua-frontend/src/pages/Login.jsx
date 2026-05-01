import { useState } from 'react'
import { useNavigate, useLocation, Link } from 'react-router-dom'
import { authAPI } from '../api'
import { useAuthStore, useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { Moon, Sun } from 'lucide-react'

export default function Login() {
  useDocumentTitle('Đăng nhập')
  const [mode, setMode] = useState('login')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [displayName, setDisplayName] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const login = useAuthStore(s => s.login)
  const { darkMode, toggleDarkMode } = useAppStore()
  const navigate = useNavigate()
  const location = useLocation()

  const redirectTo = location.state?.from || '/'

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      const cleanEmail = email.trim().toLowerCase()
      const cleanName = (displayName || cleanEmail.split('@')[0]).trim()
      const res = mode === 'login'
        ? await authAPI.login(cleanEmail, password)
        : await authAPI.register(cleanEmail, password, cleanName)
      const data = res.data?.data
      if (!data?.token) throw new Error('Invalid server response')
      login(data.user, data.token)
      if (data.refreshToken) localStorage.setItem('lingua_refresh_token', data.refreshToken)
      navigate(redirectTo, { replace: true })
    } catch (err) {
      if (err?.response?.status === 429) {
        setError('Quá nhiều yêu cầu, vui lòng thử lại sau vài phút.')
      } else if (err?.response?.status === 403) {
        setError(err?.response?.data?.message || 'Tài khoản đã bị tạm khoá.')
      } else {
        setError(err?.response?.data?.message || err.message || 'Failed')
      }
    } finally {
      setLoading(false)
    }
  }

  return (
    <main className="min-h-screen flex items-center justify-center bg-gradient-to-br from-green-50 to-blue-50 dark:from-gray-900 dark:to-gray-800 p-4">
      <button
        type="button"
        onClick={toggleDarkMode}
        aria-label={darkMode ? 'Chuyển sang chế độ sáng' : 'Chuyển sang chế độ tối'}
        className="fixed top-4 right-4 p-2 rounded-full bg-white dark:bg-gray-800 shadow-md hover:shadow-lg text-gray-600 dark:text-gray-300 transition"
      >
        {darkMode ? <Sun size={18} /> : <Moon size={18} />}
      </button>

      <section id="auth-card" className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl max-w-md w-full p-8">
        <header className="mb-6 text-center">
          <h1 className="text-3xl font-bold text-green-600 dark:text-green-400">Lingua</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-2">
            {mode === 'login' ? 'Đăng nhập để tiếp tục học' : 'Tạo tài khoản mới'}
          </p>
        </header>

        <form onSubmit={handleSubmit} className="space-y-4">
          {mode === 'register' && (
            <input
              type="text"
              placeholder="Tên hiển thị"
              value={displayName}
              onChange={e => setDisplayName(e.target.value)}
              className="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400"
              required
            />
          )}
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            className="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400"
            required
          />
          <input
            type="password"
            placeholder="Mật khẩu"
            value={password}
            onChange={e => setPassword(e.target.value)}
            className="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400"
            required
            minLength={6}
          />
          {error && <p className="text-red-600 dark:text-red-400 text-sm">{error}</p>}
          <button
            type="submit"
            disabled={loading}
            className="w-full bg-green-500 hover:bg-green-600 text-white font-semibold py-3 rounded-lg disabled:opacity-50"
          >
            {loading ? '...' : mode === 'login' ? 'Đăng nhập' : 'Đăng ký'}
          </button>
        </form>

        <p className="mt-4 text-center text-sm text-gray-500 dark:text-gray-400">
          {mode === 'login' ? 'Chưa có tài khoản?' : 'Đã có tài khoản?'}{' '}
          <button
            type="button"
            onClick={() => setMode(mode === 'login' ? 'register' : 'login')}
            className="text-green-600 dark:text-green-400 font-semibold hover:underline"
          >
            {mode === 'login' ? 'Đăng ký nhanh' : 'Đăng nhập'}
          </button>
        </p>
        {mode === 'login' && (
          <p className="mt-2 text-center text-xs text-gray-400 dark:text-gray-500">
            Hoặc{' '}
            <Link
              to="/register"
              className="text-green-600 dark:text-green-400 hover:underline"
            >
              tạo tài khoản trên trang đăng ký riêng
            </Link>
          </p>
        )}
      </section>
    </main>
  )
}
