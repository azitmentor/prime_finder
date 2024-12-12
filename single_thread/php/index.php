<?php
class PrimeFinder {
    /**
     * Check if a number is prime
     * 
     * @param int $n Number to check for primality
     * @return bool True if the number is prime, false otherwise
     */
    public function isPrime(int $n): bool {
        // Numbers less than 2 are not prime
        if ($n < 2) {
            return false;
        }
        
        if ($n === 2) {
            return true;
        }

	if ($n % 2 === 0) {
            return false;
        }

// Check for divisibility up to the square root of the number
        $sqrtN = (int)sqrt($n);
        
        for ($i = 3; $i <= $sqrtN; $i+=2) {
            if ($n % $i === 0) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Find prime numbers in a given range
     * 
     * @param int $start Start of the range
     * @param int $end End of the range
     * @return array List of prime numbers in the range
     */
    public function findPrimesInRange(int $start, int $end): array {
        $primes = [];
        
        for ($num = $start; $num <= $end; $num++) {
            if ($this->isPrime($num)) {
                $primes[] = $num;
            }
        }
        
        return $primes;
    }
}

// Main execution
function main() {
    // Set range for prime number search
    $start = 1;
    $end = 20000000; // Increased range to demonstrate timing
    
    // Create PrimeFinder instance
    $primeFinder = new PrimeFinder();
    
    // Start timing
    $startTime = microtime(true);
    
    // Find primes
    $primes = $primeFinder->findPrimesInRange($start, $end);
    
    // End timing
    $endTime = microtime(true);
    
    // Calculate execution time
    $executionTime = $endTime - $startTime;
    
    // Print results
    echo "Prime numbers between $start and $end:\n";
    echo "Total primes found: " . count($primes) . "\n";
    
    // Print first 10 primes
    echo "First 10 primes: ";
    $displayPrimes = array_slice($primes, 0, 10);
    echo implode(' ', $displayPrimes) . "\n";
    
    // Print execution time
    printf("\nExecution time: %.4f seconds\n", $executionTime);
}

// Run the main function
main();
?>