#! /bin/sh
#
# This script deletes any containers that were created from the Docker image named
# "cheviot-image" and deletes the image itself.
#
docker container ls -aq -f "ancestor=cheviot-image" | xargs docker container rm
docker image rm cheviot-image

