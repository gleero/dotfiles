# Что это?

Набор полезных вещей для терминала.

[http://gleero.com/all/dotfiles/](http://gleero.com/all/dotfiles/)

# Установка

**Работает пока только для OS X!**

Базовая установка распакует в `~/dotfiles/` дистрибутив и запустит конфигуратор, в котором можно выбрать перечень модулей для установки.

Наберите в терминале:

```bash
curl dotfiles.gleero.com | bash
```

**ВНИМАНИЕ!** После установки не редактируйте файл `~/.bash_profile`. Он генерируется автоматически и все отредактированные данные могут быть потеряны при обновлении.

Свои изменения нужно добавлять в `private/bash_profile.sh` либо `private/aliases.sh`. А можно написать модуль.

# Модули

Dotfiles делится на модули. Один модуль — одна логическая задача. Задача может содержать программы, зависимости, куски bash_profile, алиасы, кастромный код.

## Устройство модуля

Модуль — папка, по-умолчанию расположенная в `~/dotfiles/modules/`. Обязательными атрибутами модуля являются файлы `install.sh` и `description.txt`.

### install.sh

Основной установочный скрипт. Вызывается несколько раз с определенным таском (о них ниже) и всегда из корневой папки модуля.

### description.txt

Текстовый файл с описанием пакета. Состоит из двух строк. Первая — `ON` либо `OFF`. Если включено, то в установщике галочка напротив данного пакета будет стоять по-умолчанию.
Вторая строка — краткое описание пакета.

## Таски

Таск — это параметр, с которым установщик запускает install.sh модуля.
Если таск возвращает `exitcode: 1`, то инсталлятор прерывает свою работу.

Перечень доступных тасков:

### bash_profile

Возвращает в `stdout` часть профиля, который после установки добавится в `~/.bash_profile`.
Как правило считывает файл `bash_profile.txt`, который находится рядом.

Запрос:

```bash
./install.sh bash_profile
```

Пример файла `bash_profile.txt`, разукрашивающий вывод команды `ls`:

```bash
# Разукрашиваем ls
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
```

### aliases

Возвращает в `stdout` перечень алиасов, которые будут установлены.
Как правило считывает файл `aliases.txt`, который находится рядом.

Запрос:

```bash
./install.sh aliases
```

Пример файла `aliases.txt` с несколькими алиасами для `ls`:

```bash
alias ls='ls -GFh'
alias ll='ls -l'
alias la="ls -a"
```

### dependence

Устанавливает зависимости, которые требуются для работы модуля. Модули устанавливаются через `homebrew`.

Запрос:

```bash
./install.sh dependence
```

### bin

Копирует все бинарники из пакета в папку `~/dotfiles/bin/`, после чего они становятся доступны из консоли.

Запрос:

```bash
./install.sh bin
```

### install

Кастомный пользовательский скрипт, который производит нестандартную установку.

Запрос:

```bash
./install.sh install
```

Пример скрипта, добавляющего подсветку синтаксиса для nano:

```bash
if [ "$1" == "install" ]; then
	if [ -d "nanorc" ]; then
		RCFOLDER="nanorc/*.nanorc"
		if [ -f ~/.nanorc ]; then
			cat ~/.nanorc > backup_nanorc
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
```
Хорошим тоном является создать бэкап изменяемых файлов, чтобы при удалении вернуть всё как было.

Соответственно нужно написать таск `uninstall`, который подчистит систему и вернёт всё как было.

### uninstall

Кастомный пользовательский скрипт, который производит удаление после нестандартной установки.

Запрос:

```bash
./install.sh uninstall
```

Пример скрипта, удаляющего подсветку синтаксиса nano, добавляемую в предыдущем таске:

```bash
if [ "$1" == "uninstall" ]; then
	if [ -f backup_nanorc ]; then
		cat backup_nanorc > ~/.nanorc
		rm backup_nanorc
	else
		rm ~/.nanorc
	fi
fi
```

### postinstall

Кастомный пользовательский скрипт, выполняющийся после установки пакета.

Успешно выполненный послеустановочный скрипт обязан вернуть `exitcode: 2`.

Запрос:

```bash
./install.sh postinstall
```

Пример скрипта, дублирующего сгенерированный `bash_profile` для пользователя `root`:

```bash
if [ "$1" == "postinstall" ]; then
	sudo cp ~/.bash_profile /var/root/.bash_profile
	exit 2
fi
```

## Создание модуля

Для того, чтобы создать модуль, нужно выполнить `dfmod init`.

```bash
cd ~/dotfiles/modules
dfmod init test
```

Будет создан модуль с названием `test` и заготовкой.

### Общее

Если хотите чтобы пакет добавлял что-нибудь в .bash_profile, создайте рядом файл bash_profile.txt с нужным вам содержимым.

Соответственно чтобы добавить свои алиасы, положите их в файл aliases.txt.

Если ваши ништяки зависят от внешних программ или библиотек, раскоментируйте сточку DEPENDENCES и добавьте через пробел нужные вам пакеты.

Пакеты будут установлены через homebrew.

`DEPENDENCES="node mongodb"`

Для установки скриптов, приложений и бинарников, поместите их в папку `bin/` рядом со скриптом `install.sh`. Если устанавливаить нечего - папку можно удалить.

### Свои скрипты

Слать сообщения пользователю нужно командой

`echoerr "Сообщение"`

Можно  использовать `$OK`, `$INSTALL`, `$INFO` и `$ERROR` в начале сообщения, чтобы выводить красивый заголовок.

Если вы хотите произвести нестандартное действие, лучше всего воспользоваться таском `install`.

Хорошим тоном является создать бэкап изменяемых файлов, чтобы при удалении вернуть всё как было. Также нужно написать таск `uninstall`, который подчистит систему и вернёт всё как было.

При ошибке обязательно нужно выйти с помощью "exit 1".

Переменная `$DOTPATH` содержит путь к корню dotfiles. Не стоит использовать `~/dotfiles/`, так как dotfiles может быть установлена в другое место. Use `$DOTPATH`, Luke!

### Пост-установка

Скрипт пост-установки выполняется в самом конце. Не рекомендуется использовать его без необходимости. Можно использовать, например, чтобы делать что-нибудь  с .bash_profile, который к моменту запуска будет полностью сформирован.

Успешный postinstall должен вернуть код 2.

## Установка отдельного модуля

Если требуется установить отдельный модуль, нужно перейти в папку с модулями и выполнить `dfmod install <МОДУЛЬ>`.

```bash
	cd ~/dotfiles/modules/
	git clone <ЛЮБОЙ_МОДУЛЬ>
	dfmod install <МОДУЛЬ>
```

# Удаление dotfiles

```bash
	dotfiles remove
```

# Обновление dotfiles

```bash
	dotfiles update
```

# Разное

Данный сборник частично основан на [дотфайлсах Артёма Сапегина](https://github.com/sapegin/dotfiles), за что ему большое спасибо.

Большинство модулей основано на:

[https://github.com/mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
[http://brettterpstra.com/2011/10/04/bash-auto-complete-for-running-applications/](http://brettterpstra.com/2011/10/04/bash-auto-complete-for-running-applications/)