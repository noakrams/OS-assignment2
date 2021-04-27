#include "syscall.h"

.global start_ret
.global end_ret
start_ret:
li a7, SYS_sigret
ecall
end_ret:
