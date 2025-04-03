FROM node:22.12-alpine AS builder

# Копируем ВСЁ сразу в /app (tsconfig.json уже включен)
COPY . /app
WORKDIR /app

# Устанавливаем зависимости и собираем проект
RUN npm install
RUN npm run build

FROM node:22-alpine AS release
WORKDIR /app

# Копируем собранные файлы
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/package-lock.json /app/package-lock.json

ENV NODE_ENV=production
RUN npm ci --omit=dev

ENTRYPOINT ["node", "dist/index.js"]