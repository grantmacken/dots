#!/bin/bash +x
source /usr/share/defaults/etc/profile

if [ -d $HOME/.config/bash ] ; then
    for script in $HOME/.config/bash/*.sh
    do
      source $script
    done
    unset script
fi

# source $HOME/projects/owners/ingydotnet/git-subrepo/.rc
# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/home/gmack/google-cloud-sdk/path.bash.inc' ]; then source '/home/gmack/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/home/gmack/google-cloud-sdk/completion.bash.inc' ]; then source '/home/gmack/google-cloud-sdk/completion.bash.inc'; fi
# create a nvim instance on startup
# setxkbmap -option caps:swapescape

setxkbmap -option caps:escape

source <(kitty + complete setup bash)
# tmuxp load -2 $HOME/.tmuxp/project.yaml

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# added by travis gem
#[ -f /home/gmack/.travis/travis.sh ] && source /home/gmack/.travis/travis.sh

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/gmack/google-cloud-sdk/path.bash.inc' ]; then . '/home/gmack/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/gmack/google-cloud-sdk/completion.bash.inc' ]; then . '/home/gmack/google-cloud-sdk/completion.bash.inc'; fi

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
