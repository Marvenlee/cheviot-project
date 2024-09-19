# Building the Cheviot OS

# Requirements

A Linux system is required with common developer tools such as gcc, binutils, cmake make.
The following will get the required tools to build the project.

```
    $ sudo apt install build-essential
    $ sudo apt install cmake
    $ sudo apt install automake autoconf
    $ sudo apt install libsqlite3-dev
    $ sudo apt install texinfo
    $ sudo apt install libgmp-dev libmpfr-dev libmpc-dev
    $ sudo apt install mtools
```

# Cloning the project

```
    $ git clone https://github.com/Marvenlee/cheviot-project.git
    $ cd cheviot-project
    $ git submodule update --init

```

# Building the project

CMake is used as a meta-build tool that is used to build individual projects
that are typical built with Autotools/Automake.

Build the project with the following commands from within the directory this
readme.md resides in. This will build the GCC cross compiler, Newlib library
and the kernel along with ksh, coreutils and several basic drivers for the
Raspberry Pi 4.

Modify the setup-env.sh to set the appropriate board, currently this
defaults to raspberrypi4.


```
    $ cd cheviot-project
    $ mkdir build
    $ cd build
    $ source ../setup-env.sh
    $ cmake ..
    $ make pseudo-native    
    $ make
```

This will build the projects and populate the build/host folder which contains
the directory tree of the final root partition.

We then perform the following to build the final sd-card image:

```
    $ make image
```

This builds 3 images, the boot partition, the root partition and the combined sd-card image.

  * part1\_boot.fat
  * part2\_root.ext2
  * sdimage.img

The sdimage.img can be flashed to an SD-Card using dd, bmaptool or Balenaetcher. For example
if the sdcard is mounted as 2 partitions on the mmcblk0 device then unmount and flash the image
onto it with:

```
    $ umount /dev/mmcblk0p1
    $ umount /dev/mmcblk0p2
    $ sudo dd if=sdimage.img of=/dev/mmcblk0 bs=1M

```

# Running CheviotOS

Connect the Raspberry Pi 4 to a PC using a USB to Serial FTDI adaptor. The pins are
listed in the table below.


| Pi GPIO      | Pi Pin    | USB FTDI  |
| ------------ | --------- | --------- |
| TXD GPIO 14  | 8         | RX        | 
| RXD GPIO 15  | 10        | TX        | 
| GND          | 6         | GND       |


Open a terminal application on the PC, for example Minicom on Linux. Within the terminal
application select the USB FTDI as the serial port.

```
    $ sudo minicom -D /dev/ttyUSB0
```

In Minicon's serial port settings set the baud rate to 115200, 8 bits,
no parity, 1 stop bit (8N1) and disable software and hardware flow control.
In addition in the Terminal settings set the Backspace key to send the 'DEL' character.

Insert the SD-Card that was flashed with the image in the earlier steps and power on 
the Raspberry Pi.  After several seconds debug logs appear on the terminal followed by
a CheviotOS banner.  At this point you will be in a Korn shell and can enter commands
directly at the shell prompt.


# Notes

## Pseudo and File Permissions

Pseudo is used so that commands can run as a "virtual" root user. Sqlite3 is used as a
database of the generated files "virtual" permissions so that we can set most files
as being owned by root and with appropriate permissions.

## Bootloader and IFS

The 'make image' command runs the tools/mk-kernel.img.sh script to create the kernel.img
that is placed on the boot partition.  This combines the bootloader and Initial File System
(IFS) image which contains the required files to bootstrap the system. The required files
includes the kernel, UART and other drivers.

## Partition Sizes

The setup-env.sh can be modified to increase the size of the partitions. Alter the
values for the following 2 variables.

  * BOOT\_PARTITION\_SIZE\_MB
  * ROOT\_PARTITION\_SIZE\_MB

Additional partitions could be created within the mk-sdcard-image.sh and mounting these
in the /etc/startup.cfg script.





