# Source Code Layout

A general overview of how the the project is organized.

## Top Level Repository

The top level repository is the cheviot-project.git.  The following repositories are
brought in as Git submodules.

  * cheviot-build
  * drivers
  * filesystems
  * kernel
  * libc/newlib
  * libs
  * third-party
  * utils
	
This top-level repository contains this docs directory and the setup script and CMakeLists.txt
cmakefile.

CMake is used to build the overall project and can be considered a "meta-make". CMake's ExternalProject
feature is used to configure and run the build command line of each project.  For third party sources
the ExternalProject feature fetches the sources from Git repositories or FTP servers. 

In most cases the individual projects contain there own Autotools/Autoconf/Automake makefiles
where CMake invokes the configure and make commands in order to build them.
	
## Cheviot-build

This contains the cmakefiles used to build the project, the CheviotOS bootloader for the Raspberry Pi,
a skeleton root filesystem with configuration files and various scripts used to build an SD-Card image.

The directories are:

  * **bootloader**\
  Bootloader sources that form the Rasberry Pi's kernel.img along with the IFS filesystem.
  * **cmake**\
  CMake build scripts to build the project.  These are included by the top-level CMakeLists.txt.
  * **device-tree-sources** \
  Device tree derived from the Linux/u-boot device trees.
  * **mkifs**\
  Build tool to create the Initial Filesystem (IFS) image linked with the bootloader \
  in order to bootstrap the system.
  * **skeleton-boot**\
  Contains files for the Raspberry Pi boot partition, some are from Broadcom.
  * **skeleton-root**\
  The skeleton of the OS's root filesystem, sets up the directories and some config files.

Two scripts help build the final image, these are:

  * **mk-kernel-img.sh**\
  This combines the bootloader and IFS filesystem containing the kernel and key device drivers into a single file.
  * **mk-sdcard-image.sh**\
  This creates the SD-Card image with 2 partitions, a FAT-based boot partition and an Ext2 root partition.

See the [bootstrap.md](bootstrap.md) document for more details on the boot process.


## Drivers

This contains device drivers for the Raspberry Pi.

Current drivers include:

  * **aux**\
  UART driver on Raspberry Pi 4
  * **random**\
  True Random Number Generator driver  
  * **sdcard**\
  SD-Card driver based on John Cronin's sources
  * **null**\
  A "/dev/null" driver. The simplest driver implemented.


## Filesystems

Current filesystem handlers include:

  * **ext2fs**\
  Ext2 file system based on Minix sources 
  * **ifs**\
  Initial read-only filesystem used to bootstrap the OS
  * **devfs**\
  Implements the filesystem under "/dev" where devices are mounted


## Kernel

The microkernel itself. The microkernel handles process management, scheduling
memory management, filesystem API and caching.

The kernel is split into several directories:

  * **boards**\
  Platform-Specific code
  * **fs**\
  Filesystem system calls, file and directory caching, permissions and message passing.
  * **h**\
  Kernel source header files  
  * **proc**\
  Process management, scheduling, interrupts and synchronization 
  * **util** \
  Helper functions for strings and in-kernel printf
  * **vm**\
  Virtual memory management


### Notable Kernel Files

The boards/raspberry\_pi\_4/vectors.S file contains the kernel entry point for system
calls, interrupts and exceptions.  The list of system calls currently implemented can
be seen in this file.  System calls within the microkernel are all named with **sys**
prefix.

Three functions exist to transfer data between user-mode and the kernel and visa versa.
These are CopyIn, CopyOut and CopyInString and are implemented in boards/raspberry\_pi\_4/arm.S.

Message passing system calls are implemented in fs/msg.c. Some trivia, the internals
are similar to AmigaOS's message passing functions though the external syscall API
is more akin to other microkernel OSes.


## Libc/newlib

This is a fork of the Newlib C standard library. The cheviot-main branch contains
the changes for CheviotOS.

Three directories under the newlib/newlib/libc directory were added:

  * **newlib/newlib/libc/cheviot**\
  CheviotOS specific sources and system calls
  * **newlib/newlib/libc/cheviotbsd**\
  NetBSD sources to assist in porting BSD utilities
  * **newlib/newlib/libc/cheviotpthread**\
  CheviotOS specific thread library (under construction)

In addition there is low-level architecture specific directory in:

  * **newlib/newlib/libc/sys/arm**\
  Implements crt0.S and syscall assembly stubs.
  
Cheviot adds additional headers in **newlib/newlib/libc/include**.  

Some notable include files are:
  * **sys/fsreq.h**\
  Contains the message headers of messages sent to device drivers and filesystem handlers.
  * **sys/syscalls.h**\
  Prototypes for the CheviotOS system calls.


## Libs

The libs repository contains additional libraries that aren't part of libc.  In here
there are BSD libraries for porting BSD utilities and additional CheviotOS-specific
libraries.


## Utils

Similar to the libs repository, the utils repository is split into ports of existing BSD
utilities and CheviotOS-specific utilities.



