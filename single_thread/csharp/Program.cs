using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace primefinder;

public class PrimeNumberFinder
{
    public static bool IsPrime(int num)
    {
        if (num <= 1) return false;
        if (num <= 3) return true;

        if (num % 2 == 0) return false;

        for (int i = 3; i <= Math.Sqrt(num); i += 2)
        {
            if (num % i == 0) return false;
        }

        return true;
    }

    public static List<int> FindPrimes(int max)
    {
        var primes = new List<int>();

        for (int num = 2; num <= max; num++)
        {
            if (IsPrime(num))
            {
                primes.Add(num);
            }
        }

        return primes;
    }

    public static void Main(string[] args)
    {
        var sw = Stopwatch.StartNew();
        var primes = FindPrimes(20000000);
        sw.Stop();
        Console.WriteLine("Primes count:{0}", primes.Count);
        Console.WriteLine("Elapsed:{0} ms", sw.ElapsedMilliseconds);
    }
}
