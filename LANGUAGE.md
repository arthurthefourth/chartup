Chartup is a simple intuitive language for writing basic chord charts, inspired by [Markdown][1].

If you'd like to get started quickly, here's a sample document:

```
title: The Song
composer: You!

VERSE
-------------
A | A | A | A
D | D | D | E
F | Fm | Gm7b5 - C7 - |

CHORUS
--------------
Fm - - C#7 | A6 Dm7 F#m9 E5 | D5 D7#5 D6 D13 |
    G          | Gm7 C7       | E7 - A7 -  |

BRIDGE
--------------
F | Bb | Gm | A7 | D | D
```

---------------
Quick Guide:
--------------
Start with -

```
title: Your Title
composer: Composer NAme
``` 

Then just write out the chords, using `|` to make a new measure, and going to the next line when you want to.

#####Tips: 
* Spacing is irrelevant.
* Chord shorthand: Use `-` to extend a chord for multiple beats. Leaving only one or two chords in a bar will make them whole notes or half notes, respectively. 
* Rehearsal Marks: Put `------` under a letter, word, or phrase to mark the section below it.  

------------------------

Details:
----------

A Chartup document has the extension .chartup, and it has two main parts.

### Metadata

```
title: A chart
composer: This guy
```

### Chart

Charts can have multiple sections, each with its own title (which appears as a rehearsal mark).

```
Chorus
--------------
| Fm7 Bb7 | EbM7 Cm7 | 
| Fm Bb7  | EbM7 -   |

Verse
--------------
| Eb | Ab | Eb | Bb | 
```

###Measures

Measures are delineated by `|` characters. The first and final `|` characters in a line are both optional. Spacing is irrelevant.

```
| G | C |
| C | G
G | C
C         | G         |
```

###Chord Types
---------

Most common chord nomenclature is accepted. Some chords stil produce unexpected results in conversion to Lilypond, most notably, M7#11 and 13 chords. Slash chords are not yet supported, but will be soon.

```
G7b5 | AbM7 | G#7#5 | Edim | Aaug
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
* ~~Section titles~~
* ~~Extend chords with `-`~~
* ~~Validate input~~
* Slash notation (e.g. A/G)
* ~~Chord types~~
* Time signatures
* Key signatures
* MusicXML support

[1]: http://daringfireball.net/projects/markdown/syntax "Markdown Syntax at Daring Fireball"