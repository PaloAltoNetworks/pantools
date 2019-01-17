PAN Tools Dockerfile
====================

This Dockerfile installs:

```
* Ubuntu 16.04
* Python 2.7.15
* Python 3.6.7
* Ansible 2.7.4
* Terraform 0.11.10
* Azure CLI
* Google SDK 230.0.0
* PAN Configurator
* GoPAN

 and many other useful networking tools.
```

If you're new to Docker... install from here: https://www.docker.com/community-edition

Build with:  
```php
docker build -t pantools .
```

Run with:
```php
docker run -it pantools
```

Within the container switch Python versions:
```php
pyenv global 2.7.15
pyenv global 3.6.7
```

All changes within a container are lost on exit when using 'docker run'.
To map a host directory to be shared with the container:
```php
docker run -it -v /Users/username/Documents/Scripts:/scripts pantools
```