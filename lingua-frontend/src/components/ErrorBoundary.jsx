import React from 'react'

export default class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props)
    this.state = { hasError: false, error: null }
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error }
  }

  componentDidCatch(error, info) {

    console.error('Uncaught error in React tree:', error, info)
  }

  handleReset = () => {
    this.setState({ hasError: false, error: null })
  }

  handleReload = () => {
    window.location.reload()
  }

  render() {
    if (!this.state.hasError) return this.props.children

    const message = this.state.error?.message || 'Lỗi không xác định'

    return (
      <div className="min-h-screen flex items-center justify-center p-6 bg-gray-50 dark:bg-gray-900">
        <div className="max-w-lg w-full bg-white dark:bg-gray-800 rounded-2xl shadow-xl p-8 text-center">
          <div className="text-6xl mb-4">😵</div>
          <h1 className="text-2xl font-bold mb-2 text-gray-900 dark:text-white">Đã có lỗi xảy ra</h1>
          <p className="text-gray-600 dark:text-gray-300 mb-4">
            Ứng dụng gặp sự cố không mong muốn. Bạn có thể thử lại hoặc tải lại trang.
          </p>
          <pre className="text-xs text-left bg-gray-100 dark:bg-gray-900/60 p-3 rounded-lg overflow-auto max-h-40 mb-6 text-red-600 dark:text-red-400">
            {message}
          </pre>
          <div className="flex gap-3 justify-center">
            <button
              onClick={this.handleReset}
              className="px-5 py-2.5 bg-blue-500 hover:bg-blue-600 text-white rounded-xl font-semibold"
            >
              Thử lại
            </button>
            <button
              onClick={this.handleReload}
              className="px-5 py-2.5 bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600 dark:text-gray-100 rounded-xl font-semibold"
            >
              Tải lại trang
            </button>
          </div>
        </div>
      </div>
    )
  }
}
