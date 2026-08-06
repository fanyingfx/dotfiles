DESTDIR ?= /
PREFIX ?= $(DESTDIR)usr/local
EXEC_PREFIX ?= $(PREFIX)
DATAROOTDIR ?= $(PREFIX)/share
BINDIR ?= $(EXEC_PREFIX)/bin
MANDIR ?= $(DATAROOTDIR)/man
MAN1DIR ?= $(MANDIR)/man1

all: ndrop.1

ndrop.1: ndrop.1.scd
	scdoc < $< > $@

install: ndrop.1 ndrop
	@install -v -D -m 0644 ndrop.1 --target-directory "$(MAN1DIR)"
	@install -v -D -m 0755 ndrop --target-directory "$(BINDIR)"

uninstall: 
	rm "$(MAN1DIR)/ndrop.1"
	rm "$(BINDIR)/ndrop"
