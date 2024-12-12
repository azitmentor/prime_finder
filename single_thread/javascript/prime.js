function isPrime(num) {
    // Handle edge cases
    if (num <= 1) return false;
    if (num <= 3) return true;
    
    // Eliminate even numbers greater than 2
    if (num % 2 === 0) return false;
    
    // Check for divisibility up to square root of the number
    for (let i = 3; i <= Math.sqrt(num); i += 2) {
        if (num % i === 0) return false;
    }
    
    return true;
}

function findPrimes(max) {
    const primes = [];
    
    for (let num = 2; num <= max; num++) {
        if (isPrime(num)) {
            primes.push(num);
        }
    }
    
    return primes;
}


startTime = new Date();
primes = findPrimes(20000000)
console.log("Primes count:", primes.length );
endTime = new Date();
diff = endTime - startTime
console.log("Time elapsed (ms):", diff)
