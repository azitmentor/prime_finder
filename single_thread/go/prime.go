package main

import (
	"fmt"
	"math"
	"time"
)

// isPrime checks if a given number is prime
func isPrime(n int) bool {
	// Numbers less than 2 are not prime
	if n < 2 {
		return false
	}
	if n == 2 {
		return true
	}
	if n % 2 == 0 {
		return false
	}
	
	// Check for divisibility up to the square root of the number
	// This optimization reduces unnecessary iterations
	sqrtN := int(math.Sqrt(float64(n)))
	
	for i := 3; i <= sqrtN; i+=2 {
		if n % i == 0 {
			return false
		}
	}
	
	return true
}

// findPrimesInRange finds all prime numbers within a specified range
func findPrimesInRange(start, end int) []int {
	primes := []int{}
	
	for num := start; num <= end; num++ {
		if isPrime(num) {
			primes = append(primes, num)
		}
	}
	
	return primes
}

func main() {
	startTime := time.Now()

	// Example usage: find primes between 1 and 50
	start, end := 1, 20000000
	primesFound := findPrimesInRange(start, end)
	duration := time.Since(startTime)
	
	fmt.Printf("Prime numbers between %d and %d:\n", start, end)

	fmt.Printf("Total primes found: %d\n", len(primesFound))
	fmt.Printf("Time taken: %v\n", duration)

	fmt.Println()
}