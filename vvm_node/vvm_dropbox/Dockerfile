FROM python:3.5

LABEL maintainer "@thomaswilley"

USER root
RUN mkdir -p /dropbox
WORKDIR /dropbox
EXPOSE 17500
EXPOSE 17500/udp

ARG VVM_USER
ARG VVM_HOME_PATH

ENV NB_USER $VVM_USER
ENV NB_UID 1000
ENV VVM_HOME $VVM_HOME_PATH

USER root

RUN echo $VVM_USER and $VVM_HOME_PATH >> /tmp/debug.txt

# Create NB_USER with UID=1000 and in the 'users' group
# and give +rw perms to notebook user/author
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

# Install all OS dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN REPO=http://cdn-fastly.deb.debian.org \
 && echo "deb $REPO/debian jessie main\ndeb $REPO/debian-security jessie/updates main" > /etc/apt/sources.list \
 && apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install dropbox
RUN wget -nv -O /usr/local/bin/dropbox.py https://www.dropbox.com/download?dl=packages/dropbox.py && chmod +x /usr/local/bin/dropbox.py
RUN wget -nv -O- https://www.dropbox.com/download?plat=lnx.x86_64 | tar -C /usr/local -zx && chown -Rv root:root .

ADD vvm_dropbox_start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/vvm_dropbox_start.sh
ENTRYPOINT ["/usr/local/bin/vvm_dropbox_start.sh"]
