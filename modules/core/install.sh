#!/bin/bash

# Dotfiles package installer
# https://github.com/gleero/dotfiles

# Authors:
#		Vladimir Perekladov, http://perekladov.ru/

source "$DOTPATH/inc/modinstall.sh"

if [ "$1" == "bash_profile" ]; then
cat <<_EOF_
#!/bin/bash

export LC_CTYPE=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8

export DOTPATH="$DOTPATH"
PATH="\$PATH:\$DOTPATH/bin"

for i in \$DOTPATH/inc/lib*.sh ; do
	source \$i
done

for i in \$DOTPATH/private/*.sh ; do
	source \$i
done

[ -d /usr/local/share/python ] && PATH="\$PATH:/usr/local/share/python"
[ -d /usr/local/share/npm/bin ] && PATH="\$PATH:/usr/local/share/npm/bin"
which npm > /dev/null && NODE_PATH="/usr/local/share/npm/lib/node_modules"
[ -d /usr/local/opt/ruby/bin ] && PATH="\$PATH:/usr/local/opt/ruby/bin"
PATH="\$PATH:\$(brew --prefix coreutils)/libexec/gnubin"

export PATH
export NODE_PATH

_EOF_
fi

if [ "$1" == "install" ]; then
cat > ~/.bashrc <<_EOF_
if [ -e ~/.bash_profile ]; then
	source ~/.bash_profile
fi
_EOF_
fi
