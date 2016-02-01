#!/bin/bash

Dispaly_Selection()
{
#set mysql root password
    echo " "
    MysqlRootPWD="root"
   
    Echo_Yellow  "MySQL root password: ${MysqlRootPWD}"

#do you want to enable or disable the InnoDB Storage Engine?
    echo "==========================="

    InstallInnodb="y"
        echo "You will enable the InnoDB Storage Engine"

#which MySQL Version do you want to install?
    echo "==========================="

    DBSelect="2"
        echo "You will install MySQL 5.5.42"

        MySQL_Bin="/usr/local/mysql/bin/mysql"
        MySQL_Config="/usr/local/mysql/bin/mysql_config"
        MySQL_Dir="/usr/local/mysql"

#which PHP Version do you want to install?
    echo "==========================="

    PHPSelect="3"
        echo "You will Install PHP 5.4.41"

#which Memory Allocator do you want to install?
    echo "==========================="

    SelectMalloc="2"
        echo "You will install JeMalloc 3.6.0"

        MySQL51MAOpt='--with-mysqld-ldflags=-ljemalloc'
        MySQL55MAOpt="-DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' -DWITH_SAFEMALLOC=OFF"
        MariaDBMAOpt=''
        NginxMAOpt="--with-ld-opt='-ljemalloc'"

    echo "==========================="

        echo "You will install phpMyAdmin 4.4.7"

    echo "==========================="

        echo "You will install Zend Guard Loader 6.0.0"
}

Press_Install()
{
    echo ""
    echo "Press any key to install...or Press Ctrl+c to cancel"
    OLDCONFIG=`stty -g`
    stty -icanon -echo min 1 time 0
    dd count=1 2>/dev/null
    stty ${OLDCONFIG}
    . include/version.sh
}

Press_Start()
{
    echo ""
    echo "Press any key to start...or Press Ctrl+c to cancel"
    OLDCONFIG=`stty -g`
    stty -icanon -echo min 1 time 0
    dd count=1 2>/dev/null
    stty ${OLDCONFIG}
}

Install_LSB()
{
        yum -y install redhat-lsb
}

Get_Dist_Version()
{
    Install_LSB
    eval ${DISTRO}_Version=`lsb_release -rs`
    eval echo "${DISTRO} \${${DISTRO}_Version}"
}

Get_Dist_Name()
{
        DISTRO='CentOS'
        PM='yum'
    Get_OS_Bit
}

Get_OS_Bit()
{
        Is_64bit='y'
}

Tar_Cd()
{
    local FileName=$1
    local DirName=$2
    cd ${cur_dir}/src
    [[ -d "${DirName}" ]] && rm -rf ${DirName}
    echo "Uncompress ${FileName}..."
    tar zxf ${FileName}
    echo "cd ${DirName}..."
    cd ${DirName}
}

Print_Sys_Info()
{
    cat /etc/issue
    cat /etc/*-release
    uname -a
    MemTotal=`free -m | grep Mem | awk '{print  $2}'`  
    echo "Memory is: ${MemTotal} MB "
    df -h
}

StartUp()
{
    init_name=$1
    echo "Add ${init_name} service at system startup..."
        chkconfig --add ${init_name}
        chkconfig ${init_name} on
}

Remove_StartUp()
{
    init_name=$1
    echo "Removing ${init_name} service at system startup..."
        chkconfig ${init_name} off
        chkconfig --del ${init_name}
}

Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}

Get_PHP_Ext_Dir()
{
    Cur_PHP_Version=`/usr/local/php/bin/php -r 'echo PHP_VERSION;'`
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20100525/"
}

Check_Stack()
{
        Get_Stack="lnmp"
}

Check_DB()
{
        MySQL_Bin="/usr/local/mysql/bin/mysql"
        MySQL_Config="/usr/local/mysql/bin/mysql_config"
        MySQL_Dir="/usr/local/mysql"
        Is_MySQL="y"
        DB_Name="mysql"
}

Verify_DB_Password()
{
    Check_DB
    read -p "verify your current database root password: " DB_Root_Password
    ${MySQL_Bin} -uroot -p${DB_Root_Password} -e "quit"
    if [ $? -eq 0 ]; then
        echo "MySQL root password correct."
    else
        echo "MySQL root password incorrect!Please check!"
        Verify_DB_Password
    fi
    if [ "${DB_Root_Password}" = "" ]; then
        Verify_DB_Password
    fi
}