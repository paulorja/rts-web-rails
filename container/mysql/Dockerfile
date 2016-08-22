FROM debian:8.5


RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
    sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
    echo "mysqld_safe &"  > /tmp/mysql_start && \
    echo "mysqladmin --silent --wait=30 ping || exit 1"  >> /tmp/mysql_start && \
    echo "mysql -e 'CREATE USER \"rts-web\"@\"%\" IDENTIFIED BY \"123456\";'" >> /tmp/mysql_start && \
    echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"rts-web\"@\"%\" WITH GRANT OPTION;'" >> /tmp/mysql_start && \
    bash /tmp/mysql_start && \
    rm -f /tmp/mysql_start

# Define mountable directories.
VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mysqld_safe"]

# Expose ports.
EXPOSE 3306


