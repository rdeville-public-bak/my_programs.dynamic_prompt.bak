FROM ubuntu:18.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

WORKDIR /root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        zsh \
        vim \
        direnv \
        git \
        python

COPY ./test/zsh/.zshrc /root/.zshrc
COPY ./test/.envrc /root/.envrc
RUN direnv allow
RUN chsh -s /bin/zsh  root
