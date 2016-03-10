FROM mhart/alpine-node:latest

MAINTAINER "Nitin Tutlani" <nitintutlani@yahoo.com>

RUN apk -U add ca-certificates nginx git openssl mysql-client curl bash \
	rm -rf /var/cache/apk/*

ENV HOME=/home \
	TERM=dumb \
	NPM_CONFIG_PREFIX=/home/npm \
	APP_ROOT=/home/app-root \
	APP_PUBLIC_PATH=public \
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/npm/bin:/home/app-root/node_modules/.bin

RUN curl -s -o /etc/nginx/nginx.conf https://raw.githubusercontent.com/david-strejc/nginx-docker/master/nginx.conf

RUN mkdir -p ${APP_ROOT} && \
	mkdir -p ${NPM_CONFIG_PREFIX} && \
	chown -R 1001:0 ${HOME} && \
	chmod -R ug+rwx ${HOME} && \
	mkdir /tmp/logs && \
	chown -R 1001:0 /tmp/logs && \
	chmod -R ug+rwx /tmp/logs && \
	mkdir /tmp/nginx && \
	chown -R 1001:0 /tmp/nginx && \
	chmod -R ug+rwx /tmp/nginx && \
	chmod ug+rwx /etc/nginx/nginx.conf && \
	sed -i -- 's#${APP_ROOT}#'"${APP_ROOT}"/"${APP_PUBLIC_PATH}"'#g' /etc/nginx/nginx.conf

WORKDIR ${APP_ROOT}

LABEL   io.k8s.description="Image for building and running nginx php-fpm based web applications" \
		io.k8s.display-name="Nginx php-fpm web application" \
		io.openshift.expose-services="8080:http" \
		io.openshift.tags="builder,nginx,php-fpm,web application"

EXPOSE 8080

USER 1001

CMD ["nginx"]
