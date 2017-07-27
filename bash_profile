# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

# On MacOS, ~/.bashrc is not sourced automatically in interactive shells.
if [[ $(uname) == 'Darwin' ]]; then
  source ~/.bashrc
fi
