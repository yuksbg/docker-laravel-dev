## Simple docker image for laravel development

Simple docker image which is usefull for laravel development, included components:

  - PHP 7.4
  - Redis
  - SSH server
  - Nginx
  - Alpine as base image

### Building

```bash
git clone https://github.com/yuksbg/docker-laravel-dev.git
cd docker-laravel-dev
docker build -t laravel-dev .
```

### Run
```bash
docker run -it -v $(pwd):/var/www -p 80:80 -p 1022:22 laravel-dev
```

### Note
Change line 54 for your public key
