require 'test_helper'
require 'minitest/autorun'
require 'chartup'

class ChartTest < MiniTest::Test

  def test_Chart_must_be_initialized_with_string
    assert_raises(Chartup::ArgumentError) { Chartup::Chart.new(5) }
  end


  def test_Chartup_headers_are_loaded_into_chart
    t = "Symphony No. 9"
    c = "Beethoven"
    chart = Chartup::Chart.new("title: #{t}\ncomposer: #{c}")
    assert_equal t, chart.title
    assert_equal c, chart.composer
    capital_chart = Chartup::Chart.new("Title: #{t}\nComposer: #{c}")
    assert_equal t, capital_chart.title
    assert_equal c, capital_chart.composer
  end

  def test_Section_titles_are_attached_to_the_lines_below_them
    c = %Q{
      VERSE
      ---------
      Am | D7
    }
    chart = Chartup::Chart.new(c)
    assert_equal "VERSE", chart.line(0).title
  end

  def test_is_underline_tests_for_series_of_dashes_or_underscores
    good_examples = ["-", "------", "_", "______", "______-------_______"]
    bad_examples = [" ", "|------|", "- -"]
    good_examples.each { |string| assert Chartup::Chart.is_underline?(string) }
    bad_examples.each { |string| refute Chartup::Chart.is_underline?(string) }
  end

  def test_lines_of_music_become_Line_objects
    array = ["VERSE", "------", "D G C F", "Gm Cm Fm Bbm", "CHORUS", "", "-----", "A7 D7 G7 C7"]
    c = array.join("\n")
    chart = Chartup::Chart.new(c)
    assert_equal array[2], chart.line(0).to_s
    assert_equal array[3], chart.line(1).to_s
    assert_equal array[7], chart.line(2).to_s
  end

  def test_add_line
    c = Chartup.new_chart
    c.add_line('Am')
    c.add_line('Am Dm | Gm Em')
    c.add_line('|: Am Dm | Gm Em | D7 - G7 - :|')
    c.add_line('  | Am Dm |')
    c.add_line('| Dm Am | E')

    chart_string = %q{Am - - -
Am - Dm - | Gm - Em -
Am - Dm - | Gm - Em - | D7 - G7 -
- - - - | Am - Dm -
Dm - Am - | E - - -}
    assert_equal chart_string, c.to_s
  end


end