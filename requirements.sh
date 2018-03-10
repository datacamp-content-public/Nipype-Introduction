# If bash command fails, build should error out
set -e

apt-get update

apt-get install -y apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce

##### Install specific package versions with pip #####
pip3 install docker
# pip3 install pandas==0.22.0
# pip3 install matplotlib==2.1.2
# pip3 install scikit-learn==0.19.1
