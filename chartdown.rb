require 'erb'
require 'Open3'

module Chartdown

  def Chartdown.test_chart
    d = <<-chart
        title: Some chords
        composer: Arthur Lewis
        Fm Bb | Gm C | Bbsus | Eb
        Am7 D7 | G D E Bm | Cm D7 | G
        E | E | E | E | em
        chart

    c = Chartdown::Chart.new(d)
  end
  class Chart
    attr_accessor :lines, :title, :composer
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
        @composer = @line_array[0].split('composer:')[1].strip
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
      template = File.read('./chartdown.ly.erb')
      puts template
      renderer = ERB.new(template)
      rendered = renderer.result(binding)
      File.open('./test.ly', 'w') { |file| file.write(rendered) }
      rendered
    end

    def output_lilypond
      o, s = Open3.capture2("lilypond --output=test -", :stdin_data => to_ly)
    end

    def to_vex
    end

    def to_music_xml
    end

    def to_abc
    end

    def all_chords(format)
      output_string = ''
      case format
      when :lilypond
        accidentals = {'#' => 'is', 'b' => 'es', '##' => 'isis', 'bb' => 'eses'}
        lengths = {1 => 4, 2 => 2, 4 => 1 }
        @lines.each do |line|
          line.measures.each do |measure|
            measure.chords.each do |chord|
              type = ":#{chord.type}" unless chord.type.empty?
              accidental = accidentals[chord.root_accidental]
              root = chord.root_letter.downcase
              length = lengths[chord.length]
              output_string << " #{root}#{accidental}#{length}#{type}"
            end
          end
        end
      end
      output_string.strip
    end
  end

  class Line
    attr_accessor :measures
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
      sum = 0
      @measures.each { |m| sum += m.length }
      sum
    end

    def to_s
      @measures.collect { |m| m.to_s }.join(' | ')
    end
  end

  class Measure

    attr_accessor :chords
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
      sum = 0
      @chords.each { |chord| sum += chord.length }
      sum
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

    attr_accessor :name, :length, :root_letter, :root_accidental, :type
    def initialize(chord_name, length)

      raise ArgumentError 'Chord name argument is not a string' unless chord_name.is_a? String

      @length = length
      @name = chord_name

      regex = /([A-Ga-g])([b#]{0,2})(.*)/
      match = regex.match(chord_name)
      @root_letter = match[1]
      @root_accidental = match[2]
      @type = match[3]
    end


  end

end