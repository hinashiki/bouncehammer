# $Id: Makefile.am,v 1.1.2.1 2011/03/09 07:16:49 ak Exp $
# Copyright (C) 2011 Cubicroot Co. Ltd.
# This is the auto-Makefile for bounceHammer/src/lib/Kanadzuchi/Mail/Group/SE,
# is processed by automake to create Makefile.in.

distdir = $(BUILDROOT)/dist/lib/Kanadzuchi/Mail/Group/SE
pkgdatadir = @libdir@/Kanadzuchi/Mail/Group/SE
pkgdata_DATA = Cellphone.pm Smartphone.pm

all-am:
	test -d $(distdir) || mkdir -p $(distdir)
	cp -Rp $(pkgdata_DATA) $(distdir)/

.PHONY: clean
clean:
	rm -f $(distdir)/*.pm

