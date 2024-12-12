// Prime Number Finder in Rust

fn is_prime(num: u32) -> bool {
    // Handle edge cases
    if num <= 1 { return false; }
    if num <= 3 { return true; }
    
    // Eliminate even numbers greater than 2
    if num % 2 == 0 { return false; }
    
    // Check for divisibility up to square root of the number
    let sqrt_num = (num as f64).sqrt() as u32;
    for i in (3..=sqrt_num).step_by(2) {
        if num % i == 0 { return false; }
    }
    
    true
}

// Find Prime Numbers in a Range (Optimized)
fn find_primes(max: u32) -> Vec<u32> {
    // Start with 2, then only check odd numbers
    let mut primes = vec![2];
    
    // Only check odd numbers from 3 to max
    for num in (3..=max).step_by(2) {
        if is_prime(num) {
            primes.push(num);
        }
    }
    
    primes
}

fn main() {
    let start = std::time::Instant::now();
    let primes = find_primes(20_000_000);
    let duration = start.elapsed();
    println!("Primes count:{:?}", primes.len());
    println!("Time elapsed: {:?}", duration);
}