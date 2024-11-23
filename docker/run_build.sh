#! /bin/sh
#
# Build CheviotOS automatically in a docker container. The docker_entrypoint.sh
# script in the files directory is run in order to build the project.

docker run \
      -t \
      --entrypoint /home/cheviot/project/docker/files/docker_entrypoint.sh \
      --mount type=bind,source="$(pwd)"/..,target=/home/cheviot/project \
      cheviot-image

