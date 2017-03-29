docker build -t my-ssh .

docker rm -f my-ssh

docker run -d --name my-ssh  \
    -e AUTH_MECHANISM=multiContainerAuth   \
    -e AUTH_TUPLES="u1:pass1:temp1;u2:pass2:temp2" \
    -p 2223:22     \
    -v /var/run/docker.sock:/var/run/docker.sock   my-ssh
