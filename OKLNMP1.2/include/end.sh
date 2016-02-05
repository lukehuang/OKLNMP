#!/bin/bash

Add_LNMP_Startup()
{
    echo "Add Startup and Starting LNMP..."
    \cp ${cur_dir}/conf/lnmp /bin/lnmp
    chmod +x /bin/lnmp
    StartUp nginx
    /etc/init.d/nginx start

        StartUp mysql
        /etc/init.d/mysql start

    StartUp php-fpm
    /etc/init.d/php-fpm start
}

Check_Nginx_Files()
{
    isNginx=""
    echo "============================== Check install =============================="
    echo "Checking ..."
    if [[ -s /usr/local/nginx/conf/nginx.conf && -s /usr/local/nginx/sbin/nginx ]]; then
        Echo_Green "Nginx: OK"
        isNginx="ok"
    else
        Echo_Red "Error: Nginx install failed."
    fi
}

Check_DB_Files()
{
    isDB=""
        if [[ -s /usr/local/mysql/bin/mysql && -s /usr/local/mysql/bin/mysqld_safe && -s /etc/my.cnf ]]; then
            Echo_Green "MySQL: OK"
            isDB="ok"
        else
            Echo_Red "Error: MySQL install failed."
        fi
}

Check_PHP_Files()
{
    isPHP=""
    if [ "${Stack}" = "lnmp" ]; then
        if [[ -s /usr/local/php/sbin/php-fpm && -s /usr/local/php/etc/php.ini && -s /usr/local/php/bin/php ]]; then
            Echo_Green "PHP: OK"
            Echo_Green "PHP-FPM: OK"
            isPHP="ok"
        else
            Echo_Red "Error: PHP install failed."
        fi
    fi
}

Print_Sucess_Info()
{
    echo "+------------------------------------------------------------------------+"
    echo "|          LNMP V${LNMP_Ver} for ${DISTRO} Linux Server, Written by Licess          |"
    echo "+------------------------------------------------------------------------+"
    echo "|         For more information please visit http://www.lnmp.org          |"
    echo "+------------------------------------------------------------------------+"
    echo "|    lnmp status manage: lnmp {start|stop|reload|restart|kill|status}    |"
    echo "+------------------------------------------------------------------------+"
    echo "|  phpMyAdmin: http://IP/phpmyadmin/                                     |"
    echo "|  phpinfo: http://IP/phpinfo.php                                        |"
    echo "|  Prober:  http://IP/p.php                                              |"
    echo "+------------------------------------------------------------------------+"
    echo "|  Add VirtualHost: lnmp vhost add                                       |"
    echo "+------------------------------------------------------------------------+"
    echo "|  Default directory: /home/wwwroot/default                              |"
    echo "+------------------------------------------------------------------------+"
    echo "|  MySQL root password: ${MysqlRootPWD}                          |"
    echo "+------------------------------------------------------------------------+"
    lnmp status
    netstat -ntl  
    Echo_Green "Install lnmp V${LNMP_Ver} completed! enjoy it."
}

Print_Failed_Info()
{
    Echo_Red "Sorry,Failed to install LNMP!"
    Echo_Red "Please visit http://bbs.vpser.net/forum-25-1.html feedback errors and logs."
    Echo_Red "You can download /root/lnmp-install.log from your server,and upload lnmp-install.log to LNMP Forum."
}

Check_LNMP_Install()
{
    Check_Nginx_Files
    Check_DB_Files
    Check_PHP_Files
    if [[ "$isNginx" = "ok" && "$isDB" = "ok" && "$isPHP" = "ok" ]]; then
        Print_Sucess_Info
    else
        Print_Failed_Info
    fi
}

Check_XMIF_Install()
{
    #Xcache
    if [ -s "${zend_ext_dir}xcache.so" ]; then
        echo "======== xcache install completed ======"
        echo "XCache installed successfully, enjoy it!"
    else
        sed -i '/;xcache/,/;xcache end/d' /usr/local/php/etc/php.ini
        echo "XCache install failed!"
    fi

    #Memcached
    if [ -s "${zend_ext_dir}${PHP_ZTS}" ]; then
        echo "====== Memcached install completed ======"
        echo "Memcached installed successfully, enjoy it!"
    else
        sed -i '/${PHP_ZTS}/d' /usr/local/php/etc/php.ini
        echo "Memcached install failed!"
    fi

    #ionCube
    if [ -s "/usr/local/ioncube/ioncube_loader_lin_5.4.so" ]; then
        echo "====== ionCube install completed ======"
        echo "ionCube installed successfully, enjoy it!"
    else
        sed -i '/ionCube Loader/d' /usr/local/php/etc/php.ini
        sed -i '/ioncube_loader_lin/d' /usr/local/php/etc/php.ini
        echo "ionCube install failed!"
    fi

    #Pure-FTPd
    if [[ -s /usr/local/pureftpd/sbin/pure-config.pl && -s /usr/local/pureftpd/pure-ftpd.conf && -s /etc/init.d/pureftpd && ${Is_SQL_Import} -eq 0 ]]; then
        echo "====== Pure-FTPd install completed ======"
        echo "Install Pure-FTPd completed,enjoy it!"
    else
        Echo_Red "Pureftpd install failed!"
    fi
}