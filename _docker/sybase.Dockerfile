FROM datagrip/sybase:16.0

LABEL maintainer="alexandre.trindade@uerj.br"

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
