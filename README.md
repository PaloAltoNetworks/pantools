PAN Tools Dockerfile
====================

This Dockerfile installs:

```
* Ubuntu 16.04
* Python 2.7.14
* Python 3.6.5
* PAN Configurator
* GoPAN
* Ansible

 and many other useful networking tools.
```

If you're new to Docker... install from here: https://www.docker.com/community-edition

For Windows installs, be sure to use Linux containers.

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
pyenv global 2.7.14
pyenv global 3.6.5
```

All changes within a container are lost on exit.
To map a host directory to be shared with the container:
```php
docker run -it -v /Users/username/Documents/Scripts:/hostscripts pantools
```
