# Chartup

Chartup is a simple intuitive language for writing basic chord charts, inspired by [Markdown][1]. It's designed for musicians who want to be able to write out a quick chord chart in real-time, without having to learn a new application or technology.

Chartup does not plan to support the notation of actual notes; there are [plenty][2] of [options][3] for that already. 

The Chartup library currently converts .chartup files into [Lilypond][4] (.ly) documents. Lilypond can be used to render these to .png or. pdf documents.

MusicXML support is forthcoming, allowing you to import charts into Finale, Sibelius, or your favorite notation program, for further editing.

Please note that Chartup is still under development, and is lacking a number of important features.

# Usage

To try it out, visit the [Chartup][chartup] site. Or to use the library, you'll need to have lilypond installed:

Ruby:

```ruby
chart = %Q{
title: Example Chart
composer: Your Name

VERSE
--------
Am | D7

CHORUS
--------
Bb - Gm - | D7 
}
c = Chartup.new_chart(chart)

File.open('example_chart.ly', w) do |f|
  f.write c.to_ly
end
```

Command Line:

```bash
# For PDF
lilypond --output=example example_chart.ly

# Or for PNG
lilypond --output=example -dbackend=eps -dno-gs-load-fonts -dinclude-eps-fonts -ddelete-intermediate-files --png
```

For more info on the Chartup language, look at [LANGUAGE.md](LANGUAGE.md).

[1]: http://daringfireball.net/projects/markdown/syntax "Markdown Syntax at Daring Fireball"
[2]: http://abcplus.sourceforge.net/
[3]: http://icking-music-archive.org/software/htdocs/index.html
[4]: http://lilypond.org
[chartup]: http://chartup.arthurthefourth.com
