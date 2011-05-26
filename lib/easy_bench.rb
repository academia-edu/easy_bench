require 'forwardable'
require 'sometimes_memoize'

class EasyBench
  extend Forwardable

  VERSION = '1.0.1'

  attr_reader :dataset

  def initialize(title=nil)
    @dataset = DataSet.new(title)
  end

  def caller
    start_time = Time.now
    res = yield
    elapsed_time = Time.now - start_time

    @dataset.runs << elapsed_time
    if @dataset.min_run_time.nil? || @dataset.min_run_time > elapsed_time
      @dataset.min_run_time = elapsed_time
    end
    if @dataset.max_run_time.nil? || @dataset.max_run_time < elapsed_time
      @dataset.max_run_time = elapsed_time
    end

    res
  end

  def_delegators :dataset, :report, :stats

  def self.log_times(logger, label)
    start_time = Time.now
    logger.info('Starting ' + label + ' at ' + start_time.to_s)
    res = yield
    end_time = Time.now
    logger.info('Finished ' + label + ' at ' + end_time.to_s + ' (' + (end_time - start_time).to_s + 's)')
    res
  end
  
  class DataSet
    include SometimesMemoize

    attr_accessor :runs, :min_run_time, :max_run_time
    attr_reader :title

    def initialize(title)
      @title = title
      @runs = []
    end

    def total_runs
      @runs.size
    end

    def total_run_time
      @runs.inject(0.0){|sum, run| sum + run}
    end
    sometimes_memoize :total_run_time

    def ave_run_time
      tr = self.total_runs
      if 0 == tr
        nil
      else
        (self.total_run_time / self.total_runs)
      end
    end
    
    def report(bars=false)
      memoizing do
        if @title
          puts @title
          puts
        end
        print_table
        if bars
          puts
          draw_bars
        end
        puts
      end
    end

    def stats
      memoizing do
        {
          :count => total_runs,
          :total => total_run_time,
          :min => min_run_time,
          :max => max_run_time,
          :mean => ave_run_time
        }
      end
    end

    def print_table
      puts "num runs       : #{total_runs}"
      puts "total run time : #{total_run_time}s"
      puts "min run time   : #{min_run_time}s"
      puts "max run time   : #{max_run_time}s"
      puts "ave run time   : #{ave_run_time}s"
    end

    def draw_bars(include_values=false)
      if total_runs > 0
        band_height = (max_run_time - min_run_time) / 4.0
        (0..4).to_a.reverse.each do |band|
          bars = []
          @runs.each do |run|
            if run >= min_run_time + (band.to_f * band_height)
              bars << '*'
            else
              bars << ' '
            end
          end
          puts bars.join(' ')
        end
      end
      puts runs.join(' ') if include_values
    end

  end

end
