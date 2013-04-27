#!/bin/bash

# Dotfiles package installer

# Authors:
#		Original nanorc https://github.com/craigbarnes/nanorc
#		Vladimir Perekladov, http://perekladov.ru/

# https://github.com/gleero/dotfiles

source "$DOTPATH/inc/modinstall.sh"

if [ "$1" == "install" ]; then
	if [ -d "nanorc" ]; then
		RCFOLDER="nanorc/*.nanorc"
		if [ -f ~/.nanorc ]; then
			if [ ! -f backup_nanorc ]; then
				cat ~/.nanorc > backup_nanorc
			fi
		fi
		echo "" > ~/.nanorc
		for f in $RCFOLDER
		do
			fdl="`pwd`/$f"
			echo "include $fdl" >> ~/.nanorc
		done
		CNT=`ls $RCFOLDER | wc -l | sed 's/ //g'`
		echoerr "$INFO Для nano установлено $CNT тем подсветок синтаксиса"
	else
		echoerr "$ERROR Папка 'nanorc' не найдена"
		exit 1
	fi
	exit 0
fi

if [ "$1" == "uninstall" ]; then
	if [ -f backup_nanorc ]; then
		cat backup_nanorc > ~/.nanorc
		rm backup_nanorc
	else
		rm ~/.nanorc
	fi
fi
