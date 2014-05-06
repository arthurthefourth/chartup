module Chartup

  class Chart
    attr_accessor :lines, :title, :composer

    # Populate Chart object with content of Chartup string
    # @param string [String] a string in Chartup format
    # @return [Chart] the newly-created Chart.
    def initialize(string)

      raise ArgumentError.new('Chart string is not a string') unless string.is_a? String
      raise ArgumentError.new('Chart string is empty') if string.empty?

      @line_array = string.split("\n").map { |line| line.strip }.reject { |line| line.empty? }

      # Load initial labels into Chart object - title, composer, etc.
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
        # Assign section titles to the lines directly below them
        if is_underline?(@line_array[idx + 1])
          @line_title = line
          @line_array.delete_at(idx + 1)
        # Create Lines for every other line
        else
          @lines << Line.new(line, idx, self, @line_title)
          @line_title = ''
        end
      end
    end

    # Returns whether or not a string is composed only of "-" characters.
    # @param line [String] the string.
    # @return [Boolean]
    def is_underline?(line)
      false if line.nil?
      line =~ /\A-+\z/ # Line has only - characters
    end

    # Returns the nth line in this Chart.
    # @param n [Fixnum] the line number (using zero-based numbering).
    # @return [Line] the line.
    def line(n)
      @lines[n]
    end

    # @return [Line] the first line in this Chart.
    def first_line
      @lines[0]
    end

    # @return [Line] the last line in this Chart.
    def last_line
      @lines[-1]
    end

    # Converts the Chart to a human-readable string.
    # @return [String] the string.
    # @todo Include line titles in the printout.
    def to_s
      @lines.map { |line| line.to_s }.join("\n") 
    end

    # Converts the Chart to a Lilypond document, using chartup.ly.erb.
    # @return [String] the Lilypond document, as a string.
    def to_ly
      template_dir = File.join(File.dirname(__FILE__), '../../templates/')
      template_path = File.join(template_dir, 'chartup.ly.erb')
      template = File.read(template_path)
      renderer = ERB.new(template)
      rendered = renderer.result(binding)
    end

    # Returns a list of all the Chart's chords in the appropriate format.
    # @param format [Symbol] the format - currently only :lilypond.
    # @return [String] the list of chords 
    def all_chords(format)
      output_string = ''
      case format
      when :lilypond

        @lines.each do |line|
          line.measures.each do |measure|
            measure.chords.each do |chord|
              output_string << chord.formatted_chord_name_with_length(:lilypond) 
            end
          end
        end
      end
      output_string.strip
    end

  end
end