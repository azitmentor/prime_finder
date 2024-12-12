import math
import time

def is_prime(n):
    """
    Check if a number is prime.
    
    Args:
        n (int): Number to check for primality
    
    Returns:
        bool: True if the number is prime, False otherwise
    """
    # Numbers less than 2 are not prime
    if n < 2:
        return False
    if n == 2:
        return True
    
    if n % 2 == 0:
       return False

    # Check for divisibility up to the square root of the number
    sqrt_n = int(math.sqrt(n))
    
    for i in range(3, sqrt_n + 1,2):
        if n % i == 0:
            return False
    
    return True

def find_primes_in_range(start, end):
    """
    Find prime numbers in a given range.
    
    Args:
        start (int): Start of the range
        end (int): End of the range
    
    Returns:
        list: List of prime numbers in the range
    """
    return [num for num in range(start, end + 1) if is_prime(num)]

def main():
    # Set range for prime number search
    start = 1
    end = 20000000  # Increased range to demonstrate timing
    
    # Start timing
    start_time = time.time()
    
    # Find primes
    primes = find_primes_in_range(start, end)
    
    # End timing
    end_time = time.time()
    
    # Calculate execution time
    execution_time = end_time - start_time
    
    # Print results
    print(f"Prime numbers between {start} and {end}:")
    print(f"Total primes found: {len(primes)}")
    print("First 10 primes: ", end="")
    print(*primes[:10])  # Unpacking first 10 primes
    
    # Print execution time
    print(f"\nExecution time: {execution_time:.4f} seconds")

if __name__ == "__main__":
    main()