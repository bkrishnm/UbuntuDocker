# Docker installation script for Ubuntu 16.04 (Xenial) on Azure
# Usage: execute sudo -i, first.
# wget -q -O - "$@" https://gist.github.com/catataw/63044e79c3cfa20198408130ba52e110/raw/ --no-cache | sh
# After running the script reboot and check whether docker is running.

DOCKER_RESULT=1

while [ $DOCKER_RESULT -ne 0 ]; do
echo "#################################################"
echo "  Updating System"
echo "#################################################"
apt-get update -y
apt-get upgrade -y

# Set up repository
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update -y
apt-get install -y linux-image-extra-$(uname -r) && sudo modprobe aufs
apt-get update -y
echo "#################################################"
echo "  Purging Docker"
echo "#################################################"
apt-get purge lxc-docker
apt-cache policy docker-engine
echo "#################################################"
echo "  Update and Install Docker"
echo "#################################################"
apt-get update -y
apt-get install -y docker-engine docker-ce docker-ce-cli containerd.io
which docker
DOCKER_RESULT=$?
echo "#################################################"
echo "  Docker install result ${DOCKER_RESULT}"
echo "#################################################"
done

echo "#################################################"
echo "  Starting Docker "
echo "#################################################"
service docker start

echo ""
echo "#################################################"
echo "  Installing Docker Compose "
echo "#################################################"
curl -L -f -S -s --connect-timeout 5 --retry 15 -o /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m`
chmod +x /usr/local/bin/docker-compose
