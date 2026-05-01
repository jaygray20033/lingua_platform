import { Navigate, useLocation } from 'react-router-dom'
import { useAuthStore } from '../store'

export default function ProtectedRoute({ children }) {
  const { isLoggedIn, token } = useAuthStore()
  const location = useLocation()

  const hasToken = isLoggedIn || !!token || !!localStorage.getItem('lingua_token')

  if (!hasToken) {
    return <Navigate to="/login" replace state={{ from: location.pathname + location.search }} />
  }
  return children
}
