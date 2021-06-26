#!/bin/bash
GIT_USER="$( git config --get user.name )"
alias dotfiles-reload='source $HOME/.bashrc'
alias fold="fold -s"

# gcloud
export CLOUDSDK_PYTHON=python3
alias SSH='gcloud compute ssh gmack@gmack'
# https://github.com/docker/buildx/#with-buildx-or-docker-1903
# DOCKER_CLI_EXPERIMENTAL=enabled
#export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
# export VISUAL='nvr --remote-wait-silent'
export EDITOR=nvim

if [ -z "$XDG_CONFIG_HOME" ]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
  export XDG_CACHE_HOME="$HOME/.cache"
fi
if [ -z "$XDG_DATA_HOME" ]; then
  export XDG_DATA_HOME="$HOME/.local/share"
fi

# export JAVA_HOME=/usr/lib/openjdk-8
# JAVA_BIN=/usr/lib/openjdk-8/bin
# if [[ ! "$PATH" == *${JAVA_BIN}* ]]; then
#  export PATH="$PATH:${JAVA_BIN}"
# fi

# make sure we have a local bin on path
LOCAL_BIN=/usr/local/bin
if [[ ! "$PATH" == *${LOCAL_BIN}* ]]; then
  export PATH="$PATH:${LOCAL_BIN}"
fi


# make sure we have a home bin on path
HOME_BIN=$HOME/.local/bin
if [[ ! "$PATH" == *${HOME_BIN}* ]]; then
  export PATH="$PATH:${HOME_BIN}"
fi

# global npm
NPM_BIN=$HOME/.local/npm/bin
if [[ ! "$PATH" == *${NPM_BIN}* ]]; then
  export PATH="$PATH:${NPM_BIN}"
fi
NPM_CONFIG_PREFIX=$HOME/.local/npm/bin

# /home/gmack/.cache/rebar3/bin/rebar3
# make sure we have a home bin on path
REBAR_BIN=$HOME/.cache/rebar3/bin
if [[ ! "$PATH" == *${REBAR_BIN}* ]]; then
  export PATH="$PATH:${REBAR_BIN}"
fi

# export GOPATH=$HOME/go

# git controlled project development

# if we have a user name set a PROJECTS folder
if [ -n "${GIT_USER}" ]; then
  export GIT_USER="${GIT_USER}"
  
  PROJECTS="$HOME/projects/${GIT_USER}"
  alias p="cd $PROJECTS"
  export PROJECTS="${PROJECTS}"

NODE_BIN=${PROJECTS}/node_modules/.bin
if [[ ! "$PATH" == *${NODE_BIN}* ]]; then
  export PATH="$PATH:${NODE_BIN}"
fi

  #LEDGER_FILE=${PROJECTS}/accounts/main.ledger
  #export LEDGER_FILE="${LEDGER_FILE}"
  #LEDGER_PRICE_DB=${PROJECTS}/accounts/pricedb.ledger
  #export LEDGER_PRICE_DB="${LEDGER_PRICE_DB}"

  #LEDGER_INIT_FILE=~/.ledgerrc
  #export LEDGER_INIT_FILE="${LEDGER_INIT_FILE}"
  # Equivalent to %Y-%m-%d (the ISO 8601 date format). (C99
  #LEDGER_DATE_FORMAT=%F
  #export LEDGER_DATE_FORMAT="${LEDGER_DATE_FORMAT}"
fi
