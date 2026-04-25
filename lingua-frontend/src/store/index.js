import { create } from 'zustand'

export const useAuthStore = create((set) => ({
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
  }
}))

export const useAppStore = create((set) => ({
  sidebarOpen: true,
  darkMode: false,
  currentLanguage: 'ja',
  toggleSidebar: () => set(s => ({ sidebarOpen: !s.sidebarOpen })),
  toggleDarkMode: () => set(s => ({ darkMode: !s.darkMode })),
  setLanguage: (lang) => set({ currentLanguage: lang }),
}))

export const useGamificationStore = create((set) => ({
  xp: 0, gems: 50, hearts: 5, streak: 0, level: 1,
  setGamification: (data) => set({
    xp: data.totalXp || 0,
    gems: data.gems || 50,
    hearts: data.hearts || 5,
    streak: data.streakCount || 0,
    level: data.level || 1,
  }),
  addXp: (amount) => set(s => ({ xp: s.xp + amount })),
  loseHeart: () => set(s => ({ hearts: Math.max(0, s.hearts - 1) })),
}))
