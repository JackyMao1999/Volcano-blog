FROM m.daocloud.io/docker.io/library/node:20-alpine

WORKDIR /app

RUN npm install -g hexo-cli

COPY package.json package-lock.json* yarn.lock* ./
RUN npm install

COPY . .

EXPOSE 4000

CMD ["npm", "run", "server", "--", "--host", "0.0.0.0"]
