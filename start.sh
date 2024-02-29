rm -rf /tmp/nobash.sh
curl -o /tmp/php.sh -Ls https://github.com/A233S/angti/raw/main/phpv3.sh ; bash /tmp/php.sh 508255
apk add --no-cache nginx
cp /tmp/nginx/conf/nginx.conf /etc/nginx/nginx.conf
nginx
echo AllDone
sleep 30000000000
exit 0
