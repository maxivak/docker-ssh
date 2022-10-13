# Docker-SSH

SSH Server for Docker containers
This is an extension of [Docker-SSH](https://github.com/maxivak/docker-ssh) which adds  capability of logging in into multiple Docker containers updated for 2022

Run one Docker SSH server through which you can connect to multiple Docker containers depending on user.



Features:
* multiContainerAuth authentication method.


# Quick start

* build Docker image
```
docker build -t docker-ssh github.com/g-alfieri/docker-ssh
```

* run SSH server in Docker container
```
docker run -d -p 2222:22 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e AUTH_MECHANISM=multiContainerAuth \
  -e AUTH_TUPLES="u1:pwd1:container1;u2:pwd2:container2" \
  docker-ssh
```

* or specify users with passwords and corresponding containers in a separate file
```
docker run -d -p 2222:22 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e AUTH_MECHANISM=multiContainerAuth \
  -e AUTH_TUPLES_FILE="/auth" \
  -v /path/to/local/file/auth:/auth \
  docker-ssh
```

where file `auth` contains data like this:
```
u1:pwd1:container1
u2:pwd2:container2

```


* login

```
# login as user u1 to container1
ssh -p 2222 u1@localhost

# user u1 enters container 'container1'


# login as user u2 to container2
ssh -p 2222 u2@localhost

# user u2 enters container 'container2'


```
