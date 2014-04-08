module Chartup
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
    def root
      "#{@root_letter}#{@root_accidental}"
    end

    def formatted_chord_name(format)
      case format
      when :lilypond
        accidentals = {'#' => 'is', 'b' => 'es', '##' => 'isis', 'bb' => 'eses'}
        lengths = {1 => 4, 2 => 2, 3 => '2.', 4 => 1 }
        chord_names = {'M7' => 'maj7', 'sus' => 'sus4', 'M9' => 'maj9', 'ø' => 'm7.5-', 'mM7' => 'm7+'}

        accidental = accidentals[root_accidental]
        root = @root_letter.downcase
        length = lengths[@length]        
        type = chord_names[@type] || @type

        # Turn chords like G7b9#13 into chords like G7.9-13+
        extension_match = /([#b])(\d+)/
        type.gsub!(extension_match) do |match|
          symbol = $1 == '#' ? '+' : '-'
          ".#{$2}#{symbol}"
        end

        " #{root}#{accidental}#{length}:#{type}"
      end
    end
  end
end