.bash
=====

This is just my bash_ and readline_ configuration files that are shared
between hosts.  Maybe they're useful to you too, or better yet maybe
you'll spot *and* fix a bug!

If you find any problems with the configuration files in this repository
either drop me an email_ or file an issue_.  Locally, bugs are managed
with ditz_, so if you're working with a clone of the repository you can
report, list and fix bugs directly in the repository [#]_.

Installation
------------

Before installing the package you are required to read the ``Makefile``
so that you understand how it could break your current setup.  It will
likely be quite difficult to install the package if you don't read the
``Makefile`` thoroughly, this is on purpose and not a bug that needs
reporting.

History
-------

Initially, a few people at work were talking about all the hacks they
have in their bash_ config files wondering who had the coolest setups
and what they bits they should steal when Rach Holmes decided to mash
all of the together in to a package everyone could use and most
importantly fix bugs in.  Rach maintained this for a few years, and then
changed shells in a fit of heresy.

After a year or two I've decided to start maintaining the package
properly, as I was already adding features and fixing bugs in my own
systems.

.. [#] If you're using Gentoo_ you can find an ebuild for ditz_, in my
       overlay_.

.. _bash: http://www.gnu.org/software/bash/
.. _readline: http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html
.. _email: jnrowe@gmail.com
.. _issue: http://github.com/JNRowe/dotbash/issues
.. _ditz: http://ditz.rubyforge.org/
.. _Gentoo: http://www.gentoo.org/
.. _overlay: http://github.com/JNRowe/misc-overlay/tree

