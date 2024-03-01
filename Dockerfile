FROM ruby:2.7.6
RUN apt-get update && apt-get install  --no-install-recommends -y redis \
    python3 python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget ca-certificates curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev mecab-ipadic-utf8 git \
    && rm -rf /var/lib/apt/lists/*
ARG PYTHON_VERSION=3.11

ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN set -ex \
    && curl https://pyenv.run | bash \
    && pyenv update \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pyenv rehash

WORKDIR /app

WORKDIR /app/integration/app
COPY integration/app .
RUN bundle install

WORKDIR /app
COPY . /app

RUN pip3 install --upgrade pip setuptools wheel

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python3 setup.py install 