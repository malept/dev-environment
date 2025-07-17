FROM ubuntu:24.04

RUN apt-get update && apt-get install --yes sudo && usermod --append --groups sudo ubuntu && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/ubuntu/Code/@malept/dev-environment
WORKDIR /home/ubuntu/Code/@malept/dev-environment
RUN mkdir salt
COPY bootstrap.sh .
COPY salt/minion salt/minion
COPY salt/pillars salt/pillars
RUN chown -R ubuntu:ubuntu ../..

USER ubuntu
ENV BOOTSTRAP_SALT_DISABLE_SERVICE_CHECK=1
ENV SKIP_SALT_CALL=1
RUN ./bootstrap.sh docker

COPY . .
