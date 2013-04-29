#!/bin/bash
#
# Установщик dotfiles
#
# Authors:
#		Vladimir Perekladov, http://perekladov.ru/
#

# Зависимостей нет, так что цвета задаём насильно
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
CYAN="$(tput setaf 6)"
GRAY="$(tput setaf 8)"
NOCOLOR="$(tput sgr0)"

INFO="$CYAN[$GRAY INFO $CYAN]:$NOCOLOR"
OK="$CYAN[$GREEN OK $CYAN]:$NOCOLOR"
ERROR="$CYAN[$RED ERROR $CYAN]:$NOCOLOR"
INSTALL="$CYAN[$YELLOW INSTALL $CYAN]:$NOCOLOR"

# Проверяем, под OS X ли мы
if [ `uname` != 'Darwin' ]; then
	echo "$ERROR Установка возможна только под OS X"
	exit 1
fi

# Куда устанавливаем dotfiles
export DOTPATH="~/dotfiles"

# Установка homebrew
if ! command -v git >/dev/null 2>&1; then
	echo "$INSTALL Установка homebrew..."
	ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
	echo "$OK homebrew установлен"
else
	echo "$INFO Обновление homebrew..."
	brew update
	echo "$OK homebrew обновлён"
fi

# Установка Git
if ! command -v git >/dev/null 2>&1; then
	echo "$INSTALL Установка git..."
	brew install git
	echo "$OK git установлен"
else
	echo "$INFO git уже установлен"
fi

# Установка dialog
if ! command -v dialog >/dev/null 2>&1; then
	echo "$INSTALL Установка dialog..."
	brew install dialog
	echo "$OK dialog установлен"
else
	echo "$INFO dialog уже установлен"
fi

# # Устанавливаем dotfiles в $DOTPATH
echo "$INSTALL Распаковка dotfiles в $DOTPATH..."
rm -rf $DOTPATH 2> /dev/null
git clone https://github.com/gleero/dotfiles.git "$DOTPATH"
echo "$OK dotfiles распакован"

cd $DOTPATH

# Ищем пакеты, которые можно поставить
echo "$INFO сбор пакетов для установки..."

if [ ! -d "modules" ]; then
	echo "$ERROR Директория с пакетами \"$DOTPATH/modules\" не найдена"
	exit 1
fi

APP='dialog --title "Установка dotfiles" --checklist "Выберите пакеты, которые необходимо установить:" 0 0 16'

# Генерация списка
for i in $DOTPATH/modules/* ; do
	if [ -f "$i/install.sh" ]; then
		if [ -f "$i/description.txt" ]; then
			APP="$APP \"`basename $i`\" \"`head -n 2 \"$i/description.txt\" | tail -n 1`\" `head -n 1 \"$i/description.txt\"`"
		fi
	fi
done
APP="$APP --stdout"

# Запускаем диалог
data=`eval $APP`

if [ $? -eq 0 ]
then
	clear

	# Проходимся по списку установленного ПО
	data="core $data"

	# Готовим временные файлы
	BASH_PROFILE="/tmp/dotfiles-bash_profile"
	BASH_ALIASES="/tmp/dotfiles-aliases"

	# Список установленных пакетов
	PACKAGES="$DOTPATH/installed-packages"
	echo "" > $PACKAGES


	for choice in $data
	do
		echo "$INSTALL Установка модуля $choice..."
		echo "$choice" >> $PACKAGES
		# Переходим в папку с модулем
		cd "$DOTPATH/modules/$choice"

		# Собираем .bash_profile
		./install.sh bash_profile >> $BASH_PROFILE
		if [ $? -ne 0 ]; then
			echo "$ERROR Ошибка при выполнении './install.sh bash_profile' модуля $choice"
			exit 1
		else
			echo -e "\n" >> $BASH_PROFILE
		fi

		# Собираем алиасы
		./install.sh aliases >> $BASH_ALIASES
		if [ $? -ne 0 ]; then
			echo "$ERROR Ошибка при выполнении './install.sh aliases' модуля $choice"
			exit 1
		else
			echo -e "\n" >> $BASH_ALIASES
		fi

		# Устанавливаем зависимости
		./install.sh dependence
		if [ $? -ne 0 ]; then
			echo "$ERROR Ошибка при выполнении './install.sh dependence' модуля $choice"
			exit 1
		fi

		# Устанавливаем бинарники
		./install.sh bin
		if [ $? -ne 0 ]; then
			echo "$ERROR Ошибка при выполнении './install.sh bin' модуля $choice"
			exit 1
		fi

		# Установочные скрипты
		./install.sh install
		if [ $? -ne 0 ]; then
			echo "$ERROR Ошибка при выполнении './install.sh install' модуля $choice"
			exit 1
		fi

		echo "$OK Модуль $choice установлен"
	done

	#########################
	# Установка
	echo -e "\n" >> $BASH_PROFILE
	echo "" > ~/.bash_profile
	cat "$BASH_ALIASES" >> "$BASH_PROFILE"
	echo -e "for i in "\$DOTPATH/private/*.sh" ; do\nsource \$i\ndone\n" >> "$BASH_PROFILE"
	cat "$BASH_PROFILE" | grep -v '^#' | grep -v '^$' > ~/.bash_profile
	#########################

	# Послеустановочные задания
	for choice in $data
	do
		cd "$DOTPATH/modules/$choice"
		# Послеустановочные скрипты
		./install.sh postinstall
		last=$?
		if [ $last -eq 1 ]; then
			echo "$ERROR Ошибка при выполнении './install.sh postinstall' модуля $choice"
			exit 1
		fi
		if [ $last -eq 2 ]; then
			echo "$OK Для $choice выполнен послеустановочный скрипт"
		fi
		cd ".."
	done

	# Очистка
	rm $BASH_PROFILE
	rm $BASH_ALIASES

	# Создание приватной папки
	if [ ! -e $DOTPATH/private ]; then
		mkdir $DOTPATH/private
	fi

	# Красим её в зеленый цвет
	osascript -e "tell application \"Finder\" to set label index of alias POSIX file (\"$DOTPATH/private\") to 6" > /dev/null

	# Делаем файлы для пользователя
	if [ ! -e $DOTPATH/private/aliases.sh ]; then
		echo -e "# Private Aliases File\n# Can be used for other settings you don’t want to commit\n" > $DOTPATH/private/aliases.sh
	fi
	if [ ! -e $DOTPATH/private/bash_profile.sh ]; then
		echo -e "# Private Bash Profile\n# Can be used for other settings you don’t want to commit\n" > $DOTPATH/private/bash_profile.sh
	fi

	# Создание папки bin/
	if [ ! -e $DOTPATH/bin ]; then
		mkdir $DOTPATH/bin
	fi

	rm $DOTPATH/install.sh

else
	echo "$ERROR Установка прервана"
	exit 1
fi
