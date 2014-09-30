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

  def test_formatted_chord_lengths
    chords = Chartup::Chord.new('AM7b9#11', 18).formatted_chord_lengths(:lilypond)
    assert_equal %w{ \breve \breve 2}, chords

    chords2 = Chartup::Chord.new('Bb', 4).formatted_chord_lengths(:lilypond)
    assert_equal '1', chords2
  end

  def test_formatted_chord_type
    chord = Chartup::Chord.new('C#7#9b13', 4)
    type = chord.formatted_chord_type
    assert_equal '7.9+.13-', type
  end

  def test_good_chord_types_are_recognized
    good_chords = %w{M7 m9 sus 7b9b13 + dim}
    bad_chords = %w{M3 7*9 h 91}
    good_chords.each do |c|
      assert Chartup::Chord.good_chord_type?(c)
    end
  end

  def test_bad_chord_types_are_not_recognized
    bad_chords = %w{M3 7*9 h 91}
    bad_chords.each do |c|
      refute Chartup::Chord.good_chord_type?(c)
    end
  end
end