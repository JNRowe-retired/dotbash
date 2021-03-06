# vim: set syntax=make sw=4 sts=4 noet tw=80 fileencoding=utf-8:

SHELL := bash
INSTALL := $(shell type -P ginstall >/dev/null && echo ginstall || echo install)
INSTALL_DIR := $(INSTALL) -d
INSTALL_DATA := $(INSTALL) -m 644 -p

ifeq (, $(wildcard .git))
	VERSION := $(shell cat .version)
else
	VERSION := $(shell git describe)
endif
VERSION_MAJ := $(word 1, $(subst ., , $(VERSION)))
VERSION_MIN := $(word 2, $(subst ., , $(VERSION)))
VERSION_MIC := $(word 1, $(subst -, ,$(word 3, $(subst ., , $(VERSION)))))
EDITS := $(word 2, $(subst -, ,$(VERSION)))
ifeq (, $(EDITS))
VERSION := $(VERSION_MAJ).$(VERSION_MIN).$(VERSION_MIC)
else
VERSION := $(VERSION_MAJ).$(VERSION_MIN).$(VERSION_MIC)-$(EDITS)
endif

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
	$(INSTALL_DIR) $(DESTDIR)/$(HOME); \
	for file in $(DOTFILES); do \
		$(INSTALL_DATA) $$file $(DESTDIR)$(HOME)/.`basename $$file`; \
	done
	ln -sf .bash_login $(DESTDIR)$(HOME)/.bashrc
	$(INSTALL_DIR) $(DESTDIR)$(HOME)/.bash; \
	for file in $(BASHFILES) $(RLFILES); do \
		$(INSTALL_DATA) $$file $(DESTDIR)$(HOME)/.bash/`basename $$file`; \
	done
	$(INSTALL_DIR) $(DESTDIR)$(HOME)/.bash_completion.d; \
	for file in $(COMPFILES); do \
		$(INSTALL_DATA) $$file \
			$(DESTDIR)$(HOME)/.bash_completion.d/`basename $$file`; \
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
	$(INSTALL_DIR) $(DISTNAME)/bash{,_completion.d}; \
	$(INSTALL_DATA) $(DOTFILES) COPYING Makefile README.rst ChangeLog TODO $(DISTNAME); \
	$(INSTALL_DATA) $(BASHFILES) $(RLFILES) $(DISTNAME)/bash; \
	$(INSTALL_DATA) $(COMPFILES) $(DISTNAME)/bash_completion.d; \
	git describe >$(DISTNAME)/.version; \
	tar cjfv $(DISTNAME).tar.bz2 \
		`find $(DISTNAME) -not -type d | sort`; \
	rm -rf $(DISTNAME)

