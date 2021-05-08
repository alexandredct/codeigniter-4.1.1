FROM postgres:9.2.23
# @see Documentação https://hub.docker.com/_/postgres

LABEL maintainer="alexandre.trindade@uerj.br"

RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
ENV LANG pt_BR.utf8

# Ajuste de timezone para Sao_Paulo
RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

RUN apt update
RUN apt install -y git bzip2

RUN git clone https://github.com/h8/employees-database.git
RUN bzip2 -d /employees-database/employees_data.sql.bz2

#Running a sample database import
COPY postgres/employees-database.sh /docker-entrypoint-initdb.d/employees-database.sh

#
# Credenciais do banco
#
# Postgres (super usuário)
# USER	postgres
# SYBASE_PASSWORD	postgres
