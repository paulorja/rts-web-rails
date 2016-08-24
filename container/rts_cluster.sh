#!/bin/bash
if [[ "$(whoami)" != "root" ]]; then
    echo "inicie o script como root"
    exit 1
fi
function message_install_docker {
    echo -e "Necessita de docker instalado para mais informação:\
    \npara mais informação como instalar acesse \
    \nhttps://docs.docker.com/engine/installation\
    \ncaso use ubuntu 12.04 ou superior podera iniciar o script como:\
    \nrts_cluster.sh --check-dependences"
}

function dependeces_ubuntu {
    apt-get update
    apt-get install apt-transport-https ca-certificates
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    case $(lsb_release -r | cut -f2 | sed s/' '/''/g) in
        14.04 )
        apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
        echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list
        ;;
        12.04 )
        echo 'deb https://apt.dockerproject.org/repo ubuntu-precise main' > /etc/apt/sources.list.d/docker.list
        ;;
        15.10)
        echo 'deb https://apt.dockerproject.org/repo ubuntu-wily main' > /etc/apt/sources.list.d/docker.list
        ;;
        16.04 )
        apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
        echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list
        ;;
        *)
        echo 'sua versão de ubuntu não é suportada'
        ;;
    esac
    apt-get update
    apt-get purge lxc-docker
    apt-cache policy docker-engine
    apt-get install docker-engine
    service docker start
    groupadd docker
    usermod -aG docker $USER
}

if [[ "$(docker --version 2> /dev/null)" != "" ]]; then message_install_docker; fi

case $1 in
    --check-dependences | -c )
        dependeces_ubuntu
    ;;
esac

exit 1