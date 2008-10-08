CONFIGURE=	configure
TAR=		test-dept.tar.gz
DIST_TMP_DIR=	test-dept
DIST_FILES=	configure COPYING examples INSTALL install-sh makefile.in README src test

all:	dist

$(CONFIGURE):
	aclocal && autoconf

$(TAR):	$(DIST_TMP_DIR)
	tar cvpf - $^ | gzip >$@

$(DIST_TMP_DIR):	$(DIST_FILES)
	mkdir -p $@ && cp -rp $^ $@ &&\
	find $< -type d -name '.svn' | echo xargs rm -rf

dist:	$(TAR)

clean:
	rm -rf $(DIST_TMP_DIR) $(TAR) $(CONFIGURE) aclocal.m4 autom4te.cache

