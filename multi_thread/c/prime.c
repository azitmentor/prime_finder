#include <stdio.h>
#include <stdbool.h>
#include <pthread.h>
#include <stdlib.h>
#include <assert.h>

/* Specify the number of threads to run in concurrently */
#define NUM_THREADS 4

/* Each thread gets a start and end number and returns the number
   Of primes in that range */
struct range {
  unsigned long start;
  unsigned long end;
  unsigned long count;
};

/* Thread function for counting primes */
void *
prime_check (void *_args)
{
  /* Cast the args to a usable struct type */
  struct range *args = (struct range*) _args;
  unsigned long iter = 2;
  unsigned long value;

  /* Skip over any numbers < 2, which is the smallest prime */
  if (args->start < 2) args->start = 2;

  /* Loop from this thread's start to this thread's end */
  args->count = 0;
  for (value = args->start; value <= args->end; value++)
    {
      /* Trivial and intentionally slow algorithm:
         Start with iter = 2; see if iter divides the number evenly.
         If it does, it's not prime.
         Stop when iter exceeds the square root of value */
      bool is_prime = true;
      for (iter = 2; iter * iter <= value && is_prime; iter++)
        if (value % iter == 0) is_prime = false;

      if (is_prime) args->count++;
    }

  /* All values in the range have been counted, so exit */
  pthread_exit (NULL);
}

int
main (int argc, char **argv)
{
  pthread_t threads[NUM_THREADS];
  struct range *args[NUM_THREADS];
  int thread;

  /* Count the number of primes smaller than this value: */
  unsigned long number_count = 100000000L;

  /* Specify start and end values, then split based on number of
     threads */
  unsigned long start = 0;
  unsigned long end = start + number_count;
  unsigned long number_per_thread = number_count / NUM_THREADS;

  /* Simplification: make range divide evenly among the threads */
  assert (number_count % NUM_THREADS == 0);

  /* Assign a start/end value for each thread, then create it */
  for (thread = 0; thread < NUM_THREADS; thread++)
    {
      args[thread] = calloc (sizeof (struct range), 1);
      args[thread]->start = start + (thread * number_per_thread);
      args[thread]->end =
        args[thread]->start + number_per_thread - 1;
      assert (pthread_create (&threads[thread], NULL, prime_check,
                              args[thread]) == 0);
    }

  /* All threads are running. Join all to collect the results. */
  unsigned long total_number = 0;
  for (thread = 0; thread < NUM_THREADS; thread++)
    {
      pthread_join (threads[thread], NULL);
      printf ("From %ld to %ld: %ld\n", args[thread]->start,
              args[thread]->end, args[thread]->count);
      total_number += args[thread]->count;
      free (args[thread]);
    }

  /* Display the total number of primes in the specified range. */
  printf ("===============================================\n");
  printf ("Total number of primes less than %ld: %ld\n", end, 
          total_number);

  return 0;
}