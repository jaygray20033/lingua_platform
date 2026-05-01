import { create } from 'zustand'
import { persist, createJSONStorage } from 'zustand/middleware'

export const useAuthStore = create((set, get) => ({
  user: JSON.parse(localStorage.getItem('lingua_user') || 'null'),
  token: localStorage.getItem('lingua_token'),
  isLoggedIn: !!localStorage.getItem('lingua_token'),
  login: (user, token) => {
    localStorage.setItem('lingua_token', token)
    localStorage.setItem('lingua_user', JSON.stringify(user))
    set({ user, token, isLoggedIn: true })
  },
  logout: () => {
    localStorage.removeItem('lingua_token')
    localStorage.removeItem('lingua_user')
    set({ user: null, token: null, isLoggedIn: false })
  },
  updateUser: (updates) => {
    const next = { ...(get().user || {}), ...updates }
    localStorage.setItem('lingua_user', JSON.stringify(next))
    set({ user: next })
  },
  getUserId: () => {
    const u = get().user
    return u && u.id ? u.id : null
  },
}))

export const useAppStore = create((set) => ({
  sidebarOpen: true,
  darkMode: localStorage.getItem('lingua_dark') === '1',
  currentLanguage: localStorage.getItem('lingua_lang') || 'ja',
  toggleSidebar: () => set(s => ({ sidebarOpen: !s.sidebarOpen })),
  toggleDarkMode: () => set(s => {
    const next = !s.darkMode
    localStorage.setItem('lingua_dark', next ? '1' : '0')
    if (typeof document !== 'undefined') {
      document.documentElement.classList.toggle('dark', next)
    }
    return { darkMode: next }
  }),
  setLanguage: (lang) => {
    localStorage.setItem('lingua_lang', lang)
    set({ currentLanguage: lang })
  },
}))

export const useGamificationStore = create(
  persist(
    (set) => ({
      xp: 0,
      gems: 50,
      hearts: 5,
      streak: 0,
      level: 1,
      setGamification: (data) => set({
        xp: data.totalXp || 0,
        gems: data.gems || 50,
        hearts: data.hearts != null ? data.hearts : 5,
        streak: data.streakCount || 0,
        level: data.level || 1,
      }),
      addXp: (amount) => set(s => ({ xp: s.xp + amount })),
      loseHeart: () => set(s => ({ hearts: Math.max(0, s.hearts - 1) })),
      reset: () => set({ xp: 0, gems: 50, hearts: 5, streak: 0, level: 1 }),
    }),
    {
      name: 'lingua_gamification',
      storage: createJSONStorage(() => localStorage),
      partialize: (state) => ({
        xp: state.xp,
        gems: state.gems,
        hearts: state.hearts,
        streak: state.streak,
        level: state.level,
      }),
    }
  )
)
