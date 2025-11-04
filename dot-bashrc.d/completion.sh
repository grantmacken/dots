# Load bash completion for make and other tools
if [ -f /run/.toolboxenv ]; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  fi
fi
