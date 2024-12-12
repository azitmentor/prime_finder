#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

// Function to check if a number is prime
int is_prime(int n) {
    // Numbers less than 2 are not prime
    if (n == 2 ) return 1;
    if ((n < 2) || (n%2==0)) {
        return 0;
    }
    
    // Check for divisibility up to the square root of the number
    int sqrt_n = (int)sqrt((double)n);
    
    for (int i = 3; i <= sqrt_n; i+=2) {
        if (n % i == 0) {
            return 0;  // Not prime
        }
    }
    
    return 1;  // Prime
}

// Function to find primes in a given range and store them in an array
int* find_primes_in_range(int start, int end, int* count) {
    // Allocate maximum possible size of primes array
    int* primes = malloc((end - start + 1) * sizeof(int));
    *count = 0;
    
    for (int num = start; num <= end; num++) {
        if (is_prime(num)) {
            primes[*count] = num;
            (*count)++;
        }
    }
    
    // Resize array to actual number of primes found
    primes = realloc(primes, (*count) * sizeof(int));
    return primes;
}

int main() {
    int start = 1;
    int end = 20000000;  // Increased range to better demonstrate timing
    
    // Start the stopwatch
    clock_t begin = clock();
    
    // Find primes
    int prime_count;
    int* primes = find_primes_in_range(start, end, &prime_count);
    
    // Stop the stopwatch
    clock_t finish = clock();
    
    // Calculate execution time
    double time_spent = (double)(finish - begin) / CLOCKS_PER_SEC;
    
    // Print results
    printf("Prime numbers between %d and %d:\n", start, end);
    printf("Total primes found: %d\n", prime_count);
    printf("First 10 primes: ");
    for (int i = 0; i < (prime_count < 10 ? prime_count : 10); i++) {
        printf("%d ", primes[i]);
    }
    printf("\n\n");
    
    // Print execution time
    printf("Execution time: %f seconds\n", time_spent);
    
    // Free dynamically allocated memory
    free(primes);
    
    return 0;
}