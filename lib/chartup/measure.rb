module Chartup
  class Measure
    attr_accessor :chords, :starts_with_repeat, :ends_with_repeat, :index, :line

    # Builds a new Measure.
    # @param string [String] the string of chords to be parsed.
    # @param index [Fixnum] the index of this Measure in its parent Line.
    # @param line [Line] the parent line.
    def initialize(string, index=nil, line=nil)
      @index = index
      @line = line
      @starts_with_repeat = false
      @ends_with_repeat = false

      # Clean up whitespace
      @chord_strings = string.gsub(/\s+/m, ' ').strip.split(" ")
      scan_for_repeats
      @chord_strings = self.class.fill_out_chord_strings(@chord_strings)
      @chords = build_chords_from_chord_strings

    end

    def scan_for_repeats
      if @chord_strings[0] == ':'
        @starts_with_repeat = true
        @chord_strings.shift
      end

      if @chord_strings[-1] == ':'
        @ends_with_repeat = true
        @chord_strings.pop
      end
    end

    # This has to stay an instance method because it depends on the chords in previous measures.
    # At this point, every chord string should be either a 1-beat chord, or a hyphen.
    # For each chord, load it into chords, and set the current chord pointer.
    #
    # For each hyphen, add a beat to the current chord. If there is no current chord,
    # add it to the last chord before this measure.
    def build_chords_from_chord_strings
      chords = Array.new()
      current_chord = nil
      @chord_strings.each do |chord_string|
        # Each hyphen augments the length of the previous chord by a beat
        if chord_string == '-'
          current_chord ||= chord_before
          current_chord.length += 1
        else
          current_chord = Chord.new(chord_string, 1)
          chords << current_chord
        end                
      end
      chords
    end

    # Fills out an array of chords (as strings) with explicit hyphens for each beat.
    # @param chord_strings [Array] the array of chords (as strings). e.g. ['Gm7', 'C7']
    # @return [Array] the filled-out array of chords (as strings). e.g. ['Gm7', '-', 'C7', '-']
    def self.fill_out_chord_strings(chord_strings)
      length = chord_strings.length
      case length
      when 0
        chord_strings = ['-', '-', '-', '-']
      when 1
        chord_strings = [chord_strings[0], '-', '-', '-']
      when 2
        chord_strings = [chord_strings[0], '-', chord_strings[1], '-']
      when 3
        chord_strings << '-'
      end
      if length > 4
        raise Chartup::SyntaxError, "Too many chords in this measure: #{chord_strings.join(' ')}" 
      end
      chord_strings
    end

    # @return [Fixnum] the number of beats this Measure takes up.
    def length
      #TODO: Use inject for this
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
    def chord_before
      measure = prev
      # Sometimes the previous measure has no explicit chords, only hyphens.
      measure = measure.prev while measure.chords.empty?
      measure.last_chord
    end

    # @return the Measure before this one.
    def prev
      if @index == 0
        @line.prev.last_measure
      else
        @line.measure(@index - 1)
      end
    end

    # @return the Measure after this one.
    def next
      if self == @line.last_measure
        @line.next.first_measure
      else
        @line.measure(@index + 1)
      end
    end

    # Converts the Measure to a human-readable string.
    # @return [String] the string.
    # @todo Include repeat barlines.
    def to_s
      @chord_strings.join(" ")
    end
  end
end