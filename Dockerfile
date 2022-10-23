#FROM gliderlabs/alpine
FROM mhart/alpine-node:14

WORKDIR /src
ADD . .

RUN apk --update add python3 make g++ nodejs \
  && npm install \
  && apk del make gcc g++ python3 \
  && rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp


# make coffee executable
RUN chmod +x ./node_modules/coffeescript/bin/coffee

# Connect to container with name/id
ENV CONTAINER=

# Shell to use inside the container
ENV CONTAINER_SHELL=bash

# Server key
ENV KEYPATH=./id_rsa

# Server port
ENV PORT=22

# Enable web terminal
ENV HTTP_ENABLED=true

# HTTP Port
ENV HTTP_PORT=8022

EXPOSE 22

CMD ["npm", "start"]
