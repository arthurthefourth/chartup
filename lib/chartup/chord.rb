module Chartup
  class Chord

    attr_accessor :name, :length, :root_letter, :root_accidental, :type

    # Create Chord object of a particular length
    # @param chord_name [String] the full name of the Chord - e.g. "BbM7#11"
    # @param length [Fixnum] the number of beats the Chord will last for.
    def initialize(chord_name, length)

      raise ArgumentError "Chord name #{chord_name} is not a string" unless chord_name.is_a? String
      raise ArgumentError "Length #{length} is not a number" unless length.is_a? Fixnum

      @length = length
      @name = chord_name

      # Split chord into root letter, accidental, and chord type - e.g. ['B', 'b', and 'M7#11']
      regex = /^([A-Ga-g])([b#]{0,2})(.*)/
      match = regex.match(chord_name)
      raise Chartup::SyntaxError, "Bad chord root in chord \"#{chord_name}\"" if match.nil?
      @root_letter = match[1]
      @root_accidental = match[2]
      @type = match[3]
      raise Chartup::SyntaxError, "Bad chord type in chord \"#{chord_name}\"" unless good_chord_type?(@type)
    end

    def good_chord_type?(type)
      types = ['', 'm', 'M', 'M7', 'm7', 'M9', 'm9', 'M6', 'm6', 'M11', 'm11', 'M13', 'm13', '5', '6', '7', '9', '11', '13', 'dim', 'aug', 'sus', 'sus4', 'mM7', 'ø', 'º', 'Maj7', 'min7']
      ending = /(.*)([#b]\d+)\z/
      while type.length
        match = ending.match(type)
        if match.nil?
          return types.include? type
        else
          type = match[1]
        end
      end
    end

    def to_s
      @name
    end

    # Return the root of the Chord - e.g. "Bb"
    # @return [String] the root.
    def root
      "#{@root_letter}#{@root_accidental}"
    end

    # Format the chord for rendering in a particular notation format.
    # @param format [Symbol] the format - currently only :lilypond.
    # @return [String] the formatted name with length. For long chords, this may appear as multiple chords. (e.g. 'bes\breve:maj7.11+ bes4:maj7.11+')
    def formatted_chord_name_with_length(format)
      case format
      when :lilypond
        accidentals = {'#' => 'is', 'b' => 'es', '##' => 'isis', 'bb' => 'eses'}
        lengths = {1 => 4, 2 => 2, 3 => '2.', 4 => 1, 
          5 => [1, 4], 6 => '1.', 7=> '1..', 8 => '\breve', 
          9 => ['\breve', 4], 10 => ['\breve', 2], 11 => ['\breve', '2.'], 12 => '\breve.' }

        # Major 7th chords need special handling
        chord_names = {'M7' => 'maj7', 'sus' => 'sus4', 'M9' => 'maj9', 'ø' => 'm7.5-', 'mM7' => 'm7+', 'M7#11' => 'maj7.11+', "º" => "dim"}

        accidental = accidentals[root_accidental]
        root = @root_letter.downcase
        lp_length = lengths[@length]        
        type = chord_names[@type] || @type

        # Turn chords like G7b9#13 into chords like G7.9-13+
        chord_extension_regex = /([#b])(\d+)/
        type.gsub!(chord_extension_regex) do |match|
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