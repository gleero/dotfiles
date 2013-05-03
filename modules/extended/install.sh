#!/bin/bash

# Dotfiles package installer

# Authors:
#		Vladimir Perekladov, http://perekladov.ru/

# https://github.com/gleero/dotfiles

DEPENDENCES="phantomjs"

source "$DOTPATH/inc/modinstall.sh"

if [ "$1" == "install" ]; then
	brew install node
	npm install -g JSONSelect
fi

if [ "$1" == "uninstall" ]; then
	npm remove -g JSONSelect
fi