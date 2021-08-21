#!/bin/bash
# cp -fv /ICS/iris.key /usr/irissys/mgr/iris.key
host=$(hostname -I)
echo $(whoami)" on "$host
cd /tmp/
# rm -f apache-selfsigned.crt
# rm -f apache-selfsigned.key
sed "s#eman.com#$host#g" openssl.template > openssl.conf
# openssl req -config openssl.conf -new -nodes -x509 -newkey rsa:2048 -sha256 -keyout apache-selfsigned.key -out apache-selfsigned.crt -days 3650
# sleep 5
service apache2 restart
service ssh start
# exit 0
exit $?
