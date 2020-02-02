#!/bin/bash

set -x

cd /opt/graphite/webapp/ && python3.7 manage.py migrate --run-syncdb --noinput
exec /usr/bin/supervisord
