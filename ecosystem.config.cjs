const path = require('path')
const ROOT = path.resolve(__dirname)

module.exports = {
  apps: [
    {
      name: 'lingua-backend',
      script: path.join(ROOT, 'start-backend.sh'),
      cwd: ROOT,
      env: {
        JAVA_HOME: process.env.JAVA_HOME || '/usr/lib/jvm/java-21-openjdk-amd64'
      },
      watch: false,
      instances: 1,
      exec_mode: 'fork',
      out_file: path.join(ROOT, 'logs/backend-out.log'),
      error_file: path.join(ROOT, 'logs/backend-err.log'),
      merge_logs: true
    },
    {
      name: 'lingua-frontend',
      script: 'npx',
      args: 'vite --host 0.0.0.0 --port 3000',
      cwd: path.join(ROOT, 'lingua-frontend'),
      watch: false,
      instances: 1,
      exec_mode: 'fork',
      out_file: path.join(ROOT, 'logs/frontend-out.log'),
      error_file: path.join(ROOT, 'logs/frontend-err.log'),
      merge_logs: true
    }
  ]
}
