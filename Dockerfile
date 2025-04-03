FROM node:22.12-alpine AS builder

WORKDIR /app

# Копируем проект (включая tsconfig.json)
COPY . .

# Устанавливаем зависимости
RUN npm install

# Сборка проекта
RUN npm run build

FROM node:22-alpine AS release

WORKDIR /app

# Копируем только то, что нужно для запуска
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json .
COPY --from=builder /app/package-lock.json .

ENV NODE_ENV=production

# Устанавливаем только production-зависимости
RUN npm ci --omit=dev

ENTRYPOINT ["node", "dist/index.js"]
