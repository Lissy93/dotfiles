Lissy93/Dotfiles - ZSH Config ⚙️
-------------------------------

> My configuration files for Z Shell

config/zsh/
├── .p10k.zsh               Configuration for the PowerLevel10K ZSH prompt
├── .zlogin                 Startup tasks, executed when the shell is launched
├── .zlogout                Cleanup tasks, executed when the shell is exited
├── .zshenv                 Core environmental variables, used to configure file locations for dotfiles
├── .zshrc                  Entry point for ZSH config, here all the other files are imported
├── aliases/							
│  ├── alias-tips.zsh       Shows hint when there's an available short-hand alias for a command
│  ├── flutter.zsh          Aliases, shortcuts and helper functions for Flutter development
│  ├── general.zsh          General aliases and short functions for common CLI tasks
│  ├── git.zsh              Aliases, shortcuts and helper functions for working with Git
│  └── node-js.zsh          Aliases, shortcuts and helper functions for JS/ Node.js development
├── helpers/
│  ├── import-plugins.zsh   Installation, updating and importing of all ZSH plugins, via Antigen
│  ├── misc-stuff.zsh			
│  └── setup-antigen.zsh    Installs, and sets up Antigen, which is used for plugin management
└── lib/
   ├── colors.zsh           Define colors for listing various file types
   ├── completion.zsh       Configure completion and fuzzy matching settings
   ├── cursor.zsh           Set cursor color, behaviour and key bindings
   ├── expansions.zsh       Expands all glob expressions, subcommands and aliases
   ├── history.zsh          Configure history settings, file size, age, etc
   ├── key-bindings.zsh     Set key bindings, and keyboard shortcuts
   ├── navigation.zsh       Settings for jumping around directories
   ├── surround.zsh         Match parentheses/quotes around strings
   └── term-title.zsh       Show current command as terminal title (Xterm)

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Full source and documentation: https://github.com/Lissy93/dotfiles ┃
┃ Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
