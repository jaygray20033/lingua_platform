import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  headers: { 'Content-Type': 'application/json' }
})

api.interceptors.request.use(config => {
  const token = localStorage.getItem('lingua_token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

let refreshInFlight = null

async function tryRefresh() {
  const refreshToken = localStorage.getItem('lingua_refresh_token')
  if (!refreshToken) return null
  if (!refreshInFlight) {
    refreshInFlight = axios.post('/api/auth/refresh', { refreshToken })
      .then(r => {
        const data = r.data?.data
        if (data?.token) {
          localStorage.setItem('lingua_token', data.token)
          if (data.refreshToken) localStorage.setItem('lingua_refresh_token', data.refreshToken)
          return data.token
        }
        return null
      })
      .catch(() => null)
      .finally(() => { refreshInFlight = null })
  }
  return refreshInFlight
}

api.interceptors.response.use(
  res => res,
  async err => {
    const original = err?.config
    const url = original?.url || ''
    const isAuthEndpoint = url.includes('/auth/refresh') || url.includes('/auth/login') || url.includes('/auth/register')

    if (err?.response?.status === 401 && original && !original._retry && !isAuthEndpoint) {
      original._retry = true
      const newToken = await tryRefresh()
      if (newToken) {
        original.headers = original.headers || {}
        original.headers.Authorization = `Bearer ${newToken}`
        return api.request(original)
      }
      const path = window.location.pathname
      if (!path.startsWith('/login')) {
        localStorage.removeItem('lingua_token')
        localStorage.removeItem('lingua_refresh_token')
        localStorage.removeItem('lingua_user')
        window.location.replace('/login')
      }
    }
    return Promise.reject(err)
  }
)

function normalizeEmail(email) {
  return (email || '').trim().toLowerCase()
}

export const authAPI = {
  login: (email, password) => api.post('/auth/login', { email: normalizeEmail(email), password }),
  register: (email, password, displayName) => api.post('/auth/register', {
    email: normalizeEmail(email),
    password,
    displayName: (displayName || '').trim(),
  }),
  me: () => api.get('/auth/me'),
  updateMe: (payload) => api.put('/auth/me', payload),
  refresh: (refreshToken) => api.post('/auth/refresh', { refreshToken }),
  logout: () => {
    const refreshToken = localStorage.getItem('lingua_refresh_token')
    return api.post('/auth/logout', refreshToken ? { refreshToken } : {})
  },
}

export const courseAPI = {
  list: (params) => api.get('/courses', { params }),
  get: (id) => api.get(`/courses/${id}`),
  getPath: (id) => api.get(`/courses/${id}/path`),
}

export const enrollmentAPI = {
  enroll: (courseId) => api.post(`/courses/${courseId}/enroll`),
  drop: (courseId) => api.delete(`/courses/${courseId}/enroll`),
  getOne: (courseId) => api.get(`/courses/${courseId}/enrollment`),
  listMine: () => api.get('/enrollments'),
}

export const lessonAPI = {
  get: (id) => api.get(`/lessons/${id}`),
  getExercises: (lessonId) => api.get(`/exercises/by-lesson/${lessonId}`),
  complete: (lessonId, payload) => api.post(`/lessons/${lessonId}/complete`, payload),
  getReviewQueue: () => api.get('/lessons/review-queue'),
}

export const questAPI = {
  getToday: () => api.get('/quests/today'),
  claim: (id) => api.post(`/quests/${id}/claim`),
  event: (category, amount = 1) => api.post('/quests/event', { category, amount }),
}

export const vocabAPI = {
  search: (params) => api.get('/words/search', { params }),
  getWord: (id) => api.get(`/words/${id}`),
  getCharacters: (params) => api.get('/characters', { params }),
  getCharacter: (charText) => api.get(`/characters/${charText}`),
  getGrammars: (params) => api.get('/grammars', { params }),
  getGrammarDetail: (id) => api.get(`/grammars/${id}`),
}

export const srsAPI = {
  getDue: () => api.get('/srs/due'),
  review: (reviewId, rating) => api.post(`/srs/${reviewId}/review`, { rating }),
  getDecks: () => api.get('/srs/decks'),
  getDeckCards: (deckId) => api.get(`/srs/decks/${deckId}/cards`),
}

export const myDeckAPI = {
  list: () => api.get('/my-decks'),
  create: (payload) => api.post('/my-decks', payload),
  delete: (deckId) => api.delete(`/my-decks/${deckId}`),
  addCard: (deckId, payload) => api.post(`/my-decks/${deckId}/cards`, payload),
  removeCard: (deckId, cardId) => api.delete(`/my-decks/${deckId}/cards/${cardId}`),
  start: (deckId) => api.post(`/my-decks/${deckId}/start`),
}

export const favoriteAPI = {
  add: (itemType, itemId) => api.post('/favorites', { itemType, itemId }),
  remove: (itemType, itemId) => api.delete(`/favorites/${itemType}/${itemId}`),
  list: (type) => api.get('/favorites', { params: type ? { type } : {} }),
  check: (type, id) => api.get('/favorites/check', { params: { type, id } }),
}

export const mockTestAPI = {
  list: (params) => api.get('/mock-tests', { params }),
  get: (id) => api.get(`/mock-tests/${id}`),
  submit: (testId, payload) => api.post(`/mock-tests/${testId}/submit`, payload),
  myAttempts: (params) => api.get('/mock-tests/attempts', { params }),
}

export const gamificationAPI = {
  getMe: () => api.get('/gamification/me'),
  getAchievements: () => api.get('/gamification/achievements'),
  evaluateAchievements: () => api.post('/gamification/achievements/evaluate'),
  getLanguages: () => api.get('/gamification/languages'),
  getLeaderboard: (period = 'all', limit = 10) => api.get('/gamification/leaderboard', { params: { period, limit } }),
  setDailyGoal: (xp) => api.put('/gamification/daily-goal', { xp }),
  refillHearts: () => api.post('/gamification/hearts/refill'),
  getAnalytics: (days = 14) => api.get('/gamification/analytics', { params: { days } }),
  buyStreakFreeze: () => api.post('/gamification/streak-freeze/buy'),
}

export default api
