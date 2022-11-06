
Lissy93/Dotfiles - Scripts 📜
----------------------------

A set of Bash scripts for automating the setup and management of various systems.

dotfiles/scripts/
├── installs/
│  ├── arch-pacman.sh     Package installations using via for Arch-based systems
│  ├── Brewfile           Packages to be installed via Homebrew on MacOS
│  ├── flatpak.sh         Desktop apps to be installed on Linux GUI systems via Flatpak
│  ├── alpine-pkg.sh      Package installations using pkg for Alpine-based systems
│  └── prerequisites.sh   Cross-distro installation of prerequisite core packages
├── linux/
│  └── dconf-prefs.sh     Apply preferences to (mostly GNOME apps) via dconf utility
└── macos-setup/
   ├── macos-apps.sh      Apply preferences to user applications (Finder, Mail, Terminal, etc)
   ├── macos-prefs.sh     Apply user MacOS preferences (spotlight, colors, behaviour, etc)
   └── macos-security.sh  Apply essential MacOS security settings


Source: https://github.com/Lissy93/dotfiles/tree/master/scripts
Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com>
