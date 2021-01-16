#!/usr/bin/python3

import sys
import os
from pathlib import Path

# Setup common paths.
home_path = Path.home()
config_path = Path(Path.home(), ".config")
dotfiles_dir = Path(__file__).resolve().parent

# Ensure we execute from the dotfiles directory.
os.chdir(dotfiles_dir)

class DotFile:
    def __init__(self, source, target=None):
        self.source = Path(dotfiles_dir, source)
        if target == None:
            self.target = Path(home_path, ".{}".format(source))
        else:
            self.target = Path(target)

universal = [
    DotFile("zshrc"),
    DotFile("zprofile"),
    DotFile("vimrc"),
    DotFile("vim"),
    DotFile("tmux.conf"),
    DotFile("base16-shell", Path(config_path, "base16-shell")),
    DotFile("gitignore"),
    DotFile("gitconfig"),
    DotFile("alacritty.yml"),
]

macos = []

linux = [
    DotFile("sway.conf"),
    DotFile("wofi.css"),
    DotFile("wofi.conf"),
]

def link(dot_files):
    for dot_file in dot_files:
        if dot_file.target.exists():
            if dot_file.target.resolve() == dot_file.source:
                print("Skipping {}, already correctly set.".format(dot_file.target))
            else:
                print("Failed {}, remove existing and retry.")
        else:
            print("Linking {} -> {}.".format(dot_file.source, dot_file.target))
            dot_file.target.symlink_to(dot_file.source)


def setup():
    #
    # Ensure basic directories exist.
    #
    print("Checking for config directory.")
    if not config_path.exists():
        print("Creating {}.".format(config_path))
        config_path.mkdir()

    #
    # Ensure submodules are initialized.
    #
    print("Checking submodules.")
    if not Path(dotfiles_dir, "base16-shell", "README.md").exists():
        print("Submodules are not initialized. Initializing.")
        os.system("git submodule init")
        os.system("git submodule update")

    #
    # Create symlinks.
    #
    print("Creating symlinks.")
    link(universal)
    if sys.platform.startswith("darwin"):
        link(macos)
    else:
        link(linux)

    #
    # Setup basic tools on macos.
    #
    if sys.platform.startswith("darwin"):
        print("Installing basic tools.")
        os.system("brew install git tmux vim fzf")

    # TODO: setup basic tools on linux.

if __name__ == "__main__":
    setup()
