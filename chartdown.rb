require 'erb'


module Chartdown
  # Turn a chart into a 3-level array.
  # Lines, then measures, then chords.
  def Chartdown.string_to_array(string)
    if string.empty?
      []
    else
      string.split("\n").collect do |line| 
        measures = line.split('|')
        measure_array = measures.collect do |measure| 
          measure.gsub(/\s+/, ' ').strip.split(" ")
        end
      end
    end

  end


  def Chartdown.array_to_ly(array)
    # Figure out how long each chord is, and how long each line is
    # For each line, create enough beats and a break
  end


  class Chart
    def initialize(string, options={})
      @content_string = string;
      @content_array = string_to_array(string) 
      @lines = @content_array.collect do |line|
        Line.new(line)
      end
      @title = options[:title]
      @composer = options[:composer]
    end
    def line(n)
      @lines[n]
    end

  end

  class Line
    def initialize
    end

    def measure(n)
      self.measure_array[n]
    end
  end

  class Measure
    def chord
    end
  end
end