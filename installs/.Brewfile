# ~/.Brewfile
#
# List of packages to be installed / updated via Homebrew
# Apps are sorted by category, and arranged alphabetically
# Be sure to delete / comment out anything you do not need
# Usage, run: $ brew bundle --global --file $HOME/.Brewfile
# See brew docs for more info: https://docs.brew.sh/Manpage

# Options
cask_args appdir: '~/Applications', require_sha: true

# Taps
tap 'homebrew/bundle'
tap 'homebrew/core'
tap 'homebrew/services'

# CLI Essentials
brew 'git'
brew 'neovim'
brew 'ranger'
brew 'tmux'

# CLI Utils
brew 'ctags'        # Indexing of file info + headers
brew 'exa'          # Better ls
brew 'fzf'          # Fuzzy file finder
brew 'glances'      # top app, with web interface + API
brew 'gotop'        # Better htop app, resource monitoring
brew 'iproute2mac'  # MacOS port of netstat and ifconfig
brew 'jq'           # JSON parser
brew 'lazydocker'   # CLI Docker management app
brew 'scc'          # Code counter, like cloc
brew 'tldr'         # Community-maintained man pages
brew 'tree'         # Directory listings as tree
brew 'xsel'         # Copy paste access to X clipboard

# CLI Fun
brew 'figlet'       # Output text as ASCII art
brew 'lolcat'       # Make output raibow colored
brew 'neofetch'     # Show system and ditstro info

# Development
cask 'android-studio' # IDE for Android development
cask 'boop'           # Test transformation tool
brew 'gradle'         # Build automation for Java
# brew 'qemu'         # Machine emulator + virtualizer
cask 'iterm2'         # Better terminal emulator
cask 'postman'        # HTTP API testing app
cask 'sourcetree'     # Git visual client
cask 'utm'            # VM management console
cask 'visual-studio-code' # Code editor

# Development Utils
brew 'gh'     # Interact with GitHub PRs, issues, repos
cask 'ngrok'  # Reverse proxy for development / testing

# Languages and Compilers
brew 'docker'
brew 'gcc'
brew 'go'
brew 'lua'
brew 'luarocks'
brew 'node'
brew 'nvm' 
brew 'openjdk'
brew 'python'
brew 'rust'
cask 'android-sdk'

# Network and Security Testing
brew 'nmap'       # Port scanning
brew 'wrk'        # HTTP benchmarking
cask 'burp-suite' # Web security testing
cask 'metasploit' # Pen testing framework
cask 'owasp-zap'  # Web app security scanner
cask 'wireshark'  # Network analyzer + packet capture

# Security Utilities
brew 'bcrypt'     # Encryption utility, using blowfish
cask 'gpg-suite'  # PGP encryption for emails and files
brew 'openssl'    # Cryptography and SSL/TLS Toolkit
cask 'veracrypt'  # File and volume encryption

# Fonts
tap 'homebrew/cask-fonts'
cask 'font-fira-code'
cask 'font-hack'
cask 'font-inconsolata'
cask 'font-meslo-lg-nerd-font'

# Mac OS Mods and Imrovments
brew 'm-cli'          # All in one MacOS management CLI app
cask 'alt-tab'        # Much better alt-tab window switcher
cask 'anybar'         # Custom programatic menubar icons
cask 'coteditor'      # Just a simple plain-text editor
cask 'finicky'        # Website-specific default browser
cask 'hiddenbar'      # Hide / show annoying menubar icons
cask 'linearmouse'    # Device-specific mouse preferences
cask 'little-snitch'  # Firewall GUI for blocking traffic
cask 'mjolnir'        # Util for loading Lua automations
cask 'stats'          # System resource usage in menubar

# Productivity Utils
cask 'copyq'          # Clipboard manager
tap 'espanso/espanso'
cask 'espanso'        # Text expander

# Media and Creativity
brew 'handbrake'      # Video transcoder
cask 'audacity'       # Audio editor / recorder
cask 'gimp'           # Photo editor
cask 'inkscape'       # Vector editor
cask 'obs'            # Screencasting / recording
cask 'shotcut'        # Video editor
cask 'spotify', args: { require_sha: false } # Propietary music streaming
cask 'transmission'   # Torrent client
cask 'vlc'            # Media player

# General Applications
cask '1password'      # Password manager (proprietary)
cask 'tresorit'       # Encrypted file backup (proprietary)
cask 'firefox'        # Browser
cask 'chromium'       # Browser, again
cask 'standard-notes' # Encrypted synced notes
cask 'signal'         # Messenger
