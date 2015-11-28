#
# NAME
#
#     takemex.mk -- the TakeMeX build system for LaTeX
#
# DESCRIPTION
#
#     TakeMeX is a simple Makefile which does all necessary magic for
#     you to typeset a document with LaTeX.  It is built from scratch,
#     but borrows ideas from systems I've written previously to this
#     sort of heavy lifting, typically in very project-specific ways.
#
#     By default, TakeMeX assumes you want LuaLaTeX outputting to PDF,
#     and when you have bibliographies and/or indices, you use BibTeX
#     and/or MakeIndex.  All these options are intended to be sane
#     defaults and are fully configurable.
#
#     TakeMeX runs with GNU Make and BSD Make (compatible with the
#     "classic" FreeBSD make(1), and sjg's NetBSD make(1)).  You'll
#     need to select the correct file to include, and be mindful of
#     the structure of your `project.mk` file.
#
# EXAMPLE USAGE
#
#     Makefile:
#         .include "project.mk"
#         .include "mk/takemex.bsd.mk"
#
#     project.mk:
#         PROJECT = thesis
#         BIBLIO = yes
#         INDEX = yes
#
#     Or, if you're feeling _really_ experimental:
#         $ make -f mk/takemex.bsd.mk PROJECT=thesis BIBLIO=yes INDEX=yes
#
# OPTIONS
#
#     PROJECT
#         The name of the project; typically the name of the TeX file
#         you are writing (e.g. for 'thesis.tex', the PROJECT Is
#         'thesis')
#
#     INDEX
#         Does this project have an index?
#
#     INDEX_ENG
#         What engine should we use to format the index (of 'makeidx',
#         'xindy'; default 'makeidx').
#
#     BIBLIO
#         Does this project have a bibliography?
#
#     BIBLIO_ENG
#         What engine should we use to format the bibliography (of
#         'bibtex', 'bibtex8', 'bibtexu', 'biblatex', 'biber'; default
#         'bibtex').
#
#     ENGINE
#         What engine should we use (of 'lua', 'xe' and 'pdf')?
#         Default is 'lua'.
#
#     FORMAT
#         What output format should we use (of 'pdf', 'dvi' and 'ps')?
#         Default is 'pdf'.
#
#     SHELLESCAPE
#         Enable `-shell-escape' support.
#
#     FONTSPEC
#         Does this project require the the 'fontspec' package (or
#         other LuaTeX- or XeTeX-specific extensions that won't run
#         without those engines)?  Available options: 'yes' 'maybe'
#         'no'; the 'maybe' option is for gracefully-degrading
#         projects that use (e.g.) 'ifxetex' or 'ifluatex' to provide
#         sanitised output without those engines.
#
#     COUNT
#         Display the project word count at the end of the build?
#
#     DIMENSIONS
#         Log the project word count at the end of the build?
#
# COPYRIGHT
#
#     Copyright (c) 2012-15 Jashank Jeremy <jashank@rulingia.com>.
#
# RCS ID
#
#     $Id: takemex.bsd.mk,v 1.15 2015/11/25 23:34:04 jashank Exp $
#

.if (${PROJECT} == "")
.  error "PROJECT must be defined!"
.endif

_CLEANABLES	= ${PROJECT}.aux ${PROJECT}.log ${PROJECT}.out ${PROJECT}.toc

#
# Format chooser.
#

FORMAT	?= pdf

.if (${FORMAT} == "pdf")
all:: ${PROJECT}.pdf
.elif (${FORMAT} == "dvi")
all:: ${PROJECT}.dvi
.eli:f (${FORMAT} == "ps")
all:: ${PROJECT}.ps
.else
.  error "unrecognised format: ${FORMAT} (known formats: 'pdf' 'dvi' 'ps')"
.endif

ENGINE	?= lua # or 'xe' or 'pdf'

.if (${ENGINE} == "lua")
.  if (${FORMAT} == "dvi")
LATEX		= lualatex --output-format=dvi
.  else
LATEX		= lualatex
.  endif
.elif (${ENGINE} == "xe")
.  if (${FORMAT} == "dvi")
LATEX		= xelatex -no-pdf
.  else
LATEX		= xelatex
.  endif
.elif (${ENGINE} == "pdf")
.  if (${FORMAT} == "dvi")
LATEX		= latex
.  else
LATEX		= pdflatex
.  endif
.else
.  error "unrecognised engine '${ENGINE}' (known engines are: 'lua' 'xe' 'pdf')"
.endif

SHELLESCAPE ?= no
.if ${SHELLESCAPE} == "yes"
LATEX		+= -shell-escape
.endif

