import { Routes, Route } from 'react-router-dom'
import Layout from './components/Layout'
import ProtectedRoute from './components/ProtectedRoute'
import Dashboard from './pages/Dashboard'
import CourseCatalog from './pages/CourseCatalog'
import CourseDetail from './pages/CourseDetail'
import LearningPath from './pages/LearningPath'
import LessonPractice from './pages/LessonPractice'
import VocabularyExplorer from './pages/VocabularyExplorer'
import KanjiExplorer from './pages/KanjiExplorer'
import GrammarExplorer from './pages/GrammarExplorer'
import GrammarDetail from './pages/GrammarDetail'
import FlashcardSRS from './pages/FlashcardSRS'
import MockTestList from './pages/MockTestList'
import MockTestTake from './pages/MockTestTake'
import Login from './pages/Login'
import Register from './pages/Register'
import Profile from './pages/Profile'
import NotFound from './pages/NotFound'
import Leaderboard from './pages/Leaderboard'
import Achievements from './pages/Achievements'
import Analytics from './pages/Analytics'
import MyDecks from './pages/MyDecks'
import Favorites from './pages/Favorites'

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />

      <Route path="/register" element={<Register />} />

      <Route element={<ProtectedRoute><Layout /></ProtectedRoute>}>
        <Route path="/" element={<Dashboard />} />
        <Route path="/profile" element={<Profile />} />
        <Route path="/courses" element={<CourseCatalog />} />
        <Route path="/courses/:id" element={<CourseDetail />} />
        <Route path="/courses/:id/path" element={<LearningPath />} />
        <Route path="/lessons/:id" element={<LessonPractice />} />
        <Route path="/vocabulary" element={<VocabularyExplorer />} />
        <Route path="/kanji" element={<KanjiExplorer />} />
        <Route path="/grammar" element={<GrammarExplorer />} />
        <Route path="/grammar/:id" element={<GrammarDetail />} />
        <Route path="/flashcard" element={<FlashcardSRS />} />
        <Route path="/my-decks" element={<MyDecks />} />
        <Route path="/favorites" element={<Favorites />} />
        <Route path="/leaderboard" element={<Leaderboard />} />
        <Route path="/achievements" element={<Achievements />} />
        <Route path="/analytics" element={<Analytics />} />
        <Route path="/mock-tests" element={<MockTestList />} />
        <Route path="/mock-tests/:id" element={<MockTestTake />} />

        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  )
}
