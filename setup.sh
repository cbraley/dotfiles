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

# Setup tools.
mkdir -p ~/tools
ln -s -i ${DIR}/clang-format.py ~/tools/clang-format.py
chmod +x ~/tools/clang-format.py
ln -s -i ${DIR}/clang-format.py ~/tools/clang-format-diff.py
chmod +x ~/tools/clang-format-diff.py
ln -s -i ${DIR}/short_prompt_pwd.py ~/tools/short_prompt_pwd.py

echo "Setup complete."

