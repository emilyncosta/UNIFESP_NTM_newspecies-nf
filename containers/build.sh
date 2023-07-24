#!/bin/bash
set -uex

# NOTE: Make sure you've set the environment correctly and are logged in to the registry.

DOCKER_NAMESPACE="rg.fr-par.scw.cloud/ntm-mterrae-containers"

cp ../conda_envs/ntm-mterrae-env-1.yml ./ntm-mterrae-container-1/ntm-mterrae-env-1.yml

for container_dir in $(find * -maxdepth 0 -type d); do
  echo "Building $container_dir ..."
  cd $container_dir
  CONTAINER_TAG=0.0.1
  CONTAINER_NAME=$DOCKER_NAMESPACE/$container_dir:$CONTAINER_TAG
  echo "Container Name : $CONTAINER_NAME "
  docker build -t $CONTAINER_NAME .
  CONTAINER_ID=$(docker run -d $CONTAINER_NAME)
  docker commit $CONTAINER_ID $CONTAINER_NAME
  # docker push $DOCKER_NAMESPACE/$container_dir:$CONTAINER_TAG
  docker stop $CONTAINER_ID
  cd ..
done
