FROM ubuntu:18.04
RUN	echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive
ENV GRAPHITE_VERSION=1.1.6

# Install required packages
RUN apt-get -y update && \ 
    apt-get -y install software-properties-common python3.7 python3.7 python3.7-dev \
    python-django-tagging python-simplejson \
	python-memcache python-ldap python-cairo python-pysqlite2 python-support python3-pip \
	gunicorn supervisor nginx-light git wget curl build-essential python-dev libffi-dev vim jq

RUN     python3.7 -m pip install pip --upgrade
RUN     python3.7 -m pip install wheel
RUN     python3.7 -m pip install --upgrade setuptools
RUN     python3.7 -m pip install gunicorn

RUN     curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN     apt-get install -y nodejs
RUN     python3.7 -mpip install "Twisted==13.2.0"
RUN     python3.7 -m pip install pytz
RUN     git clone https://github.com/graphite-project/whisper.git /src/whisper            && \
        cd /src/whisper                                                                   && \
        git checkout ${GRAPHITE_VERSION}                                                  && \
        python3.7 setup.py install

RUN     git clone https://github.com/graphite-project/carbon.git /src/carbon              && \
        cd /src/carbon                                                                    && \
        git checkout ${GRAPHITE_VERSION}                                                  && \
        python3.7 setup.py install


RUN     git clone https://github.com/graphite-project/graphite-web.git /src/graphite-web  && \
        cd /src/graphite-web                                                              && \
        git checkout ${GRAPHITE_VERSION}								                  && \
        python3.7 setup.py install                                                        && \
        python3.7 -m pip install -r requirements.txt                                      && \
        python3.7 check-dependencies.py

# fixes fatal error "Your WhiteNoise configuration is incompatible with WhiteNoise v4.0"
RUN     /usr/bin/yes | pip uninstall whitenoise                                           && \
        python3.7 -m pip install "whitenoise<4"

# add system service config
ADD	./nginx/nginx.conf /etc/nginx/nginx.conf
ADD	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add graphite config
ADD	./webapp/initial_data.json /opt/graphite/webapp/graphite/initial_data.json
ADD	./webapp/local_settings.py.template /opt/graphite/webapp/graphite/local_settings.py.template
ADD	./conf/carbon.conf /opt/graphite/conf/carbon.conf
ADD	./conf/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD	./conf/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf
RUN	mkdir -p /opt/graphite/storage/whisper
RUN	touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index
RUN	chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
RUN	chmod 0664 /opt/graphite/storage/graphite.db
RUN cp /src/graphite-web/webapp/manage.py /opt/graphite/webapp

RUN mkdir /kube-watch
ADD package.json /kube-watch/package.json
ADD package-lock.json /kube-watch/package-lock.json
RUN cd /kube-watch && npm install
ADD kube-watch.js /kube-watch/kube-watch.js


ADD entrypoint.sh /entrypoint.sh

# Nginx
EXPOSE	80
# Carbon line receiver port
# EXPOSE	2003
# Carbon UDP receiver port
# EXPOSE	2003/udp
# Carbon pickle receiver port
# EXPOSE	2004
# Carbon cache query port
# EXPOSE	7002

CMD	["/entrypoint.sh"]
