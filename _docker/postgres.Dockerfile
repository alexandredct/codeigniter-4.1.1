FROM postgres:9.2.23
#FROM postgres:9.2.23-alpine #não possui o comando localedef no PATH
# @see Documentação https://hub.docker.com/_/postgres

LABEL maintainer="alexandre.trindade@uerj.br"

RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
ENV LANG pt_BR.utf8

RUN apt update && apt install -y git bzip2

RUN git clone https://github.com/h8/employees-database.git
RUN bzip2 -d employees-database/employees_data.sql.bz2
RUN psql -U postgres < /employees-database/employees_schema.sql
RUN psql -U postgres employees < /employees-database/employees_data.sql

# Credenciais do banco
#
# Postgres (super usuário)
# USER	postgres
# SYBASE_PASSWORD	postgres
