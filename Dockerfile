FROM python:3.8.6

WORKDIR /src
COPY requirements.txt /src
RUN pip install -r requirements.txt
COPY . /src

FROM ubuntu:20.04

RUN mkdir runner

RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y --no-install-recommends \
                        docker-compose \
                        docker.io \
                        awscli \
                        tar \
                        unzip \
                        apt-transport-https \
                        ca-certificates \
                        sudo \
                        gnupg-agent \
                        software-properties-common \
                        build-essential \
                        zlib1g-dev \
                        zstd \
                        gettext \
                        libcurl4-openssl-dev \
                        inetutils-ping \
                        jq \
                        wget \
                        dirmngr \
                        openssh-client \
                        locales \
                        python3-pip \
                        jq \
    && apt-get clean \
    && rm -rf  /var/lib/apt/lists/*
    
RUN mkdir actions-runner \
    && cd actions-runner \
    && curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz \
    && tar xzf ./actions-runner-linux-x64-2.278.0.tar.gz \
    && ./config.sh --url https://github.com/DoktaPola/tgBot --token AKS7BHAMI7EYFNWFDIXFEM3AUVERA
    
WORKDIR runner
COPY . .
ENV RUNNER_ALLOW_RUNASROOT 1
CMD ./run.sh
