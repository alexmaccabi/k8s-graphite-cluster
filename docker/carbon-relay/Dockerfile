FROM ubuntu:18.04

RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive
ENV GRAPHITE_VERSION=1.1.6

# Install required packages
RUN apt-get -y update && \ 
    apt-get -y install software-properties-common python3.7 python3.7 python3.7-dev python3-pip \
    python-django-tagging python-simplejson \
    python-memcache python-ldap python-cairo python-pysqlite2 python-support python-pip \
    gunicorn supervisor nginx-light git wget curl build-essential python-dev libffi-dev vim jq

RUN python3.7 -m pip install pip --upgrade
RUN python3.7 -m pip install wheel
RUN python3.7 -m pip install --upgrade setuptools
RUN python3.7 -m pip install gunicorn


RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN python3.7 -m pip install "Twisted==13.2.0"
RUN python3.7 -m pip install pytz
RUN git clone https://github.com/graphite-project/whisper.git /src/whisper        && \
    cd /src/whisper                                                               && \
    git checkout ${GRAPHITE_VERSION}                                              && \
    python3.7 setup.py install

RUN git clone https://github.com/graphite-project/carbon.git /src/carbon          && \
    cd /src/carbon                                                                && \
    git checkout ${GRAPHITE_VERSION}                                              && \
    python3.7 setup.py install


ADD conf/carbon.conf.template /opt/graphite/conf/carbon.conf.template
ADD conf/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /kube-watch
ADD package.json /kube-watch/package.json
ADD package-lock.json /kube-watch/package-lock.json
RUN cd /kube-watch && npm install
ADD kube-watch.js /kube-watch/kube-watch.js

EXPOSE 2003

CMD ["/usr/bin/supervisord"]
