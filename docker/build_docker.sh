#! /bin/sh
#
# Builds the docker image "cheviot-image" from the Dockerfile in this
# directory.  Run this script first and the run the run_docker.sh script
# to open an interactive session into the container.
#

docker build -t cheviot-image .

