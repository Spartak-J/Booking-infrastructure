# Этап 1: Сборка приложения
FROM node:18-alpine as build

WORKDIR /app

# Копируем package files
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем ВСЕ файлы из context (frontend/)
COPY . .

# DEBUG
RUN ls -la && ls -la public/ && ls -la src/

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