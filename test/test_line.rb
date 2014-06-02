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
    c = Chartup::new_chart(%q{
Am
Am Dm | Gm Em
|: Am Dm | Gm Em | D7 - G7 - :|
 | Am Dm |
| Dm Am | E

    })

    assert_equal 'Am - - -', c.line(0).first_measure.to_s
    assert_equal 'Am - Dm -', c.line(1).first_measure.to_s
    assert_equal 'Am - Dm -', c.line(2).first_measure.to_s
    assert_equal '- - - -', c.line(3).first_measure.to_s
    assert_equal 'Dm - Am -', c.line(4).first_measure.to_s
  end

  def test_prev
    s = %Q{
      title: Title
      composer: Composer

      VERSE
      --------
      Am D7 | E7 Gm
      Bm Dm Cm Fm | Em

      CHORUS
      --------- 
      Gm Am | D D D G | D G 
    }
    c = Chartup::Chart.new(s)
    l1 = c.line(0)
    l2 = c.line(1)
    l3 = c.line(2)
    assert_nil l1.prev
    assert_equal l1, l2.prev
    assert_equal l2, l3.prev
  end

  def test_next
    s = %Q{
      title: Title
      composer: Composer

      VERSE
      --------
      Am D7 | E7 Gm
      Bm Dm Cm Fm | Em

      CHORUS
      --------- 
      Gm Am | D D D G | D G 
    }
    c = Chartup::Chart.new(s)
    l1 = c.line(0)
    l2 = c.line(1)
    l3 = c.line(2)
    assert_equal l2, l1.next
    assert_equal l3, l2.next
    assert_nil l3.next
  end

  def test_length
    l1 = Chartup::Line.new('Am Dm | Em Dm | |', nil, nil, nil)
    assert_equal 12, l1.length

    l2 = Chartup::Line.new('Am Dm | Em Dm', nil, nil, nil)
    assert_equal 8, l2.length
  end

  def test_to_s
    l1 = Chartup::Line.new('Am Dm | Em Dm | |', nil, nil, nil)
    assert_equal 'Am - Dm - | Em - Dm - | - - - -', l1.to_s
  end
end