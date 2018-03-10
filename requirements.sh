# If bash command fails, build should error out
set -e
apt-get install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
##### Install specific package versions with pip #####
pip3 install docker
# pip3 install pandas==0.22.0
# pip3 install matplotlib==2.1.2
# pip3 install scikit-learn==0.19.1
