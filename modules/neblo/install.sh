#!/bin/bash

# Dotfiles package installer
#
# Authors:
#		Vladimir Perekladov, http://perekladov.ru/
#
# https://github.com/gleero/dotfiles

source "$DOTPATH/inc/modinstall.sh"

if [ "$1" == "postinstall" ]; then
	open Neblo.terminal
fi
