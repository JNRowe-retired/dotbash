# ~/.bash_logout
# vim: set syntax=sh filetype=sh sw=4 sts=4 et tw=80 fileencoding=utf-8:

# When exiting the console clear the screen and flip TTYs to clear the
# scrollback buffer.
if [ -z "${TTY/\/dev\/tty[0-9]}" ]
then
	cur=${TTY:8}
	clear
	chvt 63
	chvt ${cur}
fi

