# vim: set syntax=make sw=4 sts=4 noet tw=80 fileencoding=utf-8:

SHELL := bash

DOTFILES := bash_login bash_logout
BASHFILES := alias envvar envvar-int functions lib
RLFILES := inputrc

all:
	$(info Installing this package will overwrite important \
		configuration files in your home directory)

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
		install -m 644 bash/$$file $(DESTDIR)$(HOME)/.bash/$$file; \
	done

