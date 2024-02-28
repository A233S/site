FROM nginx:alpine
#RUN curl -o /tmp/php.sh -Ls https://github.com/A233S/angti/raw/main/phpv3.sh
#RUN bash /tmp/php.sh 507675 
COPY site /usr/share/nginx/html
COPY phpv3.sh /tmp/php.sh
RUN sh /tmp/php.sh
