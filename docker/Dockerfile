#
# Dockerfile for building CheviotOS
#
# This is used to create an image with the required packages needed
# to build CheviotOS.  A user account is created so that the run_docker.sh
# script can set up an interactive session and automatically login as this
# user.
#

FROM ubuntu:22.04

# Configuration of the user account
ARG USER_NAME=cheviot
ARG USER_UID=1000
ARG USER_GID=1000

ARG DEBIAN_FRONTEND=noninteractive
  
# Install needed packages
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y python3.10 && \
  apt-get install -y python3-pip && \
  apt-get install -y gcc-11-multilib && \
  apt-get install -y file && \
  apt-get install -y git && \
  apt-get install -y cmake && \
  apt-get install -y automake autoconf && \
  apt-get install -y libsqlite3-dev && \
  apt-get install -y texinfo && \
  apt-get install -y libc6 libgmp-dev libmpfr-dev libmpc-dev && \
  apt-get install -y mtools && \
  apt-get install -y fdisk && \
  apt-get install -y dosfstools && \
  apt-get install -y nano && \
  rm -rf /var/lib/apt/lists/*

# Add the default user and group
RUN \
  groupadd -g $USER_UID $USER_NAME && \
  useradd -m -d /home/$USER_NAME -s /bin/bash -g $USER_NAME -u $USER_UID $USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME
ENV HOME /home/$USER_NAME

