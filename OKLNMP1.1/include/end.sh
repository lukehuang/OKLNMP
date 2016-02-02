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
        if [[ -s /usr/local/php/sbin/php-fpm && -s /usr/local/php/etc/php.ini && -s /usr/local/php/bin/php ]]; then
            Echo_Green "PHP: OK"
            Echo_Green "PHP-FPM: OK"
            isPHP="ok"
        else
            Echo_Red "Error: PHP install failed."
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