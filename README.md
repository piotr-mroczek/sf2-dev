# docker-symfony2

Docker image for symfony2 applications.

Based on Debian Wheezy.

## How to use (pre-build image)

You must have docker installed.

### Running as daemon

You can now run your PHP application in the environment of this image:

```bash
docker run -v /home/user/symfony2:/var/www -p 8080:80 -d lepiaf/docker-symfony2
```

The Symfony app is now accessible on http://localhost:8080/app.php (assuming localhost is your docker host).

### Debugging
If you want to debug your application you can set the DEBUG environment variable:

```bash
docker run -e DEBUG=1 -v /home/user/symfony2:/var/www -p 8080:80 -d lepiaf/docker-symfony2
```

The PHP debugger will then auto-connect to port 9000 of the host that sent the request if remote debugging was indicated (e.g. with 'Xdebug helper').

### Running a command

You may want to run a single command in the same environment as your web server is running (same modules available etc). You can do so like so (-ti instead of -d):

```bash
docker run -v /home/user/symfony2:/var/www -p 8080:80 -ti lepiaf/docker-symfony2 composer install
```

("same environment" does not mean they are acutally sharing a container. If you start this image as a daemon and then execute this command, they will be isolated from each other. The only exception is the mounted volume which they share. However, you will have two exact same environments.)


## Modify/extend this image

If you need a PHP extension not included in this image or you want to use a different config file, you can simply create your own image derived from this one. Simply create directory with a file named *Dockerfile* and all other resources you need. Such a *Dockerfile* could look like this:

```bash
# declare that you're extending this image
FROM lepiaf/docker-symfony2:latest

# who are you?
MAINTAINER Tim-Christian Mundt <dev@tim-erwin.de>

# install a few more PHP extensions
RUN apt-get update && apt-get install -y php5-imagick php5-gd php5-mongo php5-curl php5-mcrypt php5-intl

# copy a custom config file from the directory where this Dockerfile resides to the image
COPY php.ini /etc/php5/fpm/php.ini

# make a small change in an existing config file
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
```

By the way, this Dockerfile (if you remove the COPY line) includes all the extensions available in this module originally. Just for your convenience :)

Now, you can build and run your own image with all your required extensions:

```bash
docker build -t timerwin/symfony2 .
docker run -v /home/user/symfony2:/var/www -p 8080:80 -d timerwin/docker-symfony2
```

Where '.' is the directoy the *Dockerfile* is in.


## Packages included
* curl
* nginx
* php5-fpm
* php5-cli
* php5-xdebug

## Exposed port
* 80 : http
* 443: https

## Exposed volumes
* /var/www: web content
* /var/log/nginx: nginx logs
