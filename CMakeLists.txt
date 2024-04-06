cmake_minimum_required(VERSION 3.5)

project(Cheviot)

include(ExternalProject)

set(CMAKE_CXX_STANDARD 11) 
set(ENV{PSEUDO_PREFIX} ${CMAKE_CURRENT_BINARY_DIR}/build/native/)

# Build the pseudo tool. This is not part of the 'all' target and
# must be done separately with 'make pseudo-native'
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/build-pseudo.cmake)

# Lay out the root filesytem's directory structure in the build/host directory
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/build-skeleton-root.cmake)

# Copy third_party blobs to the build/host/boot_partition
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/build-skeleton-boot.cmake)

add_custom_target(host_apps)

# Build and install GCC, binutils, newlib and build-tools on build platform
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/build-mkifs.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/binutils.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/gcc.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/libc-newlib-interim.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/libc-newlib.cmake)

# Build and install other libraries on build platform
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/libs-hal.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/libs-libs.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/libs-bsdlibs.cmake)

# Build and install third-party libraries on build platform
include(${CMAKE_CURRENT_SOURCE_DIR}/third-party/cmake/libtask.cmake)

# Build bootloader for host platform
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/bootloader.cmake)

# Build kernel for host platform
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/kernel.cmake)

include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/drivers.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/filesystems.cmake)

# Build utilities for host platform
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/utils.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/utils-bsdutils.cmake)

# Build third-party utils for host platform
include(${CMAKE_CURRENT_SOURCE_DIR}/third-party/cmake/pdksh.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/third-party/cmake/coreutils.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/third-party/cmake/less.cmake)

# Build the partition images and combine into a single sdcard image
include(${CMAKE_CURRENT_SOURCE_DIR}/cheviot-build/cmake/build-image.cmake)


