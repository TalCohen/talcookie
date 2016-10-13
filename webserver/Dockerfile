FROM python:3-alpine 
MAINTAINER Tal Cohen (tcohen@csh.rit.edu)

EXPOSE 8080

RUN adduser -S talcookie && \
mkdir -p /opt/talcookie

ADD . /opt/talcookie

RUN chown -R talcookie /opt/talcookie

WORKDIR /opt/talcookie

RUN pip install --no-cache-dir -r requirements.txt

USER talcookie

CMD gunicorn --workers=2 --bind ${TALCOOKIE_SERVER_IP:-0.0.0.0}:${TALCOOKIE_SERVER_PORT:-8080} app
