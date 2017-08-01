#!/bin/bash

# Note - All of these are symlinks(as opposed to hardlinks) because I link
# across multiple file systems.

# Get the directory name this script is located in.
# We then use this to make symlinks.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make the symlinks "interactively" so the user can say no.

# Symlink the system's .vim directory to the vim subdirectory here.
ln -s -i ${DIR}/vim_files  ~/.vim

# Symlink the system's .vimrc directory to vimrc
# Note that we avoid naming vimrc as .vimrc since I share
# my vimrc file between unix and windows, and Windows does not play nice
# with file names starting with a dot.
ln -s -i ${DIR}/vimrc ~/.vimrc

# Symlink the system's ~/.bashrc to bashrc here.
ln -s -i ${DIR}/bashrc ~/.bashrc

# Symlink the system's ~/.gitconfig to gitconfig here.
ln -s -i ${DIR}/gitconfig ~/.gitconfig

# Symlink the system's ~/.screenrc to screenrc here.
ln -s -i ${DIR}/screenrc ~/.screenrc

# Symlink the system's ~/.bash_profile to bash_profile
ln -s -i ${DIR}/bash_profile ~/.bash_profile

ln -s -i ${DIR}/tmux_config ~/.tmux.conf

# Setup tools.
mkdir -p ~/tools
ln -s -i ${DIR}/clang-format.py ~/tools/clang-format.py
chmod +x ~/tools/clang-format.py
ln -s -i ${DIR}/clang-format.py ~/tools/clang-format-diff.py
chmod +x ~/tools/clang-format-diff.py
ln -s -i ${DIR}/short_prompt_pwd.py ~/tools/short_prompt_pwd.py
mkdir -p ~/.config/terminator
ln -s -i ${DIR}/terminator_config ~/.config/terminator/config
ln -s -i ${DIR}/resolve_conflicts.py ~/tools/resolve_conflicts.py

echo "Setup complete."

