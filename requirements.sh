# If bash command fails, build should error out
set -e

# https://bugs.debian.org/830696 (apt uses gpgv by default in newer releases, rather than gpg)
set -x \
	&& apt-get update \
	&& { \
		which gpg \
		|| apt-get install -y --no-install-recommends gnupg \
	; } \
	&& { \
		gpg --version | grep -q '^gpg (GnuPG) 1\.' \
		|| apt-get install -y --no-install-recommends dirmngr \
	; } \
	&& rm -rf /var/lib/apt/lists/*

# apt-key is a bit finicky during "docker build" with gnupg 2.x, so install the repo key the same way debian-archive-keyring does (/etc/apt/trusted.gpg.d)
# this makes "apt-key list" output prettier too!
set -x \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys DD95CC430502E37EF840ACEEA5D32F012649A5A9 \
	&& gpg --export DD95CC430502E37EF840ACEEA5D32F012649A5A9 > /etc/apt/trusted.gpg.d/neurodebian.gpg \
	&& rm -rf "$GNUPGHOME" \
	&& apt-key list | grep neurodebian

{ \
	echo 'deb http://neuro.debian.net/debian trusty main'; \
	echo 'deb http://neuro.debian.net/debian data main'; \
	echo '#deb-src http://neuro.debian.net/debian-devel trusty main'; \
} > /etc/apt/sources.list.d/neurodebian.sources.list

sed -i -e 's,main *$,main contrib non-free,g' /etc/apt/sources.list.d/neurodebian.sources.list; grep -q 'deb .* multiverse$' /etc/apt/sources.list || sed -i -e 's,universe *$,universe multiverse,g' /etc/apt/sources.list

apt-get update
apt-get install -y fsl
##### Install specific package versions with pip #####
pip3 install nipype
pip3 install requests
pip3 install nilearn
pip3 install sklearn
# pip3 install pandas==0.22.0
# pip3 install matplotlib==2.1.2
# pip3 install scikit-learn==0.19.1
