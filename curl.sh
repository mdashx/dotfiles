# https://www.chrislatta.org/articles/web/curl/track-redirects-curl-command-line

curl -s -L -D - mdashx.com -o /dev/null -w '%{url_effective}'

curl -s -L -D - tomhyndman.com -o /dev/null -w '%{url_effective}'
