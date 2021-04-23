#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
// #include "kernel/proc.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/syscall.h"
#include "kernel/memlayout.h"
#include "kernel/riscv.h"

int main(int argc, char *argv[]) {
    int i = sigprocmask (5);
    fprintf (2,"%d", i);


    // const struct sigaction act;
    // struct sigaction oldact;

    // int j = sigaction (5, &act, &oldact);
    // fprintf (2,"%d", j);

    return 0;
}