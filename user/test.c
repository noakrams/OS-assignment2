#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/syscall.h"
#include "kernel/memlayout.h"
#include "kernel/riscv.h"
#include "kernel/sigaction.h"

int main(int argc, char *argv[]) {

    const struct sigaction act = {(void*) (5), 8};
    const struct sigaction act2 = {(void*) (6), 10};

    struct sigaction oldact;


    sigaction (5, &act, &oldact);
    sigaction (5, &act2, &oldact);
    sigaction (5, &act, &oldact);
    fprintf (2,"oldact sigmask %d\n", oldact.sigmask);
    fprintf (2,"oldact sighandler %d\n", oldact.sa_handler);

    exit(0);
}