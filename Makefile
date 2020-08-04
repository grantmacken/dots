SHELL=/bin/bash
.ONESHELL:
#.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
###################################

APP_LIST = git curl stow
assert-command-present = $(if $(shell which $1),,$(error '$1' missing and needed for this build))
$(foreach src,$(APP_LIST),$(call assert-command-present,$(src)))

XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share
XDG_BIN ?= $(HOME)/.local/bin
UP_TARG_DIR := $(abspath ../)
EMPTY := SPACE := $(EMPTY) $(EMPTY)

assert-is-root = $(if $(shell id -u | grep -oP '^0$$'),\
 $(info OK! root user, so we can change some system files),\
 $(error changing system files so need to sudo) )




# .PHONY: lua-cjson
# lua-cjson:
# 	@#cd ../../ && git clone git@github.com:openresty/lua-cjson.git
# 	@#cd ../../lua-cjson && make
# 	@# cd ../../lua-cjson && git pull
# 	@#cd ../../nvimpager && sudo $(MAKE)
# 	@#cd /usr/local/bin; stow -v -t $(XDG_BIN) .

.PHONY: configs
configs:
	@echo 'TASK: use stow to create symlinks in home dir'
	@export CWD=$(CURDIR)
	@#[ -f ~/.bashrc ] && rm ~/.bashrc
	@#[ -f ~/.gitconfig ] && rm ~/.gitconfig
	$(if $(wildcard  $(XDG_CONFIG_HOME)/bash ),,mkdir -p $(XDG_CONFIG_HOME)/bash)
	@stow -v -t ~ configs
	@source $(HOME)/.bashrc
	pushd configs/.config &>/dev/null
	@stow -v -t $(CURDIR) .
	popd &>/dev/null

.PHONY: clean-config
clean-config:
	@echo 'TASK : use stow to remove bash symlinks in home dir'
	@stow -D -v -t ~ configs

update: update-neovim gh-update

define mkHelp
=========================================================
 `make configs` will use stow to create symlinks
                default target so just `make` is ok
 `make configs-clean` will use stow to remove symlinks
 `make help`    this
 `make update` update programs

=========================================================
endef


default: help
help: export mkHelp:=$(mkHelp)
help:
	@echo "$${mkHelp}"





.PHONY: ignore-syms
ignore-syms:
	find . -type l >> .gitignore

.PHONY: update-node
:update-node
	pushd ../
	npm install
	npm update
	popd


.PHONY: fzf
fzf:
	@pushd $(PROJECTS)/fzf &>/dev/null
	#git clone git@github.com:junegunn/fzf.git
	git pull
	./install --all --xdg
	@popd &>/dev/null
	@#cd $(XDG_CACHE_HOME)/nvim/fzf/bin && ls -al .
	@#cd $(XDG_CACHE_HOME)/nvim/fzf/bin && stow -v -t $(XDG_BIN) .

.PHONY: go-cli
go-cli:
	@go get github.com/jesseduffield/lazygit
	@go get github.com/jesseduffield/lazydocker
	@cd $(GOPATH)/bin && stow -v -t $(XDG_BIN) .

.PHONY: linters
linters:
	@docker pull hadolint/hadolint:latest-alpine
	@#pip install --user yamllint
	@# pip3 install --user vint
	@#pip install --user vint --upgrade
	@#go get github.com/mrtazz/checkmake
	@#cd $(GOPATH)/src/github.com/mrtazz/checkmake && make
	@#cd $(GOPATH)/bin && stow -v -t $(XDG_BIN) .

.PHONY: nvimpager-update
nvimpager-update:
	@cd ../../nvimpager && git pull
	@cd ../../nvimpager && sudo $(MAKE)
	@cd /usr/local/bin; stow -v -t $(XDG_BIN) .

.PHONY: neovim-remote
neovim-remote:
	@#pip3 install --user neovim-remote
	@pip3 show neovim-remote
	@pip3 install --user --upgrade --no-python-version-warning neovim-remote
	@#cd /usr/local/bin; stow -v -t $(XDG_BIN) .
	@# force git to use $VISUAL
	@# see aliasesAndExports
	@git config --local --unset  core.editor
	@git config --global --unset  core.editor

.PHONY: gh-update
gh-update:
	@pushd ../../gh-cli
	@#git clone https://github.com/cli/cli.git gh-cli
	if git pull | grep 'Already up to date' 
	then
	echo ' - already up to date'
	else
	echo ' - update gh'
	make
	fi
	@pushd bin && stow -v -t $(XDG_BIN) . && popd
	@popd

.PHONY: update-neovim
update-neovim:
	@echo '## $@ ##'
	@mkdir -p $(XDG_CACHE_HOME)/nvim
	@mkdir -p $(XDG_CONFIG_HOME)/nvim
	@mkdir -p $(XDG_DATA_HOME)/nvim/site
	@pushd ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
	git pull
	popd
	@echo 'download latest neovim release'
	@curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz |
	tar xz  -C $(HOME)/.local/
	@echo 'make nvim exectable an link to local bin'
	@chmod +x $(HOME)/.local/nvim-linux64/bin/nvim
	@pushd $(HOME)/.local/bin
	@ln -sf ../nvim-linux64/bin/nvim
	@popd

.PHONY: projects
projects:
	@echo 'TASK: projects bin and node '
	@mkdir -p projects/bin
	@mkdir -p  ~/.local/bin
	@mkdir -p ../node_modules/.bin
	@stow -v -t ~/.local/bin bin
	@cd projects;stow -v  -t ../../ .

.PHONY: clean-projects
clean-projects:
	@stow -D -v -t ~/.local/bin bin
	@cd projects;stow -D -v  -t ../../ .

.PHONY: solus
solus: bin/my-solus-packages.list
	@echo 'TASK: install my solus essentials'
	@#mkdir -p  ~/.local/bin
	@sudo bin/install-solus-packages.sh $<
	@sudo eopkg up
	@setxkbmap -option caps:swapescape
	@#git remote add origin git@github.com:grantmacken/dots.git

.PHONY: solus-build-essentials
solus-build-essentials:
	@echo 'TASK: install system.devel component for compiling'
	@#sudo eopkg install -c system.devel
	@sudo eopkg install ninja libtool unzip
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
	@echo https://docs.snapcraft.io/getting-started
	@#snap install google-cloud-sdk
	@snap install --channel=edge travis
	@travis login --github-token $(shell cat ../.github-access-token)

.PHONY: fonts
fonts:
	@pushd ~/.local/share/fonts
	ls .
	@fc-list : family spacing outline scalable |
	grep -e spacing=100 -e spacing=90 | 
	grep -e outline=True | 
	grep -e scalable=True | sort
	#fc-cache -r
	@popd



