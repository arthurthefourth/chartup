module Chartup
  class Measure
    attr_accessor :chords, :starts_with_repeat, :ends_with_repeat

    # Builds a new Measure.
    # @param string [String] the string of chords to be parsed.
    # @param idx [Fixnum] the index of this Measure in its parent Line.
    # @param line [Line] the parent line.
    def initialize(string, idx, line)
      @idx = idx
      @line = line
      @starts_with_repeat = false
      @ends_with_repeat = false

      @chord_array = string.gsub(/\s+/m, ' ').strip.split(" ")

      # Process repeat barlines
      if @chord_array[0] == ':'
        @starts_with_repeat = true
        @chord_array.shift
      end

      if @chord_array[-1] == ':'
        @ends_with_repeat = true
        @chord_array.pop
      end

      @chord_array = fill_out_chord_array(@chord_array)

      # Each hyphen augments the length of the previous chord by a beat
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

    # Fills out an array of chords (as strings) with explicit hyphens for each beat.
    # @param chord_array [Array] the array of chords (as strings). e.g. ['Gm7', 'C7']
    # @return [Array] the filled-out array of chords (as strings). e.g. ['Gm7', '-', 'C7', '-']
    def fill_out_chord_array(chord_array)
      length = chord_array.length
      case length
      when 0
        chord_array = ['-', '-', '-', '-']
      when 1
        chord_array = [chord_array[0], '-', '-', '-']
      when 2
        chord_array = [chord_array[0], '-', chord_array[1], '-']
      when 3
        chord_array << '-'
      end
      if length > 4
        raise Chartup::SyntaxError, "Too many chords in this measure: #{chord_array.join(' ')}" 
      end
      chord_array
    end

    # @return [Fixnum] the number of beats this Measure takes up.
    def length
      sum = 0
      @chords.each { |chord| sum += chord.length }
      sum
    end

    # Returns the nth Chord in this Measure.
    # @param n [Fixnum] the Chord number (using zero-based numbering).
    # @return [Chord] the Chord. 
    def chord(n)
      @chords[n]
    end

    # @return [Chord] the first Chord in this Measure.
    def first_chord
      @chords[0]
    end

    # @return [Chord] the last Chord in this Measure.
    def last_chord
      @chords[-1]
    end

    # @return the last Chord *before* this measure.
    def prev_chord
      measure = prev
      # Sometimes the previous measure has no explicit chords, only hyphens.
      measure = measure.prev while measure.chords.empty?
      measure.last_chord
    end

    # @return the Measure before this one.
    def prev
      if @idx == 0
        @line.prev.last_measure
      else
        @line.measure(@idx - 1)
      end
    end

    # @return the Measure after this one.
    def next
      if self == @line.last_measure
        @line.next.first_measure
      else
        @line.measure(@idx + 1)
      end
    end

    # Converts the Measure to a human-readable string.
    # @return [String] the string.
    # @todo Include repeat barlines.
    def to_s
      @chord_array.join(" ")
    end
  end
end