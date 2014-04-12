module Chartup

  class Chart
    attr_accessor :lines, :title, :composer

    def initialize(string)

      raise ArgumentError 'Chart string is not a string' unless string.is_a? String
      raise ArgumentError 'Chart string is empty' if string.empty?

      @line_array = string.split("\n").map { |line| line.strip }.reject { |line| line.empty? }

      # regex = /(title|composer):(.*)/

      if @line_array[0].downcase.start_with? 'title:'
        @title = @line_array[0].split('title:')[1].strip
        @line_array.shift
      end

      if @line_array[0].downcase.start_with? 'composer:'
        @composer = @line_array[0].split('composer:')[1].strip
        @line_array.shift
      end

      @lines = Array.new
      # Section titles belong to specific lines
      # If we find a line above a -----, we make it the title of the line below that
      @line_array.each_with_index do |line, idx|
        if is_underline(@line_array[idx + 1])
          @line_title = line
          @line_array.delete_at(idx + 1)
        else
          @lines << Line.new(line, idx, self, @line_title)
          @line_title = ''
        end
      end
    end

    def is_underline(line)
      false if line.nil?
      line =~ /\A-+\z/ # Line has only - characters
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
      template_dir = File.join(File.dirname(__FILE__), '../../templates/')
      template_path = File.join(template_dir, 'chartup.ly.erb')
      puts template_path
      template = File.read(template_path)
      renderer = ERB.new(template)
      rendered = renderer.result(binding)
      File.open('./test.ly', 'w') { |file| file.write(rendered) }
      rendered
    end

    def all_chords(format)
      output_string = ''
      case format
      when :lilypond

        @lines.each do |line|
          line.measures.each do |measure|
            measure.chords.each do |chord|
              output_string << chord.formatted_chord_name(:lilypond) 
            end
          end
        end
      end
      output_string.strip
    end

  end
end