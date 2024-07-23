#!/bin/sh
apt-get update -y && \
apt-get upgrade -y && \
apt-get install -q -y --no-install-suggests \
    ca-certificates \
    openssh-client \
    openssl \
    curl \
    zip \
    unzip \
    sudo \
    git
