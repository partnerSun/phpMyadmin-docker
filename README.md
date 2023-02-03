# phpmyAdmin/docker
* PHP:5.6.36
* nginx:1.10.3
* [phpAdmin](https://files.phpmyadmin.net/phpMyAdmin/4.6.5.2/phpMyAdmin-4.6.5.2-all-languages.tar.gz.asc):4.6.5-2

## 配置sql注入平台,使用nginx
* nginx：参考nginx.conf
* apache2：参考000-default.conf
* sql注入平台sqli: https://github.com/Audi-1/sqli-labs.git

## sqli不支持php7.0
* 重做镜像: registry.cn-beijing.aliyuncs.com/partnersun/phpadmin:4.6.5-apache-custom, 其余参数不变.
* php7+apache2参考: registry.cn-beijing.aliyuncs.com/partnersun/phpadmin:5.2.0-apache-custom
 

## LANMP

* mysql5.7
```shell
docker run --name some-mysql \
    -e MYSQL_ROOT_PASSWORD=aaa123123 \ ##记得更改
    -p 3306:3306 \
    -d mysql:5.7-debian --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

```

* php+phpMyadmin+nginx
```shell
docker run --name phpmyadmin \
    -e PMA_HOST=mysql_ip \
    -e PMA_USER=root \
    -e PMA_PASSWORD=aaa123123 \
    -v /conf/sqli:/var/www/sqli \
    -p 8080:80 \
    -d registry.cn-beijing.aliyuncs.com/partnersun/phpadmin:4.6.5-apache-custom

```
* sqli
```shell
cd /conf/sqli
git clone https://github.com/Audi-1/sqli-labs.git
mv ./sqli-labs/* ./
```
* 修改sqli连接信息
```
vim sql-connections/db-creds.inc
```

## Environment variables summary

* ``PMA_ARBITRARY`` - when set to 1 connection to the arbitrary server will be allowed
* ``PMA_HOST`` - define address/host name of the MySQL server
* ``PMA_VERBOSE`` - define verbose name of the MySQL server
* ``PMA_PORT`` - define port of the MySQL server
* ``PMA_HOSTS`` - define comma separated list of address/host names of the MySQL servers
* ``PMA_VERBOSES`` - define comma separated list of verbose names of the MySQL servers
* ``PMA_USER`` and ``PMA_PASSWORD`` - define username to use for config authentication method
* ``PMA_ABSOLUTE_URI`` - define user-facing URI


