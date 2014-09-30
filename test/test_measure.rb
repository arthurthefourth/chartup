require 'test_helper'
require 'minitest/autorun'
require 'chartup'

class MeasureTest < MiniTest::Test

  def test_initialize_with_string_index_and_line
    l = Chartup::Line.new('Am D7 | G E7 | Am D7', nil, nil, nil)
    m = Chartup::Measure.new('G E7', 3, l)
    assert_equal 3, m.index
    assert_equal l, m.line
  end

  def test_scan_for_repeats
    m1 = Chartup::Measure.new(': Am D7')
    m2 = Chartup::Measure.new('Am D7 :')
    m3 = Chartup::Measure.new(': Am D7 :')

    assert m1.starts_with_repeat
    assert m2.ends_with_repeat
    assert (m3.starts_with_repeat && m3.ends_with_repeat)

    refute m1.ends_with_repeat
    refute m2.starts_with_repeat
  end

  def test_one_chord_lasts_a_whole_bar
    measure = Chartup::Measure.new('Am')
    assert_equal 'Am - - -', measure.to_s
  end

  def test_two_chords_last_two_beats_each
    measure = Chartup::Measure.new('Am Dm')
    assert_equal 'Am - Dm -', measure.to_s
  end

  def test_third_chords_last_two_beats
    measure = Chartup::Measure.new('Am Dm E7')
    assert_equal 'Am Dm E7 -', measure.to_s
  end

  def test_four_chords_last_one_beat_each
    measure = Chartup::Measure.new('Am Dm E7 F7')
    assert_equal 'Am Dm E7 F7', measure.to_s
  end

  def test_hyphens_extend_the_previous_chord_a_beat
  end

  def test_hyphens_work_over_barlines
  end

  def test_hyphens_work_over_staff_lines
  end

  def test_fill_out_chord_strings
    # Specify pairs of valid input with their expected output
    good_pairs = [
      {
        in: [], 
        out: ['-', '-', '-', '-'] 
      },

      {
        in: [''],
        out: ['-', '-', '-', '-']
      },
      { 
        in: %w{ Am },
        out: ['Am', '-', '-', '-']
      },

      {
        in: %w{ Am D7 },
        out: ['Am', '-', 'D7', '-'] 
      },

      {
        in: %w{ Am D7 E },
        out: ['Am', 'D7', 'E', '-']
      },

      { 
        in: %w{ Am D7 E F7 },
        out: ['Am', 'D7', 'E', 'F7']
      }
    ] 

    good_pairs.each do |pair|
      assert_equal pair[:out], Chartup::Measure.fill_out_chord_strings(pair[:in])
    end

    bad_input = %w{ Am D7 E F7 G7 }
    assert_raises(Chartup::SyntaxError) { Chartup::Measure.fill_out_chord_strings(bad_input)}
  end

end