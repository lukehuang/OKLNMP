#!/bin/bash

Install_PHPMemcache()
{
    echo "Install memcache php extension..."
    cd ${cur_dir}/src
    Download_Files ${Download_Mirror}/web/memcache/${PHPMemcache_Ver}.tgz ${PHPMemcache_Ver}.tgz
    Tar_Cd ${PHPMemcache_Ver}.tgz ${PHPMemcache_Ver}
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config
    make && make install
    cd ../
}

Install_Memcached()
{
    ver="1"
        PHP_ZTS="memcache.so"

    echo "====== Installing memcached ======"

    sed -i '/memcache.so/d' /usr/local/php/etc/php.ini
    sed -i '/memcached.so/d' /usr/local/php/etc/php.ini
    Get_PHP_Ext_Dir
    zend_extm=${zend_ext_dir}${PHP_ZTS}
    if [ -s "${zend_extm}" ]; then
        rm -f "${zend_extm}"
    fi

    if echo "${Cur_PHP_Version}" | grep -Eqi '^5.4.';then
        sed -i "/the dl()/i\
extension = \"${PHP_ZTS}\"" /usr/local/php/etc/php.ini
    else
        echo "Error: can't get php version!"
        echo "Maybe php was didn't install or php configuration file has errors.Please check."
        sleep 3
        exit 1
    fi

    echo "Install memcached..."
    cd ${cur_dir}/src
    Download_Files ${Download_Mirror}/web/memcached/${Memcached_Ver}.tar.gz ${Memcached_Ver}.tar.gz
    Tar_Cd ${Memcached_Ver}.tar.gz ${Memcached_Ver}
    ./configure --prefix=/usr/local/memcached
    make &&make install
    cd ../

    ln -sf /usr/local/memcached/bin/memcached /usr/bin/memcached

    \cp ${cur_dir}/init.d/init.d.memcached /etc/init.d/memcached
    chmod +x /etc/init.d/memcached
    useradd -s /sbin/nologin nobody

    if [ ! -d /var/lock/subsys ]; then
      mkdir -p /var/lock/subsys
    fi

    StartUp memcached

        Install_PHPMemcache

    echo "Copy Memcached PHP Test file..."
    \cp ${cur_dir}/conf/memcached${ver}.php /home/wwwroot/default/memcached.php

    Restart_PHP

    if [ -s /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp -s 127.0.0.1 --dport 11211 -j ACCEPT
        /sbin/iptables -I INPUT -p udp -s 127.0.0.1 --dport 11211 -j ACCEPT
        /sbin/iptables -A INPUT -p tcp --dport 11211 -j DROP
        /sbin/iptables -A INPUT -p udp --dport 11211 -j DROP

            service iptables save
    fi

    echo "Starting Memcached..."
    /etc/init.d/memcached start

    if [ -s ${zend_extm} ]; then
        echo "====== Memcached install completed ======"
        echo "Memcached installed successfully, enjoy it!"
    else
        sed -i '/${PHP_ZTS}/d' /usr/local/php/etc/php.ini
        echo "Memcached install failed!"
    fi
}

Uninstall_Memcached()
{
    echo "================================================="
    echo "You will uninstall Memcached..."
    sed -i '/memcache.so/d' /usr/local/php/etc/php.ini
    sed -i '/memcached.so/d' /usr/local/php/etc/php.ini
    Restart_PHP
    Remove_StartUp memcached
    echo "Delete Memcached files..."
    rm -rf /usr/local/libmemcached
    rm -rf /usr/local/memcached
    rm -rf /etc/init.d/memcached
    rm -rf /usr/bin/memcached
    if [ -s /sbin/iptables ]; then
        /sbin/iptables -D INPUT -p tcp -s 127.0.0.1 --dport 11211 -j ACCEPT
        /sbin/iptables -D INPUT -p udp -s 127.0.0.1 --dport 11211 -j ACCEPT
        /sbin/iptables -D INPUT -p tcp --dport 11211 -j DROP
        /sbin/iptables -D INPUT -p udp --dport 11211 -j DROP

            service iptables save
    fi
    echo "Uninstall Memcached completed."
}