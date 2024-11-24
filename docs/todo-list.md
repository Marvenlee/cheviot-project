# CheviotOS To-Do List

A more in depth look at what needs doing to get CheviotOS functional.


## Kernel File System

The kernel's virtual filesystem is mostly complete. There are a still a
few things to do.

### Pathname Lookup

Currently we allocate 1K pathname lookup buffers on the kernel stack.
The stack is 4K, so half of this is used by the sys_rename() syscall.
We need to allocate a 4K page on pathname lookup, and release this after
it is used.  The lookup_discard() function should also dereference the
vnodes it returned so we need to increment their reference counts.

### Vnode Reference Counting and Locking

This brings us to a general problem of vnode reference counting and locking.
We need to make sure the reference counts are handled correctly so that we
don't have dangling vnodes that are no longer used and cannot be freed.

Similarly we need to make sure the vnodes are being locked correctly.

### Links

Symbolic links and hard links need implementing.

### Directory Name Lookup Cache (DNLC)

The DNLC code exists in fs/dnlc.c but was disabled and calls to it removed
from various functions. Add it back to pathname lookup and delete the DNLC
entries on file, directory and other vnode deletion.

Ensure "/dev/tty" is not handled by the DNLC.

### Delayed Writes

The file cache handling creates tasks to flush a mount's blocks out after
a delay of several seconds. Ensure this works.

### Dynamic File Cache Size

The kernel currently implements a fixed size file cache. We need to scale this
with the amount of free memory. There is also some cleanup needed of page table
mapping code related to this fixed size file cache that needs removing.

### Closing Message Ports

Message ports are handled by the filesystem.  If a server closes a message
port, ensure the filesystem or device it handles is unmounted.  Ensure
we can safely perform a sync before unmounting.



## Ext2 File System Handler

The Ext2 file system handler is a rewrite of the Ext2 driver from Minix and
is under the Minix. Reading works for files and directories. Writing and creating
files is known to have issues. Debug this.



## SD Card Driver

The SD Card driver is using polling to wait for interrupts. We need to use interrupts.
We need to optimize reads and writes in conjunction with the Ext2 filesystem handler.



## Login and BSD Libraries

We have ported the login command from NetBSD and the BSD libraries needed to do so.
Login currently doesn't work as we need the ext2 filesystem to be able to do writes.

We also need the pwd_mkdb command to work in order to create the necessary password
database files.

That will allow us to complete most of the user login and create accounts.  Currently
we boot straight to the PD-KSH shell.



## Threads

CheviotOS thread support is minimal. Processes and threads are separated.  We create
a single thread when a process is created. There are syscalls to create threads, exit
them and join them but that's about it.  We need to implement locking primitives
such as mutexes and expose these to userland.

The pthreads API will be added to CheviotOS's version of Newlib. Fast locking with
"ldxr" and "stxr" for compare and exchange will need looking into.



## Networking and Sockets

Initially I wanted the networking layer to be in a separate ring between the kernel
and the application. See the future.md page for some thoughts on protection rings.

The networking server will instead be implemented as another type of filesystem server.
A few additional syscalls relating to sockets will be added to send messages to the
networking server.

The initial thoughts are to do what Minix did, import the LwIP stack as a library and
build a network server around it.

The Broadcom Genet driver for the Raspberry Pi 4 will need porting,  it should be
similar to other device drivers. We could use sendmsg() to configure the network
interface of a driver, to bring it up or down for instance.



## USB

We could port the TinyUSB library for embedded devices in a similar way to LwIP
and use it as a basis to create a USB server.



## Creating Message Ports

Message ports are currently created in a 2 step process.  First we make a node or
a directory on a filesystem using mknod2() or mkdir().  We then call createmsgport()
from a filesystem handler or device driver to create the port "on top of" the node
or directory we have made.  It would be good to have this as a single operation.

We also need servers such as the networking server to receive messages when a
new node is created or destroyed. This is so that new storage for state can be allocated
and perhaps new threads or coroutines created.  This is to avoid having a small pool
of tasks in a server that can only concurrently handle a small number of connections.



## Aux UART Driver

We need to handle interrupts when writing to the UART.  Currently we busy-wait until
characters are written out.

