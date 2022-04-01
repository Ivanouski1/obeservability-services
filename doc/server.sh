#!/bin/bash

sudo yum update -y

# LDAP Server Installation
sudo yum install openldap openldap-servers openldap-clients -y
sudo systemctl start slapd
sudo systemctl enable slapd
sudo systemctl status slapd

ADMIN_PASS=$(cat files/admin_pass)
USER_PASS=$(cat files/user_pass)

PASSWORD=$(slappasswd -s ${ADMIN_PASS})
PASSWORD2=$(slappasswd -s ${USER_PASS})

#ldaprootpasswd.ldif
sed -i "s|PASS|${PASSWORD}|g" files/ldaprootpasswd.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f files/ldaprootpasswd.ldif

#LDAP DB
sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
sudo chown -R ldap:ldap /var/lib/ldap/DB_CONFIG
sudo systemctl restart slapd
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

#ldapdomain.ldif
sed -i "s|PASS|${PASSWORD}|g" files/ldapdomain.ldif
sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f files/ldapdomain.ldif

#baseldapdomain.ldif
sudo ldapadd -x -D cn=Manager,dc=devopsldab,dc=com -w ${ADMIN_PASS} -f files/baseldapdomain.ldif

#ldapgroup.ldif
sudo ldapadd -x -D "cn=Manager,dc=devopsldab,dc=com" -w ${ADMIN_PASS} -f files/ldapgroup.ldif

#ldapuser.ldif
sed -i "s|USER_PASS|${PASSWORD2}|g" files/ldapuser.ldif
ldapadd -x -D cn=Manager,dc=devopsldab,dc=com -w ${ADMIN_PASS} -f files/ldapuser.ldif


#Install phpldapadmin
sudo yum --enablerepo=epel -y install phpldapadmin
sudo sed -i '397 s;// $servers;$servers;' /etc/phpldapadmin/config.php
sudo sed -i '398 s;$servers->setValue;// $servers->setValue;' /etc/phpldapadmin/config.php
sudo sed -i ' s;Require local;Require all granted;' /etc/httpd/conf.d/phpldapadmin.conf 
sudo sed -i ' s;Allow from 127.0.0.1;Allow from 0.0.0.0;' /etc/httpd/conf.d/phpldapadmin.conf 
sudo systemctl restart httpd