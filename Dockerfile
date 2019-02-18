# Build with:  docker build -t pantools .
# The following installs Ubuntu 16.04 LTS codename Xenial
#
# Ubuntu ~402MB
#

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

### Python 2.7.15 ~121MB
RUN pyenv install 2.7.15

### Python 3.6.7 ~177MB
RUN pyenv install 3.6.7

RUN pyenv global 3.6.7 2.7.15


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

# sha256sum and md5sum ~1MB
RUN apt-get install hashalot

# My Trace Route ~28MB
RUN apt-get install mtr -y

# Speedtest ~1MB
RUN pyenv global 2.7.15
RUN pip install speedtest-cli

# todos and fromdos to convert LF to CR/LF for Windows/Linux/Mac text compatibility ~2MB
RUN apt-get install tofrodos

# Hping3 ~5MB
# Examples: http://0daysecurity.com/articles/hping3_examples.html
# Note: Docker seems to rate/limit/drop flood commands
RUN apt-get install hping3 -y

# Lynx Web Browser ~8MB
RUN apt-get install lynx -y

# Slurm Network Usage ~1MB
# Example: slurm -i eth0
RUN apt-get install slurm -y

# NMon System Monitor ~2MB
RUN apt-get install nmon -y

# Disk Monitor ~3MB
# Example: Disk Queue size: iostat -x
RUN apt-get install sysstat -y

# Aria2 Multi-threaded download ~xxMB
# Example download with 8 connections: aria2c -x 8 http://releases.ubuntu.com/16.04/ubuntu-16.04.5-desktop-amd64.iso 
RUN apt-get install aria2 -y


# SNMPWalk ~6MB
RUN apt-get install snmp -y

# Install Common MIBS ~25MB
RUN apt-get install snmp-mibs-downloader -y

