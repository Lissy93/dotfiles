Lissy93/Dotfiles - Config ⚙️
----------------------------

List of configuration files for various apps, utils and systems.

config
├── desktop-apps/             # Config files for GUI applications
│  ├── firefox.user.js        # Firefox (browser)
│  └──  thunderbird.user.js   # Thunderbird (mail client) 
├── general/                  # General config files for all *nix-based systems
│  ├── .bashrc
│  ├── .gemrc
│  ├── .gitignore_global
│  ├── .gpg.conf
│  ├── .curlrc
│  ├── .gitconfig
│  ├── .wgetrc
│  └──  dnscrypt-proxy.toml
├── macos/
│  ├── launchpad.yml
│  ├── skhdrc
│  └── yabairc
└── README.txt


Generic configs which are used across all systems (e.g. .gitconfig, .bashrc, .wgetrc)
are stored in the root of the config directory, whereas files which are only used on
certain systems (like MacOS) or by certain applications (like Firefox's user.js) are
kept in category-specific directories (e.g. macos, desktop-apps, gnome, etc).

The location on disk that files should be symlinked to is specified in symlinks.yml
Run the install.sh script to apply settings based on system type and user preferences

Important: Take care to read through files thoroughly before applying any changes.

For full documentation, see: https://github.com/Lissy93/dotfiles
Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com>
