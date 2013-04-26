#!/bin/bash

# Dotfiles package installer

# Authors:
#	Based on http://blog.ikato.com/post/15675823000/how-to-install-consolas-font-on-mac-os-x
#   Artem Sapegin, https://github.com/sapegin/dotfiles/blob/master/setup/consolas.sh
#   Vladimir Perekladov, http://perekladov.ru/

# https://github.com/gleero/dotfiles

DEPENDENCES="cabextract"

source "$DOTPATH/inc/modinstall.sh"

if [ "$1" == "install" ]; then
	CNT=`find ~/Library/Fonts -iname "consola*" | wc -l | sed "s/ //g"`
	if [ "$CNT" -eq "0" ]; then
		TMPDIR=`mktemp -d /tmp/dotfiles.XXXXXXXX`
		cd $TMPDIR
		curl -O http://download.microsoft.com/download/f/5/a/f5a3df76-d856-4a61-a6bd-722f52a5be26/PowerPointViewer.exe
		cabextract PowerPointViewer.exe
		cabextract ppviewer.cab
		open -W CONSOLA*.TTF
		rm -rf $TMPDIR
	fi
fi

if [ "$1" == "uninstall" ]; then
	find ~/Library/Fonts -iname "consola*" -type f -delete
fi