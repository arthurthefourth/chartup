require 'test_helper'
require 'minitest/autorun'
require 'chartup'

class ChartupTest < MiniTest::Test
  def test_new_chart_should_return_a_new_Chart
    assert_equal Chartup::Chart, Chartup.new_chart('Am').class
  end

  def test_validate_syntax_should_raise_a_Syntax_Error
    assert_raises(Chartup::SyntaxError) { Chartup.new_chart('H') }
  end

  def test_to_ly_should_return_a_Lilypond_document
    assert_match '\new Staff {', Chartup.new_chart('Am').to_ly
  end
end