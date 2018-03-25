# MySQL 5.7 / SSH sur Ubuntu
#
# VERSION               0.0.1
#

FROM     ubuntu:artful
MAINTAINER Gallyoko "yogallyko@gmail.com"

# Definition des constantes
ENV login_ssh="mysqlserver"
ENV password_ssh="mysqlserver"
ENV password_mysql="mysqlserver"

# Mise a jour des depots
RUN (apt-get update && apt-get upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)
 
# Installation des paquets de base
RUN apt-get install -y -q wget nano openssh-server

# Installation de MySQL
RUN echo "mysql-server-5.7 mysql-server/root_password password ${password_mysql}" | debconf-set-selections
RUN echo "mysql-server-5.7 mysql-server/root_password_again password ${password_mysql}" | debconf-set-selections
RUN apt-get -y -q install mysql-server-5.7

# Ajout utilisateur "${login_ssh}"
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/${login_ssh} --gecos "User" ${login_ssh}

# Modification du mot de passe pour "${login_ssh}"
RUN echo "${login_ssh}:${password_ssh}" | chpasswd

# Ajout des droits admin pour "${login_ssh}"
RUN usermod -a -G root ${login_ssh}

# Ports
EXPOSE 22 3306 4309

# script de lancement des services et d affichage de l'accueil
COPY services.sh /root/services.sh
RUN chmod -f 755 /root/services.sh

# Ajout du script services.sh au demarrage
RUN echo "sh /root/services.sh" >> /root/.bashrc
