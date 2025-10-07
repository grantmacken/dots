# Terminal title and prompt configuration

# Assign a tab number if not already set
# This persists across shell sessions within the same terminal tab
if [ -z "$BASH_TAB_NUMBER" ]; then
  # Use a lock file to atomically increment tab counter
  TAB_COUNTER_FILE="${XDG_RUNTIME_DIR:-/tmp}/bash_tab_counter_$$"
  mkdir -p "$(dirname "$TAB_COUNTER_FILE")"
  
  # Try to find the next available tab number
  for i in {1..9}; do
    TAB_LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/bash_tab_${i}.lock"
    if mkdir "$TAB_LOCK_FILE" 2>/dev/null; then
      export BASH_TAB_NUMBER=$i
      # Clean up lock on shell exit
      trap "rmdir '$TAB_LOCK_FILE' 2>/dev/null" EXIT
      break
    fi
  done
  
  # If all 9 slots taken, don't number
  if [ -z "$BASH_TAB_NUMBER" ]; then
    export BASH_TAB_NUMBER=""
  fi
fi

# Function to set terminal title
set_terminal_title() {
  local title=""

  # Check if we're in a git repository
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the git repository name (basename of the root directory)
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$git_root" ]; then
      title=$(basename "$git_root")
    fi
  fi

  # If not in a git repo, use the current directory name
  if [ -z "$title" ]; then
    title=$(basename "$PWD")
    # If we're in home directory, use ~
    if [ "$PWD" = "$HOME" ]; then
      title="~"
    fi
  fi

  # Prepend tab number if available
  if [ -n "$BASH_TAB_NUMBER" ]; then
    title="${BASH_TAB_NUMBER}: ${title}"
  fi

  # Set the terminal title using OSC escape sequences
  # Works with ptyxis and other modern terminals
  echo -ne "\033]0;${title}\007"
}

# Set up PROMPT_COMMAND to update title before each prompt
# Preserve any existing PROMPT_COMMAND
if [ -z "$PROMPT_COMMAND" ]; then
  PROMPT_COMMAND="set_terminal_title"
else
  PROMPT_COMMAND="${PROMPT_COMMAND};set_terminal_title"
fi
