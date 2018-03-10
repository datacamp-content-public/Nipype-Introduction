# If bash command fails, build should error out
set -e
# copied from: https://github.com/neurodebian/dockerfiles/blob/16393dd2b676c6128a4b9742cb51b9ce9ab7d436/dockerfiles/xenial-non-free/Dockerfile
##################
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
	echo 'deb http://neuro.debian.net/debian xenial main'; \
	echo 'deb http://neuro.debian.net/debian data main'; \
	echo '#deb-src http://neuro.debian.net/debian-devel xenial main'; \
} > /etc/apt/sources.list.d/neurodebian.sources.list

sed -i -e 's,main *$,main contrib non-free,g' /etc/apt/sources.list.d/neurodebian.sources.list; grep -q 'deb .* multiverse$' /etc/apt/sources.list || sed -i -e 's,universe *$,universe multiverse,g' /etc/apt/sources.list
##################
# copied from https://github.com/poldracklab/fmriprep/blob/5db1828193932ee7ada44c2bc5974d934d4680a9/Dockerfile
##################
apt-get update && \
apt-get install -y --no-install-recommends \
                curl \
                bzip2 \
                ca-certificates \
                xvfb \
                cython3 \
                build-essential \
                autoconf \
                libtool \
                pkg-config

apt-get update && \
apt-get install -y --no-install-recommends \
                fsl-core=5.0.9-4~nd16.04+1 \
                fsl-mni152-templates=5.0.7-2 \
                afni=16.2.07~dfsg.1-5~nd16.04+1

{ \
echo 'FSLDIR=/usr/share/fsl/5.0'; \
echo 'FSLOUTPUTTYPE=NIFTI_GZ'; \
echo 'FSLMULTIFILEQUIT=TRUE'; \
echo 'POSSUMDIR=/usr/share/fsl/5.0'; \
echo 'LD_LIBRARY_PATH=/usr/lib/fsl/5.0:$LD_LIBRARY_PATH'; \
echo 'FSLTCLSH=/usr/bin/tclsh'; \
echo 'FSLWISH=/usr/bin/wish'; \
echo 'AFNI_MODELPATH=/usr/lib/afni/models'; \
echo 'AFNI_IMSAVE_WARNINGS=NO'; \
echo 'AFNI_TTATLAS_DATASET=/usr/share/afni/atlases'; \
echo 'AFNI_PLUGINPATH=/usr/lib/afni/plugins'; \
echo 'PATH=/usr/lib/fsl/5.0:/usr/lib/afni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
} > /etc/environment

##### Install specific package versions with pip #####
pip3 install \
     nipype  \
     nilearn \
     sklearn
