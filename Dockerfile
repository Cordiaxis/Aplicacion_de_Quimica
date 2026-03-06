# ── Stage 1: Build ──────────────────────────────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copiar dependencias primero para aprovechar caché de capas
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copiar el resto del código y compilar
COPY . .
RUN flutter build web --release

# ── Stage 2: Serve ──────────────────────────────────────────────────────────
FROM nginx:alpine AS runner

# Eliminar config por defecto de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copiar el build generado
COPY --from=builder /app/build/web /usr/share/nginx/html

# Configuración personalizada de Nginx (SPA-friendly)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
