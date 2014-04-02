# Unit tests for Chartdown parser
require_relative 'chartdown'

describe Chartdown do
  describe '#string_to_array' do

    subject { Chartdown::string_to_array(chart) }

    context 'blank input' do
      let(:chart) { '' }
      it { should eq [] }
    end

    context 'one line of single chords' do
      let(:chart) { 'Fm | G | A7 | D' }
      it { should eq [[['Fm'], ['G'], ['A7'], ['D']]]}
    end

    context 'multiple lines of multiple chords' do
      let(:chart) do
        <<-chart
        Fm Bb | Gm C | Bbsus | Eb
        Am7 D7 | G D E Bm | Cm D7 | G
        chart
      end
      it do
        should eq [
          [ ['Fm', 'Bb'], ['Gm', 'C'], ['Bbsus'], ['Eb'] ],
          [ ['Am7', 'D7'], ['G', 'D', 'E', 'Bm'], ['Cm', 'D7'], ['G'] ]
        ]
      end
    end

  end

  describe '#array_to_ly' do
  end
end
