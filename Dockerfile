FROM jamesmontalvo3/meza-docker-pre-yum:latest
MAINTAINER James Montalvo
ENV container=docker

RUN git clone https://github.com/enterprisemediawiki/meza /opt/meza --branch reorg
# COPY . /opt/meza

RUN bash /opt/meza/src/scripts/getmeza.sh

RUN meza setup env monolith --fqdn="INSERT_FQDN" --db_pass=1234 --enable_email=false --private_net_zone=public

RUN echo "" >> /opt/conf-meza/secret/monolith/group_vars/all.yml
RUN echo "docker_skip_tasks: true" >> /opt/conf-meza/secret/monolith/group_vars/all.yml

RUN meza deploy monolith
