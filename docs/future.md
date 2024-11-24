
## Future Trampoline Microkernel

It has previously been mentioned that the microkernel has a relatively large API
compared to some modern microkernels. A long-term goal is to split the microkernel
and make it run on a minimal "trampoline microkernel" that implements virtual
protection rings.

In this model the operating system is structured as a series of rings, the core
running in rings with more privilege and applications and sandboxes running with
less privileges.

The diagram below shows a 3-level design with the Personality, application and
sandboxed application. The personality would implement what is in the current
microkernel. That is it would implement processes, memory management, scheduling and
the VFS. 

Applications would run as separate processes but would have the option
to create subprocesses that can call into the application. In this way and
application can act as a reference monitor or pseudo virtual machine.

The personality could be split into rings for Processes/scheduling (executive),
networking and filesystem.

![trampoline_diagram](images/cheviot_trampoline.png)

The microkernel is merely trampoline, similar to how kernel-pagetable-isolation (KPTI)
works. This only implements:

    - "call" and "reply" system calls, to transfer call into and return from a protection ring
    - interrupt dispatching to a function in a specific ring and "iret" system call
    - exception handler redirection to a specific ring and "fret" system call
    - Optional copyin, copyout and copyinstr system calls to copy data from a less privileged ring.

It is estimated that the code size could be less than 2 kilobytes.

The trampoline needs to manage a single thread at a time, holding only the state to allow
the current thread to call and return between rings.


### Use Cases of Rings

Some use cases of protection rings are:

#### Reference monitor

Applications could have a common reference monitor that checks which syscalls are allowed
and can perform auditing and logging of these.

#### Device Manager

Would allow faster calls for APIs such as toggling GPIOs as there would be no message
passing and scheduling overhead as happens in the current implementation.  The device manager
can also limit what memory device drivers can map in.

#### Cryptographic Key Management Ring

A ring to manage cryptographic keys and access any crypto hardware.

#### GUI and Audio

Having synchronous IPC with effectively 1-to-1 threads would allow for faster commands
to these servers.  It would also avoid going through the filesystem or sendmsg paths
to copy data, avoiding scheduling overhead.

#### Sandboxed Applications

Applications or applets could be contained in lightweight containers.  Having to first
call into the main application or reference monitor to request any action.



