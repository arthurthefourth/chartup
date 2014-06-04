# encoding: utf-8
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
      types = ['', 'm', 'M', 'M7', 'm7', 'M9', 'm9', 'M6', 'm6', 'M11', 'm11', 'M13', 'm13', '5', '6', '7', '9', '11', '13', 'dim', 'aug', 'sus', 'sus4', 'mM7', 'ø', 'º', 'Maj7', 'min7', '+']
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

    def formatted_chord_type(type, format)
      case format
      when :lilypond
        chord_names = {'M7' => 'maj7', 'sus' => 'sus4', 'M9' => 'maj9', 'ø' => 'm7.5-', 'mM7' => 'm7+', 'M7#11' => 'maj7.11+', "º" => "dim", '+' => 'aug'}

        chord_types = type.split(/([#b]\d+)/).reject{|x| x.empty? }
        basic_type = chord_types.shift
        chord_types = chord_types.map do |type|
          type.sub(/([#b])(\d+)/) do |match|
            acc = $1 == '#' ? '+' : '-'
            ".#{$2}#{acc}"
          end
        end

        basic_type = chord_names[basic_type] || basic_type

        type = "#{basic_type}#{chord_types.join('')}"
      end
    end

    # Format the chord for rendering in a particular notation format.
    # @param format [Symbol] the format - currently only :lilypond.
    # @return [String] the formatted name with length. For long chords, this may appear as multiple chords. (e.g. 'bes\breve:maj7.11+ bes4:maj7.11+')
    def formatted_chord_name_with_length(format=:lilypond)
      case format
      when :lilypond
        accidentals = {'#' => 'is', 'b' => 'es', '##' => 'isis', 'bb' => 'eses'}


        # Process chord type
        type = formatted_chord_type(@type, format)

        accidental = accidentals[root_accidental]
        root = @root_letter.downcase
        chord_lengths = formatted_chord_lengths(length, format)
 
        if chord_lengths.is_a?(Array)
          chord_lengths.flatten.map {|l| " #{root}#{accidental}#{l}:#{type}"}.join('')
        else
          " #{root}#{accidental}#{chord_lengths}:#{type}"
        end
      end
    end

    #Return an array of chord lengths, or a single chord length
    def formatted_chord_lengths(length, format=:lilypond)
      case format
      when :lilypond

        lengths = {
          1 => 4, 2 => 2, 3 => '2.', 4 => 1, 
          5 => [1, 4], 6 => '1.', 7=> '1..', 8 => '\breve' 
        }

        # For notes longer than 8, add in breves before the chord.
        if @length > 8
          breves = @length / 8
          remainder = @length % 8

          if remainder == 0
            lengths_array = []
          else
            lengths_array = [ lengths[remainder] ]
          end

          breves.times { lengths_array.unshift(lengths[8]) }
          lengths_array

        else
          lengths[length]
        end
      end
    end
  end
end