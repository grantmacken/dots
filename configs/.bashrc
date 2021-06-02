#!/bin/bash +x
source /usr/share/defaults/etc/profile
if [ -d $HOME/.config/bash ] ; then
    for script in $HOME/.config/bash/*.sh
    do
      source $script
    done
    unset script
fi
# kitty
source <(kitty + complete setup bash)
# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# gh client
eval "$(gh completion -s bash)"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/gmack/projects/google-cloud-sdk/path.bash.inc' ]; then . '/home/gmack/projects/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/gmack/projects/google-cloud-sdk/completion.bash.inc' ]; then . '/home/gmack/projects/google-cloud-sdk/completion.bash.inc'; fi

. "$HOME/.cargo/env"
