require 'erb'


module Chartdown

  class Chart

    def initialize(string)

      raise ArgumentError 'Chart string is not a string' unless string.is_a? String
      raise ArgumentError 'Chart string is empty' if string.empty?

      @line_array = string.split("\n").collect { |line| line.strip }.reject { |line| line.empty? }

      # regex = /(title|composer):(.*)/
      # @line_arr

      if @line_array[0].downcase.start_with? 'title:'
        @title = @line_array[0].split('title:')[1].strip
        @line_array.shift
      end

      if @line_array[0].downcase.start_with? 'composer:'
        @composer = line_array[0].split('composer:')[1].strip
        @line_array.shift
      end

      @lines = @line_array.collect do |line|
        Line.new(line)
      end
    end

    def line(n)
      @lines[n]
    end

    def to_s
      @lines.collect { |line| line.to_s }.join("\n") 
    end

    def to_ly
      # Figure out how long each chord is, and how long each line is
      # For each line, create enough beats and a break
    end

    def to_vex
    end

    def to_music_xml
    end

    def to_abc
    end

  end

  class Line
    def initialize(string)
      @measure_array = string.split('|')
      @measures = @measure_array.collect do |measure|
        Measure.new(measure)
      end
    end

    def measure(n)
      @measures[n]
    end

    def length
      @measures.inject { |sum, measure| sum += measure.length }
    end

    def to_s
      @measures.collect { |measure| measure.to_s }.join(' | ')
    end
  end

  class Measure

    def initialize(string)
      @chord_array = string.gsub(/\s+/m, ' ').strip.split(" ")
      case @chord_array.length
      when 1
        @chords = [ Chord.new(@chord_array[0], 4) ]
      when 2
        @chords = @chord_array.collect do |chord|
          Chord.new(chord, 2)
        end
      when 4
        @chords = @chord_array.collect do |chord|
          Chord.new(chord, 1)
        end
      else
        # Each dash augments the value of the previous chord
        # Start at the last element and move left
        # When you hit a chord, add it in as the beginning of the array - @chords.insert(0, Chord.new(chord, length))

      end
    end

    def length
      @chords.inject { |sum, chord| sum += chord.length }
    end

    def chord(n)
      @chords[n]
    end

    def to_s
      # This will need fixing
      @chord_array.join(" ")
    end
  end

  class Chord

    def initialize(chord_name, length)

      raise ArgumentError 'Chord name argument is not a string' unless chord_name.is_a? String

      @length = length
      regex = /([A-Ga-g][b#]*)(.*)/
      match = regex.match(chord_name)
      @root = match[1]
      @type = match[2]
    end

    def Chord.root_from_chord_name(chord_name)
      regex = /[ABCDEFG][b#]*/
      chord_name[0]
    end

    def Chord.type_from_chord_name(chord_name)
      raise ArgumentError 'Chord name argument is not a string' unless chord_name.is_a? String
      chord_name[1..chord_name.length]
    end

  end

end