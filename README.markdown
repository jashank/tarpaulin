Typeset all those delicious Rust docs.

Huge props to everyone who's contributed to the body of _over five
hundred pages_ of excellent documentation for Rust.  You all rock!

### Assorted style notes

- The styles I've built try to emulate `rustbook`/`rustdoc` (Fira
Sans, Source Serif Pro/Heuristica, Source Code Pro) but do fall short
in a few places (see below).

- The styles are also focussed on producing a dead-tree format book.
For that reason, content structure decisions like the calculation of
hierarchy by parts/chapters/sections are made how they are.  I also
like the idea of a dead-tree Rust book that mostly stands alone and
acts as both tutorial and reference separately. 

- The size of each PDF page is A4 (ISO paper forever!), but the
cam/crop marks take it down to 230x180mm, the paperback size for a
Certain Large Technical Publishing House.

### Build it!

- Have an up-to-date-ish TeX installation.  Easy way out: install
TeX Live (i believe v2013 is the earliest working version and you
almost certainly want something more recent; I use v2014) which gets
you all the dependencies, including LuaLaTeX, fontspec, geometry,
hyperref, etc.

- Have an up-to-date-ish Pandoc. Who doesn't love Pandoc?

- Have a Rust source tree in `../rust` relative to this checkout.  It
needs to be newer than rust-lang/rust@024aa9a345

- `(cd fonts && make)` to download OpenType versions of Fira Sans,
  Source Serif Pro, Heuristica, and Source Code Pro from your local
  CTAN mirror.

- `zsh build.sh` (which may also work with bash but I haven't tested
this) which grabs `../rust/src/doc`, and processes `book`, `nomicon`,
and `grammar` and `reference` into TeX.

- `(cd tex && make)` to ACTUALLY DO THE THING

### Remaining Work

- Get TeX's grubby fingers off the quotes. grr.

- Process out rustdoc's `//#` syntax.

- Mangle the document references, which, while all self-complete
(currently excepting the library stuff) don't work; not entirely sure
how to tackle this one. 

- Wrangle some of the line lengths in the code samples (thankfully
scaling ttfamily to 0.857142 was enough to get from ~60 to ~72
characters per line, which is just enough to lower the _screaming_
about overfull hboxes to a mere wailing)

- Tangle syntax highlighting back in.  pandoc's highlighting engine
doesn't work with my approach; one of the LaTeX ones might, though.

- Fandangle up a tool that typesets crate documentation into something
acceptable for a book.  I think this means I have to take `rustdoc`'s
JSON output and somehow coerce that to LaTeX. 

Note that the Rust logo, a trademark of the Mozilla Foundation,
appears here without official permission.  Nobody has yet C&D'd at me,
and my reading of the legal stuff suggests it's _probably_ okay.  The
typeset result is not attempting to dilute either the wordmark or the
logo's value.
