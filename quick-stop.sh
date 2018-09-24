#!/bin/bash

## This is a starter/basic bash script. It is designed to help test the mutli-environment configuration.
## It is by no means complete or final. @blame: Benjamin Rosner, @br2490

STACKS=(dev stage prod)
MAIN_DIR=`pwd`

for stack in "${STACKS[@]}"
do
  echo "Removing ${stack}"
  cd "$MAIN_DIR/$stack"
  docker-compose down -v
  echo "Done work on ${stack}. Moving on..."
  sleep 2
done

echo 'Removing master Portainer and Traefik (proxy) Containers...'
cd $MAIN_DIR
docker-compose down -v
sleep 2

echo 'Removing master ingress/egress network...'
docker network rm isle-proxy

echo 'All done.'
