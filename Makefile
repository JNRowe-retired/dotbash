# vim: set syntax=make sw=4 sts=4 noet tw=80 fileencoding=utf-8:

SHELL := bash

VERSION := $(shell git tag -l | sort -n)
VERSION_MAJ := $(word 1, $(subst ., , $(VERSION)))
VERSION_MIN := $(word 2, $(subst ., , $(VERSION)))
VERSION_MIC := $(word 3, $(subst ., , $(VERSION)))
EDITS := $(shell [ `git log $(VERSION)..master | wc -l` != 0 ] && echo "+")

DOTFILES := bash_login bash_logout
BASHFILES := alias envvar envvar-int functions lib
RLFILES := inputrc
COMPFILES := func

# Rewrite with locations
BASHFILES := $(addprefix bash/, $(BASHFILES))
RLFILES := $(addprefix bash/, $(RLFILES))
COMPFILES := $(addprefix bash_completion.d/, $(COMPFILES))

DIRT := ChangeLog TODO

.PHONY: ChangeLog _gen_dist clean dist distclean major minor micro patchclean \
	snapshot test

all:
	$(info Installing this package will overwrite important \
		configuration files in your home directory)
	$(info Use `make install' to do a user installation of dotbash $(VERSION))
	$(info Or `make skel-install' to install in to /etc/skel)

install:
ifneq ($(NOT_A_MORON), true)
	$(error Installing this package can wreck your configuration files)
endif
	mkdir -p $(DESTDIR)/$(HOME); \
	for file in $(DOTFILES); do \
		install -m 644 $$file $(DESTDIR)$(HOME)/.$$file; \
	done
	ln -sf .bash_login $(DESTDIR)$(HOME)/.bashrc
	mkdir $(DESTDIR)$(HOME)/.bash; \
	for file in $(BASHFILES) $(RLFILES); do \
		install -m 644 $$file $(DESTDIR)$(HOME)/.bash/$$file; \
	done
	mkdir $(DESTDIR)$(HOME)/.bash_completion.d; \
	for file in $(COMPFILES); do \
		install -m 644 $$file $(DESTDIR)$(HOME)/.bash_completion.d/$$file; \
	done

test: $(DOTFILES) $(BASHFILES) $(COMPFILES)
	for i in $^; do \
		bash -c "source $${i}" >/dev/null 2>&1 \
			|| echo "Syntax error(s) in $${i}"; \
	done

ChangeLog:
	echo "ChangeLog for dotbash v$(VERSION)" >$@; \
	echo >>$@; \
	git log --graph --date=short --stat -- `git ls-files | grep -v ^.be` >>$@

TODO: .be
	echo "Todo list for dotbash" >$@; \
	echo >>$@; \
	be list >>$@

major:
	new_VERSION=$$(($(VERSION_MAJ)+1)).0.0; \
	git tag -s -m"Tagged $$new_VERSION" $$new_VERSION
minor:
	new_VERSION=$(VERSION_MAJ).$$(($(VERSION_MIN)+1)).0; \
	git tag -s -m"Tagged $$new_VERSION" $$new_VERSION
micro:
	new_VERSION=$(VERSION_MAJ).$(VERSION_MIN).$$(($(VERSION_MIC)+1)); \
	git tag -s -m"Tagged $$new_VERSION" $$new_VERSION

clean:
	rm ~*
distclean: clean
	rm $(DIRT)
patchclean:
	find -name *.orig -name *.rej -exec rm {} \;

dist: DISTNAME=dotbash-$(VERSION)
dist: _gen_dist
snapshot: DISTNAME=dotbash-$(shell date -I)
snapshot: _gen_dist
_gen_dist: README.rst ChangeLog TODO $(DOTFILES) $(BASHFILES) $(RLFILES) \
	$(COMPFILES)
	-mkdir -p $(DISTNAME)/bash{,_completion.d}; \
	cp $(DOTFILES) README.rst ChangeLog TODO $(DISTNAME); \
	cp $(BASHFILES) $(RLFILES) $(DISTNAME)/bash; \
	cp $(COMPFILES) $(DISTNAME)/bash_completion.d; \
	tar cjfv $(DISTNAME).tar.bz2 \
		`find $(DISTNAME) -not -type d | sort`; \
	rm -rf $(DISTNAME)

