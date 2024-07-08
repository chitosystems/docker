ARG MYSQL_TAG

FROM ${MYSQL_TAG}
COPY ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
COPY ./root/ /root/
RUN apt-get update && apt-get install -y default-mysql-client
