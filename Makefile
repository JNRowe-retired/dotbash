# vim: set syntax=make sw=4 sts=4 noet tw=80 fileencoding=utf-8:

DOTFILES := bash_login bash_logout

all:
	$(info Installing this package will overwrite important \
		configuration files in your home directory)

install:
ifneq ($(NOT_A_MORON), true)
	$(error Installing this package can wreck your configuration files)
endif
	for file in $(DOTFILES); do \
		mkdir -p $(DESTDIR)/$(HOME); \
		install -m 644 $$file $(DESTDIR)$(HOME)/.$$file; \
	done
	ln -sf .bash_login $(DESTDIR)$(HOME)/.bashrc

