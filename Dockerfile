FROM node:22.12-alpine AS builder

# Копируем проект вместе с tsconfig.json
COPY . /app
COPY tsconfig.json /app/tsconfig.json

WORKDIR /app

# Устанавливаем зависимости
RUN npm install

# Сборка проекта
RUN npm run build

FROM node:22-alpine AS release

WORKDIR /app

# Копируем собранный проект
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/package-lock.json /app/package-lock.json

ENV NODE_ENV=production

# Устанавливаем только production зависимости
RUN npm ci --omit=dev

ENTRYPOINT ["node", "dist/index.js"]