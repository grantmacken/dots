SHELL=/bin/bash
.ONESHELL:
#.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

XDG_CACHE_HOME := ~/.cache
XDG_CONFIG_HOME := ~/.config
XDG_DATA_HOME := ~/.local/share
XDG_BIN := $(HOME)/.local/bin
UP_TARG_DIR := $(abspath ../)
HOME_BACKUP_DIR := /old_home/gmack

.PHONY: configs
configs:
	@echo 'TASK: use stow to create symlinks in home dir'
	if ! [ -L ~/.bashrc ] 
	then
	rm -fv ~/.bashrc
	fi
	$(if $(wildcard  $(XDG_CONFIG_HOME)/bash ),,mkdir -p $(XDG_CONFIG_HOME)/bash)
	@stow -v -t ~ configs

.PHONY: clean-config
clean-config:
	@echo 'TASK : use stow to remove bash symlinks in home dir'
	@stow -D -v -t ~ configs

.PHONY: home-backup-restore
home-backup-restore:
	@echo 'TASK: cp ssh dir'
	@#cp -rv $(HOME_BACKUP_DIR)/.ssh $(HOME)/
	@cp -rv $(HOME_BACKUP_DIR)/.docker $(HOME)/
	@#ls -alr $(HOME)/.ssh
	@#echo 'TASK/: XDG config dir'
	@#cp -rv $(HOME_BACKUP_DIR)/.config/gh $(HOME)/.config/
	@#cp -rv $(HOME_BACKUP_DIR)/.config/gcloud $(HOME)/.config/
	@#echo 'TASK: XDG data dir'
	@#cp -rv $(HOME_BACKUP_DIR)/.local/share/fonts $(HOME)/.local/share/
	@#mkdir -p $(HOME)/.local/bin
	@# gh client https://github.com/cli/cli/releases/latest
	@# https://github.com/cli/cli/releases/download/v0.11.1/gh_0.11.1_linux_amd64.tar.gz
	@#https://github.com/jesseduffield/lazygit/releases/latest
	@#cp -v $(HOME_BACKUP_DIR)/.local/bin/{tree-sitter,silicon} $(HOME)/.local/bin/

update:  gh neovim

default: help
help: export mkHelp:=$(mkHelp)
help:
	@echo "$${mkHelp}"

.PHONY: ignore-syms
ignore-syms:
	find . -type l >> .gitignore

.PHONY: rustup
rustup:
	@curl https://sh.rustup.rs -sSf | sh
	@#cargo install skim
	@#cd $(HOME)/.cargo/bin && stow -v -t $(XDG_BIN) .

.PHONY: neovim
neovim:
	@mkdir -p	$(HOME)/.local/nvim-linux64
	@pushd $(HOME)/.local
	@wget  --progress=bar:force:noscroll https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
	@tar -C $(HOME)/.local/ -xf ./nvim-linux64.tar.gz
	@rm nvim-linux64.tar.gz
	@pushd $(HOME)/.local/nvim-linux64/bin && stow -v -t $(XDG_BIN) . && popd
	@popd

.PHONY: ledger
ledger:
	@if [ -d $(HOME)/projects/ledger ]
	then
	pushd	$(HOME)/projects/ledger
	git pull
	./acprep update
	popd
	else
	pushd $(HOME)/projects
	gh repo clone ledger/ledger
	pushd ledger
	./acprep dependencies
	./acprep update
	sudo make install
	popd
	popd
	fi

.PHONY: go-cli
go-cli:
	@go get github.com/jesseduffield/lazygit
	@go get github.com/jesseduffield/lazydocker
	@cd $(GOPATH)/bin && stow -v -t $(XDG_BIN) .

.PHONY: linters
linters:
	@#docker pull hadolint/hadolint:latest-alpine
	@pip3 install --user yamllint
	@# pip3 install --user vint
	@#pip install --user vint --upgrade
	@#go get github.com/mrtazz/checkmake
	@#cd $(GOPATH)/src/github.com/mrtazz/checkmake && make
	@#cd $(GOPATH)/bin && stow -v -t $(XDG_BIN) .
	@#pip3 install --user ueberzug


