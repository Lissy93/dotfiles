```
    ____        __  _____ __         
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  ) 
/_____/\____/\__/_/ /_/_/\___/____/       
```

## Intro

My personal dot files, that I use to quickly configure a Linux environment on desktop and server instances.
[Dotbot](https://github.com/anishathalye/dotbot) is being used to create symlinks in all the right places.

Tested and used on Ubuntu, Arch Linux and Manjaro.

---

## Setup

To setup, just clone the repo, cd into it, and run the install script.

```
git clone git@github.com:Lissy93/dotfiles.git
cd dotfiles
./install.sh
```

---

## Configuring

Configuration is specified in `.install.conf.yaml` and managed with [Dotbot](https://github.com/anishathalye/dotbot). 

The bootstrap configurations are idempotent (and so the installer can be run multiple times without causing any problems).

To only install certain parts of the config, pass the `--only` flag to the install.sh script, similarly `--except` can be used to exclude certain directives.

---

## Dependencies

- [zsh](https://www.zsh.org/) - Interactive Shell
- [vim](https://www.vim.org/) - Fast, solid customizable text editor
- [tmux](https://github.com/tmux/tmux) - Detachable terminal multiplexer
- [ranger](https://ranger.github.io/) - CLI-based file manager with VI bindings
- [git](https://git-scm.com/) - Version control system

Ubuntu: `sudo apt install -y zsh vim tmux ranger git`

Arch Linux:  `sudo pacman -S zsh vim tmux ranger git`

Depending on your setup, `make`, `ctags` and `python3-pip` may also be needed

---
## Details


### Tmux

Fairly standard Tmux configuration, strongly based off Tmux-sensible. Configuration is defined in [`.tmux.conf`](https://github.com/Lissy93/dotfiles/blob/master/tmux/tmux.conf)

Tmux plugins are managed using [TMP](https://github.com/tmux-plugins/tpm) and defined in [`.tmux.conf`](https://github.com/Lissy93/dotfiles/blob/master/tmux/tmux.conf). To install them from GitHub, run `prefix` + <kbd>I</kbd> from within Tmux, and they will be cloned int `~/.tmux/plugins/`.

#### Plugins

- **[Tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)**: `tmux-plugins/tmux-sensible` - General, sensible Tmux config
- **[Tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)**: `tmux-plugins/tmux-continuum` - Continuously saves and environment with automatic restore
- **[Tmux-yank](https://github.com/tmux-plugins/tmux-yank)**: `tmux-plugins/tmux-yank` - Allows access to system clipboard
- **[Tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight)**: `tmux-plugins/tmux-prefix-highlight` - Highlight Tmux prefix key when pressed
- **[Tmux-online-status](https://github.com/tmux-plugins/tmux-online-status)**: `tmux-plugins/tmux-online-status` - Displays network status
- **[Tmux-open](https://github.com/tmux-plugins/tmux-open)**: `tmux-plugins/tmux-open` - Bindings for quick opening selected path/ url
- **[Tmux-mem-cpu-load](https://github.com/thewtex/tmux-mem-cpu-load)**: `thewtex/tmux-mem-cpu-load` - Shows system resources

### Vim

The entry point for the Vim config is the [`vimrc`](https://github.com/Lissy93/dotfiles/blob/master/vim/vimrc), but the main editor settings are defined in [`vim/editor.vim`](https://github.com/Lissy93/dotfiles/blob/master/vim/editor.vim)

#### Plugins

Vim plugins are managed using [Plug](https://github.com/junegunn/vim-plug) defined in [`vim/plugins.vim`](https://github.com/Lissy93/dotfiles/blob/master/vim/plugins.vim).
To install them from GitHub, run `:PlugInstall` (see [options](https://github.com/junegunn/vim-plug#commands)) from within Vim.


Layout & Navigation:
- **[Airline](https://github.com/vim-airline/vim-airline)**: `vim-airline/vim-airline` - A very nice status line at the bottom of each window, displaying useful info
- **[Nerd-tree](https://github.com/preservim/nerdtree)**: `preservim/nerdtree` - Alter files in larger projects more easily, with a nice tree-view pain
- **[Matchup](https://github.com/andymass/vim-matchup)**: `andymass/vim-matchup` - Better % naviagtion, to highlight and jump between open and closing blocks
- **[TagBar](https://github.com/preservim/tagbar)**: `preservim/tagbar` - Provides an overview of the structure of a long file, shows tags ordered by scope
- **[Gutentags](https://github.com/ludovicchabant/vim-gutentags)**: `ludovicchabant/vim-gutentags` - Manages tag files
- **[Fzf](https://github.com/junegunn/fzf.vim)**: `junegunn/fzf` and `junegunn/fzf.vim` - Command-line fuzzy finder and corresponding vim bindings
- **[Deoplete.nvim](https://github.com/Shougo/deoplete.nvim)**: `Shougo/deoplete.nvim` - Extensible and asynchronous auto completion framework
- **[Smoothie](https://github.com/psliwka/vim-smoothie)**: `psliwka/vim-smoothie` - Smooth scrolling, supporting `^D`, `^U`, `^F` and `^B`
- **[DevIcons](https://github.com/ryanoasis/vim-devicons)**: `ryanoasis/vim-devicons` - Adds file-type icons to Nerd-tree and other plugins

Operations:
- **[Nerd-Commenter](https://github.com/preservim/nerdcommenter)**: `preservim/nerdcommenter` - For auto-commenting code blocks
- **[Ale](https://github.com/dense-analysis/ale)**: `dense-analysis/ale` - Checks syntax asynchronously, with lint support
- **[Surround](https://github.com/tpope/vim-surround)**: `tpope/vim-surround` - Easily surround selected text with brackets, quotes, tags etc
- **[IncSearch](https://github.com/haya14busa/incsearch.vim)**: `haya14busa/incsearch.vim` - Efficient incremental searching within files
- **[Vim-Visual-Multi](https://github.com/mg979/vim-visual-multi)**: `mg979/vim-visual-multi` - Allows for inserting/ deleting in multiple places simultaneously
- **[Visual-Increment](https://github.com/triglav/vim-visual-increment)**: `triglav/vim-visual-increment` - Create an increasing sequence of numbers/ letters with `Ctrl` + `A`/`X`
- **[Vim-Test](https://github.com/janko/vim-test)**: `janko/vim-test` - A wrapper for running tests on different granularities
- **[Syntastic](https://github.com/vim-syntastic/syntastic)**: `vim-syntastic/syntastic` - Syntax checking that warns in the gutter when there's an issue

Git:
- **[Git-Gutter](https://github.com/airblade/vim-gitgutter)**: `airblade/vim-gitgutter` - Shows git diff markers in the gutter column
- **[Vim-fugitive](https://github.com/tpope/vim-fugitive)**: `tpope/vim-fugitive` - A git wrapper for git that lets you call a git command using `:Git`
- **[Committia](https://github.com/rhysd/committia.vim)**: `rhysd/committia.vim` - Shows a diff, status and edit window for git commits
- **[Vim-Git](https://github.com/tpope/vim-git)**: `tpope/vim-git` - Runtime files for git in vim, for  git, gitcommit, gitconfig, gitrebase, and gitsendemail

File-Type Plugins:
- **[Vim-JavaScript](https://github.com/pangloss/vim-javascript)**: `pangloss/vim-javascript` *(JavaScript)* - Syntax highlighting and improved indentation for JS files
- **[Yats](https://github.com/HerringtonDarkholme/yats.vim)**: `HerringtonDarkholme/yats.vim` *(TypeScript)* - Syntax highlighting and snippets for TypeScript files
- **[Vim-jsx-pretty](https://github.com/MaxMEllon/vim-jsx-pretty)**: `MaxMEllon/vim-jsx-pretty` *(React)* - Highlighting and indentation for React .tsx and .jsx files
- **[Vim-CSS-Color](https://github.com/ap/vim-css-color)**: `ap/vim-css-color` *(CSS/ SASS)* - Previews colors as text highlight, where hex codes are present
- **[Mustache and Handlebars](https://github.com/mustache/vim-mustache-handlebars)**: `mustache/vim-mustache-handlebars` *(Mustache/ Handlebars)* - Auto handles braces
- **[Vim-Go](https://github.com/fatih/vim-go)**: `fatih/vim-go` *(GoLang)* - Go support, with syntax highlighting, quick execute, imports, formatting etc
- **[Indentpython](https://github.com/vim-scripts/indentpython.vim)**: `vim-scripts/indentpython.vim` *(Python)* - Correct indentation for Python files
- **[Semshi](https://github.com/numirias/semshi)**: `numirias/semshi` *(Python)* - Advanced syntax highlighting for Python files
- **[SimpylFold](https://github.com/tmhedberg/SimpylFold)**: `tmhedberg/SimpylFold` *(Python)* - Code-folding for Python
- **[Vimtex](https://github.com/lervag/vimtex)**: `lervag/vimtex` *(LaTex)* - Completion of citations, labels, commands and glossary entries
- **[Dockerfile.vim](https://github.com/ekalinin/Dockerfile.vim)**: `ekalinin/Dockerfile.vim` *(Docker)* - Syntax highlighting and snippets for Dockerfiles
- **[Vim-Json](https://github.com/elzr/vim-json)**: `elzr/vim-json` *(JSON)* - Syntax highlighting, warnings, and quote concealing foe .json files
- **[Requirements](https://github.com/raimon49/requirements.txt.vim)**: `raimon49/requirements.txt.vim` *(Requirements)* - Syntax highlighting for the requirements file format
- **[Vim-Markdown](https://github.com/gabrielelana/vim-markdown)**: `gabrielelana/vim-markdown` *(Markdown)* - Syntax highlighting, auto format, easy tables and more
- **[Zinit](https://github.com/zinit-zsh/zinit-vim-syntax)**: `zinit-zsh/zinit-vim-syntax` *(ZSH)* - syntax definition for Zinit commands in any file of type zsh
- **[Nginx](https://github.com/chr4/nginx.vim)**:`chr4/nginx.vim` *(Nginx)* - Integer matching, hichlight syntax and IPv4/ IPv6, mark insecure protocols and more

Themes:

