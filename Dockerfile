FROM node:20

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build
CMD ["node", "dist/brave-search/index.js"]
