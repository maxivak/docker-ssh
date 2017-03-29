docker build -t my-ssh .

docker rm -f my-ssh

docker run -d --name my-ssh  \
    -e AUTH_MECHANISM=multiContainerAuth   \
    -e AUTH_TUPLES_FILE="/auth" \
    -v $PWD/example_auth:/auth \
    -p 2223:22     \
    -v /var/run/docker.sock:/var/run/docker.sock   my-ssh
