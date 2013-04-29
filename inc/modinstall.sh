#!/bin/bash
# Установщик модуей

echoerr() { echo "$@" 1>&2; }

for inc in "$DOTPATH/inc/lib*.sh" ; do
	source $inc
done

if [ "$#" -ne "1" ]; then
	echoerr "$ERROR Для того, чтобы установить пакет, выполните \"dfmod install `dirname $0`\""
	exit 1
fi

case "$1" in

	"bash_profile")
		if [ -f "bash_profile.txt" ]; then
			cat "bash_profile.txt"
		fi
		;;

	"aliases")
		if [ -f "aliases.txt" ]; then
			cat "aliases.txt"
		fi
		;;

	"dependence")
		if [ "$DEPENDENCES" != '' ]; then
			for ITEM in $DEPENDENCES; do
				if brew info $ITEM | grep "Not installed" >/dev/null 2>&1; then
					echo "$INSTALL Установка $ITEM..."
					brew install $ITEM
					echo "$OK $ITEM установлен"
				else
					echo "$INFO $ITEM уже установлен"
				fi
			done
		fi
		;;

	"uninstall")
		if [ "$DEPENDENCES" != '' ]; then
			for ITEM in $DEPENDENCES; do
				if ! brew info $ITEM | grep "Not installed" >/dev/null 2>&1; then
					echo "$INSTALL Удаление $ITEM..."
					brew remove $ITEM
					echo "$OK $ITEM удалён"
				else
					echo "$INFO $ITEM уже установлен"
				fi
			done
		fi
		;;

	"bin")
		if [ -d bin ]; then
			cp -r bin/* $DOTPATH/bin/
		fi
		;;
esac
