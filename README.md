# OKLNMP

## OKLNMP1.2 2016年2月5日

新增Xcache memcached ionCube第三方组件；

新增Pureftpd；

Autoconf版本提升为2.61；

删除多余代码；

优化已有代码。

## OKLNMP1.1 2016年2月2日

新增bz2,imap,wddx,calendar等php模块。

## OKLNMP 1.0 2016年2月1日 

一键式安装LNMP；

由LNMP1.2修改而来；

新手站长再也不用为环境搭配的问题而烦恼了；

一键安装默认配置；

优化安装脚本；

删除多余内容；

> OKLNMP是什么？
---------------------

OKLNMP一键安装包是在LNMP(Nginx/MySQL/PHP)的基础上，定制化的提供特定配置的生产环境，真正的一键式安装程序。
## 要求配置：

+ CentOS 6 64位系统

### 包含：

+ PHP5.4
+ MySQL5.5
+ Nginx1.8
 
### 组件：

JeMalloc,ZendGuardLoader,Pureftpd,XCache,Memcached,ionCube

并在LNMP原基础上添加了常用的PHP模块。

#### 作者：Uni9K1ng

> LNMP一键安装包是什么?
—————————————————————

LNMP一键安装包是一个用Linux Shell编写的可以为CentOS/RadHat/Fedora、Debian/Ubuntu/Raspbian VPS(VDS)或独立主机安装LNMP(Nginx/MySQL/PHP)、LNMPA(Nginx/MySQL/PHP/Apache)、LAMP(Apache/MySQL/PHP)生产环境的Shell程序。同时提供一些实用的辅助工具如：虚拟主机管理、FTP用户管理、Nginx、MySQL/MariaDB、PHP的升级、常用缓存组件的安装、重置MySQL root密码、502自动重启、日志切割、SSH防护DenyHosts/Fail2Ban、备份等许多实用脚本。

#### LNMP官网：http://lnmp.org

#### 作者: licess <admin@lnmp.org>
--------------------------------------------------------------------------------

> 安装
————
./install.sh

+ 安装前建议使用screen，执行：screen -S lnmp

+ 如断线可使用screen -r lnmp 恢复。

> 常用功能
————————

+ FTP服务器：http://yourIP/ftp/ 进行管理，也可使用lnmp ftp {add|list|del}进行管理。

> 状态管理
————————

+ LNMP状态管理：lnmp {start|stop|reload|restart|kill|status}
+ Nginx状态管理：lnmp nginx或/etc/init.d/nginx {start|stop|reload|restart}
+ MySQL状态管理：lnmp mysql或/etc/init.d/mysql {start|stop|restart|reload|force-reload|status}
+ PHP-FPM状态管理：lnmp php-fpm或/etc/init.d/php-fpm {start|stop|quit|restart|reload|logrotate}
+ PureFTPd状态管理：lnmp pureftpd或/etc/init.d/pureftpd {start|stop|restart|kill|status}

> 虚拟主机管理
————————————

+ 添加：lnmp vhost add
+ 删除：lnmp vhost del
+ 列出：lnmp vhost list

> 相关图形界面
————————————

+ PHPMyAdmin：http://yourIP/phpmyadmin/
+ phpinfo：http://yourIP/phpinfo.php
+ PHP探针：http://yourIP/p.php
+ PureFtp用户管理：http://yourIP/ftp/
+ Xcache管理界面：http://yourIP/xcache/
+ Zend Opcache管理界面：http://yourIP/ocp.php

> LNMP相关目录文件
————————————————

### 目录位置
+ Nginx：/usr/local/nginx/
+ MySQL：/usr/local/mysql/
+ PHP：/usr/local/php/
+ PHPMyAdmin：/home/wwwroot/default/phpmyadmin/
+ 默认虚拟主机网站目录：/home/wwwroot/default/
+ Nginx日志目录：/home/wwwlogs/

### 配置文件：
+ Nginx主配置文件：/usr/local/nginx/conf/nginx.conf
+ MySQL/MariaDB配置文件：/etc/my.cnf
+ PHP配置文件：/usr/local/php/etc/php.ini
+ PureFtpd配置文件：/usr/local/pureftpd/pure-ftpd.conf
+ PureFtpd MySQL配置文件：/usr/local/pureftpd/pureftpd-mysql.conf


> 技术支持
————————

技术支持论坛：http://bbs.vpser.net/forum-25-1.html
