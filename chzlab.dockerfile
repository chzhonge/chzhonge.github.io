FROM nginx:1.17.8-alpine
COPY config/nginx/chzlab.net /etc/nginx/sites-enabled/chzlab.net
COPY config/nginx/default /etc/nginx/sites-enabled/default
COPY public /var/www/public
