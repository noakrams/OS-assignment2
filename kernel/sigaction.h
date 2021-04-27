struct sigaction {
  void (*sa_handler) (int);
  unsigned int sigmask;
};