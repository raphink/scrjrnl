CTANUPLOAD=ctanupload

CONTRIBUTION  = scrjrnl
VERSION       = v0.1
SUMMARY       = A class to typeset diaries or journals
NAME          = Raphaël Pinson
EMAIL         = raphink@gmail.com
DIRECTORY     = /macros/latex/contrib/$(CONTRIBUTION)
DONOTANNOUNCE = 0
LICENSE       = free
FREEVERSION   = lppl
FILE          = $(CONTRIBUTION).tar.gz

SOURCEFILES   = $(CONTRIBUTION).dtx $(CONTRIBUTION).ins
PKGFILES      = $(CONTRIBUTION).cls
DOCFILES      = $(CONTRIBUTION).pdf example.pdf

TEXINSTALLDIR = /usr/local/texlive/texmf-local

export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION FILE

# default rule
ctanify: $(FILE)

$(FILE): README $(SOURCEFILES) $(DOCFILES) $(PKGFILES)
	ctanify --pkgname $(CONTRIBUTION) $^

%.cls: %.dtx %.ins
	latex $*.ins

%.pdf: %.tex
	lualatex -interaction=batchmode $<
	lualatex -interaction=batchmode $<

$(CONTRIBUTION).pdf:
	lualatex -interaction=batchmode $(CONTRIBUTION).dtx
	makeindex -s gind.ist $(CONTRIBUTION).idx
	makeindex -s gglo.ist -o $(CONTRIBUTION).gls $(CONTRIBUTION).glo
	lualatex -interaction=batchmode $(CONTRIBUTION).dtx

upload: ctanify
	$(CTANUPLOAD) -p

%.tds.zip: %.tar.gz
	tar xzf $< $@

install: $(CONTRIBUTION).tds.zip
	unzip $< -d $(TEXINSTALLDIR)
	mktexlsr

test: $(CONTRIBUTION)-test.pdf

clean:
	rm -f *.aux *.glo *.idx *.log
	rm -f $(DOCFILES) $(PKGFILES)
	rm -f $(FILE)

