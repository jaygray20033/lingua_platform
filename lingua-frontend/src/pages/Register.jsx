import { useState } from 'react'
import { useNavigate, useLocation, Link } from 'react-router-dom'
import { authAPI } from '../api'
import { useAuthStore, useAppStore } from '../store'
import { useDocumentTitle } from '../hooks/useDocumentTitle'
import { Moon, Sun } from 'lucide-react'

export default function Register() {
  useDocumentTitle('Đăng ký')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
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
    if (password !== confirmPassword) {
      setError('Mật khẩu xác nhận không khớp.')
      return
    }
    if (password.length < 6) {
      setError('Mật khẩu phải có ít nhất 6 ký tự.')
      return
    }
    setLoading(true)
    try {
      const cleanEmail = email.trim().toLowerCase()
      const cleanName = (displayName || cleanEmail.split('@')[0]).trim()
      const res = await authAPI.register(cleanEmail, password, cleanName)
      const data = res.data?.data
      if (!data?.token) throw new Error('Invalid server response')
      login(data.user, data.token)
      if (data.refreshToken) {
        localStorage.setItem('lingua_refresh_token', data.refreshToken)
      }
      navigate(redirectTo, { replace: true })
    } catch (err) {
      if (err?.response?.status === 429) {
        setError('Quá nhiều yêu cầu, vui lòng thử lại sau vài phút.')
      } else if (err?.response?.status === 409) {
        setError('Email này đã được đăng ký.')
      } else {
        setError(
          err?.response?.data?.message || err.message || 'Đăng ký thất bại',
        )
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

      <section
        id="register-card"
        className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl max-w-md w-full p-8"
      >
        <header className="mb-6 text-center">
          <h1 className="text-3xl font-bold text-green-600 dark:text-green-400">
            Lingua
          </h1>
          <p className="text-gray-500 dark:text-gray-400 mt-2">
            Tạo tài khoản mới để bắt đầu học
          </p>
        </header>

        <form onSubmit={handleSubmit} className="space-y-4">
          <input
            type="text"
            placeholder="Tên hiển thị"
            value={displayName}
            onChange={e => setDisplayName(e.target.value)}
            className="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400"
            required
          />
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
            placeholder="Mật khẩu (≥ 6 ký tự)"
            value={password}
            onChange={e => setPassword(e.target.value)}
            className="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400"
            required
            minLength={6}
          />
          <input
            type="password"
            placeholder="Xác nhận mật khẩu"
            value={confirmPassword}
            onChange={e => setConfirmPassword(e.target.value)}
            className="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-green-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400"
            required
            minLength={6}
          />
          {error && (
            <p className="text-red-600 dark:text-red-400 text-sm">{error}</p>
          )}
          <button
            type="submit"
            disabled={loading}
            className="w-full bg-green-500 hover:bg-green-600 text-white font-semibold py-3 rounded-lg disabled:opacity-50"
          >
            {loading ? 'Đang xử lý…' : 'Đăng ký'}
          </button>
        </form>

        <p className="mt-4 text-center text-sm text-gray-500 dark:text-gray-400">
          Đã có tài khoản?{' '}
          <Link
            to="/login"
            className="text-green-600 dark:text-green-400 font-semibold hover:underline"
          >
            Đăng nhập
          </Link>
        </p>
      </section>
    </main>
  )
}
