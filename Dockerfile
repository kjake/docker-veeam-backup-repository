FROM ubuntu:latest

USER root

RUN echo 'Dir::Cache::pkgcache "";\nDir::Cache::srcpkgcache "";' | tee /etc/apt/apt.conf.d/00_disable-cache-files
RUN apt-get update -y && \
    apt-get install -y \
        openssh-server \
        perl \
        augeas-tools && \
    mkdir /root/.ssh && \
    chmod 700 /root/.ssh
RUN augtool set /files/etc/ssh/sshd_config/Ciphers/1 aes256-cbc && \
    augtool set /files/etc/ssh/sshd_config/Ciphers/2 aes192-cbc && \
    augtool set /files/etc/ssh/sshd_config/Ciphers/3 aes128-cbc && \
    augtool set /files/etc/ssh/sshd_config/Ciphers/4 aes256-ctr && \
    augtool set /files/etc/ssh/sshd_config/Ciphers/5 aes192-ctr && \
    augtool set /files/etc/ssh/sshd_config/Ciphers/6 aes128-ctr && \
    augtool set /files/etc/ssh/sshd_config/KexAlgorithms/1 diffie-hellman-group-exchange-sha256 && \
    augtool set /files/etc/ssh/sshd_config/KexAlgorithms/2 diffie-hellman-group-exchange-sha1 && \
    augtool set /files/etc/ssh/sshd_config/KexAlgorithms/3 diffie-hellman-group14-sha1 && \
    augtool set /files/etc/ssh/sshd_config/KexAlgorithms/4 diffie-hellman-group1-sha1 && \
    augtool set /files/etc/ssh/sshd_config/MACs/1 hmac-sha2-512 && \
    augtool set /files/etc/ssh/sshd_config/MACs/2 hmac-sha2-256 && \
    augtool set /files/etc/ssh/sshd_config/MACs/3 hmac-md5 && \
    augtool set /files/etc/ssh/sshd_config/MACs/4 hmac-sha1 && \
    augtool set /files/etc/ssh/sshd_config/PasswordAuthentication no && \
    augtool set /files/etc/ssh/sshd_config/PermitRootLogin yes
RUN usermod -p '*' root && \
    rm -rf /var/cache/apt/*

COPY docker-entrypoint /usr/local/bin/

EXPOSE 22

ENTRYPOINT ["docker-entrypoint"]

CMD [ "/usr/sbin/sshd", "-D", "-e"]