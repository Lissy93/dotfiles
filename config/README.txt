Lissy93/Dotfiles - Config ⚙️
----------------------------

> All configuration files for apps, utils and services used across *nix-based systems

The location on disk that files should be symlinked to is specified in symlinks.yml
Run the install.sh script to apply settings based on system type and user preferences

Important: Take care to read through files thoroughly before applying any changes
And always make a backup of your pre-existing config files before over-writing them

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Source: https://github.com/Lissy93/dotfiles/tree/master/scripts    ┃
┃ Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

---

config/
├── git/                      # Git (version control) config files
├── tmux/                     # Tmux (multiplexer) config, sessions, bindings and plugin list
├── vim/                      # Vim (text editor) config, key bindings and plugin list
├── zsh/                      # ZSH (shell) settings, aliases, utils and plugin list
├── general/                  # All other config files for *nix-based systems
│  ├── .bashrc
│  ├── .gemrc
│  ├── .gitignore_global
│  ├── .gpg.conf
│  ├── .curlrc
│  ├── .gitconfig
│  ├── .wgetrc
│  └──  dnscrypt-proxy.toml
├── macos/                    # Configs for apps only used on MacOS
│  ├── launchpad.yml          # The layout and folder structure of launchpad screen
│  ├── skhdrc                 # Hot keys for managing TWM
│  └── yabairc                # Settings for tiling window manager
├── desktop-apps/             # Config files for GUI applications
│  ├── firefox.user.js        # Firefox (browser)
│  └── thunderbird.user.js    # Thunderbird (mail client) 
├── themes/                   # Color themes for various apps
│  ├── iterm                  # 
│  └── warp                   # 
└── README.txt

