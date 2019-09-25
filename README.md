PAN Tools Dockerfile
====================

This Dockerfile installs:

```
* Ubuntu Bionic 18.04
* Python 3.7.4
* Python 2.7.16
* Ansible 2.8.5
* Terraform 0.12.9
* Azure CLI
* Microsoft PowerShell 6.1.3 with Azure module
* AWS CLI
* Google SDK 263.0.0
* PAN Configurator
* GoPAN

 and many other useful networking tools.
```
### Installing

Download the pre-built image from Docker Hub with:

```php
docker pull paloaltonetworks/pantools
docker tag paloaltonetworks/pantools pantools
```

-or-

 Build from sources with:  
```php
docker build -t pantools .
```
### Running

Run with:
```php
docker run -it pantools
```
or Mount Present Working Directory to /pwd and Run with:
```php
Mac/Linux: docker run -it -v "$PWD:/pwd" pantools
Windows: docker run -it -v %cd%:/pwd pantools
```

Within the container you can switch Python versions:
```php
pyenv global 3.7.4
pyenv global 2.7.16
```

This can also run as a SSHD service by uncommenting out lines in the Dockerfile, rebuilding then running with:
```php
docker-compose up -d
```

## Contributing
Feel free to open issues, offer feedback, and send Pull Requests to our Github repository where this code is hosted.

## Disclaimer
This software is provided without support, warranty, or guarantee. Use at your own risk.