ARG HOST=www.otw-iris.va.gov
ARG IMAGE=store/intersystems/sam:1.0.0.115
FROM $IMAGE AS src
COPY csp-webgateway /tmp/
WORKDIR /tmp
COPY sam.sh hsts.sh
COPY openssl.template .
USER root
RUN host=$HOST \
  && sed "s#eman.com#www.otw-iris.va.gov#g" openssl.template > openssl.conf \
  && openssl req -config openssl.conf -new -nodes -x509 -newkey rsa:2048 -sha256 -keyout apache-selfsigned.key -out apache-selfsigned.crt -days 3650
# COPY apache-selfsigned.crt .
# COPY apache-selfsigned.key .
RUN apt-get update 
RUN apt-get install -y apache2 
RUN apt-get install -y apache2-utils 
RUN apt-get clean 
RUN cat /tmp/csp-webgateway >> /etc/apache2/apache2.conf
RUN chmod 664 apache-selfsigned.crt
RUN chmod +x hsts.sh
COPY otw-ssl.conf /etc/apache2/sites-available
RUN a2enmod ssl && a2enmod headers && a2ensite otw-ssl
# WORKDIR /usr/irissys/csp/bin
# RUN rm CSP.ini
# COPY CSP.ini .
# RUN apt-get update \
#  && apt-get install ssh -y  \
#  && service ssh start \
#  && echo "irisowner:abcxyz" | chpasswd
CMD ["-b","/tmp/hsts.sh"]
