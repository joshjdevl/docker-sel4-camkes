FROM ubuntu:14.04
MAINTAINER <joshjdevl@gmail.com>

RUN apt-get -qq update && apt-get -qq -y install python-software-properties software-properties-common && \
add-apt-repository "deb http://gb.archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" && \
apt-get -qq update

RUN add-apt-repository ppa:saiarcot895/myppa && \
apt-get -qq update && \
apt-get -qq -y install apt-fast -qq

RUN apt-fast -qq update

RUN apt-fast -qq install -y git phablet-tools
RUN git config --global user.email "<email>"

#http://sel4.systems/Download/
ENV HOME /home/root

RUN mkdir -p $HOME/bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > $HOME/bin/repo
RUN chmod a+x $HOME/bin/repo

RUN sudo apt-fast -qq install -y git python

ENV PATH $HOME/bin:$PATH
RUN mkdir $HOME/seL4test
RUN cd $HOME/seL4test
RUN  git config --global user.email "you@example.com"
RUN  git config --global user.name "Your Name"
#RUN $HOME/bin/repo init -u https://github.com/seL4/sel4test-manifest.git
#RUN $HOME/bin/repo sync

#http://sel4.systems/Download/DebianToolChain.pml
RUN sudo apt-get -qq update
RUN sudo apt-fast -qq install -y build-essential realpath libxml2-utils python-tempita
RUN sudo apt-fast -qq install -y gcc-multilib ccache ncurses-dev
RUN sudo apt-fast -qq install -y cabal-install ghc libghc-missingh-dev libghc-split-dev 
RUN cabal update
RUN cabal install data-ordlist
RUN sudo apt-fast -qq install -y python-pip python-jinja2 python-ply
RUN sudo pip install --upgrade pip
RUN sudo pip install pyelftools


#Ubuntu 14.04
RUN sudo apt-get -qq install python-software-properties
RUN sudo add-apt-repository universe
RUN sudo apt-get -qq update
RUN sudo apt-fast -qq install -y gcc-arm-linux-gnueabi
RUN sudo apt-fast -qq install -y qemu-system-arm qemu-system-x86

WORKDIR $HOME/seL4test
RUN git config --global color.ui false
RUN $HOME/bin/repo init -u https://github.com/seL4/sel4test-manifest.git
RUN $HOME/bin/repo sync

#Build
RUN make ia32_simulation_release_xml_defconfig
RUN make
#RUN make simulate-ia32

#CAMKES
#http://sel4.systems/CAmkES/GettingStarted.pml

#dependencies
RUN sudo apt-fast -qq install -y build-essential lib32z1 lib32ncurses5 lib32bz2-1.0 python python-pip python-tempita cabal-install realpath libxml2-utils qemu git python-jinja2 python-ply

WORKDIR /tmp
RUN sudo mkdir -p /opt/local
RUN wget https://sourcery.mentor.com/public/gnu_toolchain/arm-none-eabi/arm-2013.11-24-arm-none-eabi-i686-pc-linux-gnu.tar.bz2
RUN tar xf arm-2013.11-24-arm-none-eabi-i686-pc-linux-gnu.tar.bz2
RUN sudo mv arm-2013.11 /opt/local/

RUN pip install --user pyelftools

RUN cabal update
RUN cabal install MissingH data-ordlist split

#camkes source
RUN mkdir $HOME/camkes-project
WORKDIR $HOME/camkes-project
RUN $HOME/bin/repo init -u https://github.com/seL4/camkes-manifest.git
RUN $HOME/bin/repo sync

RUN make arm_simple_defconfig
RUN make silentoldconfig
RUN make

CMD tail -f /dev/null
