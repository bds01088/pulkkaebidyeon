FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --silent
COPY . .
CMD [ "node", ".\quiz_server.js"]
EXPOSE 3001