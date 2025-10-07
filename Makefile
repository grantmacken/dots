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

# WGET := wget -q --no-check-certificate --timeout=10 --tries=3
# https://docs.rockylinux.org/10/books/nvchad/nerd_fonts/

help: ## show available make targets
	cat $(MAKEFILE_LIST) |
	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
	sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

default: ## install dotfiles (runs init, stow)
	echo '##[ stow dotfiles ]##'
	chmod +x dot-local/bin/* || true
	stow --verbose --dotfiles --target ~/ .
	echo '✅ completed task'

delete: ## delete stow dotfiles
	echo '##[ $@ ]##'
	stow --verbose --dotfiles --delete --target ~/ .
	echo '✅ completed task'

init:
	echo '##[ $@ ]##'
	mkdir -p $(BIN_HOME)
	mkdir -p $(CACHE_HOME)/nvim
	mkdir -p $(STATE_HOME)/nvim
	mkdir -p -v $(DATA_HOME)/nvim/lists
	mkdir -p -v $(DATA_HOME)/nvim/luals/{logs,meta}
	mkdir -p files latest dot-local/bin  dot-config dot-bashrc.d
	chmod +x dot-local/bin/* &>/dev/null || true

clean_nvim:
	rm -rf $(CACHE_HOME)/nvim
	rm -rf $(STATE_HOME)/nvim
	rm -rf $(DATA_HOME)/nvim
	rm -rf $(CONFIG_HOME)/nvim
	$(MAKE)

ai:
	# uv a python package manager
	uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

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
	systemctl --no-pager --user status bu_projects.service

tbx_enable: ## enable and start tbx-reset systemd timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user daemon-reload
	systemctl --no-pager --user enable --now tbx-reset.timer
	systemctl --no-pager --user status tbx-reset.timer
	echo '✅ tbx-reset timer enabled and started'

tbx_disable: ## disable and stop tbx-reset systemd timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user disable --now tbx-reset.timer
	echo '✅ tbx-reset timer disabled and stopped'

tbx_status: ## check tbx-reset timer and services status
	echo '##[ $@ ]##'
	systemctl --no-pager --user status tbx-reset.timer || true
	systemctl --no-pager --user list-timers tbx-reset.timer
	echo ''
	systemctl --no-pager --user status tbx-reset.service || true
	echo ''
	systemctl --no-pager --user status pty_conf.service || true

tbx_test: ## manually run tbx-reset and pty_conf services
	echo '##[ $@ ]##'
	systemctl --no-pager --user start pty_conf.service
	systemctl --no-pager --user status tbx-reset.service
	echo ''
	systemctl --no-pager --user status pty_conf.service

.PHONY: copilot
copilot: ## Copilot for the project
	# copilot --help
	## copilot --banner --allow-all-tools --add-dir $(CURDIR)

.PHONY: task
task: ## copilot task for the project
	# Execute a prompt directly
	# copilot -p 'vim plugin resession errors with latest nvim. disable ' --allow-all-tools
	copilot -p 'add commit message for last copilot task' --allow-all-tools
	## copilot task --add-dir $(CURDIR)

.PHONY: commit
commit: ## as copilot to add commit message
	copilot -p 'add commit message since last commit' --allow-all-tools --add-dir $(CURDIR)
	# ask if want to push the commit
	read -p "Do you want to push the commit? (y/n): "
	if [[ $$REPLY =~ ^[Yy]$$ ]]
	then git push
	else echo "Commit not pushed." 
	fi
	## copilot task --add-dir $(CURDIR)