Termios handling needs to be finished. with the ability to change baud and
to flush buffers.



## The alarm() syscall

The alarm syscall needs implementing. Posix timers may be needed later.



## Events, Kqueue and Select

We have an API to wait for a set of events and to raise these events.  These
are separate from signals.  We may remove events and just use signals with
sigwait or sigsuspend type APIs.

The select function needs implementing, a lot of code uses it.

The Kqueue is the primary event handling mechanism in CheviotOS. This is currently
only used by servers to wait for messages and interrupts. We need to finish our
kqueue implementation for files and devices.



## Non-Blocking Reads and Writes

Non-blocking reads and writes are not currently implemented. We need kqueue() and
select() to be finished.



## Memory Management

### Dynamic Allocation of Kernel Tables

Currently a large number of kernel tables, such as the process, thread and vnode
tables are statically allocated during kernel initialization. We need to dynamically
allocate these.

Physical memory should be carved up into 64K chunks and assigned to a process. These
64K chunks should be assigned to a process or the filesystem. For processes these
64k chunks can be further split to hold process, thread, page table and other structures
relating to the process.

For the filesystem, the remaining 64K chunks can be used to dynamically allocate vnodes
and file cache buffers.

### Mmap

The mmap() syscall is partially implemented.  It can map anonymous memory and physical
memory with the MAP_PHYS flag and offset used as physical address.  It would be good
to be able to map files for reading. Maybe not for writing.

Sharing of memory between a client and server might also be useful for IPC.


## Shutdown and Reboot

The reboot syscall needs implementing.  User sessions and processes need terminating.
Filesystems need syncing and unmounting. Drivers need stopping.


## Compiler Warnings, FIXMEs, TODOs and Cleanup

Turing all warnings on during the build has shown a large number warnings. Similarly
there are a large number of FIXMEs and TODOs scattered throughout the code. These
need cleaning up.


## Device Tree

The device tree library libdt has been ported, but I feel we should switch to XML for CheviotOS.
I don't like how we interpret fields related to interrupt controllers, some seem
to be 2 bytes and others 3 bytes. Decide much later what to do.

 
## Sendmsg message formats

We need to define the formats that servers supporting the sendmsg() command can understand.
Either as plain text, json, xml or binary commands.  

We could define messages for power management to drivers as well as tweaking driver settings.

Sendmsg needs to be renamed to avoid conflicting with socket sendmsg.


## Kernel Preemption

The microkernel currently implements a big kernel lock. This means only a single thread
can run at a time within the kernel and threads are scheduled cooperatively within the
kernel.  The big kernel lock forms a "monitor" with sleep and wakeup of tasks blocked
on condition variables.  Tasks sleeping on a condition variable or exiting the the
kernel are the only points where a reschedule occurs.  Rescheduling doesn't occur when
an interrupt returns.  Effectively the kernel is coroutining.

Kernel preemption will replace the big kernel lock with mutexes and similar sleep and
wakeup on condition variables.  Instead of a single big kernel lock, it might be the
kernel can be protected by 2 or 3 mutexes, 1 for the filesystem and another for process
and task management.  In many cases we can grab a mutex, set a kernel object to be in a busy
state and release the mutex before doing whatever operations on the kernel object. 

Thread scheduling can be done whenever a mutex is acquired or released, or when a thread
blocks on a condition variable. Scheduling should also occur prior to returning from
an interrupt service routine.


## Protection Rings

Lastly I'd like to implement protection rings. One of the original goals of CheviotOS
was to implement an OS with multiple protection rings in a similar fashion to how
the Kernel-Page-Table-Isolation (KPTI) trampoline works in Linux.

The existing kernel would effectively move into user-space (with system/kernel privileges)
and other protection rings would be implemented as separate user-space address spaces.
The microkernel/trampoline would only need to implement call() and return() syscalls
that carry a small payload of data in it's registers, similar to how syscalls pass
parameters to the kernel.

The microkernel/trampoline then has a small table for only the current running thread.
This thread is a table of activation records for each ring the thread can call into.
Each record would contain the IP/SP/pagedir entry point, stack pointer and page directory
to call into and the return IP/SP/pagedir.  A bitmap of rules can control which rings
can call into others of a higher privilege.




