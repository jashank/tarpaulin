CLEANABLES =

fonts =

fonts += FiraSans
FiraSans_format = otf
FiraSans_styles = Regular RegularItalic Medium MediumItalic
FiraSans_url = http://mirrors.ctan.org/fonts/fira/opentype

fonts += SourceSerifPro
SourceSerifPro_format = otf
SourceSerifPro_styles = Regular Bold
SourceSerifPro_url = http://mirrors.ctan.org/fonts/sourceserifpro/fonts

# As Source Serif Pro doesn't have a nice italic, use Heuristica instead.
fonts += Heuristica
Heuristica_format = otf
Heuristica_styles = Italic BoldItalic
Heuristica_url = http://mirrors.ctan.org/fonts/heuristica/opentype

fonts += SourceCodePro
SourceCodePro_format = otf
SourceCodePro_styles = Regular
SourceCodePro_url = http://mirrors.ctan.org/fonts/sourcecodepro/fonts

###
# font_fetch_set :: FontName -> [MakeTarget]
define font_fetch_set
CLEANABLES += $$(foreach style,$$(${1}_styles),${1}-$${style}.$$(${1}_format))

$(1)-%.$$(${1}_format)::
	@wget $$(${1}_url)/$$@

$(1):: $$(foreach style,$$(${1}_styles),${1}-$${style}.$$(${1}_format))
	@true
endef

.stamp:: ${fonts}
	@touch .stamp

$(foreach font,${fonts},$(eval $(call font_fetch_set,${font})))

clean:
	@rm -vf ${CLEANABLES}
	@rm -f .stamp
	
