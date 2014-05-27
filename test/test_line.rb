require 'minitest/autorun'
require 'chartup'

class LineTest < MiniTest::Test


  def test_initialize_with_string_index_chart_and_title
    c = Chartup::Chart.new('Am | D7')
    l = Chartup::Line.new('G7 | C', 15, c, 'Title')
    assert_equal 'Title', l.title
    assert_equal 15, l.index
  end

  def test_measure
    m0 = 'G7 Am D7 E7'
    m1 = 'C D E F'
    m2 = 'Cm Bm Fm Gm'
    measures = [m0, m1, m2].join('|')
    l = Chartup::Line.new(measures, nil, nil, nil)
    assert_equal m0, l.measure(0).to_s
    assert_equal m1, l.measure(1).to_s
    assert_equal m2, l.measure(2).to_s

  end

  def test_last_measure
    l1 = Chartup::Line.new('Am', nil, nil, nil)
    assert_equal 'Am - - -', l1.last_measure.to_s

    l2 = Chartup::Line.new('Am Dm | Gm Em', nil, nil, nil)
    assert_equal 'Gm - Em -', l2.last_measure.to_s

    l3 = Chartup::Line.new('| Am Dm | Gm Em |: D7 - G7 - :|', nil, nil, nil)
    assert_equal 'D7 - G7 -', l3.last_measure.to_s
  end

  def test_first_measure
    l1 = Chartup::Line.new('Am', nil, nil, nil)
    assert_equal 'Am - - -', l1.first_measure.to_s

    l2 = Chartup::Line.new('Am Dm | Gm Em', nil, nil, nil)
    assert_equal 'Am - Dm -', l2.first_measure.to_s

    l3 = Chartup::Line.new('|: Am Dm | Gm Em |: D7 - G7 - :|', nil, nil, nil)
    assert_equal 'Am - Dm -', l3.first_measure.to_s
  end

end