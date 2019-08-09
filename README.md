PAN Tools Dockerfile
====================

This Dockerfile installs:

```
* Ubuntu Bionic 18.04
* Python 2.7.16
* Python 3.6.8
* Ansible 2.8.1
* Terraform 0.12.6
* Azure CLI
* AWS CLI
* Google SDK 240.0.0
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
pyenv global 2.7.16
pyenv global 3.6.8
```

Can run as a SSHD service by uncommenting out lines in the Dockerfile, rebuilding then running with:
```php
docker-compose up -d
```