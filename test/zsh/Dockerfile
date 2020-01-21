FROM ubuntu:18.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

COPY . /root/

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        zsh \
        vim \
        direnv \
        git \
        python

RUN cd /root && direnv allow
RUN cd /root 
RUN mv /root/hosts/common.sh /root/hosts/common.sh.bak
RUN mv /root/test/zsh/.zshrc /root/.zshrc
RUN chsh -s /bin/zsh  root
# ENTRYPOINT /bin/zsh -c 'source ~/.zshrc && echo "$PROMPT"'
