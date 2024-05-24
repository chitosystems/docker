ARG MYSQL_TAG

#FROM mariadb:${MYSQL_TAG}
FROM ${MYSQL_TAG}
COPY ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
COPY ./root/ /root/
#COPY ./init-db.sh /usr/local/bin/
#RUN chmod 755 /usr/local/bin/init-db.sh
