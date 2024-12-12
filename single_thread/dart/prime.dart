class PrimeFinder {
  bool isPrime(int number) {
    if (number <= 1) return false;
    if (number <= 3) return true;
    
    if (number % 2 == 0) return false;
    
    for (int i = 3; i * i <= number; i += 2) {
      if (number % i == 0) return false;
    }
    
    return true;
  }

  List<int> findPrimesInRange(int start, int end) {
    List<int> primes = [];
    
    for (int number = max(start, 2); number <= end; number++) {
      if (isPrime(number)) {
        primes.add(number);
      }
    }
    
    return primes;
  }

  // Helper method to find maximum of two numbers
  int max(int a, int b) {
    return a > b ? a : b;
  }
}

// Example usage
void main() {
  final primeFinder = PrimeFinder();
  
  final stopwatch = Stopwatch()..start();
  final primes = primeFinder.findPrimesInRange(1, 20000000);
  print('Primes count: ${primes.length}');
  print('Time elapsed: ${stopwatch.elapsed} (ms)');
}