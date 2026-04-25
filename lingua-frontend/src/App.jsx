import { Routes, Route } from 'react-router-dom'
import Layout from './components/Layout'
import Dashboard from './pages/Dashboard'
import CourseCatalog from './pages/CourseCatalog'
import LearningPath from './pages/LearningPath'
import LessonPractice from './pages/LessonPractice'
import VocabularyExplorer from './pages/VocabularyExplorer'
import KanjiExplorer from './pages/KanjiExplorer'
import GrammarExplorer from './pages/GrammarExplorer'
import FlashcardSRS from './pages/FlashcardSRS'
import MockTestList from './pages/MockTestList'
import MockTestTake from './pages/MockTestTake'
import Login from './pages/Login'

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route element={<Layout />}>
        <Route path="/" element={<Dashboard />} />
        <Route path="/courses" element={<CourseCatalog />} />
        <Route path="/courses/:id/path" element={<LearningPath />} />
        <Route path="/lessons/:id" element={<LessonPractice />} />
        <Route path="/vocabulary" element={<VocabularyExplorer />} />
        <Route path="/kanji" element={<KanjiExplorer />} />
        <Route path="/grammar" element={<GrammarExplorer />} />
        <Route path="/flashcard" element={<FlashcardSRS />} />
        <Route path="/mock-tests" element={<MockTestList />} />
        <Route path="/mock-tests/:id" element={<MockTestTake />} />
      </Route>
    </Routes>
  )
}
