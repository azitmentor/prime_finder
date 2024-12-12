package main

import (
	"fmt"
	"math"
	"runtime"
	"sort"
	"sync"
	"time"
)

// Check if a number is prime
func isPrime(num int) bool {
	// Handle edge cases
	if num <= 1 {
		return false
	}
	if num <= 3 {
		return true
	}

	// Eliminate even numbers greater than 2
	if num%2 == 0 {
		return false
	}

	// Check for divisibility up to square root of the number
	sqrtNum := int(math.Sqrt(float64(num)))
	for i := 3; i <= sqrtNum; i += 2 {
		if num%i == 0 {
			return false
		}
	}

	return true
}

// Parallel prime finding method using channels and goroutines
func findPrimesParallel(max int) []int {
	// Determine the number of CPUs
	numCPU := runtime.NumCPU()
	runtime.GOMAXPROCS(numCPU)

	// Channel to collect prime numbers
	primeChan := make(chan int, max)
	
	// WaitGroup to synchronize goroutines
	var wg sync.WaitGroup

	// Divide the work into chunks
	chunkSize := max / numCPU
	if chunkSize < 1 {
		chunkSize = 1
	}

	// Function to find primes in a specific range
	findPrimesInRange := func(start, end int) {
		defer wg.Done()
		for num := start; num <= end; num++ {
			if isPrime(num) {
				primeChan <- num
			}
		}
	}

	// Spawn goroutines for each chunk
	for i := 0; i < numCPU; i++ {
		wg.Add(1)
		start := 2 + i*chunkSize
		end := start + chunkSize - 1
		if i == numCPU-1 {
			end = max
		}
		go findPrimesInRange(start, end)
	}

	// Close channel when all goroutines are done
	go func() {
		wg.Wait()
		close(primeChan)
	}()

	// Collect primes from the channel
	var primes []int
	for prime := range primeChan {
		primes = append(primes, prime)
	}

	// Sort the primes
	sort.Ints(primes)

	return primes
}

// Alternative method using sync.Mutex
func findPrimesParallelMutex(max int) []int {
	numCPU := runtime.NumCPU()
	runtime.GOMAXPROCS(numCPU)

	// Shared slice of primes with mutex
	var primes []int
	var mu sync.Mutex
	var wg sync.WaitGroup

	chunkSize := max / numCPU
	if chunkSize < 1 {
		chunkSize = 1
	}

	findPrimesInRange := func(start, end int) {
		defer wg.Done()
		localPrimes := []int{}
		
		for num := start; num <= end; num++ {
			if isPrime(num) {
				localPrimes = append(localPrimes, num)
			}
		}

		// Safely add local primes to shared slice
		mu.Lock()
		primes = append(primes, localPrimes...)
		mu.Unlock()
	}

	// Spawn goroutines
	for i := 0; i < numCPU; i++ {
		wg.Add(1)
		start := 2 + i*chunkSize
		end := start + chunkSize - 1
		if i == numCPU-1 {
			end = max
		}
		go findPrimesInRange(start, end)
	}

	// Wait for all goroutines to complete
	wg.Wait()

	// Sort the primes
	sort.Ints(primes)

	return primes
}

func main() {
	max := 200_000_000
	fmt.Printf("Let find, total count will be: %d\n", max)

	// Method 1: Channel-based parallel prime finding
	fmt.Println("Finding primes using channel-based method...")
	start := time.Now()
	primesChan := findPrimesParallel(max)
	durationChan := time.Since(start)

	fmt.Println("Channel Method:")
	fmt.Printf("Total primes found: %d\n", len(primesChan))
	fmt.Printf("First 10 primes: %v\n", primesChan[:10])
	fmt.Printf("Last 10 primes: %v\n", primesChan[len(primesChan)-10:])
	fmt.Printf("Time taken: %v\n", durationChan)

	// Method 2: Mutex-based parallel prime finding
	fmt.Println("\nFinding primes using mutex-based method...")
	start = time.Now()
	primesMutex := findPrimesParallelMutex(max)
	durationMutex := time.Since(start)

	fmt.Println("Mutex Method:")
	fmt.Printf("Total primes found: %d\n", len(primesMutex))
	fmt.Printf("First 10 primes: %v\n", primesMutex[:10])
	fmt.Printf("Last 10 primes: %v\n", primesMutex[len(primesMutex)-10:])
	fmt.Printf("Time taken: %v\n", durationMutex)
}