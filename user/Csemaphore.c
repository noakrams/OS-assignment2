
#include "Csemaphore.h"
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"


void csem_down(struct counting_semaphore *sem) {
    bsem_down(sem->bsem2);
    bsem_down(sem->bsem1);
    sem->count -= 1;
    if (sem->count > 0)
    	bsem_up(sem->bsem2);
    bsem_up(sem->bsem1);
}


void csem_up(struct counting_semaphore *sem) {
	bsem_down(sem->bsem1);
	sem->count += 1;
	if (sem->count == 1)
		bsem_up(sem->bsem2);
	bsem_up(sem->bsem1);
}


int csem_alloc(struct counting_semaphore *sem, int count) {
    int bsem1 = bsem_alloc();
    int bsem2 = bsem_alloc();
    if (bsem1 == -1 || bsem2 == -1)
        return -1; 
    sem->bsem1 = bsem1;
    sem->bsem2 = bsem2;
    if (count == 0)
        // Binary semaphore first value = min(1, count)
        bsem_down(sem->bsem2); 
    sem->count = count;
    return 0;
}


void csem_free(struct counting_semaphore *sem) {
    bsem_free(sem->bsem1);
    bsem_free(sem->bsem2);
    free(sem);
}
