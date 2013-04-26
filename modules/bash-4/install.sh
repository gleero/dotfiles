#!/bin/bash

# Dotfiles package installer
# https://github.com/gleero/dotfiles

DEPENDENCES="bash"

source "$DOTPATH/inc/modinstall.sh"

if [ "$1" == "install" ]; then
	echoerr "$INFO 'bash-4' требует повышенных привилегий"
	grep -Fxq '/usr/local/bin/bash' /etc/shells || sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
	chsh -s /usr/local/bin/bash $USER
fi

if [ "$1" == "uninstall" ]; then
	chsh -s /bin/bash $USER
	cat /etc/shells | grep -v /usr/local/bin/bash > /tmp/etcshells
	echoerr "$INFO 'bash-4' требует повышенных привилегий"
	sudo mv /tmp/etcshells /etc/shells
fi
