Release History
===============

September 20, 2019
------------------
- Python 3.7.4 installed and now default instead of 2.6
- Upgrade Ansible to 2.8.5
- Fixed Ansible environment to properly path roles, libraries and inventory
- Upgraded Terraform to 0.12.9
- Upgraded Google SDK to 263.0.0

August 9, 2019
--------------
- Upgraded Terraform to 0.12.6.  See Dockerfile comments for 0.11 to 0.12 upgrade notes.

June 20, 2019
-------------
- Upgraded Ansible to 2.8.1 to support new Ansible Collections.

June 1, 2019
------------
- Added iperf3 and removed iperf2
- Added SLR_Bot Python stats script for Security Lifecycle Review

May 8, 2019
-----------
- Added Docker-Compose and commented out Dockerfile lines for capability to run as an SSHD service

May 3, 2019
-----------
- Added support for Ansible module panos_set

April 20, 2019
--------------
- Added Midnight Commander File Manager
- Added tree command
- Upgraded pip for Python 2 and Python 3

March 28, 2019
--------------
- Updated Ubuntu to 18.04 Bionic
- Updated Python to 2.7.16 and 3.6.8
- Updated Ansible to 2.7.9
- Updated Terraform to 0.11.13
- Updated Google Cloud SDK to 240.0.0
- Updated Powershell to 6.1.3
- Updated Pan Configurator/PHP to 7.2 
- Added support for PAN-FCA Flexible Cloud Automation

March 21, 2019
--------------
- Added Shodan

February 19, 2019
-----------------
- Updated SNMP MIB's for PAN-OS 9.0

February 18, 2019
-----------------
- Added Slurm Network Monitor
- Added NMon System Monitor
- Added iostat Disk Monitor
- Added Aria2 Multi-Connection Download 

January 16, 2019
----------------
- Added Google Cloud SDK 230.0.0
- Added AWS CLI

January 4, 2019
---------------
- Added Lynx web browser
- Added NMap 7.70 which seems compatible with Ansible

December 13, 2018
-----------------
- Fixed Ansible and load PAN Library
- Remarked out NMap 7.01 which seems incompatible with Ansible library/install

December 4, 2018
----------------
- Updated Python to 2.7.15 and 3.6.7
- Added Microsoft Azure CLI
- Added Terraform

November 26, 2018
-----------------
- Added Microsoft PowerShell with Azure Modules
- Fixed changes to MIB sourcefiles

June 27, 2018
-------------
- Added hping3 utility
- Added CPS Bot script

May 28, 2018
------------
- Added standard and PAN MIBs for snmpwalk with OID text format support.

May 25, 2018
------------
- Save all files as CR/LF for Windows compatibility

May 21, 2018
------------
- Added PAN-Toolbox scripts

May 20, 2018
------------
- Added Speedtest and Netcat

May 8, 2018
-----------
- Fixed PAN Configurator dependencies and aliases

May 7, 2018
-----------
- Added GoPAN Utilities

April 30, 2018
--------------
- Initial Release
