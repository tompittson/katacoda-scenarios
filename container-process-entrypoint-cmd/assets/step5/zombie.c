#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

int main ()
{
  pid_t pid;
  int i;

  for (i = 0; i < 1000; i++) {
    pid = fork ();
    if (pid > 0) {
      // parent process
      printf("Zombie #%d born:\n", i + 1);
      sleep(1);
    } else {
      // child process (exit to become a zombie with no wait)
      printf("**Zombie**\n");
      exit (0);
    }
  }

  _exit(0);
}