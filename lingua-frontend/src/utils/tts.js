
const LANG_MAP = {
  ja: 'ja-JP', 'ja-JP': 'ja-JP',
  zh: 'zh-CN', 'zh-CN': 'zh-CN', 'zh-TW': 'zh-TW',
  en: 'en-US', 'en-US': 'en-US', 'en-GB': 'en-GB',
  vi: 'vi-VN', 'vi-VN': 'vi-VN',
  ko: 'ko-KR',
}

let cachedVoices = null
let currentAudio = null

function loadVoices() {
  if (typeof window === 'undefined' || !window.speechSynthesis) return []
  if (cachedVoices && cachedVoices.length) return cachedVoices
  cachedVoices = window.speechSynthesis.getVoices() || []
  return cachedVoices
}

if (typeof window !== 'undefined' && window.speechSynthesis) {

  window.speechSynthesis.addEventListener?.('voiceschanged', () => {
    cachedVoices = window.speechSynthesis.getVoices() || []
  })
}

export function isSpeechSupported() {
  return typeof window !== 'undefined' && !!window.speechSynthesis
}

function findVoice(lang) {
  const voices = loadVoices()
  if (!voices.length) return null
  const exact = voices.find(v => v.lang === lang)
  if (exact) return exact
  const prefix = (lang || '').split('-')[0]
  return voices.find(v => v.lang && v.lang.startsWith(prefix)) || null
}

export function stopSpeaking() {
  try { window.speechSynthesis?.cancel() } catch (_) {}
  if (currentAudio) {
    try { currentAudio.pause() } catch (_) {}
    currentAudio = null
  }
}

export function speak(input, opts = {}) {
  let text, audioUrl, lang
  if (typeof input === 'string') {
    text = input
    lang = opts.lang
  } else if (input && typeof input === 'object') {
    text = input.text
    audioUrl = input.audioUrl
    lang = input.lang || opts.lang
  } else {
    return
  }
  if (!text && !audioUrl) return

  const targetLang = LANG_MAP[lang] || lang || 'en-US'
  const rate = opts.rate ?? 0.85
  const onEnd = opts.onEnd || (() => {})
  const onError = opts.onError || (() => {})

  stopSpeaking()

  if (audioUrl) {
    try {
      const a = new Audio(audioUrl)
      currentAudio = a
      a.onended = () => { currentAudio = null; onEnd() }
      a.onerror = () => { currentAudio = null; tryWebSpeech(text, targetLang, rate, onEnd, onError) }
      a.play().catch(() => tryWebSpeech(text, targetLang, rate, onEnd, onError))
      return
    } catch (_) {

    }
  }

  tryWebSpeech(text, targetLang, rate, onEnd, onError)
}

function tryWebSpeech(text, lang, rate, onEnd, onError) {
  if (!text) { onEnd(); return }
  if (!isSpeechSupported()) {

    return onError(new Error('TTS_NOT_SUPPORTED'))
  }
  try {
    const u = new SpeechSynthesisUtterance(text)
    u.lang = lang
    u.rate = rate
    const v = findVoice(lang)
    if (v) {
      u.voice = v
    } else {

      console.warn(`[TTS] Không tìm thấy voice cho lang=${lang}. Hãy cài voice pack hệ điều hành hoặc dùng pre-generated audio (scripts/generate_audio_tts.py).`)
    }
    let ended = false
    u.onend = () => { ended = true; onEnd() }
    u.onerror = (e) => {
      if (!ended) onError(e)
    }
    window.speechSynthesis.speak(u)

    setTimeout(() => {
      if (!ended && !window.speechSynthesis.speaking && !window.speechSynthesis.pending) {
        onError(new Error('TTS_VOICE_NOT_AVAILABLE'))
      }
    }, 1500)
  } catch (e) {
    onError(e)
  }
}

export function certToLang(cert) {
  if (cert === 'JLPT') return 'ja-JP'
  if (cert === 'HSK') return 'zh-CN'
  if (cert === 'CEFR' || cert === 'IELTS') return 'en-US'
  if (cert === 'TOPIK') return 'ko-KR'
  return 'en-US'
}

export default { speak, stopSpeaking, isSpeechSupported, certToLang }
