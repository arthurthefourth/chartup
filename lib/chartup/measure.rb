module Chartup
  class Measure
    attr_accessor :chords, :starts_with_repeat, :ends_with_repeat

    def initialize(string, idx, line)
      @idx = idx
      @line = line
      @starts_with_repeat = false
      @ends_with_repeat = false

      @chord_array = string.gsub(/\s+/m, ' ').strip.split(" ")

      if @chord_array[0] == ':'
        @starts_with_repeat = true
        @chord_array.shift
      end

      if @chord_array[-1] == ':'
        @ends_with_repeat = true
        @chord_array.pop
      end

      @chord_array = fill_out_chord_array(@chord_array)

      @chords = Array.new()
      @chord_array.each do |chord|
        if chord == '-'
          @current_chord ||= prev_chord
          @current_chord.length += 1
        else
          @current_chord = Chord.new(chord, 1)
          @chords << @current_chord
        end                
      end
    end

    def fill_out_chord_array(chord_array)
      case chord_array.length
      when 0
        chord_array = ['-', '-', '-', '-']
      when 1
        chord_array = [chord_array[0], '-', '-', '-']
      when 2
        chord_array = [chord_array[0], '-', chord_array[1], '-']
      when 3
        chord_array << '-'
      end
      chord_array
    end

    def length
      sum = 0
      @chords.each { |chord| sum += chord.length }
      sum
    end

    def chord(n)
      @chords[n]
    end

    def first_chord
      @chords[0]
    end

    def last_chord
      @chords[-1]
    end

    def prev_chord
      measure = prev
      measure = measure.prev while measure.chords.empty?
      measure.last_chord
    end

    def prev
      if @idx == 0
        @line.prev.last_measure
      else
        @line.measure(@idx - 1)
      end
    end

    def next
      if self == @line.last_measure
        @line.next.first_measure
      else
        @line.measure(@idx + 1)
      end
    end

    def to_s
      # This will need fixing
      @chord_array.join(" ")
    end
  end
end