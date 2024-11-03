#! /bin/sh
#
# Start a container based on the image, "cheviot-image". Run it interactively
# with a command prompt.  Run build_docker.sh prior to running this in order to
# set up the Docker image. 
#

docker run \
      -it \
      --mount type=bind,source="$(pwd)"/..,target=/home/cheviot/project \
      cheviot-image

