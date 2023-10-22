if [ -f /etc/os-release ]; then
    osname=$(grep ID /etc/os-release | egrep -v 'VERSION|LIKE' | cut -d'=' -f2)
    echo $osname
else
    echo "Can not locate /etc/os-relese - unable to find osname"
    exit 8
fi  

if [ $osname == "ubuntu" ]; then

    clear
    sudo 
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository --yes --update ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install -y git

    echo "$(git --version) installed successfully"
fi

exit 0 