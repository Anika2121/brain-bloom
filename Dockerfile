ARG PYTHON_VERSION=3.12-slim

FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /code

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt
RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/
COPY . /code
RUN pip install --no-cache-dir -r requirements.txt --index-url https://download.pytorch.org/whl/cpu
ENV SECRET_KEY "eJiY666hRf1PAsAH0k8Jv9u2r4P58F2VF6zw4f06MvyI2ScfGB"
RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["celery", "-A", "brain-bloom-django", "worker", "--loglevel=info"]
