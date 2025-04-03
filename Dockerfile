FROM node:22.12-alpine AS builder

# Копируем проект
COPY . /app

WORKDIR /app

# Устанавливаем все зависимости, включая dev-зависимости
RUN npm install

# Сборка проекта (уже есть в package.json)
RUN npm run build

FROM node:22-alpine AS release

WORKDIR /app

# Копируем собранный проект и необходимые файлы
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/package-lock.json /app/package-lock.json

ENV NODE_ENV=production

# Установка только production-зависимостей
RUN npm ci --omit=dev

ENTRYPOINT ["node", "dist/index.js"]