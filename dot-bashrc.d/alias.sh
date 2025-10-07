if [ -f "/run/.toolboxenv" ]; then
  alias ??='gh copilot suggest -t shell'
  alias explain='gh copilot explain'
  # You might also want these:
  alias git?='gh copilot suggest -t git'
  alias gh?='gh copilot suggest -t gh'
fi
