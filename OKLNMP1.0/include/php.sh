#!/bin/bash

Export_PHP_Autoconf()
{
    export PHP_AUTOCONF=/usr/local/autoconf-2.13/bin/autoconf
    export PHP_AUTOHEADER=/usr/local/autoconf-2.13/bin/autoheader
}

Ln_PHP_Bin()
{
    ln -sf /usr/local/php/bin/php /usr/bin/php
    ln -sf /usr/local/php/bin/phpize /usr/bin/phpize
    ln -sf /usr/local/php/bin/pear /usr/bin/pear
    ln -sf /usr/local/php/bin/pecl /usr/bin/pecl
        ln -sf /usr/local/php/sbin/php-fpm /usr/bin/php-fpm
}

Pear_Pecl_Set()
{
    pear config-set php_ini /usr/local/php/etc/php.ini
    pecl config-set php_ini /usr/local/php/etc/php.ini
}

Install_PHP_54()
{
    Echo_Blue "[+] Installing ${Php_Ver}..."
    Tar_Cd ${Php_Ver}.tar.gz ${Php_Ver}
        ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir --with-freetype-dir=/usr/local/freetype --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --with-mcrypt --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --with-gettext --disable-fileinfo
    make ZEND_EXTRA_LIBS='-liconv'
    make install

    Ln_PHP_Bin

    echo "Copy new php configure file..."
    mkdir -p /usr/local/php/etc
    \cp php.ini-production /usr/local/php/etc/php.ini

    cd ${cur_dir}
    # php extensions
    echo "Modify php.ini......"
    sed -i 's/post_max_size = 8M/post_max_size = 50M/g' /usr/local/php/etc/php.ini
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /usr/local/php/etc/php.ini
    sed -i 's/;date.timezone =/date.timezone = PRC/g' /usr/local/php/etc/php.ini
    sed -i 's/short_open_tag = Off/short_open_tag = On/g' /usr/local/php/etc/php.ini
    sed -i 's/; cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
    sed -i 's/; cgi.fix_pathinfo=0/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
    sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/php/etc/php.ini
    sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,popen,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/php/etc/php.ini
    Pear_Pecl_Set

    echo "Install ZendGuardLoader for PHP 5.4..."
    cd ${cur_dir}/src
        Download_Files ${Download_Mirror}/web/zend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
        tar zxf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
        mkdir -p /usr/local/zend/
        \cp ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64/php-5.4.x/ZendGuardLoader.so /usr/local/zend/

    echo "Write ZendGuardLoader to php.ini..."
cat >>/usr/local/php/etc/php.ini<<EOF

;eaccelerator

;ionCube

[Zend ZendGuard Loader]
zend_extension=/usr/local/zend/ZendGuardLoader.so
zend_loader.enable=1
zend_loader.disable_licensing=0
zend_loader.obfuscation_level_support=3
zend_loader.license_path=

;xcache
;xcache end
EOF
    echo "Creating new php-fpm configure file..."
    cat >/usr/local/php/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log
log_level = notice

[www]
listen = /tmp/php-cgi.sock
listen.backlog = -1
listen.allowed_clients = 127.0.0.1
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 6
request_terminate_timeout = 100
request_slowlog_timeout = 0
slowlog = var/log/slow.log
EOF

echo "Copy php-fpm init.d file..."
\cp ${cur_dir}/src/${Php_Ver}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
}

Creat_PHP_Tools()
{
    echo "Create PHP Info Tool..."
    cat >/home/wwwroot/default/phpinfo.php<<eof
<?
phpinfo();
?>
eof

    echo "Copy PHP Prober..."
    cd ${cur_dir}/src
    tar zxf p.tar.gz
    \cp p.php /home/wwwroot/default/p.php

    \cp ${cur_dir}/conf/index.html /home/wwwroot/default/index.html
    \cp ${cur_dir}/conf/lnmp.gif /home/wwwroot/default/lnmp.gif
    echo "============================Install PHPMyAdmin================================="
    [[ -d /home/wwwroot/default/phpmyadmin ]] && rm -rf /home/wwwroot/default/phpmyadmin
    tar zxf ${PhpMyAdmin_Ver}.tar.gz
    mv ${PhpMyAdmin_Ver} /home/wwwroot/default/phpmyadmin
    \cp ${cur_dir}/conf/config.inc.php /home/wwwroot/default/phpmyadmin/config.inc.php
    sed -i 's/LNMPORG/LNMP.org'$RANDOM'VPSer.net/g' /home/wwwroot/default/phpmyadmin/config.inc.php
    mkdir /home/wwwroot/default/phpmyadmin/{upload,save}
    chmod 755 -R /home/wwwroot/default/phpmyadmin/
    chown www:www -R /home/wwwroot/default/phpmyadmin/
    echo "============================phpMyAdmin install completed======================="

    #add iptables firewall rules
    if [ -s /sbin/iptables ]; then
        /sbin/iptables -I INPUT 1 -i lo -j ACCEPT
        /sbin/iptables -I INPUT 2 -m state --state ESTABLISHED,RELATED -j ACCEPT
        /sbin/iptables -I INPUT 3 -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT 4 -p tcp -s 127.0.0.1 --dport 3306 -j ACCEPT
        /sbin/iptables -I INPUT 5 -p tcp --dport 3306 -j DROP
            service iptables save
    fi
}