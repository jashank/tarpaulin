typeset all those delicious Rust docs

huge props to the guys who wrote _over five hundred pages_ of
excellent documentation

- paper size is a4, with cam/crop down to a paperback size for a
Certain Large Technical Publishing House

- the styles try to emulate rustbook/rustdoc (Fira Sans, Source Serif
Pro/Heuristica, Source Code Pro) but fall short in a few places

make it build:

- have an up-to-date-ish TeX installation. LuaLaTeX or XeLaTeX are a
  hard requirement, as are a whole bag of packages. easy way out:
  install TeX Live (i believe v2013 is the earliest working version
  and you almost certainly want something more recent. i use v2014.)

- have an up-to-date-ish Pandoc. who doesn't love Pandoc?

- have a rust source tree in ../rust relative to this checkout

- `(cd fonts && make)` to download OpenType versions of Fira Sans,
  Source Serif Pro, Heuristica, and Source Code Pro from your local
  CTAN mirror.

- `zsh build.sh` (may work with bash but i haven't tested this) which
  grabs ../rust/src/doc, and processes the Book, the Rustonomicon,
  and the grammar and reference (i call this collectively "langref")

- `(cd tex && make)` to ACTUALLY DO THE THING

if you opted to use XeLaTeX, you'll need to edit `tex/project.mk` and
set `ENGINE` to `xe`.

remaining work:

- get TeX's grubby fingers off the quotes. grr.

- process out rustdoc's `//#` syntax

- mangle the document references, which, while all self-complete
  (currently excepting the library stuff) don't work.  not entirely
  sure how to tackle this one. 

- wrangle some of the line lengths in the code samples (thankfully
  scaling ttfamily to 0.857142 was enough to get from ~60 to ~72
  characters per line, which is just enough to stop the _screaming_
  about overfull hboxes)

- tangle syntax highlighting. pandoc's highlighting engine doesn't
  work with my approach; one of the LaTeX ones might, though


- fandangle up a tool that typesets crate documentation into something
  acceptable for a book.  i think this means i have to take rustdoc's
  JSON output and somehow coerce that to LaTeX.

note that the rust logo appears here without proper permission. my
reading of the legal stuff suggests it's _probably_ okay as this is
not attempting to dilute rust or the logo's value.  if it needs to be
taken down, i'm happy to oblige. 
