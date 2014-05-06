require 'erb'
require_relative 'chartup/chart'
require_relative 'chartup/line'
require_relative 'chartup/measure'
require_relative 'chartup/chord'

module Chartup
  def Chartup.test_chart
    d = <<-chart
title: The Song
composer: You!

VERSE
-------------
A | A | A | A
D | D | D | E
F | Fm | Gm7b5 - C7 - |

CHORUS
--------------
Fm - - C#7 | A6 Dm7 F#m9 Eaug | Ddim D7#5 D6 D13 |
    G          | Gm7 C7       | E7 - A7 -  | D A7 | | G

BRIDGE
--------------
F | Bb | Gm | A7 | Dm | D7b9b13
        chart

    c = Chartup::Chart.new(d)
  end

  class Error < StandardError; end
  class SyntaxError < Error; end
end