FROM python:3-buster

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs supervisor

ENV DEBIAN_FRONTEND=noninteractive
ENV GRAPHITE_VERSION=1.1.6

RUN pip install wheel
RUN pip install --upgrade setuptools
RUN pip install gunicorn

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
