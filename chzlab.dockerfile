FROM node:12.18.4-alpine3.9 as build-env

COPY . /app

WORKDIR /app

RUN yarn install && npm run build

FROM nginx:1.17.8-alpine

COPY --from=build-env /app/public /app/chzlab.net

COPY config/nginx/chzlab.net /etc/nginx/conf.d/default.conf
