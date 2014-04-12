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

    def to_s
      @name
    end
    def root
      "#{@root_letter}#{@root_accidental}"
    end

    def formatted_chord_name(format)
      case format
      when :lilypond
        accidentals = {'#' => 'is', 'b' => 'es', '##' => 'isis', 'bb' => 'eses'}
        lengths = {1 => 4, 2 => 2, 3 => '2.', 4 => 1, 
          5 => [1, 4], 6 => '1.', 7=> '1..', 8 => '\breve', 
          9 => ['\breve', 4], 10 => ['\breve', 2], 11 => ['\breve', '2.'], 12 => '\breve.' }
        # Major 7th chords will need special handling
        chord_names = {'M7' => 'maj7', 'sus' => 'sus4', 'M9' => 'maj9', 'ø' => 'm7.5-', 'mM7' => 'm7+', 'M7#11' => 'maj7.11+', "º" => "dim"}

        accidental = accidentals[root_accidental]
        root = @root_letter.downcase
        lp_length = lengths[@length]        
        type = chord_names[@type] || @type

        # Turn chords like G7b9#13 into chords like G7.9-13+
        extension_match = /([#b])(\d+)/
        type.gsub!(extension_match) do |match|
          symbol = $1 == '#' ? '+' : '-'
          ".#{$2}#{symbol}"
        end

        # For notes longer than 8, add in breves before the chord.
        if @length > 8
          breves = @length / 8
          final_length = @length % 8
          if final_length == 0
            lp_length = []
          else
            lp_length = [ lengths[final_length] ]
          end
          breves.times { lp_length.unshift(lengths[8])}
        end
        if lp_length.is_a?(Array)


          lp_length.map {|l| " #{root}#{accidental}#{l}:#{type}"}.join('')
        else
          " #{root}#{accidental}#{lp_length}:#{type}"
            
        end
      end
    end
  end
end