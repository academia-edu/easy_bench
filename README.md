# Easy Bench

A quick and easy benchmarking library for Ruby. Useful for benchmarking only part of an iteration, and accumulating the data to report later in the code.

Features:

 * Measure the call times of only some of the expressions in your interation -- the timer is explicitly started and stopped for the duration of a block.
 * The result of the operation inside then benchmarked block is returned from the benchmarking call, so an EasyBench call can be wrapped around existing code with no changes.
 * This style allows for interleaving of two or more alternatives being benchmarked within an interaction, which can correct for ramp-up effects you might see if you benchmarked the alternatives sequentially.
 * Simple report output shows minimum, maximum, and mean call times.
 * The report output can also include a simple bar chart to visually inspect the data for outliners (only really useful for small runs of 20 iterations or so)

## Install

    $ sudo gem install easy_bench

Will also install the [Sometimes Memoize](https://github.com/benlund/sometimes_memoize) gem.

## Summary

A simple benchmark:

    eb = EasyBench.new('Sleeping')

    1.upto(10).each do |i|

      eb.caller{sleep(i.to_f / 10)}

    end

    eb.stats #=> {:count=>10, :total=>5.501514, :min=>0.100154, :max=>1.000172, :mean=>0.5501514000000001}

    eb.report(true) # prints a report and simple bar chart as below


Sample report:


    Sleeping

    num runs       : 10
    total run time : 5.501514s
    min run time   : 0.100154s
    max run time   : 1.000172s
    ave run time   : 0.5501514000000001s
    
                      *
                  * * *
              * * * * *
          * * * * * * *
    * * * * * * * * * *


Interleaving:

    eb1 = EasyBench.new('Old Way')
    eb2 = EasyBench.new('New Way')
    
    10000.times do
    
      eb1.caller{ SlowDB.call }
      eb2.caller{ HopefullyFasterDB.call }
    
    end

    eb1.report
    eb2.report

