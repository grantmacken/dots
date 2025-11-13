SHELL=/usr/bin/bash
.SHELLFLAGS := -euo pipefail -c
# -e Exit immediately if a pipeline fails
# -u Error if there are unset variables and parameters
# -o option-name Set the option corresponding to option-name
.ONESHELL:
.DELETE_ON_ERROR:
.SECONDARY:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent

CONFIG_HOME := $(HOME)/.config
CACHE_HOME  := $(HOME)/.cache
DATA_HOME   := $(HOME)/.local/share
STATE_HOME  := $(HOME)/.local/state
BIN_HOME    := $(HOME)/.local/bin
QUADLET := $(CONFIG_HOME)/containers/systemd
SYSTEMD := $(CONFIG_HOME)/systemd/user
PROJECTS := $(HOME)/Projects

check-toolbox: ## Verify running in tbx-coding toolbox
	dot-local/bin/check-toolbox
	echo '✓ Running in tbx-coding toolbox'

check-tools: ## Verify required CLI tools and versions
	dot-local/bin/check-tools

default: ## install dotfiles (runs init, stow)
	dot-local/bin/check-toolbox
	echo '##[ stow dotfiles ]##'
	chmod +x dot-local/bin/* || true
	stow --verbose --dotfiles --target ~/ .
	echo '✅ completed task'

# help: ## show available make targets
# 	cat $(MAKEFILE_LIST) |
# 	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
# 	sort |
# 	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

# delete: ## delete stow dotfiles
# 	echo '##[ $@ ]##'
# 	stow --verbose --dotfiles --delete --target ~/ .
# 	echo '✅ completed task'

init:
	dot-local/bin/check-toolbox
	echo '##[ $@ ]##'
	mkdir -p $(BIN_HOME)
	mkdir -p $(CACHE_HOME)/nvim
	mkdir -p $(STATE_HOME)/nvim
	mkdir -p -v $(DATA_HOME)/nvim/luals/{logs,meta}
	mkdir -p files latest dot-local/bin dot-config dot-bashrc.d
	chmod +x dot-local/bin/* &>/dev/null || true

reset_nvim:
	dot-local/bin/check-toolbox
	echo '##[ $@ ]##'
	echo '- removing stuff not under stow control...'
	rm -rf $(CACHE_HOME)/nvim
	rm -rf $(STATE_HOME)/nvim
	rm -rf $(DATA_HOME)/nvim
	echo '- removing everything stow control...'
	stow --verbose --dotfiles --delete --target ~/ .
	echo 'bring everything back...'
	$(MAKE)
	##  use nlua script to install plugins
	nvim_plugins
	##  use nlua script to install treesitter parsers and queries
	nvim_treesitter
	echo '✅ completed task'

list-configurables: ## list configurable files in container
	ls /usr/local/bin/

backup_enable: ## enable and start bu_projects systemd timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user daemon-reload
	systemctl --no-pager --user enable --now bu_projects.timer
	systemctl --no-pager --user status bu_projects.timer
	echo '✅ backup timer enabled and started'

backup_disable: ## disable and stop bu_projects systemd timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user disable --now bu_projects.timer
	echo '✅ backup timer disabled and stopped'

backup_status: ## check bu_projects timer and service status
	echo '##[ $@ ]##'
	systemctl --no-pager --user status bu_projects.timer || true
	systemctl --no-pager --user list-timers bu_projects.timer
	echo ''
	systemctl --no-pager --user status bu_projects.service || true

backup_test: ## manually run bu_projects backup service
	echo '##[ $@ ]##'
	systemctl --no-pager --user start bu_projects.service
	systemctl --no-pager --user status bu_projects.service || true

tbx_enable: ## enable and start tbx systemd timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user daemon-reload
	systemctl --no-pager --user enable --now tbx.timer
	systemctl --no-pager --user status tbx.timer
	echo '✅ tbx timer enabled and started'

tbx_disable: ## disable and stop tbx systemd timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user disable --now tbx.timer
	echo '✅ tbx timer disabled and stopped'

tbx_status: ## check tbx timer and service status
	echo '##[ $@ ]##'
	systemctl --no-pager --user status tbx.timer || true
	systemctl --no-pager --user list-timers tbx.timer
	echo ''
	systemctl --no-pager --user status tbx.service || true

tbx_test: ## manually run tbx service
	echo '##[ $@ ]##'
	systemctl --no-pager --user start tbx.service
	systemctl --no-pager --user status tbx.service || true

test: ## run neovim busted tests with nlua
	# echo '##[ $@ ]##'
	pushd dot-config/nvim &>/dev/null
	busted | faucet && echo
	popd &>/dev/null
	echo '✅ busted tests completed'


