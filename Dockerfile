# Build with:  docker build -t pantools .
# The following installs Ubuntu 18.04 LTS codename Bionic ~382MB
#

FROM ubuntu:bionic

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

# Define Python Versions to use
ENV PY3VER 3.7.4
ENV PY2VER 2.7.16

### Python 3 ~198MB
# Need to install libffi-dev for Python 3.7 (not required for Python 3.6)
RUN apt-get install libffi-dev
RUN pyenv install $PY3VER

### Python 2 ~128MB
RUN pyenv install $PY2VER

# Upgrade Python 2 PIP 
RUN pyenv global $PY2VER
RUN pip2 install --upgrade pip

# Upgrade Python 3 PIP and leave Python 3 Active/Default
RUN pyenv global $PY3VER
RUN pip3 install --upgrade pip

RUN pyenv global $PY3VER $PY2VER

###
### Other Network Utilities
###

# vi Text editor ~2MB
RUN apt-get install vim-tiny -y

# Nano Text editor ~1MB
RUN apt-get install nano

# tree Directory output ~1MB
RUN apt-get install tree

# Ping ~2MB
RUN apt-get install iputils-ping -yq

# Traceroute ~1MB
RUN apt-get install traceroute

# ifconfig, netstat ~1MB
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
RUN pip install speedtest-cli

# todos and fromdos to convert LF to CR/LF for Windows/Linux/Mac text compatibility ~2MB
RUN apt-get install tofrodos

# Hping3 ~5MB
# Examples: http://0daysecurity.com/articles/hping3_examples.html
# Note: Docker seems to rate/limit/drop flood commands
# ENV fixes prompting in Ubuntu 18.04
ENV DEBIAN_FRONTEND=noninteractive
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

# iPerf3 ~2MB
# iperf3 -s -p 8888 : Server listen on port 8888 (Run Docker with -p 8888:8888)
# iperf3 -c w.x.y.z -p 8888 -n 1M  : Send to server w.x.y.z 1MB via TCP
RUN apt-get install iperf3 -y

# Aria2 Multi-threaded download ~6MB
# Example download with 8 connections: aria2c -x 8 http://releases.ubuntu.com/16.04/ubuntu-16.04.5-desktop-amd64.iso 
RUN apt-get install aria2 -y

# Midnight Commander mc ~10MB
RUN apt-get install mc -y


# SNMPWalk ~6MB
RUN apt-get install snmp -y

# Install Common MIBS ~25MB
RUN apt-get install snmp-mibs-downloader -y

