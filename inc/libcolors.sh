#!/bin/bash

# Набор обычных цветов
BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"

# Набор ярких цветов
GRAY="$(tput setaf 8)"
HRED="$(tput setaf 9)"
HGREEN="$(tput setaf 10)"
HYELLOW="$(tput setaf 11)"
HBLUE="$(tput setaf 12)"
HMAGENTA="$(tput setaf 13)"
HCYAN="$(tput setaf 14)"
HWHITE="$(tput setaf 15)"

# Жирный
BOLD="$(tput bold)"

# Отключить цвет
NOCOLOR="$(tput sgr0)"

# Красивые инфо-плашки
INFO="$CYAN[$GRAY INFO $CYAN]:$NOCOLOR"
OK="$CYAN[$GREEN OK $CYAN]:$NOCOLOR"
ERROR="$CYAN[$RED ERROR $CYAN]:$NOCOLOR"
INSTALL="$CYAN[$YELLOW INSTALL $CYAN]:$NOCOLOR"
