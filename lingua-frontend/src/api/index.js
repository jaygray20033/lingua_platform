import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  headers: { 'Content-Type': 'application/json' }
})

// Add auth token to requests
api.interceptors.request.use(config => {
  const token = localStorage.getItem('lingua_token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

// Auth
export const authAPI = {
  login: (email, password) => api.post('/auth/login', { email, password }),
  register: (email, password, displayName) => api.post('/auth/register', { email, password, displayName }),
}

// Courses
export const courseAPI = {
  list: (params) => api.get('/courses', { params }),
  get: (id) => api.get(`/courses/${id}`),
  getPath: (id) => api.get(`/courses/${id}/path`),
}

// Lessons
export const lessonAPI = {
  get: (id) => api.get(`/lessons/${id}`),
  getExercises: (lessonId) => api.get(`/exercises/by-lesson/${lessonId}`),
}

// Vocabulary
export const vocabAPI = {
  search: (params) => api.get('/words/search', { params }),
  getWord: (id) => api.get(`/words/${id}`),
  getCharacters: (params) => api.get('/characters', { params }),
  getCharacter: (charText) => api.get(`/characters/${charText}`),
  getGrammars: (params) => api.get('/grammars', { params }),
}

// SRS
export const srsAPI = {
  getDue: (userId) => api.get('/srs/due', { params: { userId } }),
  review: (reviewId, rating) => api.post(`/srs/${reviewId}/review`, { rating }),
  getDecks: () => api.get('/srs/decks'),
  getDeckCards: (deckId) => api.get(`/srs/decks/${deckId}/cards`),
}

// Mock Tests
export const mockTestAPI = {
  list: (params) => api.get('/mock-tests', { params }),
  get: (id) => api.get(`/mock-tests/${id}`),
}

// Gamification
export const gamificationAPI = {
  getMe: (userId) => api.get('/gamification/me', { params: { userId } }),
  getAchievements: () => api.get('/gamification/achievements'),
  getLanguages: () => api.get('/gamification/languages'),
}

export default api
