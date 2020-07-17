# Exclude those directories even if not listed in .gitignore, or if .gitignore is missing
FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Change behavior of fzf dialogue
# export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info \
#   --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {}
#   || cat {}) 2> /dev/null | head -300' \
# --preview-window='right:hidden:wrap' \
# --bind='f3:execute(bat --style=numbers {} || \
# less -f {}),\
# f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | \
# pbcopy)'"

# Change find backend
# Use 'git ls-files' when inside GIT repo, or fd otherwise
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"

# Find commands for "Ctrl+T" and "Opt+C" shortcuts
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
