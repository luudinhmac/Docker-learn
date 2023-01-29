FROM node:12.18-alpine

WORKDIR /app

RUN npm install -g pm2

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install --production --silent

COPY . .

RUN adduser -D -u 1001 appuser -G dialout

RUN chown -R appuser:dialout /app

USER appuser

CMD ["pm2-runtime", "ecosystem.config.js", "--env", "production"]
