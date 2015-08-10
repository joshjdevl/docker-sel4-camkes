FROM ubuntu:14.04
MAINTAINER <joshjdevl@gmail.com>

RUN apt-get update && apt-get -y install python-software-properties software-properties-common && \
add-apt-repository "deb http://gb.archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" && \
apt-get update

RUN add-apt-repository ppa:saiarcot895/myppa && \
apt-get update && \
apt-get -y install apt-fast

RUN apt-fast update

RUN apt-fast install -y git phablet-tools
RUN git config --global user.email "<email>"

#http://sel4.systems/Download/
ENV HOME /home/root

RUN mkdir -p $HOME/bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > $HOME/bin/repo
RUN chmod a+x $HOME/bin/repo

RUN sudo apt-fast install -y git python

ENV PATH $HOME/bin:$PATH
RUN mkdir $HOME/seL4test
RUN cd $HOME/seL4test
RUN  git config --global user.email "you@example.com"
RUN  git config --global user.name "Your Name"
#RUN $HOME/bin/repo init -u https://github.com/seL4/sel4test-manifest.git
#RUN $HOME/bin/repo sync

#http://sel4.systems/Download/DebianToolChain.pml
RUN sudo apt-get update
RUN sudo apt-fast install -y build-essential realpath libxml2-utils python-tempita
RUN sudo apt-fast install -y gcc-multilib ccache ncurses-dev
RUN sudo apt-fast install -y cabal-install ghc libghc-missingh-dev libghc-split-dev 
RUN cabal update
RUN cabal install data-ordlist
RUN sudo apt-fast install -y python-pip python-jinja2 python-ply
RUN sudo pip install --upgrade pip
RUN sudo pip install pyelftools


#Ubuntu 14.04
RUN sudo apt-get install python-software-properties
RUN sudo add-apt-repository universe
RUN sudo apt-get update
RUN sudo apt-fast install -y gcc-arm-linux-gnueabi
RUN sudo apt-fast install -y qemu-system-arm qemu-system-x86

WORKDIR $HOME/seL4test
RUN git config --global color.ui false
RUN $HOME/bin/repo init -u https://github.com/seL4/sel4test-manifest.git
RUN $HOME/bin/repo sync

#Build
RUN make ia32_simulation_release_xml_defconfig
RUN make
#RUN make simulate-ia32

CMD tail -f /dev/null
