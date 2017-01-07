# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

READLINK=$(which greadlink || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.alfie_dotfiles" ]; then
  DOTFILES_DIR="$HOME/.alfie_dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return # `exit 1` would quit the shell itself
fi

# Finally we can source the dotfiles (order matters)
echo $DOTFILES_DIR
for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,path,env,alias,grep,prompt}; do
    echo $DOTFILE
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done


# Set LSCOLORS

eval "$(dircolors "$DOTFILES_DIR"/system/.dir_colors)"


# Clean up

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE


# Export

export DOTFILES_DIR
