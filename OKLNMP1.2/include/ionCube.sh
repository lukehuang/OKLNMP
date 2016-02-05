#!/bin/bash

Install_ionCube()
{
    echo "====== Installing ionCube ======"

    sed -ni '1,/;ionCube/p;/\[Zend/,$ p' /usr/local/php/etc/php.ini
    Get_PHP_Ext_Dir
       zend_exti="/usr/local/ioncube/ioncube_loader_lin_5.4.so"

    if [ -s "${zend_exti}" ]; then
        rm -f "${zend_exti}"
    fi

    rm -rf /usr/local/ioncube
    cd ${cur_dir}/src
    rm -rf ioncube
    rm -rf ioncube_loaders_lin_x8*.tar.gz
    if grep -Eqi "xcache.so" /usr/local/php/etc/php.ini; then

            Download_Files ${Download_Mirror}/web/ioncube/4.7.5/ioncube_loaders_lin_x86-64.tar.gz ioncube_loaders_lin_x86-64.tar.gz
            tar zxf ioncube_loaders_lin_x86-64.tar.gz
    else
            Download_Files http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz ioncube_loaders_lin_x86-64.tar.gz
            tar zxf ioncube_loaders_lin_x86-64.tar.gz
    fi
    mv ioncube /usr/local/

    echo "Writing ionCube Loader to configure files..."
    cat >ionCube.ini<<EOF
[ionCube Loader]
zend_extension="${zend_exti}"

EOF

    sed -i '/;ionCube/ {
r ionCube.ini
}' /usr/local/php/etc/php.ini

    rm -f ionCube.ini

    if [ -s "${zend_exti}" ]; then
        Restart_PHP
        echo "====== ionCube install completed ======"
        echo "ionCube installed successfully, enjoy it!"
    else
        sed -i '/ionCube Loader/d' /usr/local/php/etc/php.ini
        sed -i '/ioncube_loader_lin/d' /usr/local/php/etc/php.ini
        echo "ionCube install failed!"
    fi
 }

 Uninstall_ionCube()
 {
    echo "================================================="
    echo "You will uninstall ionCube..."
    sed -ni '1,/;ionCube/p;/\[Zend/,$ p' /usr/local/php/etc/php.ini
    echo "Delete ionCube files..."
    rm -rf /usr/local/ioncube/
    Restart_PHP
    echo "Uninstall ionCube completed."
 }
