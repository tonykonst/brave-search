FROM node:20

WORKDIR /app

# Сначала копируем файлы зависимостей
COPY package*.json ./
RUN npm ci

# Затем копируем весь остальной код
COPY . .

# Компилируем
RUN npm run build

CMD ["node", "dist/index.js"]
