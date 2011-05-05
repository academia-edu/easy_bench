# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../lib', __FILE__)
require 'easy_bench'

Gem::Specification.new do |s|
  s.name = 'easy_bench'
  s.version = EasyBench::VERSION

  s.authors = ['Ben Lund', 'Academia, Inc']
  s.description = 'A quick and easy benchmarking library for Ruby. Useful for benchmarking only part of an iteration, and accumulating the data to report later in the code.'
  s.summary = 'Measure the call times of only some of the expressions in your interation -- the timer is explicitly started and stopped for the duration of a block. The result of the operation inside then benchmarked block is returned from the benchmarking call, so an EasyBench call can be wrapped around existing code with no changes. This style allows for interleaving of two or more alternatives being benchmarked within an interaction, which can correct for ramp-up effects you might see if you benchmarked the alternatives sequentially. Simple report output shows minimum, maximum, and mean call times. The report output can also include a simple bar chart to visually inspect the data for outliners (only really useful for small runs of 20 iterations or so)'
  s.email = 'ben@academia.edu'
  s.homepage = 'http://github.com/academia-edu/easy_bench'

  s.add_dependency('sometimes_memoize')
  s.files = ['lib/easy_bench.rb']
end
