#!/bin/bash 

if [ -f /etc/os-release ]; then
    osname=$(grep ID /etc/os-release | egrep -v 'VERSION|LIKE' | cut -d'=' -f2)
    echo $osname
else
    echo "Can not locate /etc/os-release - unable to find the osname"
    exit 8
fi

if [ $osname == "ubuntu" ]; then

    clear
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible

    echo "$(ansible --version) installed successfully"

fi
exit 0 
