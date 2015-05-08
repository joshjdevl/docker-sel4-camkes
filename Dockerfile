FROM ubuntu:14.04
MAINTAINER Ihor Kuz <ihor.kuz@nicta.com.au>

RUN apt-get update && apt-get -y install python-software-properties software-properties-common && \
add-apt-repository "deb http://gb.archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" && \
apt-get update

RUN add-apt-repository ppa:saiarcot895/myppa && \
apt-get update && \
apt-get -y install apt-fast

RUN apt-fast update

RUN apt-fast install -y git phablet-tools
RUN git config --global user.email "<email>" 

RUN apt-fast install -y build-essential gcc-multilib ccache ncurses-dev

RUN apt-fast install -y python-software-properties
RUN add-apt-repository universe
RUN apt-fast update
RUN apt-fast install -y gcc-arm-linux-gnueabi
RUN apt-fast install -y gcc-arm-none-eabi

RUN apt-fast install -y lib32z1 lib32ncurses5 lib32bz2-1.0

RUN apt-fast install -y qemu-system-arm qemu-system-x86

RUN apt-fast install -y python python-pip python-tempita python-jinja2 python-ply
RUN pip install --upgrade pip
RUN hash -d pip
RUN pip install pyelftools

RUN apt-fast install -y cabal-install ghc libghc-missingh-dev libghc-split-dev
RUN cabal update
RUN cabal install data-ordlist

RUN apt-fast install -y realpath libxml2-utils 

RUN apt-fast install -y minicom android-tools-fastboot u-boot-tools 

RUN mkdir /home/root

RUN mkdir /home/root/camkes-manifest

RUN cd /home/root/camkes-manifest && repo init -u https://github.com/seL4/camkes-manifest.git
RUN cd /home/root/camkes-manifest && repo sync

RUN cd /home/root/camkes-manifest && make arm_simple_defconfig && make silentoldconfig && make -j 2 

CMD ["/bin/bash"]
