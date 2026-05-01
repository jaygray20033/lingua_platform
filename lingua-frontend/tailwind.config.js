/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: { 50: '#eff6ff', 100: '#dbeafe', 200: '#bfdbfe', 300: '#93c5fd', 400: '#60a5fa', 500: '#3b82f6', 600: '#2563eb', 700: '#1d4ed8', 800: '#1e40af', 900: '#1e3a8a' },
        lingua: { green: '#58CC02', red: '#FF4B4B', orange: '#FF9600', blue: '#1CB0F6', purple: '#CE82FF', gold: '#FFD900' }
      },
      fontFamily: {
        sans: ['Inter', 'Noto Sans JP', 'Noto Sans SC', 'system-ui', 'sans-serif']
      }
    }
  },
  plugins: []
}
