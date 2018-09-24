#!/bin/bash

## This is a starter/basic bash script. It is designed to help test the mutli-environment configuration.
## It is by no means complete or final. @blame: Benjamin Rosner, @br2490

STACKS=(dev stage prod)
MAIN_DIR=`pwd`

echo 'Creating master ingress/egress network.'
docker network create isle-proxy
sleep 2

echo 'Pulling newest Portainer and Traefik (proxy) Images'
docker-compose pull
echo 'Starting master Portainer and Traefik (proxy) Containers'
docker-compose up -d
sleep 2

for stack in "${STACKS[@]}"
do
  echo "Starting work on ${stack}"
  cd "$MAIN_DIR/$stack"
  echo 'Pulling images.'
  docker-compose pull
  echo 'Starting stack'
  docker-compose up -d
  echo 'Waiting for stack to finish startup...'
  sleep 60
  ## This should be done with nc (netcat) checking if fedora and apache are ready.
  echo 'Install ISLANDORA.'
  docker exec -it isle-apache-$stack bash /utility-scripts/isle_drupal_build_tools/isle_islandora_installer.sh
  echo "Done work on ${stack}. Moving on."
  sleep 2
done

echo 'All done. Please visit http://portainer.isle.localdomain and http://admin.isle.localdomain'
