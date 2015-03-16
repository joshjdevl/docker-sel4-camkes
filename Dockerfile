FROM ubuntu:14.04
MAINTAINER Ihor Kuz <ihor.kuz@nicta.com.au>

RUN apt-get update

RUN apt-get install -y git phablet-tools
RUN git config --global user.email "<email>" 

RUN apt-get install -y build-essential gcc-multilib ccache ncurses-dev

RUN apt-get install -y python-software-properties
RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install -y gcc-arm-linux-gnueabi
RUN apt-get install -y gcc-arm-none-eabi

RUN apt-get install -y lib32z1 lib32ncurses5 lib32bz2-1.0

RUN apt-get install -y qemu-system-arm qemu-system-x86

RUN apt-get install -y python python-pip python-tempita python-jinja2 python-ply
RUN pip install --upgrade pip
RUN hash -d pip
RUN pip install pyelftools

RUN apt-get install -y cabal-install ghc libghc-missingh-dev libghc-split-dev
RUN cabal update
RUN cabal install data-ordlist

RUN apt-get install -y realpath libxml2-utils 

RUN apt-get install -y minicom android-tools-fastboot u-boot-tools 

RUN mkdir /home/root

CMD ["/bin/bash"]
