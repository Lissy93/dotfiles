FROM alpine:latest

LABEL maintainer "Alicia Sykes <https://aliciasykes.com>"
LABEL org.opencontainers.image.source https://github.com/lissy93/dotfiles

# Parameters
ARG user=alicia
ARG group=wheel
ARG uid=1000
ARG dotfiles=dotfiles.git
ARG userspace=userspace.git
ARG vcsprovider=github.com
ARG vcsowner=lissy93

# Install system packages, with root
USER root
RUN \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk upgrade --no-cache && \
  apk add --update --no-cache \
    sudo \
    autoconf \
    automake \
    libtool \
    nasm \
    ncurses \
    ca-certificates \
    libressl \
    bash-completion \
    cmake \
    ctags \
    file \
    curl \
    build-base \
    gcc \
    coreutils \
    wget \
    neovim \
    git git-doc \
    zsh \
    vim \
    tmux \
    docker \
    docker-compose

RUN \
  echo "%${group} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  adduser -D -G ${group} ${user} && \
  addgroup ${user} docker

COPY ./ /home/${user}/.userspace/

RUN \
  git clone --recursive https://${vcsprovider}/${vcsowner}/${dotfiles} /home/${user}/.dotfiles && \
  chown -R ${user}:${group} /home/${user}/.dotfiles && \
  chown -R ${user}:${group} /home/${user}/.userspace

ENV DOTFILES_DIR="$HOME/.dotfiles"

RUN chmod u+x /home/${user}/.dotfiles/install.sh

USER ${user}

RUN cd $HOME/.dotfiles && ./install.sh --auto-yes

ENV HISTFILE=/home/${user}/.cache/.zsh_history

CMD []

ENTRYPOINT [ "/bin/zsh" ]

# docker run -it --rm -w "$HOME" -v "$HOME/.userspace":/userspace -v $PWD:/cwd -v $HOME/.config:/config:rw -v /var/run/docker.sock:/var/run/docker.sock --network host dot-test

