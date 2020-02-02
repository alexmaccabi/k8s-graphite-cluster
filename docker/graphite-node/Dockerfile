FROM python:3-buster

# RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y  supervisor nginx-light cron
ENV DEBIAN_FRONTEND=noninteractive
ENV GRAPHITE_VERSION=1.1.6

# Install required packages
# RUN     apt-get -y update && \ 
#     apt-get -y install software-properties-common python3.7 \
#     python3.7-dev python3-pip python3-django-tagging python3-simplejson \
#     python3-memcache python3-ldap python3-cairo python-pysqlite2 python-support  \
#     gunicorn supervisor nginx-light git wget curl build-essential libffi-dev vim

# RUN     cp /usr/bin/python3.7 /usr/bin/python

RUN pip install wheel
RUN pip install --upgrade setuptools
RUN pip install gunicorn

RUN     pip install "Twisted==19.10.0"
RUN     pip install pytz
RUN     git clone https://github.com/graphite-project/whisper.git /src/whisper            && \
        cd /src/whisper                                                                   && \
        git checkout ${GRAPHITE_VERSION}                                                  && \
        python setup.py install

RUN     git clone https://github.com/graphite-project/carbon.git /src/carbon              && \
        cd /src/carbon                                                                    && \
        git checkout ${GRAPHITE_VERSION}                                                  && \
        python setup.py install


RUN     git clone https://github.com/graphite-project/graphite-web.git /src/graphite-web  && \
        cd /src/graphite-web                                                              && \
        git checkout ${GRAPHITE_VERSION}								                  && \
        python setup.py install                                                           && \
        pip install -r requirements.txt                                                   && \
        python check-dependencies.py

# fixes fatal error "Your WhiteNoise configuration is incompatible with WhiteNoise v4.0"
RUN     /usr/bin/yes | pip uninstall whitenoise                                           && \
        pip install "whitenoise<4"

# Add system service config
ADD	./nginx/nginx.conf /etc/nginx/nginx.conf
ADD	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add graphite config
ADD	./webapp/initial_data.json /opt/graphite/webapp/graphite/initial_data.json
ADD	./webapp/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD	./conf/carbon.conf /opt/graphite/conf/carbon.conf
ADD	./conf/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD	./conf/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf
RUN	mkdir -p /opt/graphite/storage/whisper
RUN	touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index
RUN	chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
RUN	chmod 0664 /opt/graphite/storage/graphite.db
RUN cp /src/graphite-web/webapp/manage.py /opt/graphite/webapp

# Install curator cron job
ADD curator/cron /etc/cron.d/curator.cron
ADD curator/run.sh /etc/cron.d/curator.sh
RUN chmod +x /etc/cron.d/curator.sh

ADD entrypoint.sh /entrypoint.sh

# RUN alias python=python3.7

# Nginx
EXPOSE	80
# Carbon line receiver port
# EXPOSE	2003
# Carbon UDP receiver port
# EXPOSE	2003/udp
# Carbon pickle receiver port
EXPOSE	2004
# Carbon cache query port
# EXPOSE	7002

CMD	["/entrypoint.sh"]
