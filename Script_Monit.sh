#! /bin/bash
# unset any variable which system may be using
# clear the screen
clear
unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage
while getopts iv name
do
        case $name in
          i)iopt=1;;
          v)vopt=1;;
          *)echo "Argumento invalido";;
        esac
done
if [[ ! -z $iopt ]]
then
{
wd=$(pwd)
basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
su -c "cp $scriptname /usr/bin/monitor" root && echo "Felicidades! Ha instalado Scrip_Monit" || echo "La instalacion ha fallado"
}
fi
if [[ ! -z $vopt ]]
then
{
echo -e " Script_Monit version 0.1 creado por BlogoTecnica.com"
}
fi
if [[ $# -eq 0 ]]
then
{
# Define Variables
tecreset=$(tput sgr0)
dia=`date +"%d/%m/%Y"`
hora=`date +"%H:%M"`
version="v1.0 Script_Monit by Blogotecnica.com"
echo -e '\E[32m'" ........................................................................................"
echo -e '\E[32m'" ........................................................................................"
echo -e '\E[32m'" ... Script para monitorear servidores, version $version ..."
echo -e '\E[32m'" ........................................................................................"
echo -e '\E[32m'" ........................................................................................"
echo -e '\E[32m'"Hora a la que se ha testeado el monetireo del servidor:" $tecreset $hora
echo -e '\E[32m'"Dia  que se ha testeado el monetireo del servidor:" $tecreset $dia
# Checkea conexion a internet
ping -c 1 google.com &> /dev/null && echo -e '\E[32m'"Internet: $tecreset Actualmente estas conectado" || echo -e '\E[32m'"Internet: $tecreset Actualmente estas desconectado"
# Checkea el tipo de sistema operativo que usa
os=$(uname -o)
echo -e '\E[32m'"Tipo de sistema operativo que usa este servidor:" $tecreset $os
# Checkea la version del sistema operativo y el nombre
cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' > /tmp/osrelease
echo -n -e '\E[32m'"Nombre del sistema operativo usado en este servidor :" $tecreset && cat /tmp/osrelease | grep -v "VERSION" | cut -f2 -d\"
echo  -n -e '\E[32m'"Version del sistema operativo usado en este servidor :" $tecreset && cat /tmp/osrelease | grep -v "NAME" | cut -f2 -d\"
# Checkea la ackitectura 
architecture=$(uname -m)
echo -e '\E[32m'"Architectura del servidor:" $tecreset $architecture
# Checkea el kernel
kernelrelease=$(uname -r)
echo -e '\E[32m'"Kernel usado en el servidor:" $tecreset $kernelrelease
# Checkea el nombre de la maquina
echo -e '\E[32m'"Dominio o nombre del Servidor :" $tecreset $HOSTNAME
# Checkea la ip interna del servidor
internalip=$(hostname -I)
echo -e '\E[32m'"IP interna del Servidor :" $tecreset $internalip
# Checkea la ip externa del servidor
externalip=$(curl -s ipecho.net/plain;echo)
echo -e '\E[32m'"IP publica del Servidor : $tecreset "$externalip
# Checkea los DNS
nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
echo -e '\E[32m'"Nombre del Servidor :" $tecreset $nameservers 
# Checkea usuarios logueados
who>/tmp/who
echo -e '\E[32m'"Usuarios logueados en el Servidor :" $tecreset && cat /tmp/who 
# Checkea ram  y swap
free -h | grep -v + > /tmp/ramcache
echo -e '\E[32m'"Memoria Ram usada :" $tecreset
cat /tmp/ramcache | grep -v "Swap"
echo -e '\E[32m'"Swap usado :" $tecreset
cat /tmp/ramcache | grep -v "Mem"
# Checkea  la memoria de los discos 
df -h| grep 'Filesystem\|/dev/sda*' > /tmp/diskusage
echo -e '\E[32m'"Disco Usado :" $tecreset 
cat /tmp/diskusage
# Checkea el promedio de carga
loadaverage=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
echo -e '\E[32m'"Porcentage de carga :" $tecreset $loadaverage
# Checkea el Uptime del servidor
tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
echo -e '\E[32m'"Uptime del sistema/(HH:MM) :" $tecreset $tecuptime
# Borra variables
unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage
# Borra los archivos temporales
rm /tmp/osrelease /tmp/who /tmp/ramcache /tmp/diskusage
}
fi
shift $(($OPTIND -1))
