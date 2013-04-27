#!/bin/bash

# Dotfiles package installer
#
# Authors:
#		Vladimir Perekladov, http://perekladov.ru/
#
# https://github.com/gleero/dotfiles

source "$DOTPATH/inc/modinstall.sh"

if [ "$1" == "postinstall" ]; then
	echoerr "$INFO 'rootbash' требует повышенных привилегий, поэтому сейчас команда 'sudo' запросит ваш пароль"
	sudo cp ~/.bash_profile /var/root/.bash_profile
	if [[ `sudo dscl . -read /Users/root UserShell | grep /bin/sh` ]]
	then
		echo "$INSTALL Меняю шелл рута с /bin/sh на /bin/bash"
		if [ -e /usr/local/bin/bash ]; then
			sudo dscl . -change /Users/root UserShell /bin/sh /usr/local/bin/bash
		else
			sudo dscl . -change /Users/root UserShell /bin/sh /bin/bash
		fi
	fi
	exit 2
fi
