# phpmyAdmin/docker
* PHP:7.4
* Apache/2.4.38 (Debian)
* phpMyadmin 5.0.2: docker镜像

## 配置sql注入平台
* sql注入平台sql-lab适用于php5.x: https://github.com/Audi-1/sqli-labs.git
* sql注入平台sql-lab适用于php7.x: https://gitcode.net/mirrors/skyblueee/sqli-labs-php7.git
* 官方sql-lab适用于<php7.0


## 镜像打包
```
  docker build -t phpmyadmin:5.0.2-apache-custom -f ./Dockerfile-php7.0
```

## LANMP

* mysql5.7
```shell
docker run --name some-mysql \
    -e MYSQL_ROOT_PASSWORD=aaa123123 \ ##记得更改
    -p 3306:3306 \
    -d mysql:5.7-debian --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

#root授权
grant all on  *.* to 'root'@'%' identified by 'aaa123123'  with grant option;

```

* php+phpMyadmin+apache2
```shell
docker run --name phpmyadmin \
    -e PMA_HOST=mysql_ip \
    -e PMA_USER=root \
    -e PMA_PASSWORD=aaa123123 \
    -v /conf/sqli:/var/www/sqli \
    -p 80:80 \
    -d registry.cn-beijing.aliyuncs.com/partnersun/phpadmin:5.0.2-apache-custom

```
* sqli
```shell
cd /conf/sqli
git clone https://gitcode.net/mirrors/skyblueee/sqli-labs-php7.git
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


