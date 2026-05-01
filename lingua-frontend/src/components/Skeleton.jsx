import { useAppStore } from '../store'

const baseClass =
  'animate-pulse rounded-md bg-gray-200 dark:bg-gray-700'

export function SkeletonText({ width = 'w-full', height = 'h-4', className = '' }) {
  return <div className={`${baseClass} ${width} ${height} ${className}`} />
}

export function SkeletonCard({ className = '' }) {
  const { darkMode } = useAppStore()
  return (
    <div
      className={`p-5 rounded-2xl border ${
        darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
      } ${className}`}
      aria-busy="true"
      aria-live="polite"
    >
      <SkeletonText width="w-2/3" height="h-5" className="mb-3" />
      <SkeletonText width="w-full" height="h-3" className="mb-2" />
      <SkeletonText width="w-5/6" height="h-3" className="mb-2" />
      <SkeletonText width="w-1/3" height="h-3" />
    </div>
  )
}

export function SkeletonList({ count = 5, className = '' }) {
  return (
    <div className={`grid grid-cols-1 md:grid-cols-2 gap-4 ${className}`}>
      {Array.from({ length: count }).map((_, i) => (
        <SkeletonCard key={i} />
      ))}
    </div>
  )
}

export function SkeletonAvatar({ size = 'w-10 h-10' }) {
  return <div className={`${baseClass} ${size} rounded-full`} />
}

export function SkeletonRow({ className = '' }) {
  return (
    <div className={`flex items-center gap-3 ${className}`}>
      <SkeletonAvatar />
      <div className="flex-1 space-y-2">
        <SkeletonText width="w-1/3" height="h-3" />
        <SkeletonText width="w-2/3" height="h-3" />
      </div>
    </div>
  )
}

export default {
  SkeletonText,
  SkeletonCard,
  SkeletonList,
  SkeletonAvatar,
  SkeletonRow,
}