.PHONY: formatters
formatters:
	@cargo install stylua

.PHONY: lsp-erlang_ls
lsp-erlang_ls:
	@[ -d ../../erlang_ls ] || pushd ../..; gh repo clone https://github.com/erlang-ls/erlang_ls
	@pushd ../../erlang_ls
	@git pull
	@make
	@pushd _build/default/bin; stow -v -t $(XDG_BIN) . && popd
	@pushd _build/dap/bin; stow -v -t $(XDG_BIN) . && popd
	@popd

.PHONY: lsp-sumneko
lsp-sumneko:
	@#pushd ../../lua-language-server
	@#gh repo clone https://github.com/sumneko/lua-language-server
	@#git submodule update --init --recursive
	@#cd 3rd/luamake
	@#compile/install.sh
	@#cd ../..
	@#./3rd/luamake/luamake rebuild
	@#popd

.PHONY: lsp
lsp:
	@#which vscode-json-languageserver 2>/dev/null || yarn remove vscode-json-languageserver
	@#which bash-language-server 2>/dev/null && yarn remove bash-language-server

.PHONY: npm
npm:
	@# nvim now installed as a snap
	@# set up global dir 
	@mkdir -p $(HOME)/.local/npm 
	@npm config get prefix | grep -q '$(HOME)/.local/npm' || \
 npm config set prefix $(HOME)/.local/npm 
	@#npm install -g neovim
	@npm outdated -g --depth=0
	@#cd $(HOME)/.local/npm/bin; stow -v -t $(XDG_BIN) 


.PHONY: nvimpager
nvimpager:
	# && gh repo clone lucc/nvimpager 
	@pushd ../nvimpager 
	git pull
	$(MAKE) PREFIX=$(HOME)/.local install
	popd


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

.PHONY: gh
gh:
	@if [ ! -d $(HOME)/projects/gh-cli ] 
	then
	mkdir -p ../../gh-cli
	git clone https://github.com/cli/cli.git ../../gh-cli
	else
	@pushd ../../gh-cli
	@git pull | grep -q 'Already up to date.' || 
	$(MAKE) prefix=$(HOME)/.local install
	popd
	fi

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

.PHONY: packages
packages: bin/my-solus-packages.list
	@echo 'TASK: install my solus essentials'
	@#mkdir -p  ~/.local/bin
	@sudo bin/install-solus-packages.sh $<
	@sudo eopkg up
	@setxkbmap -option caps:swapescape
	@#[ -d ../../rebar3 ] || pushd ../../; gh repo clone https://github.com/erlang/rebar3.git; pushd rebar3 ; ./bootstrap; popd; popd
	@#pushd $(XDG_BIN) && ln -s $(HOME)/projects/rebar3/rebar3 && popd


.PHONY: solus-build-essentials
solus-build-essentials:
	@echo 'TASK: install system.devel component for compiling'
	@sudo eopkg install -c system.devel
	@sudo eopkg install ninja libtool unzip
	@#setxkbmap -option caps:swapescape
	@#git remote add origin git@github.com:grantmacken/dots.git

.PHONY: snaps
snaps: bin/my-snaps.list
	@echo 'TASK: install snaps'
	@echo https://docs.snapcraft.io/getting-started
	@bin/install-snaps.sh $<

.PHONY: gcloud
gcloud:
	@cd $(HOME)/projects
	@#curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-327.0.0-linux-x86_64.tar.gz
	@#tar -zxf google-cloud-sdk-*
	@#cd google-cloud-sdk
	@#./install.sh
	

.PHONY: init-ssh
init-ssh:
	@#gcloud compute config-ssh
	@#ls -al ~/.ssh
	@#1: ssh-keygen -t rsa -b 4096 -C "$(shell git config user.email)"
	@#2: eval "$$(ssh-agent -s)"
	@#3: ssh-add ~/.ssh/id_rsa
	@#4: xclip -sel clip < ~/.ssh/id_rsa.pub
	@#5: verify



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

