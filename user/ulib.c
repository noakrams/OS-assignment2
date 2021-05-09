#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"


char*
strcpy(char *s, const char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    ;
  return os;
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    ;
  return n;
}

void*
memset(void *dst, int c, uint n)
{
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    cdst[i] = c;
  }
  return dst;
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
}

char*
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  return buf;
}

int
stat(const char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
  close(fd);
  return r;
}

int
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    while(n-- > 0)
      *dst++ = *src++;
  } else {
    dst += n;
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}

int
memcmp(const void *s1, const void *s2, uint n)
{
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    if (*p1 != *p2) {
      return *p1 - *p2;
    }
    p1++;
    p2++;
  }
  return 0;
}

void *
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
}


// void 
// csem_down(struct counting_semaphore *sem) {
//     bsem_down(sem->bsem2);
//     bsem_down(sem->bsem1);
//     sem->count -= 1;
//     if (sem->count > 0)
//     	bsem_up(sem->bsem2);
//     bsem_up(sem->bsem1);
// }


// void 
// csem_up(struct counting_semaphore *sem) {
// 	bsem_down(sem->bsem1);
// 	sem->count += 1;
// 	if (sem->count == 1)
// 		bsem_up(sem->bsem2);
// 	bsem_up(sem->bsem1);
// }


// int 
// csem_alloc(struct counting_semaphore *sem, int count) {
//     int bsem1 = bsem_alloc();
//     int bsem2 = bsem_alloc();
//     if (bsem1 == -1 || bsem2 == -1)
//         return -1; 
//     sem->bsem1 = bsem1;
//     sem->bsem2 = bsem2;
//     if (count == 0)
//         // Binary semaphore first value = min(1, count)
//         bsem_down(sem->bsem2); 
//     sem->count = count;
//     return 0;
// }


// void 
// csem_free(struct counting_semaphore *sem) {
//     bsem_free(sem->bsem1);
//     bsem_free(sem->bsem2);
//     free(sem);
// }
