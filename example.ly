#(set-default-paper-size "letter") % Allow A4 option

\header{
  title = "The Song"
  composer = "Arthur Lewis"
  tagline = " "
}

harmonies = \chordmode {
  a1: a1: a1: a1: d1: d1: d1: e1: f1: f1:m g2:m7.5- c2:7 f2.:m cis4:7 a4:6 d4:m7 fis4:m9 e4:m7.5- d4: d4:7.5+ d4:6 d4:13 g1: g2:m7 c2:7 e2:7 a2:7 f1: bes1: g1:m a1:7 d1: d1:
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
    
    
      \mark \markup{ \right-align \box "VERSE" }
    
	  \comp #16 \break
    
    
	  \comp #16 \break
    
    
	  \comp #12 \break
    
    
      \mark \markup{ \right-align \box "CHORUS" }
    
	  \comp #12 \break
    
    
	  \comp #12 \break
    
    
      \mark \markup{ \right-align \box "BRIDGE" }
    
	  \comp #24 \break
     
	}
}
>>

\version "2.18.2"  % necessary for upgrading to future LilyPond versions.

