# Current Status

Cheviot is a long way from being a complete OS.  In it's current state it boots
into a KSH shell with the IFS image mounted as root.  This allows some basic
coreutils commands to be used to test out the system calls and C library.


## Short term goals

  * Extended file system (Ext2) support by finishing extfs handler.
  * Finish file system syscalls.
  * File system locking and vnode reference count fixes
  * Directory Name Lookup Cache (Code is disabled due to bugs)  
  * Signal handling (API exists but handlers are not called)
  * Revert to stride scheduler fixes.
  * Support custom interrupt handlers, current drivers are polling
  * Support interrupt handlers running with user-space privileges
  * Interrupt handling in the SD-Card driver and DMA (DMA is supported but busy-waits).
    
## Long term goals

  * POSIX threads, currrently supports libtask coroutines, mainly used in aux and serial drivers.
  * Fine grained locking in kernel to replace the Big Kernel Lock.
  * Kernel preemption. Currently tasks are scheduled cooperatively in the kernel.
  * Replace VirtualAlloc functions with mmap, munmap and mprotect
  * Convert memory management segment array to linked lists.
  * Additional drivers for GPIO pins, SPI, I2C, etc.
  * XML device tree and mechanism to limit drivers access to RAM, interrupts and other drivers
  * Similar XML capability mechanism to limit syscalls
  * Self host GCC and binutils.
  * Port of a text editor
  * Multiple virtual protection rings, see future.md.
  
  
