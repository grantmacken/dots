# Dotfiles Management Makefile
# Orchestrates deployment via GNU Stow and systemd unit management
# Must run from repository root inside tbx-coding toolbox (except in GitHub Actions)

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

# XDG Base Directory paths
CONFIG_HOME := $(HOME)/.config
CACHE_HOME  := $(HOME)/.cache
DATA_HOME   := $(HOME)/.local/share
STATE_HOME  := $(HOME)/.local/state
BIN_HOME    := $(HOME)/.local/bin
QUADLET := $(CONFIG_HOME)/containers/systemd
SYSTEMD := $(CONFIG_HOME)/systemd/user
PROJECTS := $(HOME)/Projects

default: ## install dotfiles (runs init, stow)
	# Verify running from correct location and environment
	dot-local/bin/check-repo-root
ifndef GITHUB_ACTIONS
	dot-local/bin/check-toolbox
endif
	echo '##[ stow dotfiles ]##'
	# Ensure all scripts are executable before deployment
	chmod +x dot-local/bin/* || true
	# Deploy using stow --dotfiles (dot-config/ → ~/.config/, etc.)
	stow --verbose --dotfiles --target $${HOME} .
	echo '✅ completed task'
	echo '✓ Running in tbx-coding toolbox'

verify: check-symlinks check-dry-run ## Verify deployment would succeed (dry-run conflict check)
	echo '✅ verification passed - deployment should succeed'

validate-setup: init-validate stow-validate ## Run full workflow validation (init + stow + validations)
	echo '✅ full workflow validation passed'

init-validate: init validate-init

stow-validate: default validate-stow

init: ## create required directories in home
	# Verify running from correct location and environment
	dot-local/bin/check-repo-root
ifndef GITHUB_ACTIONS
	dot-local/bin/check-toolbox
endif
	echo '##[ $@ ]##'
	# Create XDG Base Directory structure
	mkdir -p $(BIN_HOME)
	mkdir -p $(CACHE_HOME)/nvim
	mkdir -p $(STATE_HOME)/nvim
	# Neovim LSP (lua_ls) directories
	mkdir -p -v $(DATA_HOME)/nvim/luals/{logs,meta}
	# Ensure repository structure exists
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

#### Pattern rules for systemd units
# These allow managing any unit: make myunit_enable, make myunit_disable, etc.
# Requires unit files deployed to ~/.config/systemd/user/ via stow

%_enable: ## enable and start systemd timer (e.g., make myunit_enable)
	echo '##[ $@ ]##'
	# Reload systemd to pick up unit file changes
	systemctl --no-pager --user daemon-reload
	# Enable and start timer immediately
	systemctl --no-pager --user enable --now $*.timer
	systemctl --no-pager --user status $*.timer
	echo '✅ $* timer enabled and started'

%_disable: ## disable and stop systemd timer (e.g., make myunit_disable)
	echo '##[ $@ ]##'
	# Disable and stop timer immediately
	systemctl --no-pager --user disable --now $*.timer
	echo '✅ $* timer disabled and stopped'

%_status: ## check systemd timer and service status (e.g., make myunit_status)
	echo '##[ $@ ]##'
	# Show timer status (may not exist, don't fail)
	systemctl --no-pager --user status $*.timer || true
	# Show when timer will next trigger
	systemctl --no-pager --user list-timers $*.timer
	echo ''
	# Show service status (may not have run yet)
	systemctl --no-pager --user status $*.service || true

%_test: ## manually run systemd service (e.g., make myunit_test)
	echo '##[ $@ ]##'
	# Trigger service immediately (bypasses timer)
	systemctl --no-pager --user start $*.service
	systemctl --no-pager --user status $*.service || true

test: ## run neovim busted tests with nlua
	# echo '##[ $@ ]##'
	pushd dot-config/nvim &>/dev/null
	busted | faucet && echo
	popd &>/dev/null
	echo '✅ busted tests completed'

test-workflow: ## trigger GitHub Actions workflow and monitor run
	echo '##[ $@ ]##'
	dot-local/bin/gh-test-workflow
	echo '✅ workflow triggered'

#### Verification tasks

check-tools: ## Verify required CLI tools and versions
	dot-local/bin/check-tools

check-root: ## Verify running in repo root
	dot-local/bin/check-repo-root

check-symlinks: ## Check for broken symlinks
	# Verify systemd/containers dirs have no symlinks (FR-007)
	dot-local/bin/check-no-symlinks dot-config/systemd/user
	dot-local/bin/check-no-symlinks dot-config/containers/systemd

check-dry-run: ## Verify stow dry-run (conflict check)
	# Run stow in simulation mode to detect conflicts before actual deployment
	# Skipped in GitHub Actions to avoid false positives
ifndef GITHUB_ACTIONS
	stow --simulate --verbose --dotfiles --target ~/ .
endif

check-toolbox: ## Verify running in toolbox container
ifndef GITHUB_ACTIONS
	dot-local/bin/check-toolbox
else
	echo 'Skipping toolbox check in GitHub Actions environment'
endif

validate-stow: ## Validate stow symlinks
	dot-local/bin/validate-stow

validate-init: ## Validate init directories
	dot-local/bin/validate-init

validate-nvim: ## Validate neovim setup
	dot-local/bin/validate-nvim

validate-systemd: ## Validate systemd operations from toolbox
	dot-local/bin/validate-systemd

nvim-verify: ## Verify Neovim deployment (structure, count, launch)
	echo '##[ $@ ]##'
	dot-local/bin/validate-nvim-plugins
	dot-local/bin/check-plugin-count
	dot-local/bin/validate-nvim-launch
	echo '✅ Neovim verification passed'

git-status: ## Show git status and recent commits
	echo '##[ $@ ]##'
	git --no-pager status
	echo ''
	echo '##[ Recent commits ]##'
	git --no-pager log --oneline -5


help: ## show available make targets
	cat $(MAKEFILE_LIST) |
	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
	sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'


