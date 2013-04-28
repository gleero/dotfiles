#!/bin/bash

# Dotfiles package installer
# https://github.com/gleero/dotfiles

# Authors:
#		Vladimir Perekladov, http://perekladov.ru/

source "$DOTPATH/inc/modinstall.sh"

if [ "$1" == "bash_profile" ]; then

	echo "#!/bin/bash"
	echo ''
	echo 'export LC_CTYPE=ru_RU.UTF-8'
	echo 'export LC_ALL=ru_RU.UTF-8'
	echo "export DOTPATH=\"$DOTPATH\""
	echo ''
	echo 'PATH="$PATH:$DOTPATH/bin"'
	echo ''
	echo 'for i in "$DOTPATH/inc/lib*.sh" ; do'
	echo '	source $i'
	echo "done"
	echo ''

fi
