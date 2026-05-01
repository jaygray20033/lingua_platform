# BUG-11: Dockerfile cho frontend (multi-stage: build với Node, serve với Nginx)

# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /build

# Cache npm install
COPY package.json package-lock.json* ./
RUN npm ci || npm install

# Copy source và build
COPY . .
RUN npm run build

# Stage 2: Serve với Nginx slim
FROM nginx:alpine
# Cấu hình Nginx — proxy /api → backend:8080, fallback SPA về index.html
RUN rm /etc/nginx/conf.d/default.conf
COPY <<'EOF' /etc/nginx/conf.d/lingua.conf
server {
  listen 80;
  server_name _;
  root /usr/share/nginx/html;
  index index.html;

  # Static assets có cache dài
  location /assets/ {
    expires 30d;
    add_header Cache-Control "public, immutable";
    try_files $uri =404;
  }

  # Proxy API calls tới backend Quarkus
  location /api/ {
    proxy_pass http://backend:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_read_timeout 60s;
  }

  # SPA fallback — mọi route khác trả về index.html
  location / {
    try_files $uri $uri/ /index.html;
  }
}
EOF

COPY --from=builder /build/dist /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=15s --timeout=3s --retries=5 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1/ || exit 1
