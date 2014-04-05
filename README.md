Chartdown
============

Chartdown is a language for writing simple music charts, inspired by [Markdown](http://daringfireball.net/projects/markdown/syntax). Like Markdown documents, Chartdown files can be used as charts on their own, but they look better when translated onto a musical staff. Chartdown does not plan to support the notation of actual notes; there are [plenty](http://lilypond.org) of [great](http://abcplus.sourceforge.net/) [options](http://icking-music-archive.org/software/htdocs/index.html) for that already. 

The chartdown tool converts Chartdown files into Lilypond (.ly) documents, which can then be exported as PDF's, PNG's, or MusicXML.

If you'd like to get started quickly, here's an example document:

Example
--------

```
title: The Song
composer: Arthur Lewis
tempo: 120
[ V C V B V C ]

VERSE
-------------
A | A | A | A
D | D | D | E
F | Fm | Gm7b5 - C7 - |

CHORUS
--------------
||: Fm - - C#7 | A6 /G /F# /E | D5 D7#5 D6 D13 |
    G          | Gm7 C7       | E7 - A7 - :||

BRIDGE
--------------
F | Bb | Gm | A7 | D | D
```


A Chartdown document has the extension .chartdown, and it has two main parts.

* Metadata

```
title: A chart
composer: This guy
tempo: 127
```

* Chart

Charts can have multiple sections, each with its own title.

```
Chorus
--------------
| Fm7 Bb7 | EbM7 Cm7 | 
| Fm Bb7  | EbM7 -   |

Verse
--------------
||: Eb | Ab | Eb | Bb :|| 
```

Lines within each section are written mostly as you'd expect.

Measures
--------

Measures are delineated by `|` characters. The first and final `|` characters in a line are both optional. Spacing is irrelevant.

```
| G | C |
| C | G
G | C
C         | G         |
```

Chord Types
---------

Most common chord nomenclature is accepted.

```
G7b5 | AbM7 | G#7#5 | Eº | Aaug
```

Rhythm
----------

Each measure is divided into quarter notes. Chord lengths can be implicit or explicit.

*Implicit*

A chord by itself in a measure will last the whole bar. Two chords by themselves will each last half the bar. (This is not well defined for odd meters yet.) If the chords in a bar don't add up to the full bar, the last chord will be extended to the end of the bar.

*Explicit*

Chords last a quarter note by default. The `-` character acts as an invisible repetition of the previous chord. So, in `Fm - Bb Eb`, the Fm would last for 2 beats.



**Quarter notes**
```
C Am Dm G | C A Ab G
```

**Half notes**
```
Fm Bb | Eb Ab
```

*or*

```
Fm - Bb - | Eb - Ab - |
```

**Whole notes**
```
Ab | G | Cm 
```

**Quarter-quarter-half**
```
Fm Bb Eb - | Fm Bb Eb - |
```

**Extending over a barline**
```
Fm | - Bb - Eb | - Ab - - 
```

--------------------------------
TODO
=========

* Repeat barlines
* Extend chords with `-`
* Validate input
* Chord types
* Time signatures
* VexTab
