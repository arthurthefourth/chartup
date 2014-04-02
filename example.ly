\header{
  title = "The Song"
  composer = "Arthur Lewis"
}

harmonies = \chordmode {
  c1:m7 c2:m7 f2:7 c4 d4:7 b4:6 bes1:m7 ees4:m7 f2:m7 bes:m7 ees:maj7 
}

% Macro to print single slash
rs = {
  \once \override Rest #'stencil = #ly:percent-repeat-item-interface::beat-slash
  \once \override Rest #'thickness = #0.48
  \once \override Rest #'slope = #1.7
  r4
}

% Function to print a specified number of slashes
comp = #(define-music-function (parser location count) (integer?)
  #{
    \override Rest #'stencil = #ly:percent-repeat-item-interface::beat-slash
    \override Rest #'thickness = #0.48
    \override Rest #'slope = #1.7
    \repeat unfold $count { r4 }
    \revert Rest #'stencil
  #}
)

<<
\new ChordNames {
	\set chordChanges = ##t
	\harmonies 
}

\new Staff {
	\relative c'' {
	  \override Score.RehearsalMark.self-alignment-X = #LEFT
	  \mark \markup{ \right-align \box "CHORUS" } 
	  \comp #16 \break 
	  \mark \markup{ \box "VERSE" }
	  \comp #16 \break \comp #16 \break
	}
}
>>

\version "2.18.2"  % necessary for upgrading to future LilyPond versions.

