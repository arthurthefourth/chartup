module Chartup
  class Line
    attr_accessor :measures, :title, :index, :measure_array

    # Creates a new Line object. 
    # @param string [String] the string of measures to be parsed into the Line.
    # @param index [Fixnum] the index of the line within its parent chart (needed for {#next} and {#prev})
    # @param chart [Chart] the parent Chart
    # @param title [String] the title of this line, if any.
    def initialize(string, index, chart, title)
      @title = title
      @index = index
      @chart = chart
      @measures = []

      @measure_array = string.split('|')
      @measure_array.shift if @measure_array.first.empty?
      @measure_array = @measure_array.map { |measure| measure.strip }
      
      @measure_array.each_with_index do |measure, index|
        @measures << Measure.new(measure, index, self)
      end
    end

    # Returns the nth measure of this Line.
    # @param n [Fixnum] the measure number (using zero-based numbering).
    # @return [Measure] the measure.
    def measure(n)
      @measures[n]
    end

    # Alias to {#measure}
    def bar(n)
      measure(n)
    end

    # @return [Measure] the last measure of this Line.
    def last_measure
      @measures[-1]
    end

    # @return [Measure] the first measure of this Line.
    def first_measure
      @measures[0]
    end

    # @return [Line] the Line before this one in its parent Chart
    def prev
      return nil if @index == 0 
      @chart.line(@index - 1)
    end

    # @return [Line] the Line after this one in its parent Chart
    def next
      @chart.line(@index + 1)
    end

    # @return [Fixnum] the number of beats this Line takes up.
    def length
      # Adjust later for different time signatures
      4 * @measures.length
    end

    # Converts this Line to a human-readable string.
    # @return [String] the string.
    # @todo Include repeat signs.
    def to_s
      @measures.map { |m| m.to_s }.join(' | ')
    end
  end
end