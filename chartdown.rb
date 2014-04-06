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

      @line_array = string.split("\n").map { |line| line.strip }.reject { |line| line.empty? }

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

      @lines = Array.new
      @line_array.each_with_index do |line, idx|
        @lines << Line.new(line, idx, self)
      end
    end

    def line(n)
      @lines[n]
    end

    def first_line
      @lines[0]
    end

    def last_line
      @lines[-1]
    end

    def to_s
      @lines.map { |line| line.to_s }.join("\n") 
    end

    def to_ly
      # Figure out how long each chord is, and how long each line is
      # For each line, create enough beats and a break
      template = File.read('./chartdown.ly.erb')
      renderer = ERB.new(template)
      rendered = renderer.result(binding)
      File.open('./test.ly', 'w') { |file| file.write(rendered) }
      rendered
    end

    def output_lilypond(format)
      case format
      when :pdf
        o, s = Open3.capture2("lilypond --output=test -", :stdin_data => to_ly)
      when :png 
        o, s = Open3.capture2("lilypond --output=test -dbackend=eps -dno-gs-load-fonts -dinclude-eps-fonts --png -", :stdin_data => to_ly)
      end
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
        lengths = {1 => 4, 2 => 2, 3 => '2.', 4 => 1 }
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

    def initialize(string, idx, chart)
      @idx = idx
      @chart = chart
      @measure_array = string.split('|')
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
      sum = 0
      @measures.each { |m| sum += m.length }
      sum
    end

    def to_s
      @measures.map { |m| m.to_s }.join(' | ')
    end
  end

  class Measure
    attr_accessor :chords

    def initialize(string, idx, line)
      @idx = idx
      @line = line
      @chord_array = string.gsub(/\s+/m, ' ').strip.split(" ")
      @chord_array = fill_out_chord_array(@chord_array)

      @chords = Array.new()
      @chord_array.each do |chord|
        if chord == '-'
          @current_chord ||= prev.last_chord
          @current_chord.length += 1
        else
          @current_chord = Chord.new(chord, 1)
          @chords << @current_chord
        end                
      end
    end

    def fill_out_chord_array(chord_array)
      case chord_array.length
      when 1
        chord = chord_array[0]
        chord_array = [chord, '-', '-', '-']
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