require 'erb'
require 'Open3'
require_relative 'chartup/chart'
require_relative 'chartup/line'
require_relative 'chartup/measure'
require_relative 'chartup/chord'

module Chartup
  def Chartup.test_chart
    d = <<-chart
        title: Some chords
        composer: Arthur Lewis
        Fm Bb | Gm C | Bbsus | Eb
        Am7 D7 | G D E Bm | Cm D7 | G
        E | E | E | E | em
        chart

    c = Chartup::Chart.new(d)
  end
end