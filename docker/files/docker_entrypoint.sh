#! /bin/bash
#
# Script to run when automatically building the image in Docker

cd /home/cheviot/project
mkdir -p build
cd build
source ../setup-env.sh
cmake ..

if [ -e build/native/bin/pseudo ]
then
    echo "pseudo already built"
else
    make pseudo-native
fi
make
make image

