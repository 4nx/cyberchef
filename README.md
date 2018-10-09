# CyberChef Docker Container

Table of Contents
=================

   * [CyberChef Docker Container](#cyberchef-docker-container)
     * [Introduction](#introduction)
      * [Image Variants](#image-variants)
      * [Usage](#usage)
        * [Create Docker volumes](#create-docker-volumes)
        * [Starting the container](#starting-the-container)
          * [Running from command line](#running-from-command-line)
          * [Running with docker compose](#running-with-docker-compose)
        * [Accessing the console](#accessing-the-console)
        * [Environment variables](#environment-variables)
          * [Existing variables and environment file](#existing-variables-and-environment-file)
          * [Use of an environment file via command line](#use-of-an-environment-file-via-command-line)
          * [Use of an environment file via docker compose](#use-of-an-environment-file-via-docker-compose)
      * [Building](#building)
        * [Building via command line](#building-via-command-line)
        * [Building with docker compose](#building-with-docker-compose)
      * [Contribution](#contribution)
      * [License](#license)

## Introduction
This repository is for building a Docker container with [GCHQs CyberChef](https://github.com/gchq/CyberChef)

## Image Variants

**Architecture:**
* ``amd64`` for most desktop computers (e.g. x64, x86-64, x86_64)

**Distribution:**

* ``alpine`` for alpine 3.8

## Usage

The following describes the best practice use of the container and the usage.

### Create Docker volumes

The recommended mechanism to use persistent data are Docker ``volumes`` because they depend on the directory structure of the host machine and can be used the same way on every platform. So you need to create the volumes on your host:
```
docker volume create cyberchef-nginx
docker volume create cyberchef-ssl
docker volume create cyberchef-logs
```

### Starting the container

You can start a container with a prebuild image or by building it on your own.

#### Running from command line

Directly via command line use the following:
```SHELL
docker run \
    --name cyberchef \
    -p 8080:80 \
    -d \
    --restart=always \
    -v "cyberchef-nginx:/etc/nginx" \
    -v "cyberchef-ssl:/etc/ssl" \
    -v "cyberchef-logs:/var/log/nginx" \
    4nxio/cyberchef:latest
```

#### Running with docker compose

Create the following ``docker-compose.yml``:
```YAML
version: '3'
services:
  cyberchef:
    image: "4nxio/cyberchef:latest"
    restart: always
    ports:
      - "8080:80"
    volumes:
      - "cyberchef-nginx:/etc/nginx"
      - "cyberchef-ssl:/etc/ssl"
      - "cyberchef-logs:/var/log/nginx"

volumes:
  cyberchef-nginx:
    external: true
  cyberchef-ssl:
    external: true
  cyberchef-logs:
    external: true
```

You can start the container via ``docker-compose up -d``. It will be started via the automated build image on Docker Hub. 

### Accessing the console

You can connect to a console of an already running cyberchef container with the following command:
* ``docker ps``  - lists all your currently running container
* ``docker exec -it cyberchef /bin/sh`` - connect to cyberchef container by name
* ``docker logs cyberchef`` - gives you the output of the cyberchef container while starting

### Environment variables

There is the possibility to configure the nginx webserver via environment variables which can be set directly from the command line, docker compose file or an extra environment file. The recommended way is to use an environment file.

#### Existing variables and environment file

Just have a look [here](https://github.com/4nx/cyberchef/blob/master/environment.conf) and download the file.

#### Use of an environment file via command line

You can use the environment file via command line with:
```SHELL
docker run \
    --name cyberchef \
    -p 8080:80 \
    --env-file environment.conf \
    -d \
    --restart=always \
    -v "cyberchef-nginx:/etc/nginx" \
    -v "cyberchef-ssl:/etc/ssl" \
    -v "cyberchef-logs:/var/log/nginx" \
    4nxio/cyberchef:latest
```

#### Use of an environment file via docker compose

Just create the following ``docker-compose.yml`` or extend your existing one:
```YAML
version: '3'
services:
  cyberchef:
    image: "4nxio/cyberchef:latest"
    restart: always
    env_file:
      - environment.conf
    ports:
      - "8080:80"
    volumes:
      - "cyberchef-nginx:/etc/nginx"
      - "cyberchef-ssl:/etc/ssl"
      - "cyberchef-logs:/var/log/nginx"

volumes:
  cyberchef-nginx:
    external: true
  cyberchef-ssl:
    external: true
  cyberchef-logs:
    external: true
```

## Building

You can build the image by yourself via command line or docker compose.

### Building via command line

Checkout the github repository and then run those command:
```
$ docker build -t 4nxio/cyberchef:latest .
```

### Building with docker compose

Check out the Dockerfile, docker-entrypoint.sh and optional the environment.conf. After this create the following ``docker-compose.yml``:
```YAML
version: '3'
services:
  cyberchef:
    build: .
    restart: always
    ports:
      - 8080:80
    volumes:
      - "cyberchef-nginx:/etc/nginx"
      - "cyberchef-ssl:/etc/ssl"
      - "cyberchef-logs:/var/log/nginx"

volumes:
  cyberchef-nginx:
    external: true
  cyberchef-ssl:
    external: true
  cyberchef-logs:
    external: true
```
It will also be started via ``docker-compose up -d``. Be advised that it will be build only the first time. If you want to build it again later on use the command ``docker-compose build`` or ``docker-compose up --build``. You can check that the container is running via ``docker-compose ps``, stop the container with ``docker-compose stop`` and remove the container with ``docker-compose rm``.

## Contribution

Contribution to this project is welcome. Please feel free to fork and and start pull requests.

## License

When not explicitly set, files are placed under [![Apache 2.0 license](https://img.shields.io/badge/license-Apache2.0-blue.svg)](https://github.com/4nx/cyberchef/blob/master/LICENSE).
