module Chartup
  class Line
    attr_accessor :measures, :title

    def initialize(string, idx, chart, title)
      @title = title
      @idx = idx
      @chart = chart
      @measure_array = string.split('|').map { |measure| measure.strip }.reject { |measure| measure.empty? }
      @measures = Array.new
      @measure_array.each_with_index do |measure, idx|
        @measures << Measure.new(measure, idx, self)
      end
    end

    def measure(n)
      @measures[n]
    end

    def bar(n)
      measure(n)
    end

    def last_measure
      @measures[-1]
    end

    def first_measure
      @measures[0]
    end

    def prev
      @chart.line(@idx - 1)
    end

    def next
      @chart.line(@idx + 1)
    end

    def length
      # Adjust later for different time signatures
      4 * @measures.length
    end

    def to_s
      @measures.map { |m| m.to_s }.join(' | ')
    end
  end
end