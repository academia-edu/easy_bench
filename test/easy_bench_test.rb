unless ARGV.include?('gem')
  $:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
end

require 'easy_bench'
require 'test/unit'

class EasyBenchTest < Test::Unit::TestCase

  def test_stats

    eb = EasyBench.new('Sleeping')

    stats = eb.stats
    assert_equal 0, stats[:count]
    assert_nil stats[:min]
    assert_nil stats[:max]
    assert_equal 0, stats[:total]
    assert_nil stats[:mean]

    1.upto(10).each do |i|

      eb.caller{sleep(i.to_f / 10)}

    end

    stats = eb.stats

    assert_equal 10, stats[:count]
    assert_approximately_equal 0.1, stats[:min], 2
    assert_approximately_equal 1.0, stats[:max], 2
    assert_approximately_equal 5.5, stats[:total], 2
    assert_approximately_equal 0.55, stats[:mean], 2

    eb.report(true)

  end

  def assert_approximately_equal(target, actual, sig_figs)
    rounded_actual = (actual * (10 ** sig_figs)).to_i.to_f / (10 ** sig_figs)
    assert_equal target, rounded_actual    
  end

end
