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
. include/php.sh
. include/nginx.sh
. include/end.sh
. include/version.sh
. include/xcache.sh
. include/memcached.sh
. include/ionCube.sh

Get_Dist_Name

if [ "${DISTRO}" = "unknow" ]; then
    Echo_Red "Unable to get Linux distribution name, or do NOT support the current distribution."
    exit 1
fi

clear
echo "+------------------------------------------------------------------------+"
echo "|      LNMP V${LNMP_Ver} for ${DISTRO} Linux Server, Written by Licess   |"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compile & install LNMP/LNMPA/LAMP on Linux       |"
echo "+------------------------------------------------------------------------+"
echo "|          For more information please visit http://www.lnmp.org         |"
echo "+------------------------------------------------------------------------+"
echo "|                       PHP5.4   MySQL5.5   Nginx1.8                     |"
echo "+------------------------------------------------------------------------+"
echo "|               ##### cache / optimizer / accelerator #####              |"
echo "+------------------------------------------------------------------------+"
echo "|                            XCache   Memcached                          |"
echo "+------------------------------------------------------------------------+"
echo "|             ##### encryption/decryption utility for PHP #####          |"
echo "+------------------------------------------------------------------------+"
echo "|                              ionCube Loader                            |"
echo "+------------------------------------------------------------------------+"

Install_Pureftpd()
{
    Get_OS_Bit
    Get_Dist_Name
    Check_DB

    if [ -s /var/lib/mysql/mysql.sock ]; then
    ln -sf /tmp/mysql.sock /var/lib/mysql/mysql.sock
    fi

    echo "Installing pure-ftpd..."
    cd ${cur_dir}/src
    Tar_Cd ${Pureftpd_Ver}.tar.gz ${Pureftpd_Ver}
    ./configure --prefix=/usr/local/pureftpd CFLAGS=-O2 --with-mysql=${MySQL_Dir} --with-quotas --with-cookie --with-virtualhosts --with-diraliases --with-sysquotas --with-ratios --with-altlog --with-paranoidmsg --with-shadow --with-welcomemsg --with-throttling --with-uploadscript --with-language=english --with-rfc2640

    make && make install

    echo "Copy configure files..."
    \cp configuration-file/pure-config.pl /usr/local/pureftpd/sbin/
    chmod 755 /usr/local/pureftpd/sbin/pure-config.pl
    \cp $cur_dir/conf/pureftpd-mysql.conf /usr/local/pureftpd/
    \cp $cur_dir/conf/pure-ftpd.conf /usr/local/pureftpd/

    echo "Modify parameters of pureftpd configures..."
    sed -i 's/127.0.0.1/localhost/g' /usr/local/pureftpd/pureftpd-mysql.conf
    sed -i 's/Ftp_DB_Pwd/'${Ftp_DB_Pwd}'/g' /usr/local/pureftpd/pureftpd-mysql.conf
    \cp $cur_dir/conf/pureftpd-script.sql /tmp/pureftpd-script.sql
    sed -i 's/Ftp_DB_Pwd/'${Ftp_DB_Pwd}'/g' /tmp/pureftpd-script.sql
    sed -i 's/Ftp_Manager_Pwd/'${Ftp_Manager_Pwd}'/g' /tmp/pureftpd-script.sql

    echo "Import pureftpd database..."
    ${MySQL_Bin} -u root -p${MysqlRootPWD} -h localhost < /tmp/pureftpd-script.sql
    Is_SQL_Import=$?

    echo "Installing GUI User manager for PureFTPd..."
    cd ${cur_dir}/src
    unzip -q ${Pureftpd_Manager_Ver}.zip
    mv ftp /home/wwwroot/default/
    chmod 777 -R /home/wwwroot/default/ftp/
    chown www -R /home/wwwroot/default/ftp/

    echo "Modify parameters of GUI User manager for PureFTPd..."
    www_uid=`id -u www`
    www_gid=`id -g www`
    sed -i 's/\$DEFUserID.*/\$DEFUserID = "'${www_uid}'";/g' /home/wwwroot/default/ftp/config.php
    sed -i 's/\$DEFGroupID.*/\$DEFGroupID = "'${www_gid}'";/g' /home/wwwroot/default/ftp/config.php
    sed -i 's/English/Chinese/g' /home/wwwroot/default/ftp/config.php
    sed -i 's/tmppasswd/'${Ftp_DB_Pwd}'/g' /home/wwwroot/default/ftp/config.php
    sed -i 's/127.0.0.1/localhost/g' /home/wwwroot/default/ftp/config.php
    sed -i 's/myipaddress.com/localhost/g' /home/wwwroot/default/ftp/config.php
    mv /home/wwwroot/default/ftp/install.php /home/wwwroot/default/ftp/install.php.bak
    rm -f /tmp/pureftpd-script.sql

    \cp $cur_dir/init.d/init.d.pureftpd /etc/init.d/pureftpd
    chmod +x /etc/init.d/pureftpd

    StartUp pureftpd

    if [ -s /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 21 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 20 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 20000:30000 -j ACCEPT

            service iptables save
    fi
    /etc/init.d/pureftpd start
}

Restart_PHP()
{
        echo "Restarting php-fpm......"
        /etc/init.d/php-fpm restart
}

Install_XMI()
{
    Get_OS_Bit
    Get_Dist_Name

                    Install_XCache
                    Install_Memcached
                    Install_ionCube
}

Restart_PHP()
{
        echo "Restarting php-fpm......"
        /etc/init.d/php-fpm restart
}

Init_Install()
{
    Press_Install
    Print_Sys_Info
    Get_Dist_Version
    Set_Timezone
        CentOS_InstallNTP
        CentOS_RemoveAMP
        CentOS_Dependent
    Disable_Selinux
    Check_Download
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
    Install_XMI
    Install_Pureftpd
    Check_LNMP_Install
    Check_XMIF_Install
}

        Dispaly_Selection
        LNMP_Stack 2>&1 | tee -a /root/lnmp-install.log