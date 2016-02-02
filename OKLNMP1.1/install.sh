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
. include/init.sh
. include/mysql.sh
. include/mariadb.sh
. include/php.sh
. include/nginx.sh
. include/apache.sh
. include/end.sh

Get_Dist_Name

if [ "${DISTRO}" = "unknow" ]; then
    Echo_Red "Unable to get Linux distribution name, or do NOT support the current distribution."
    exit 1
fi

clear
echo "+------------------------------------------------------------------------+"
echo "|          LNMP V${LNMP_Ver} for ${DISTRO} Linux Server, Written by Licess          |"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compile & install LNMP/LNMPA/LAMP on Linux       |"
echo "+------------------------------------------------------------------------+"
echo "|          For more information please visit http://www.lnmp.org         |"
echo "+------------------------------------------------------------------------+"

Init_Install()
{
    Press_Install
    Print_Sys_Info
    Set_Timezone
        CentOS_InstallNTP
        CentOS_RemoveAMP
        CentOS_Dependent
    Disable_Selinux
    Install_Autoconf
    Install_Libiconv
    Install_Libmcrypt
    Install_Mhash
    Install_Mcrypt
    Install_Freetype
    Install_Curl
    Install_Pcre
        Install_Jemalloc
        CentOS_Lib_Opt
        Install_MySQL_55
    Export_PHP_Autoconf
}

LNMP_Stack()
{
    Init_Install
        Install_PHP_54
    Install_Nginx
    Creat_PHP_Tools
    Add_LNMP_Startup
    Check_LNMP_Install
}

        Dispaly_Selection
        LNMP_Stack 2>&1 | tee -a /root/lnmp-install.log