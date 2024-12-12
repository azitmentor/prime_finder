use std::sync::{Arc, Mutex};
use std::thread;

// Prime number checker remains the same
fn is_prime(num: u32) -> bool {
    if num <= 1 { return false; }
    if num <= 3 { return true; }
    
    if num % 2 == 0 || num % 3 == 0 { return false; }
    
    let sqrt_num = (num as f64).sqrt() as u32;
    for i in (5..=sqrt_num).step_by(6) {
        if num % i == 0 || num % (i+2) == 0 { return false; }
    }
    
    true
}

// Method 1: Parallel Prime Finding using Chunks
fn find_primes_parallel_chunked(max: u32, thread_count: usize) -> Vec<u32> {
    // Prepare shared results vector
    let primes = Arc::new(Mutex::new(Vec::new()));
    
    // Determine chunk size
    let chunk_size = max / thread_count as u32;
    
    // Spawn threads
    let handles: Vec<_> = (0..thread_count)
        .map(|i| {
            let primes = Arc::clone(&primes);
            
            // Calculate start and end for this thread
            let start = 2 + i as u32 * chunk_size;
            let end = if i == thread_count - 1 { max } else { start + chunk_size - 1 };
            
            thread::spawn(move || {
                let local_primes: Vec<u32> = (start..=end)
                    .filter(|&num| is_prime(num))
                    .collect();
                
                // Add local primes to shared vector
                let mut shared_primes = primes.lock().unwrap();
                shared_primes.extend(local_primes);
            })
        })
        .collect();
    
    // Wait for all threads to complete
    for handle in handles {
        handle.join().unwrap();
    }
    
    // Extract and sort the primes
    let mut result = Arc::try_unwrap(primes).unwrap().into_inner().unwrap();
    result.sort();
    
    // Ensure 2 is included if max >= 2
    if max >= 2 && !result.contains(&2) {
        result.insert(0, 2);
    }
    
    result
}

// Method 2: Parallel Iterator-based Approach
fn find_primes_parallel_rayon(max: u32) -> Vec<u32> {
    use rayon::prelude::*;
    
    let mut primes: Vec<u32> = (2..=max)
        .into_par_iter()
        .filter(|&num| is_prime(num))
        .collect();
    
    primes.sort();
    primes
}

fn main() {
    let max = 200_000_000;
    
    // Method 1: Custom Multithreaded Approach
    println!("Finding primes using custom multithreading...");
    let start = std::time::Instant::now();
    let primes_chunked = find_primes_parallel_chunked(max, num_cpus::get());
    let duration = start.elapsed();
    
    println!("Custom Multithreaded Method:{}",max);
    println!("Total primes found: {}", primes_chunked.len());
    println!("First 10 primes: {:?}", &primes_chunked[..10]);
    println!("Last 10 primes: {:?}", &primes_chunked[primes_chunked.len()-10..]);
    println!("Time taken: {:?}", duration);
    
    // Method 2: Rayon Parallel Iterator
    println!("\nFinding primes using Rayon...");
    let start = std::time::Instant::now();
    let primes_rayon = find_primes_parallel_rayon(max);
    let duration = start.elapsed();
    
    println!("Rayon Parallel Method:");
    println!("Total primes found: {}", primes_rayon.len());
    println!("First 10 primes: {:?}", &primes_rayon[..10]);
    println!("Last 10 primes: {:?}", &primes_rayon[primes_rayon.len()-10..]);
    println!("Time taken: {:?}", duration);
}