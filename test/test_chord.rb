require 'test_helper'
require 'minitest/autorun'
require 'chartup'

class ChordTest < MiniTest::Test

  def test_formatted_chord_name_with_length
    chord = Chartup::Chord.new('AM7b9#11', 18)
    assert_equal ' a\breve:maj7.9-.11+ a\breve:maj7.9-.11+ a2:maj7.9-.11+', chord.formatted_chord_name_with_length(:lilypond)

    chord2 = Chartup::Chord.new('D#susb9', 5)
    assert_equal ' dis1:sus4.9- dis4:sus4.9-', chord2.formatted_chord_name_with_length(:lilypond)

    aug = Chartup::Chord.new('Bbb+', 2)
    assert_equal ' beses2:aug', aug.formatted_chord_name_with_length(:lilypond)
  end
end