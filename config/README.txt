Lissy93/Dotfiles - Config ⚙️
----------------------------

List of configuration files for various apps, utils and systems.

└── config/
  ├── tmux/               # Tmux (multiplexer) config
  ├── vim/                # Vim (text editor) config
  ├── zsh/                # ZSH (shell) config
  ├── macos/              # Config files for Mac-specific apps
  └── desktop-apps/       # Config files for GUI apps


Generic configs which are used across all systems (e.g. .gitconfig, .bashrc, .wgetrc)
are stored in the root of the config directory, whereas groups of config files, for like
ZSH, Vim, Tmux etc are organized into directories.
files which are only used on
certain systems (like MacOS) or by certain applications (like Firefox's user.js) are
kept in category-specific directories (e.g. macos, desktop-apps, gnome, etc).

The location on disk that files should be symlinked to is specified in symlinks.yml
Run the install.sh script to apply settings based on system type and user preferences

Important: Take care to read through files thoroughly before applying any changes.

Full source and documentation: https://github.com/Lissy93/dotfiles
Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com>