# Install PAN specific MIBs from PAN-OS 8.1 ~1MB
RUN apt-get install unzip
RUN wget https://www.paloaltonetworks.com/content/dam/pan/en_US/assets/zip/technical-documentation/snmp-mib-modules/PAN-MIB-MODULES-8.1.zip -O /tmp/temp.zip
RUN unzip /tmp/temp.zip -d /tmp
RUN mv /tmp/PAN-MIB-MODULES-8.1/*.my /usr/share/snmp/mibs
RUN rm /tmp/temp.zip
RUN rm /tmp/PAN-MIB-MODULES-8.1 -rf
RUN sed -i 's/mibs :/# mibs :/g' /etc/snmp/snmp.conf
RUN echo "mibs +PAN-COMMON-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-ENTITY-EXT-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-LC-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-TRAPS" >> /etc/snmp/snmp.conf


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

# Ansible ~76MB
#RUN echo 'alias ansible="pyenv global 2.7.15; /opt/pyenv/shims/ansible"' >> /root/.bashrc
ENV ANSIBLE_VERSION=2.7.4
RUN pyenv global 2.7.15
RUN pip install ansible==${ANSIBLE_VERSION} \
        pandevice \
        pan-python \
        xmltodict \
        jsonschema 
RUN mkdir /etc/ansible
RUN wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg -O /etc/ansible/ansible.cfg
RUN wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/hosts -O /etc/ansible/hosts
RUN ansible-galaxy install PaloAltoNetworks.paloaltonetworks
RUN echo '[defaults]' >> /etc/ansible/ansible.cfg
RUN echo 'library = /root/.ansible/roles/PaloAltoNetworks.paloaltonetworks/library/' >> /etc/ansible/ansible.cfg
RUN ln -s /opt/pyenv/shims/python /usr/bin/python

# NMap 7.70 ~28MB
RUN curl -fL -o /tmp/nmap.tar.bz2 \
         https://nmap.org/dist/nmap-7.70.tar.bz2 \
 && tar -xjf /tmp/nmap.tar.bz2 -C /tmp \
 && cd /tmp/nmap* \
 && ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --without-zenmap \
        --without-nmap-update \
        --with-openssl=/usr/lib \
        --with-liblua=/usr/include \
 && make \
 && make install \
 && rm -rf /var/cache/apk/* \
           /tmp/nmap*
# NMap 7.01 was causing a problem with Ansible libraries and may be an issue with PyEnv as well...
# NMap 7.70 installation seems to work well with NMap and Ansible
# As of Jan 2019... below installs Nmap 7.01
#RUN apt-get install nmap -y

# Harden Script ~3MB
RUN pyenv global 2.7.15
RUN pip install requests
RUN git clone https://github.com/p0lr/Harden/ /scripts/harden

# GoPAN Utilities ~20MB
RUN mkdir /GoPAN
RUN curl -L https://github.com/zepryspet/GoPAN/raw/master/binaries/linux64bit/GoPAN -o /GoPAN/GoPAN
RUN chmod 755 /GoPAN/GoPAN
RUN curl -L https://raw.githubusercontent.com/zepryspet/GoPAN/master/README.md -o /GoPAN/README.md

# PAN-Toolbox ~20MB
# Example: /pan-toolbox/pan-rcli-nopass.py -fw w.x.y.z -u admin -p admin -cmd "show system info" -stdout
RUN pyenv global 2.7.15
RUN pip install paramiko
RUN git clone https://github.com/workape/pan-toolbox
RUN chmod +x /pan-toolbox/*.py

# CPS Bot ~10MB
# Script to SNMP Poll Active CPS numbers for each Zone
RUN pip install pudb
RUN git clone https://github.com/ipzero209/cps_bot
RUN chmod +x /cps_bot/cps_bot.py
# Fix script to run with PyEnv
RUN sed -i 's/python/env python/' /cps_bot/cps_bot.py

# Microsoft Powershell (pwsh) with Azure Module ~60MB
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v6.1.0/powershell_6.1.0-1.ubuntu.16.04_amd64.deb
RUN apt-get install -y liblttng-ust0
RUN dpkg -i powershell_6.1.0-1.ubuntu.16.04_amd64.deb
RUN rm powershell_6.1.0-1.ubuntu.16.04_amd64.deb
RUN mkdir /root/.config/powershell
RUN echo "# Installing Modules can be blocked by some Firewalls" >> /root/.config/powershell/profile.ps1
RUN echo "Install-Module -Force Az" >> /root/.config/powershell/profile.ps1
RUN echo "Import-Module Az" >> /root/.config/powershell/profile.ps1
RUN echo "***** Running Powershell... Don't be alarmed by Display Issues :) *****"
RUN pwsh
RUN echo "Enable-AzureRmAlias" > /root/.config/powershell/profile.ps1

# Microsoft Azure CLI (az) ~170MB
RUN pip install azure-cli
# apt-get install below works but uses ~360MB... using PIP instead
#RUN apt-get install apt-transport-https lsb-release software-properties-common -y
#ENV AZ_REPO=xenial
#RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
#    tee /etc/apt/sources.list.d/azure-cli.list
#RUN apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
#     --keyserver packages.microsoft.com \
#     --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF
#RUN apt-get update
#RUN apt-get install azure-cli

# Terraform 0.11 ~90MB
ENV tf_ver=0.11.10
RUN curl -L -o terraform.zip https://releases.hashicorp.com/terraform/${tf_ver}/terraform_${tf_ver}_linux_amd64.zip && \
    unzip terraform.zip && \
    install terraform /usr/local/bin/terraform-0.11 && \
    rm -rf terraform.zip terraform && \
    mv /usr/local/bin/terraform-0.11 /usr/local/bin/terraform
RUN echo 'alias terraform="/usr/local/bin/terraform"' >> /root/.bashrc
RUN echo 'alias tf="/usr/local/bin/terraform"' >> /root/.bashrc

# Google Cloud SDK ~140MB
ENV GCLOUD_VERSION 230.0.0
RUN curl --silent -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz -o google-cloud-sdk.tar.gz \
 && tar xzf google-cloud-sdk.tar.gz \
 && rm google-cloud-sdk.tar.gz \
 && google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc \
 # Disable gcloud components Update Check
 && google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true
RUN echo 'alias gcloud="/google-cloud-sdk/bin/gcloud"' >> /root/.bashrc
RUN echo 'alias gsutil="/google-cloud-sdk/bin/gsutil"' >> /root/.bashrc

# AWS CLI ~60MB
RUN pip install awscli awsebcli

# Clean-up
RUN apt-get -y autoremove && \
    apt-get -y autoclean && \ 
    apt-get -y clean all && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.pip/cache && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt

# Un-comment following line to add local scripts directory and all sub-directories, if they exist
# COPY scripts /scripts/
