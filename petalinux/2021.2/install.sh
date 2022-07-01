apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
  build-essential \
  sudo \
  tofrodos \
  iproute2 \
  gawk \
  net-tools \
  expect \
  libncurses5-dev \
  tftpd \
  update-inetd \
  libssl-dev \
  flex \
  bison \
  libselinux1 \
  gnupg \
  wget \
  socat \
  gcc-multilib \
  libsdl1.2-dev \
  libglib2.0-dev \
  lib32z1-dev \
  libgtk2.0-0 \
  xxd \
  libidn11 \
  screen \
  pax \
  diffstat \
  xvfb \
  xterm \
  texinfo \
  gzip \
  unzip \
  cpio \
  chrpath \
  autoconf \
  lsb-release \
  libtool \
  libtool-bin \
  locales \
  kmod \
  git \
  rsync \
  bc \
  u-boot-tools \
  python \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

dpkg --add-architecture i386 &&  apt-get update &&  \
      DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
      zlib1g:i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

locale-gen en_US.UTF-8 && update-locale

sudo adduser $USER dialout

sudo dpkg-reconfigure dash

mkdir -p /tools/Xilinx
chmod 777 /tools/Xilinx
chmod +x petalinux-v2021.2-final-installer.run

echo "export LC_ALL en_US.UTF-8" >> /home/.bashrc
echo "export LANG en_US.UTF-8" >> /home/.bashrc
echo "export LANGUAGE en_US.UTF-8" >> /home/.bashrc
