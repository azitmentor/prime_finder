import java.util.List;
import java.util.ArrayList;
import java.time.*; 

public class PrimeFinder {
    public boolean isPrime(int number) {
        if (number <= 1) return false;
        if (number <= 3) return true;
        
        if (number % 2 == 0) return false;
        
        for (int i = 3; i * i <= number; i += 2) {
            if (number % i == 0 ) return false;
        }
        
        return true;
    }

    public List<Integer> findPrimesInRange(int start, int end) {
        List<Integer> primes = new ArrayList<>();
        
        for (int number = Math.max(start, 2); number <= end; number++) {
            if (isPrime(number)) {
                primes.add(number);
            }
        }
        
        return primes;
    }

    public static void main(String[] args) {
        PrimeFinder primeFinder = new PrimeFinder();
        Instant start = Instant.now();
        List<Integer> primes = primeFinder.findPrimesInRange(1, 20000000);
        Instant finish = Instant.now();
        long timeElapsed = Duration.between(start, finish).toMillis();
        System.out.println("Time elapsed in milisec: "+timeElapsed);
        System.out.println("Primes count: "+primes.size());
    }
}