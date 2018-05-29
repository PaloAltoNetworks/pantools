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

# Netcat ~1MB
RUN apt-get install netcat -y

# NSLookup ~45MB
RUN apt-get install dnsutils -y


# SNMPWalk ~6MB
RUN apt-get install snmp -y

# Install Common MIBS ~25MB
RUN apt-get install snmp-mibs-downloader -y

# Install PAN specific MIBs from PAN-OS 8.1 ~1MB
RUN apt-get install unzip
RUN wget https://www.paloaltonetworks.com/content/dam/pan/en_US/assets/zip/technical-documentation/snmp-mib-modules/PAN-MIB-MODULES-8.1.zip -O /tmp/temp.zip
RUN unzip /tmp/temp.zip -d /tmp
RUN rm /tmp/temp.zip
RUN mv /tmp/*.my /usr/share/snmp/mibs
RUN rm /tmp/*.md5
RUN sed -i 's/mibs :/# mibs :/g' /etc/snmp/snmp.conf
RUN echo "mibs +PAN-COMMON-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-ENTITY-EXT-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-LC-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-TRAPS" >> /etc/snmp/snmp.conf


# sha256sum and md5sum ~1MB
RUN apt-get install hashalot

# iPerf ~2MB
# iperf -s -p 8888 : Server listen on port 8888 (Run Docker with -p 8888:8888)
# iperf -c w.x.y.z -p 8888 -n 1M  : Send to server w.x.y.z 1MB via TCP
RUN apt-get install iperf

# PAN Configurator ~53MB
RUN apt-get install php -y
RUN apt-get install php7.0-curl -y
RUN apt-get install php7.0-xml -y
RUN git clone https://github.com/swaschkut/pan-configurator/
RUN echo 'include_path = ".:/pan-configurator"' >> /etc/php/7.0/cli/php.ini
RUN cat /pan-configurator/utils/alias.sh >> /root/.bashrc

# Ansible ~27MB
#~76MB
#RUN pyenv global 3.6.5
#RUN pip install ansible
#Switch to the correct Python version to run
#RUN echo 'alias ansible="pyenv global 3.6.5; /opt/pyenv/shims/ansible"' >> /root/.bashrc
#Just using apt-get appears to work best ;)
RUN apt-get install ansible -y

# NMap ~54MB
RUN apt-get install nmap -y

# Harden Script ~3MB
RUN pyenv global 2.7.14
RUN pip install requests
RUN git clone https://github.com/p0lr/Harden/ /scripts/harden

# My Trace Route ~28MB
RUN apt-get install mtr -y

# GoPAN Utilities ~20MB
RUN mkdir /GoPAN
RUN curl -L https://github.com/zepryspet/GoPAN/raw/master/binaries/linux64bit/GoPAN -o /GoPAN/GoPAN
RUN chmod 755 /GoPAN/GoPAN
RUN curl -L https://raw.githubusercontent.com/zepryspet/GoPAN/master/README.md -o /GoPAN/README.md

# Speedtest ~1MB
RUN pyenv global 2.7.14
RUN pip install speedtest-cli

# PAN-Toolbox ~20MB
# Example: /pan-toolbox/pan-rcli-nopass.py -fw w.x.y.z -u admin -p admin -cmd "show system info" -stdout
RUN pyenv global 2.7.14
RUN pip install paramiko
RUN git clone https://github.com/workape/pan-toolbox
RUN chmod +x /pan-toolbox/*.py

# todos and fromdos to convert LF to CR/LF for Windows/Linux/Mac text compatibility ~2MB
RUN apt-get install tofrodos


# Un-comment following line to add local scripts directory and all sub-directories, if they exist
# COPY scripts /scripts/
