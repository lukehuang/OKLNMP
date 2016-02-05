#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

cur_dir=$(pwd)
Stack="lnmp"

LNMP_Ver='1.2'

. include/main.sh
. include/xcache.sh
. include/memcached.sh
. include/ionCube.sh

shopt -s extglob

Check_DB
Get_OS_Bit
Get_Dist_Name

clear
echo "+------------------------------------------------------------------------+"
echo "|          LNMP V${LNMP_Ver} for ${DISTRO} Linux Server, Written by Licess          |"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compile & install Nginx+MySQL+PHP on Linux       |"
echo "+------------------------------------------------------------------------+"
echo "|          For more information please visit http://www.lnmp.org         |"
echo "+------------------------------------------------------------------------+"

Check_ftp()
{
    if [ ! -f /usr/local/pureftpd/sbin/pure-config.pl ]; then
        echo "Pureftpd was not installed!"
        exit 1
    fi
}

Uninstall_ftp()
{
    echo "================================================="
    echo "You will uninstall Pureftpd..."
    Check_ftp
    echo "Stop pureftpd..."
    /etc/init.d/pureftpd stop
    echo "Remove service..."
    Remove_StartUp pureftpd
    echo "Delete files..."
    rm -f /etc/init.d/pureftpd
    rm -rf /usr/local/pureftpd
    rm -rf /home/wwwroot/default/ftp
    echo "Pureftpd uninstall completed."
}

Restart_PHP()
{
        echo "Restarting php-fpm......"
        /etc/init.d/php-fpm restart
}

Uninstall_LNMP()
{
    echo "Stoping LNMP..."
    lnmp stop

    Remove_StartUp nginx
    Remove_StartUp ${DB_Name}
    Remove_StartUp php-fpm
    echo "Deleting LNMP files..."
    rm -rf /usr/local/nginx
    rm -rf /usr/local/${DB_Name}/!(var|data)
    rm -rf /usr/local/php
    rm -rf /usr/local/zend

    rm -f /etc/my.cnf
    rm -f /etc/init.d/nginx
    rm -f /etc/init.d/${DB_Name}
    rm -f /etc/init.d/php-fpm
    rm -f /bin/lnmp
    echo "LNMP Uninstall completed."
}

        echo "You will uninstall LNMP"
        Echo_Red "Please backup your configure files and mysql data!!!!!!"
        Echo_Red "The following directory or files will be remove!"
        cat << EOF
/usr/local/nginx
${MySQL_Dir}
/usr/local/php
/etc/init.d/nginx
/etc/init.d/${DB_Name}
/etc/init.d/php-fpm
/usr/local/zend
/etc/my.cnf
/bin/lnmp
EOF
        sleep 3
        Press_Start
        Uninstall_XCache
        Uninstall_Memcached
        Uninstall_ionCube
        Uninstall_ftp
        Uninstall_LNMP