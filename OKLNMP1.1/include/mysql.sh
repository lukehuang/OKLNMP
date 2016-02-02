#!/bin/bash

Deb_Check_MySQL()
{
    apt-get purge -y mysql-client mysql-server mysql-common mysql-server-core-5.5 mysql-client-5.5
    rm -f /etc/my.cnf
    rm -rf /etc/mysql/
}

MySQL_Sec_Setting()
{
    if [ -d "/proc/vz" ];then
        ulimit -s unlimited
    fi
    /etc/init.d/mysql start

    ln -sf /usr/local/mysql/bin/mysql /usr/bin/mysql
    ln -sf /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
    ln -sf /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
    ln -sf /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe

    /usr/local/mysql/bin/mysqladmin -u root password ${MysqlRootPWD}

    cat > /tmp/mysql_sec_script<<EOF
    use mysql;
    update user set password=password('${MysqlRootPWD}') where user='root';
    delete from user where not (user='root') ;
    delete from user where user='root' and password=''; 
    drop database test;
    DROP USER ''@'%';
    flush privileges;
EOF

    /usr/local/mysql/bin/mysql -u root -p${MysqlRootPWD} -h localhost < /tmp/mysql_sec_script

    rm -f /tmp/mysql_sec_script

    echo -e "\nexpire_logs_days = 10" >> /etc/my.cnf
    sed -i '/skip-external-locking/a\max_connections = 1000' /etc/my.cnf

    /etc/init.d/mysql restart
    /etc/init.d/mysql stop
}

Install_MySQL_55()
{
    Echo_Blue "[+] Installing ${Mysql_Ver}..."
    rm -f /etc/my.cnf
    Tar_Cd ${Mysql_Ver}.tar.gz ${Mysql_Ver}
    patch -p1 < ${cur_dir}/src/patch/mysql-openssl.patch
    MySQL_ARM_Patch
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_READLINE=1 -DWITH_SSL=bundled -DWITH_ZLIB=system -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 ${MySQL55MAOpt}
    make && make install

    groupadd mysql
    useradd -s /sbin/nologin -M -g mysql mysql

    \cp support-files/my-medium.cnf /etc/my.cnf
    sed '/skip-external-locking/i\datadir = /usr/local/mysql/var' -i /etc/my.cnf
    if [ "${InstallInnodb}" = "y" ]; then
    sed -i 's:#innodb:innodb:g' /etc/my.cnf
    sed -i 's:/usr/local/mysql/data:/usr/local/mysql/var:g' /etc/my.cnf
    else
    sed '/skip-external-locking/i\default-storage-engine=MyISAM\nloose-skip-innodb' -i /etc/my.cnf
    fi

    /usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/usr/local/mysql/var --user=mysql
    chown -R mysql /usr/local/mysql/var
    chgrp -R mysql /usr/local/mysql/.
    \cp support-files/mysql.server /etc/init.d/mysql
    chmod 755 /etc/init.d/mysql

    cat > /etc/ld.so.conf.d/mysql.conf<<EOF
    /usr/local/mysql/lib
    /usr/local/lib
EOF
    ldconfig
    ln -sf /usr/local/mysql/lib/mysql /usr/lib/mysql
    ln -sf /usr/local/mysql/include/mysql /usr/include/mysql

    MySQL_Sec_Setting
}