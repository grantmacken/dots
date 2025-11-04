# Set simple prompt: toolbox icon if in container, otherwise >
if [ -f /run/.toolboxenv ]; then
  PS1='🧰 '
else
  PS1='> '
fi
