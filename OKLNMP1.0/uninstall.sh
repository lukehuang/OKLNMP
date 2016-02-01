#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

cur_dir=$(pwd)
Stack=$1

LNMP_Ver='1.2'

. include/main.sh

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

    Check_Stack
    echo "Current Stack: ${Get_Stack}"

    action="1"
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
        Uninstall_LNMP