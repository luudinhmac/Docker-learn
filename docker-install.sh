#!/bin/bash
#if [ ! -z `sudo which apt | grep "/apt"` ]; then
#sudo apt -y update
#sudo apt -y install git wget
#elif [ -z `sudo which yum | grep "/yum"` ]; then
#yum update
#yum install -y wget git
#fi

# Check distro linux
is_ubuntu=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release | egrep Ubuntu -i)
is_centos=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release | egrep CentOS -i)
is_amazon_linux=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release | egrep 'Amazon Linux 2' -i)
# Get docker exist
if [ ! -z "$is_ubuntu" ]; then
    is_docker_exist=$(dpkg -l | grep docker -i)
elif [ ! -z "$is_centos" ]; then
    is_docker_exist=$(rpm -qa | grep docker)
elif [ ! -z "$is_amazon_linux" ]; then
    is_docker_exist=$(rpm -qa | grep docker)
else
    echo "Error: Current Linux release version is not supported, please use either centos or ubuntu. "
    exit
fi

if [ ! -z "$is_docker_exist" ]; then
    echo "Warning: docker already exists. "
fi

function ubuntu_install() {
    #Install docker
    sudo apt-get -y update
    sudo apt-get install -y curl wget git
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common git vim
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get -y update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker.service
    sudo systemctl start docker
    # Install docker-compose
    COMPOSE_VERSION=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1)
    sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose
    sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
    is_docker_success=$(sudo docker run hello-world | grep -i "Hello from Docker")
    if [ -z "$is_docker_success" ]; then
        echo "Error: Docker installation Failed."
        exit
    fi
    echo -e "Docker has been installed successfully."
}
function centos_install() {
    sudo yum install -y wget curl git
    #Install docker
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2 git vim
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum -y install docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker.service
    sudo systemctl start docker
    is_docker_success=$(sudo docker run hello-world | grep -i "Hello from Docker")
    if [ -z "$is_docker_success" ]; then
        echo -e "Error: Docker installation Failed."
        exit
    fi
    echo "Docker has been installed successfully."
}

function amazon_install() {
    sudo yum install -y git wget curl
    sudo amazon-linux-extras install docker -y
    sudo systemctl enable docker
    sudo systemctl start docker
    is_docker_success=$(sudo docker run hello-world | grep -i "Hello from Docker")
    if [ -z "$is_docker_success" ]; then
        echo -e "Error: Docker installation Failed."
        exit
    fi
    echo "Docker has been installed successfully."

}

# Install docker-compose
function docker_compose_install() {
    COMPOSE_VERSION=v$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1)
    echo "${COMPOSE_VERSION}"
    sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose
    sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
}
if [ ! -z "$is_ubuntu" ]; then
    ubuntu_install
elif [ ! -z "$is_centos" ]; then
    centos_install
elif [ ! -z "$is_amazon_linux" ]; then
    amazon_install
fi
docker_compose_install
docker-compose --version
echo "Docker-compose has been installed successfully."
