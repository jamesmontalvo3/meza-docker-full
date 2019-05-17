FROM jamesmontalvo3/meza-docker-pre-yum:latest
MAINTAINER James Montalvo
ENV container=docker

RUN git clone -b master https://github.com/enterprisemediawiki/meza /opt/meza
# COPY . /opt/meza

RUN bash /opt/meza/src/scripts/getmeza.sh

RUN meza setup env monolith --fqdn="INSERT_FQDN" --db_pass=1234 --private_net_zone=public

RUN ansible-vault decrypt /opt/conf-meza/secret/monolith/secret.yml --vault-password-file /opt/conf-meza/vault/vault-pass-monolith.txt \
	&& echo "" >> /opt/conf-meza/secret/monolith/secret.yml \
	&& echo "docker_skip_tasks: true" >> /opt/conf-meza/secret/monolith/secret.yml \
	&& ansible-vault encrypt /opt/conf-meza/secret/monolith/secret.yml --vault-password-file /opt/conf-meza/vault/vault-pass-monolith.txt

RUN meza deploy monolith
