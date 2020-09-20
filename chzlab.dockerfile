FROM node:12.18.4-alpine3.9 as build-env

COPY . /app

WORKDIR /app

RUN yarn install && npm run build && echo '# chzlab.net\nUser-agent: *' > /app/public/robots.txt

FROM staticfloat/nginx-certbot:latest

COPY --from=build-env /app/public /app/chzlab.net

ENV CERTBOT_EMAIL chzhonge@gmail.com
COPY config/nginx/chzlab.net-new /etc/nginx/conf.d/default.conf