# Install PAN specific MIBs from PAN-OS 9.0 ~1MB
RUN apt-get install unzip
RUN wget https://docs.paloaltonetworks.com/content/dam/techdocs/en_US/zip/snmp-mib/pan-90-snmp-mib-modules.zip -O /tmp/temp.zip
RUN unzip /tmp/temp.zip -d /tmp
RUN mv /tmp/*.my /usr/share/snmp/mibs
RUN rm /tmp/temp.zip
RUN rm /tmp/*.md5
RUN sed -i 's/mibs :/# mibs :/g' /etc/snmp/snmp.conf
RUN echo "mibs +PAN-COMMON-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-ENTITY-EXT-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-LC-MIB" >> /etc/snmp/snmp.conf
RUN echo "mibs +PAN-TRAPS" >> /etc/snmp/snmp.conf

# PAN Configurator ~53MB
RUN apt-get install php -y
RUN apt-get install php7.2-curl -y
RUN apt-get install php7.2-xml -y
RUN git clone https://github.com/swaschkut/pan-configurator/
RUN echo 'include_path = ".:/pan-configurator"' >> /etc/php/7.2/cli/php.ini
RUN cat /pan-configurator/utils/alias.sh >> /root/.bashrc

# Ansible ~118MB
ENV ANSIBLE_VERSION=2.8.5
RUN pip install ansible==${ANSIBLE_VERSION} \
        pandevice \
        pan-python \
        xmltodict \
        jsonschema 
RUN mkdir /etc/ansible
#RUN wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg -O /etc/ansible/ansible.cfg
#RUN wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/hosts -O /etc/ansible/hosts
RUN echo '[defaults]' >> /etc/ansible/ansible.cfg
# To not need roles defined in Playbooks
RUN echo 'library = /root/.ansible/roles/PaloAltoNetworks.paloaltonetworks/library/' >> /etc/ansible/ansible.cfg
RUN echo 'roles_path = /root/.ansible/roles' >> /etc/ansible/ansible.cfg
# Suppress Python warnings when running Playbooks
RUN echo 'interpreter_python = auto_silent' >> /etc/ansible/ansible.cfg
# To not need "-i hosts" when running Playbooks... "./hosts" should work... but doesn't for some reason... using fixed path
RUN echo 'inventory = /pwd/hosts' >> /etc/ansible/ansible.cfg
RUN ansible-galaxy install PaloAltoNetworks.paloaltonetworks
# Include panos_set Module
RUN curl -L https://raw.githubusercontent.com/ansible/ansible/fb9720429119cd56a7dde6d06600a082b4ab19c3/lib/ansible/modules/network/panos/_panos_set.py -o /root/.ansible/roles/PaloAltoNetworks.paloaltonetworks/library/panos_set.py
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
RUN pip install requests
RUN git clone https://github.com/p0lr/Harden/ /scripts/harden

# PANOS to Terraform Conversion Script ~1MB  // Need to test! :)
# RUN pyenv global $PY3VER
# RUN pip install pandevice
# RUN git clone https://github.com/freimer/import-pan /scripts/pancfg-to-tf
# RUN pyenv global $PY2VER

# GoPAN Utilities ~20MB
RUN mkdir /GoPAN
RUN curl -L https://github.com/zepryspet/GoPAN/raw/master/binaries/linux64bit/GoPAN -o /GoPAN/GoPAN
RUN chmod 755 /GoPAN/GoPAN
RUN curl -L https://raw.githubusercontent.com/zepryspet/GoPAN/master/README.md -o /GoPAN/README.md

# PAN-Toolbox ~20MB
# Example: /pan-toolbox/pan-rcli-nopass.py -fw w.x.y.z -u admin -p admin -cmd "show system info" -stdout
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

# SLR_Bot ~6MB
# Security Lifecycle Review script to gather/export stats
# Seems to run fine on Python 2.7.16... uncomment next 3 lines if you want Python 3.x
#RUN pyenv global $PY3VER
#RUN pip install requests
RUN git clone https://github.com/nembery/SLR_Bot
#RUN pyenv global $PY2VER

# Microsoft Powershell (pwsh) with Azure Module ~60MB
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v6.1.3/powershell_6.1.3-1.ubuntu.18.04_amd64.deb
RUN apt-get install -y liblttng-ust0
RUN dpkg -i powershell_6.1.3-1.ubuntu.18.04_amd64.deb
RUN rm powershell_6.1.3-1.ubuntu.18.04_amd64.deb
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
#RUN apt-get install azure-cli

# Terraform ~50MB
# May have to delete old .terraform directory if using previous 0.11.x TF files... to use new provider
# Also may have to run 'terraform 0.12upgrade' to convert TF files to the new format
ENV tf_ver=0.12.9
RUN curl -L -o terraform.zip https://releases.hashicorp.com/terraform/${tf_ver}/terraform_${tf_ver}_linux_amd64.zip && \
    unzip terraform.zip && \
    install terraform /usr/local/bin/terraform-${tf_ver} && \
    rm -rf terraform.zip terraform && \
    mv /usr/local/bin/terraform-${tf_ver} /usr/local/bin/terraform
RUN echo 'alias terraform="/usr/local/bin/terraform"' >> /root/.bashrc
RUN echo 'alias tf="/usr/local/bin/terraform"' >> /root/.bashrc

# Google Cloud SDK ~140MB
ENV GCLOUD_VERSION 263.0.0
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

# Shodan ~6MB
# https://cli.shodan.io/
RUN pip install shodan

# Support for PAN-FCA Flexible Cloud Automation ~1MB
RUN pip install requests-toolbelt


### Un-comment following line to add local scripts directory and all sub-directories, if they exist
# COPY scripts /scripts/


# SSHD Service ~48MB
### Un-comment the following 10 lines to run Pantools as a SSHD service for remote operation
# RUN apt-get install openssh-server -y
# RUN mkdir /var/run/sshd
# RUN echo 'root:paloalto' | chpasswd
# RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
### SSH into Docker ignores ENV variables... need to save into /etc/profile
# RUN echo "export HOME=/root" >> /etc/profile
# RUN echo "export PYENV_ROOT=/opt/pyenv" >> /etc/profile
# RUN echo "export PATH=/opt/pyenv/shims:/opt/pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /etc/profile
# EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]
###


# Clean-up
RUN apt-get -y autoremove && \
    apt-get -y autoclean && \ 
    apt-get -y clean all && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.pip/cache && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt
