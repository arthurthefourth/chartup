require 'minitest/autorun'
require 'chartup'

class ChartTest < MiniTest::Test

  def test_Chart_must_be_initalized_with_non_empty_string
    assert_raises(Chartup::ArgumentError) { Chartup::Chart.new(5) }
    assert_raises(Chartup::ArgumentError) { Chartup::Chart.new('') }
  end


  def test_Chartup_headers_are_loaded_into_chart
    t = "Symphony No. 9"
    c = "Beethoven"
    chart = Chartup::Chart.new("title: #{t}\ncomposer: #{c}")
    assert_equal t, chart.title
    assert_equal c, chart.composer
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
    bad_examples = [" ------ ", " ", "|------|", "-- ", "- -"]
    good_examples.each { |string| assert Chartup::Chart.is_underline?(string) }
    bad_examples.each { |string| refute Chartup::Chart.is_underline?(string) }
  end

  def test_Lines_of_music_are_added_to_the_chart_individually
    array = ["D G C F", "Gm Cm Fm Bbm", "A7 D7 G7 C7"]
    c = array.join("\n")
    chart = Chartup::Chart.new(c)
    assert_equal array[0], chart.line(0).to_s
    assert_equal array[1], chart.line(1).to_s
    assert_equal array[2], chart.line(2).to_s
  end

end