FONTSPEC ?= no
# If we aren't using a fontspec-enabled engine, warn about it
.if ${FONTSPEC} == "yes"
.  if (${ENGINE} == "lua") || (${ENGINE} == "xe")
.  else
.    error "no fontspec support, build cannot continue"
.  endif
.elif (${FONTSPEC} == "maybe")
.  if (${ENGINE} == "lua") || (${ENGINE} == "xe")
.  else
.    warning "no fontspec support, expect degraded output"
.  endif
.endif

#
# Indexing support
#
INDEX		?= no
INDEX_ENG	?= makeidx # or xindy

.if ${INDEX} == "yes"
.  if ${INDEX_ENG} == "makeidx"
INDEX_CMD	= makeindex ${PROJECT}
.  elif ${INDEX_ENG} == "xindy"
INDEX_CMD	= texindy ${PROJECT}
.  else
.    error "unrecognised index engine: ${INDEX_ENG} (known index engines are 'makeidx' 'xindy')"
.  endif

_CLEANABLES	+= ${PROJECT}.idx ${PROJECT}.ilg ${PROJECT}.ind
.else
INDEX_CMD	= true
.endif

#
# Bibliography support
#
BIBLIO		?= no
BIBLIO_ENG	?= bibtex # or bibtex8 or bibtexu or biblatex or biber 

.if ${BIBLIO} == "yes"
.  if ${BIBLIO_ENG} == "bibtex"
BIBLIO_CMD	= bibtex ${PROJECT}
.  elif ${BIBLIO_ENG} == "bibtex8"
BIBLIO_CMD	= bibtex8 ${PROJECT}
.  elif ${BIBLIO_ENG} == "bibtexu"
BIBLIO_CMD	= bibtexu ${PROJECT}
.  elif ${BIBLIO_ENG} == "biblatex"
BIBLIO_CMD	= biblatex ${PROJECT}
.  elif ${BIBLIO_ENG} == "biber"
BIBLIO_CMD	= biber ${PROJECT}
.  else
.    error "unrecognised biblio engine: ${BIBLIO_ENG} (known biblio engines are 'bibtex' 'bibtex8' 'bibtexu' 'biblatex' 'biber')"
.  endif

_CLEANABLES	+= ${PROJECT}.bbl ${PROJECT}.blg
.else
BIBLIO_CMD	= true
.endif

PDFTOPS_ENG	?= poppler # (or 'gs')
.if ${PDFTOPS_ENG} == "poppler"
PDFTOPS	= pdftops
.elif ${PDFTOPS_ENG} == "gs"
PDFTOPS	= pdf2ps
.else
.  error "unrecognised PDF->PS engine: ${PDFTOPS_ENG} (known PDF->PS engines are 'poppler' 'gs')"
.endif

TEXCOUNT	?= texcount
.if ${COUNT} == "yes"
COUNTWORDS_CMD	= ${TEXCOUNT} -brief -total -inc ${PROJECT}.tex
.else
COUNTWORDS_CMD	= true
.endif

.if ${DIMENSIONS} == "yes"
DIMENSIONS_CMD	= (echo `date +%s` `texcount -total -brief -quiet ${PROJECT}.tex 2>/dev/null | head -n 1 | sed -e 's/\+/ /g;s/(//g;s/)//g;s/\// /g;s/ Total//'`)
.else
DIMENSIONS_CMD	= true
.endif

${PROJECT}.pdf ${PROJECT}.dvi:: ${PROJECT}.tex ${ADDITIONAL}
	${LATEX} ${PROJECT} && \
		${INDEX_CMD} && \
		${BIBLIO_CMD} && \
	${LATEX} ${PROJECT} && \
	${LATEX} ${PROJECT}
	@${COUNTWORDS_CMD}
	@${DIMENSIONS_CMD} >> ${PROJECT}.dimensions

${PROJECT}.ps:: ${PROJECT}.pdf
	${PDFTOPS} ${PROJECT}.pdf ${PROJECT}.ps

clean::
	-rm -f ${_CLEANABLES}

tidy::
	-rm -f ${PROJECT}.pdf
	-rm -f ${PROJECT}.dvi
	-rm -f ${PROJECT}.ps

debug::
	@echo "ENGINE=${ENGINE} FORMAT=${FORMAT} FONTSPEC=${FONTSPEC} => LATEX=${LATEX}"
	@echo "PDFTOPS_ENG=${PDFTOPS_ENG} => PDFTOPS=${PDFTOPS}"
	@echo "BIBLIO=${BIBLIO} BIBLIO_ENG=${BIBLIO_ENG} => BIBLIO_CMD=${BIBLIO_CMD}"
	@echo "INDEX=${INDEX} INDEX_ENG=${INDEX_ENG} => INDEX_CMD=${INDEX_CMD}"
