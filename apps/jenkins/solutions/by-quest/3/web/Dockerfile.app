FROM alpine:3.3

RUN apk --no-cache add py-pip libpq python-dev curl

RUN pip install flask==0.10.1 python-consul gunicorn

ADD / /app

WORKDIR /app

EXPOSE 5000 7000

HEALTHCHECK CMD curl --fail http://localhost:5000/health || exit 1

CMD python app.py 
