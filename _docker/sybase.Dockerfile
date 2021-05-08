FROM datagrip/sybase:16.0

LABEL maintainer="alexandre.trindade@uerj.br"

# Ajuste de timezone para Sao_Paulo
RUN yum update -y tzdata
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Diretório onde irá ser criada o db_bm
RUN mkdir /sybase-data
RUN chmod -R 777 /sybase-data


ENV SYBASE=/opt/sybase

EXPOSE 5000

# ======================================================================================================================
# Credenciais do banco
# ======================================================================================================================
# Guest user
# Environment variable	Default value
# SYBASE_USER	tester
# SYBASE_PASSWORD	guest1234
# SYBASE_DB	testdb

# Admin user
# Environment variable	Default value
# SYBASE_USER	sa
# SYBASE_PASSWORD	myPassword
