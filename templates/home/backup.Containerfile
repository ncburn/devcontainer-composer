FROM alpine:latest

COPY ./templates/home/files/ /tmp/home/

RUN apk update && apk upgrade && \
    apk add curl bash zsh git && \
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /tmp/home/local/bin -t /tmp/home/local/share/oh-my-posh && \
    ZSH="/tmp/home/local/share/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
