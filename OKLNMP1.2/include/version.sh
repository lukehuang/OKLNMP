#!/bin/bash

Download_Mirror='http://soft.vpser.net'

Nginx_Modules_Arguments=""

Autoconf_Ver='autoconf-2.61'
Libiconv_Ver='libiconv-1.14'
LibMcrypt_Ver='libmcrypt-2.5.8'
Mcypt_Ver='mcrypt-2.6.8'
Mash_Ver='mhash-0.9.9.9'
Freetype_Ver='freetype-2.4.12'
Curl_Ver='curl-7.42.1'
Pcre_Ver='pcre-8.36'
Jemalloc_Ver='jemalloc-3.6.0'
Libunwind_Ver='libunwind-1.1'
Nginx_Ver='nginx-1.8.0'
Mysql_Ver='mysql-5.5.42'
Php_Ver='php-5.4.41'

PhpMyAdmin_Ver='phpMyAdmin-4.4.7-all-languages'

APR_Ver='apr-1.5.1'
APR_Util_Ver='apr-util-1.5.4'
Mod_RPAF_Ver='mod_rpaf-0.8.4-rc3'

Pureftpd_Ver='pure-ftpd-1.0.37'
Pureftpd_Manager_Ver='User_manager_for-PureFTPd_v2.1_CN'

XCache_Ver='xcache-3.2.0'
ZendOpcache_Ver='zendopcache-7.0.4'
PHPRedis_Ver='redis-2.2.7'
Memcached_Ver='memcached-1.4.22'
Libmemcached_Ver='libmemcached-1.0.18'
PHPMemcache_Ver='memcache-3.0.8'

if [ "${Stack}" != "" ]; then
    echo "You will install ${Stack} stack."
    if [ "${Stack}" = "lnmp" ]; then
        echo "${Nginx_Ver}"
    fi
        echo "${Mysql_Ver}"

    echo "${Php_Ver}"
    echo "${Jemalloc_Ver}"
fi