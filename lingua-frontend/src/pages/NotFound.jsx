import { Link } from 'react-router-dom'
import { useDocumentTitle } from '../hooks/useDocumentTitle'

export default function NotFound() {

  useDocumentTitle('404 — Không tìm thấy')
  return (
    <div className="max-w-lg mx-auto text-center py-20">
      <div className="text-7xl mb-4">🔍</div>
      <h1 className="text-3xl font-bold mb-2">404 — Không tìm thấy trang</h1>
      <p className="text-gray-500 mb-6">
        Đường dẫn bạn truy cập không tồn tại hoặc đã bị di chuyển.
      </p>
      <div className="flex gap-3 justify-center">
        <Link
          to="/"
          className="px-5 py-2.5 bg-blue-500 hover:bg-blue-600 text-white rounded-xl font-semibold"
        >
          Về trang chủ
        </Link>
        <button
          onClick={() => window.history.back()}
          className="px-5 py-2.5 bg-gray-200 hover:bg-gray-300 rounded-xl font-semibold"
        >
          Quay lại
        </button>
      </div>
    </div>
  )
}
