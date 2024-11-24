# Current Status

Cheviot is a long way from being a complete OS.  In it's current state it boots
into a KSH shell with the IFS image mounted as root.  This allows some basic
coreutils commands to be used to test out the system calls and C library.

See the to-do list file for more details, [todo-list.md](todo-list.md)

## Current Features

  * Microkernel with a mostly POSIX compatible API.
  * Microkernel implements process and memory management
  * Microkernel contains Virtual Filesystem Switch (VFS) layer
  * VFS implements POSIX file system calls
  * VFS implements file and directory name lookup caching.
  * Device drivers run as user-mode processes
  * Filesystem handlers run as user-mode processes
  * Ext2, IFS, devfs filesystem handlers
  * Ext2 handler based on Minix Ext2 driver 
  * SD Card, serial and hardware TRNG drivers
  * Drivers use libfdt to access device tree blobs
  * Newlib as the Libc library
  * Newlib extended with BSD libraries such as Berkeley DB library  
  * Enables BSD utilities to compile, e.g. login (unused)
  * Port of the PD-Ksh Korn shell
  * Signal handling, sessions and process groups


## Currently Unsupported
  * Anything other than a Raspberry Pi 4b
  * Networking
  * POSIX pthread APIs
  * POSIX mmap memory management APIs
  * Bash shell
  * Python
  * Everything else

# Summary of Goals

## Short term goals

  * Fix Extended file system (Ext2) support in extfs handler.
  * Finish file system system calls for symlinks and rename.
  * File system locking and vnode reference count fixes
  * Fix Directory Name Lookup Cache 
  * Revert to stride or other fair share scheduler for applications
  
  
## Long term goals

  * POSIX threads, currrently supports libtask coroutines, mainly used in aux and serial drivers.
  * Login handling and user account management
  * Fine grained locking in kernel to replace the Big Kernel Lock.
  * Kernel preemption. Currently tasks are scheduled cooperatively in the kernel.
  * Port networking stack such as LwIP and Ethernet driver.
  * Replace VirtualAlloc functions with mmap, munmap and mprotect
  * Faster context switches by using CPU Address Space IDs.
  * Address Space Layout Randomization.  Currently executables aren't position independent.
  * Port TinyUSB for USB handling.
  * Additional drivers for SPI, I2C, etc.
  * Additional device tree helper functions
  * Self host GCC and binutils.
  * Port of a text editor
  * Multiple protection rings, See [future.md](future.md).
  * Support other Raspberry Pi variants





