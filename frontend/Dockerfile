# Этап 1: Сборка приложения
FROM node:18-alpine as build

WORKDIR /app

# Копируем package files
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# DEBUG: Покажем что есть перед копированием
RUN echo "=== Before COPY ===" && ls -la

# Копируем все файлы проекта
COPY public/ ./public/
COPY src/ ./src/

# DEBUG: Покажем что скопировалось
RUN echo "=== After COPY ===" && ls -la && \
    echo "=== Contents of public/ ===" && ls -la public/ && \
    echo "=== Contents of src/ ===" && ls -la src/

# Собираем приложение
RUN npm run build

# Этап 2: Production сервер
FROM nginx:alpine

# Копируем собранное приложение
COPY --from=build /app/build /usr/share/nginx/html

# Копируем конфигурацию Nginx для SPA
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]