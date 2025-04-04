# cheviot-project

This is the base repository of the CheviotOS project. This uses git submodules
to pull in other repositories that contain the sources and build scripts.

The original Cheviot project contained all sources in a single repository. It
has been broken into submodules for easier management.

## Introduction

CheviotOS is a multi-server microkernel operating system for the Raspberry Pi 4.
The kernel's API is mostly compatible with POSIX and is able to run the Korn
shell and a number of command line utilities from NetBSD and GNU Coreutils.

![cheviotos_screenshot](docs/images/cheviot_command_line.png)

Development started in 2013 on a Raspberry Pi 1 and previously as a KielderOS
on x86 PCs in the mid 2000s. This is a hobby so development occurs when time
permits.

As it is a microkernel the device drivers and file system handlers run as normal
user-mode processes and use the kernel's inter-process communication primitives
to communicate with the kernel and user applications.

The OS is still in an early *alpha* state.
 
There are ports of third-party tools such as:
  * Newlib which is used as the standard C library.
  * GNU Coreutils - common Unix commands such as ls, cat, sort, tr and tail
  * PD-KSH - The Korn shell
  * Some BSD utilities and libraries

Drivers have been created for:
  * aux - Serial port driver that appears as a tty.
  * sdcard - Port of John Cronnin SD Card driver code
  * random - Raspberry Pi True Random Number Generator driver
  
Filesystems have been created for:
  * ifs - Initial File System, a simple file system image for bootstrapping the OS.
  * devfs - Simple file system mounted as /dev
  * extfs - partially implemented (based on Minix extfs driver)
  * fatfs - partially implemented (requires rewrite).


## Hardware Requirements

CheviotOS currently runs on a Raspberry Pi 4 with shell access via USB to FTDI serial port adapter.

![raspberry_pi_4](docs/images/raspberry_pi_4.jpg)


## Documentation

  * [build.md](docs/build.md) - Build instructions
  * [status.md](docs/status.md) - Current project status and goals
  * [todo-list.md](docs/todo-list.md) - More detailed notes on what needs doing
  * [source-layout.md](docs/source-layout.md) - Overview of the source code tree
  * [bootstrap.md](docs/bootstrap.md) - Documents how the OS is bootstrapped
  * [ipc.md](docs/ipc.md) - Notes on message passing and servers
  * [future.md](docs/future.md) - Thoughts on OS restructure into rings

## Licensing

See each repository/subdirectory README.md for details on licensing.


