all: website deploy

favicon:
	node gh-badge.js '' '' '#bada55' .png > web/favicon.png

website:
	cat try.html | sed "s,<img src='/,&/img.shields.io/," \
             | sed "s,<span id='imgUrlPrefix'>,&http://img.shields.io," \
	     | sed "s,<style>,<!-- Warning: this file was generated from try.html -->\n<style>," > index.html

deploy:
	git add -f Verdana.ttf
	git add -f secret.json
	git commit -m'MUST NOT BE ON GITHUB'
	git push -f heroku HEAD:master
	git reset HEAD~1
	(git checkout -B gh-pages && \
	git merge master && \
	git push -f origin gh-pages:gh-pages) || git checkout master
	git checkout master

setup:
	curl http://download.redis.io/releases/redis-2.8.8.tar.gz >redis.tar.gz \
	&& tar xf redis.tar.gz \
	&& rm redis.tar.gz \
	&& mv redis-2.8.8 redis \
	&& cd redis \
	&& make

redis:
	./redis/src/redis-server

test:
	npm test

.PHONY: all favicon website deploy setup redis test
