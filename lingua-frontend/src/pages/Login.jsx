import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authAPI } from '../api'
import { useAuthStore } from '../store'

export default function Login() {
  const [isRegister, setIsRegister] = useState(false)
  const [email, setEmail] = useState('demo@lingua.com')
  const [password, setPassword] = useState('password')
  const [name, setName] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()
  const { login } = useAuthStore()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true); setError('')
    try {
      const res = isRegister
        ? await authAPI.register(email, password, name)
        : await authAPI.login(email, password)
      if (res.data.success) {
        login(res.data.data.user, res.data.data.token)
        navigate('/')
      } else {
        setError(res.data.message || 'Đã có lỗi xảy ra')
      }
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể kết nối server')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 via-purple-600 to-pink-500 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl p-8 w-full max-w-md">
        <div className="text-center mb-8">
          <span className="text-5xl">🌐</span>
          <h1 className="text-3xl font-bold mt-2 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">Lingua</h1>
          <p className="text-gray-400 mt-1">Nền tảng học ngoại ngữ toàn diện</p>
        </div>

        {error && <div className="bg-red-50 text-red-600 p-3 rounded-xl text-sm mb-4">{error}</div>}

        <form onSubmit={handleSubmit} className="space-y-4">
          {isRegister && (
            <input value={name} onChange={e => setName(e.target.value)} placeholder="Tên hiển thị"
              className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500" required />
          )}
          <input value={email} onChange={e => setEmail(e.target.value)} type="email" placeholder="Email"
            className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500" required />
          <input value={password} onChange={e => setPassword(e.target.value)} type="password" placeholder="Mật khẩu"
            className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500" required />
          <button type="submit" disabled={loading}
            className="w-full py-3 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-xl font-bold text-lg hover:shadow-lg transition disabled:opacity-50">
            {loading ? '...' : isRegister ? 'Đăng ký' : 'Đăng nhập'}
          </button>
        </form>

        <div className="mt-6 text-center">
          <button onClick={() => setIsRegister(!isRegister)} className="text-blue-500 hover:underline text-sm">
            {isRegister ? 'Đã có tài khoản? Đăng nhập' : 'Chưa có tài khoản? Đăng ký'}
          </button>
        </div>

        <div className="mt-4 text-center text-xs text-gray-400">
          <p>Demo: demo@lingua.com / password</p>
        </div>
      </div>
    </div>
  )
}
