const { Worker, isMainThread, parentPort, workerData } = require('worker_threads');

if (isMainThread) {
    const numThreads = 20;
    const rangeStart = 1;
    const rangeEnd = 200000000;
    const rangeSize = Math.ceil((rangeEnd - rangeStart + 1) / numThreads);
    const workers = [];
    let results = [];
    let completedWorkers = 0; // Track completed workers
    startTime = new Date();

    for (let i = 0; i < numThreads; i++) {
        const start = rangeStart + i * rangeSize;
        const end = Math.min(rangeStart + (i + 1) * rangeSize - 1, rangeEnd);
        workers.push(
            new Worker(__filename, { workerData: { start, end } })
        );
    }

    workers.forEach(worker => {
        worker.on('message', primes => {
            results = results.concat(primes);
            completedWorkers++; // Increment completed worker count
            if (completedWorkers === numThreads) { // Check if all workers are done
                endTime = new Date();
                diff = endTime - startTime
                console.log("time taken:(ms)",diff);
                console.log(`Primes count: ${results.length}`);
                process.exit(0);
            }
        });

        worker.on('error', err => console.error(err));
        worker.on('exit', code => {
            if (code !== 0) console.error(`Worker stopped with exit code ${code}`);
        });
    });
} else {
    const { start, end } = workerData;
    const primes = [];

    for (let i = start; i <= end; i++) {
        if (isPrime(i)) {
            primes.push(i);
        }
    }

    parentPort.postMessage(primes);
}

function isPrime(num) {
    if (num <= 1) return false;
    if (num <= 3) return true;
    if (num % 2 === 0) return false;
    for (let i = 3; i * i <= num; i += 2) {
        if (num % i === 0) return false;
    }
    return true;
}
