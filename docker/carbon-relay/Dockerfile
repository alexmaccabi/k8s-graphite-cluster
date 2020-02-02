FROM python:3-buster

# RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs supervisor

ENV DEBIAN_FRONTEND=noninteractive
ENV GRAPHITE_VERSION=1.1.6

# Install required packages
# RUN apt-get -y update && \ 
#     apt-get -y install software-properties-common python3.8 python3.8 python3.8-dev python3-pip \
#     python-django-tagging python-simplejson \
#     python-memcache python-ldap python-cairo python-pysqlite2 python-support python-pip \
#     gunicorn nginx-light git wget curl build-essential libffi-dev vim jq


# RUN apt-get update
# RUN apt-get install -y software-properties-common 
# RUN add-apt-repository ppa:jonathonf/python-3.6
# RUN apt-get update

# RUN apt-get install -y build-essential python3.6 python3.6-dev python3-pip libcairo2-dev curl git supervisor

# RUN python -m pip install pip --upgrade
RUN pip install wheel
RUN pip install --upgrade setuptools
RUN pip install gunicorn

# RUN python -m pip install pip --upgrade
# RUN pip install wheel
# RUN pip install --upgrade setuptools
# RUN pip install gunicorn
# RUN pip install supervisor





RUN pip install "Twisted==19.10.0"
RUN pip install pytz
RUN git clone https://github.com/graphite-project/whisper.git /src/whisper        && \
    cd /src/whisper                                                               && \
    git checkout ${GRAPHITE_VERSION}                                              && \
    python setup.py install

RUN git clone https://github.com/graphite-project/carbon.git /src/carbon          && \
    cd /src/carbon                                                                && \
    git checkout ${GRAPHITE_VERSION}                                              && \
    python setup.py install


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
