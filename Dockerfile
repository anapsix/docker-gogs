FROM alpine

# adapted for Alpine from codeskyblue/docker-gogs
# src: https://github.com/codeskyblue/docker-gogs
MAINTAINER Anastas Dancha <anapsix@random.io>

RUN apk --update add bash git rsync openssh linux-pam curl ca-certificates tar && \
    curl -Ls https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk > /tmp/glibc-2.21-r2.apk && \
    apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
    addgroup -g 999 -S git && \
    adduser -G git -u 999 -S -s /bin/sh git && \
    wget https://github.com/gogits/gogs/releases/download/v0.6.1/linux_amd64.zip && \
    unzip linux_amd64.zip && rm -v linux_amd64.zip && \
    mv gogs /home/git/gogs && \
    mkdir /home/git/gogs/conf /home/git/gogs/log && \
    chown -R git:git /home/git/gogs

#ADD app.ini /home/git/gogs/conf/app.ini
#RUN sed -i '/DB_TYPE/s/mysql/sqlite3/g;' /home/git/gogs/conf/app.ini

# SSH login fix. Otherwise user is kicked off after login
RUN echo 'session optional pam_loginuid.so' > /etc/pam.d/sshd
RUN sed 's@UsePrivilegeSeparation yes@UsePrivilegeSeparation no@' -i /etc/ssh/sshd_config
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

# create new server keys on startup
RUN sed 's@^HostKey@\#HostKey@' -i /etc/ssh/sshd_config
RUN echo "HostKey /data/ssh/ssh_host_key" >> /etc/ssh/sshd_config
RUN echo "HostKey /data/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config
RUN echo "HostKey /data/ssh/ssh_host_dsa_key" >> /etc/ssh/sshd_config
RUN echo "HostKey /data/ssh/ssh_host_ecdsa_key" >> /etc/ssh/sshd_config
RUN echo "HostKey /data/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config

# prepare data
ENV GOGS_CUSTOM /data/gogs
RUN echo "export GOGS_CUSTOM=/data/gogs" >> /etc/profile

ADD docker-entrypoint.sh /entrypoint.sh

ENV RUNAS git

WORKDIR /home/git/gogs

VOLUME /data/gogs

EXPOSE 22 3000

CMD ["/entrypoint.sh"]
