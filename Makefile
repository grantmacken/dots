SHELL=/bin/bash
APP_LIST = git curl stow
assert-command-present = $(if $(shell which $1),,$(error '$1' missing and needed for this build))
$(foreach src,$(APP_LIST),$(call assert-command-present,$(src)))

XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share
XDG_BIN ?= $(HOME)/.local/bin
UP_TARG_DIR := $(abspath ../)
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)


assert-is-root = $(if $(shell id -u | grep -oP '^0$$'),\
 $(info OK! root user, so we can change some system files),\
 $(error changing system files so need to sudo) )

define mkHelp
=========================================================

 `make help`     this
 `make {target}` will use stow to create symlinks
 `make {target}-clean` will use stow to remove symlinks

TARGETS: [ neovim | home | projects ]

setxkbmap -option caps:swapescape

UP DIR: $(UP_TARG_DIR)
=========================================================
endef

.PHONY: home projects

default: help
help: export mkHelp:=$(mkHelp)
help:
	@echo "$${mkHelp}"


.PHONY: neovim
neovim:
	@mkdir -p $(XDG_CACHE_HOME)/nvim
	@mkdir -p $(XDG_CONFIG_HOME)/nvim
	@mkdir -p $(XDG_DATA_HOME)/nvim/site/autoload
	@mkdir -p $(XDG_DATA_HOME)/nvim/site/plugged
	$(if $(wildcard  $(XDG_DATA_HOME)/nvim/site/autoload/plug.vim),,curl -fLo $(XDG_DATA_HOME)/nvim/site/autoload/plug.vim  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim)
	@cd nvim; stow -v --ignore='site' -t $(XDG_CONFIG_HOME)/nvim .
	@cd nvim; stow -v -t $(XDG_DATA_HOME)/nvim/site site


.PHONY: clean-neovim
clean-neovim:
	@echo 'Task: $(notdir $@)'
	@cd nvim; stow -D -v  --ignore='site' -t "$(XDG_CONFIG_HOME)/nvim" .
	@cd nvim; stow -D -v -t "$(XDG_DATA_HOME)/nvim/site" site


.PHONY: configs
configs:
	@echo 'TASK: use stow to create symlinks in home dir'
	@#[ -f ~/.bashrc ] && rm ~/.bashrc
	@#[ -f ~/.gitconfig ] && rm ~/.gitconfig
	$(if $(wildcard  $(XDG_CONFIG_HOME)/bash ),,mkdir -p $(XDG_CONFIG_HOME)/bash)
	@stow -v -t ~ configs
	@source $(HOME)/.bashrc

.PHONY: clean-config
clean-config:
	@echo 'TASK : use stow to remove bash symlinks in home dir'
	@stow -D -v -t ~ configs

.PHONY: projects
projects:
	@echo 'TASK: projects bin and node '
	@mkdir -p projects/bin
	@mkdir -p  ~/.local/bin
	@mkdir -p  ../node_modules/.bin
	@stow -v -t ~/.local/bin bin
	@cd projects;stow -v  -t ../../ .

.PHONY: clean-projects
clean-projects:
	@stow -D -v -t ~/.local/bin bin
	@cd projects;stow -D -v  -t ../../ .

.PHONY: init
init: bin/my-solus-packages.list
	@echo 'TASK: install my solus essentials'
	@mkdir -p  ~/.local/bin
	@#sudo bin/install-solus-packages.sh $<
	@#setxkbmap -option caps:swapescape
	@#git remote add origin git@github.com:grantmacken/dots.git

.PHONY: init-ssh
init-ssh:
	@#gcloud compute config-ssh
	@#ls -al ~/.ssh
	@#1: ssh-keygen -t rsa -b 4096 -C "$(shell git config user.email)"
	@#2: eval "$$(ssh-agent -s)"
	@#3: ssh-add ~/.ssh/id_rsa
	@#4: xclip -sel clip < ~/.ssh/id_rsa.pub
	@#5: verify


.PHONY: snaps
snaps: bin/my-snaps.list
	@echo 'TASK: install snaps'
	@snap install google-cloud-sdk
