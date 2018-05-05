# Build with:  docker build -t pantools .
# Note: I've seen Build fail when using VPN, potentially a firewall blocking file downloads.

###
### The following installs Ubuntu 16.04 LTS codename Xenial
###
### Ubuntu ~402MB
###

FROM ubuntu:xenial

RUN apt-get update -q \
    && apt-get upgrade -q -y \
    && apt-get install -y \
        build-essential \
        curl \
        git \
        libbz2-dev \
        libncurses5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        zlib1g-dev


### PyEnv ~4MB
ENV HOME=/root PYENV_ROOT=/opt/pyenv PATH=/opt/pyenv/shims:/opt/pyenv/bin:$PATH
RUN curl https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

### Python 2.7.14 ~121MB
RUN pyenv install 2.7.14

### Python 3.6.5 ~177MB
RUN pyenv install 3.6.5

RUN pyenv global 3.6.5 2.7.14


###
### Other Network Utilities
###

# vi Text editor ~2MB
RUN apt-get install vim-tiny -y

# Nano Text editor ~1MB
RUN apt-get install nano

# Ping ~2MB
RUN apt-get install iputils-ping -yq

# Traceroute ~1MB
RUN apt-get install traceroute

# ifconfig ~1MB
RUN apt-get install net-tools

# TCPDump ~3MB
RUN apt-get install tcpdump -y

# Telnet ~1MB ... useful for port testing :)
RUN apt-get install telnet

# NSLookup ~45MB
RUN apt-get install dnsutils -y

# SNMPWalk ~6MB
RUN apt-get install snmp -y

# sha256sum and md5sum ~1MB
RUN apt-get install hashalot

# iPerf ~2MB
RUN apt-get install iperf

# PAN Configurator ~44MB
### Doesn't seem to work... Need to setup correct environment variables to get working ???
RUN apt-get install php -y
RUN git clone https://github.com/cpainchaud/pan-configurator/

# Ansible ~76MB
RUN pyenv global 3.6.5
RUN pip install ansible
# Switch to the correct Python version to run
RUN echo 'alias ansible="pyenv global 3.6.5; /opt/pyenv/shims/ansible"' >> /root/.bashrc

# NMap ~54MB
RUN apt-get install nmap -y

# Harden Script ~3MB
RUN pyenv global 2.7.14
RUN pip install requests
RUN git clone https://github.com/p0lr/Harden/ /scripts/harden

# My Trace Route ~28MB
RUN apt-get install mtr -y

# Un-comment following line to add local scripts directory and all sub-directories, if they exist
# COPY scripts /scripts/
