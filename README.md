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


Download pre-built image from Docker Hub with:

```php
docker pull ajoldham/pantools
docker tag ajoldham/pantools pantools
```

-or-

 Build from sources with:  
```php
docker build -t pantools .
```

<br>

Run with:
```php
docker run -it pantools
```

Within the container switch Python versions:
```php
pyenv global 3.7.4
pyenv global 2.7.16
```

Can run as a SSHD service by uncommenting out lines in the Dockerfile, rebuilding then running with:
```php
docker-compose up -d
```