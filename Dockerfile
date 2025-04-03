FROM node:22-slim
WORKDIR /app

# Копируем файлы package.json 
COPY package*.json ./

# Устанавливаем корневые зависимости
RUN npm ci

# Копируем весь исходный код
COPY . .

# Компилируем TypeScript
RUN npm run build

# Переменная окружения для порта
ENV PORT=8080
EXPOSE 8080

# Переменная окружения для API Key
ENV BRAVE_API_KEY=""

# Запускаем приложение
CMD ["node", "dist/index.js"]