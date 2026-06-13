# ---- Build Stage ----
FROM node:20-alpine AS builder

WORKDIR /app

RUN npm install -g hexo-cli

COPY package.json package-lock.json* ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# ---- Production Stage ----
FROM nginx:stable-alpine

COPY --from=builder /app/public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
