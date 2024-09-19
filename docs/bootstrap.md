## The Bootstrap Sequence

The bootloader is combined with the IFS image to form a single file named kernel.img. 
This is a 2nd stage bootloader. The Raspberry Pi has a common 1st stage boot code from Broadcom
in start4.elf that is designed to load a single file named kernel.img.  

With CheviotOS being a microkernel we need a way of bootstrapping several key drivers that
run as separate user-mode processes.  So instead of kernel.img being the kernel, in CheviotOS
it is a bootloader and combined IFS image.

The bootloader setups up an initial virtual address space and loads the kernel from the IFS
image into the upper part of the virtual address space.  It also passes the location of the
IFS image and IFS filesystem handler executable to the kernel.  Once the kernel has initialized
the first process it creates, the root process is the IFS filesystem handler.

The IFS server then forks itself into 2 processes.  One becomes the actual IFS server,
the "other" process continues the bootstrap.

The IFS server maps in the IFS image into it's address space and mounts itself as the root
filesystem, "/".  It can now accept filesystem requests such as to open, read and write files.

The other process waits for "/" to be mounted. It now has access to the files in the IFS
through normal POSIX file calls.  These are translated by the kernel into messages that are
sent to IFS server which takes care of reading the files from the IFS image.

This "other" process peforms an "exec" system call to become the "/sbin/init" process
that continues the bootstrap process. This reads a startup script in "/etc/startup.cfg"
that loads the other key drivers and filesystem handlers and mounts the Ext2 root filesystem
initially at "/media/root".  It then performs a "pivot-root" to switch the current root "/"
which points to the IFS to the Ext2 root that currently points at "/media/root".

Finally the PD-Ksh shell is started. In the future this will perform additional initialization
and a login prompt.




