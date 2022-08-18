<h1 align="center"><code>~/.Dotfiles</code></h1>
<h2 align="center"><code>$HOME, sweet $HOME</code></h2>
<p align="center"><i>My dotfiles for configuring Vim, ZSH, Tmux, Git, etc</i></p>
<p align="center"><img width="400" src="https://i.ibb.co/rH30RbM/Dotfiles.png" /></p>


## Contents
- [Introduction to Dotfiles](#intro)
    - [What are dotfiles?](#what-are-dotfiles)
    - [Dotfile Management Systems](#dotfile-management-systems)
    - [So copy paste, right?](#so-copy-paste-right)
    - [XDG Directories](#xdg-directories)
    - [Applying Dotfiles](#applying-dotfiles)
    - [Containerized Userspace](#containerized-userspace)
    - [Security](#security)
- [My Dots](#my-dots)
    - [Setup](#setup)
    - [Aliases](#aliases)
    - [Utilities](#utilities)
    - [Packages](#packages)
    - [ZSH](#zsh)
    - [Vim](#vim)
    - [Tmux](#tmux)
    - [Git](#git)
    - [Dependencies](#dependencies)
---

## Intro

### What are dotfiles?

One of the beautiful things about Linux, is how easily customizable everything is. Usually these custom configurations are stored in files that start with a dot (hence dotfiles!), and typically located in your users home `~`, or better yet `~/.config` (even this can be customized, for apps that respect the XDG Base Directory spec). Some examples of dotfiles that you're likely already familiar with include `.gitconfig`, `.zshrc` or `.vimrc`.

You will often find yourself tweaking your configs over time, so that your system perfectly matches your needs. It makes sense to back these files up, so that you don't need to set everything up from scratch each time you enter a new environment. Git is a near-perfect system for this, as it allows for easy roll-backs, branches and it's well supported with plenty of hosting options (like here on GitHub).

Once everything's setup, you'll be able to SSH into a fresh system or reinstall your OS, then just run your script and go from zero to feeling at right at home within a minute or two.

It's not hard to create your own dotfile repo, it's great fun and you'll learn a ton along the way!


---

### Dotfile Management Systems

You can make things simple, or complex as you like.

The two most common methods are either symlinking, or using a git bare repo, these are explained in more detail in the [Applying Dotfiles](#applying-dotfiles) section. You can either do things manually, write a simple script, or use a pre-build dotfile management system (like [dotbot](https://github.com/anishathalye/dotbot), [chezmoi](https://github.com/twpayne/chezmoi), [yadm](https://github.com/TheLocehiliosan/yadm) or [GNU Stow](https://www.gnu.org/software/stow/)).

In terms of managing dependencies, using either [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) or [git subtree](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt) will let you keep dependencies in your project, while also separate from your own code and easily updatable.

---

### So copy paste, right?

Zach Holman wrote a great article titled [Dotfiles Are Meant to Be Forked](https://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/). I personally disagree with this, since your dotfiles are ususally highly personalized, so what's right for one developer, likely won't be what someone else is looking for. They're also usually something you build up over time, and althgouh some repos may provide a great starting point, it's really important to know what everything does, and how it works.

By all means feel free to take what you want from mine. I've taken care to ensure that each file is standalone, and well documented so that certain files can just be dropped into any system. But I cannot stress enough the importance of reading through files to ensure it's actually what you want. 

If you're looking for some more example dotfile repos to get you started, I can highly recomend taking a look at: [holman](https://github.com/holman/dotfiles).

There's even more to check out at [webpro/awesome-dotfiles](https://github.com/webpro/awesome-dotfiles), [dotfiles.github.io](https://dotfiles.github.io/) and [r/unixporn](https://www.reddit.com/r/unixporn/).

---

### XDG Directories

One of my goals was to try and keep the top-level user home directory as clean as possible by honouring the [XDG base directory specification](https://specifications.freedesktop.org/basedir-spec), which lets you specify the locations for config, cache, data, log and other files. This is done by setting environmental variables within [`.zshenv`](https://github.com/Lissy93/dotfiles/blob/master/zsh/.zshenv).

You can modify any of these values, but by default the following paths are used:

Variable | Location
--- | ---
`XDG_CONFIG_HOME` | `~/.config`
`XDG_DATA_HOME`   | `~/.local/share`
`XDG_BIN_HOME`   | `~/.local/bin`
`XDG_LIB_HOME`    | `~/.local/lib`
`XDG_CACHE_HOME`  | `~/.local/var/cache`

---


### Applying Dotfiles

There are several different approaches to managing dotfiles. The two most common would be either symlinking, or git bare repo.

#### Option 1 - Symlinking

Symlinks let you maintain all your dotfiles in a working directory, and then link them to the appropriate places on disk, sort of like shortcuts.

For example, if your dotfiles are in `~/Documents/dotfiles`, you could create a zshrc file there, and link it with:

```bash
ln -s ~/Documents/dotfiles/zsh/.zshrc ~/.zshrc
``` 

This would obviously get cumbersome very quickly if you had a lot of files, so you would really want to automate this process. You could either create your own script to do this, or use a tool specifically designed for this.

I personally use [Dotbot](https://github.com/anishathalye/dotbot), as it doesn't have any dependencies - just include it as a sub-module, define a list of links in a simple YAML file, and hit go.
[GNU Stow](https://www.gnu.org/software/stow/) is also a popular choice, and it's usage is explained well in [this article](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/) by Alex Pearce.
There's many other tools which do a similar thing, like [Homesick](https://github.com/technicalpickles/homesick), [Rcm](https://github.com/thoughtbot/rcm), [dotdrop](https://github.com/deadc0de6/dotdrop) or [mackup](https://github.com/lra/mackup).

#### Option 2 - Git Bare Repo

Bare repositories let you add files from anywhere on your system, maintaining the original directory structure, and without the need for symlinks ([learn more](https://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)). Just initiialize or clone using the [`--bare`](https://git-scm.com/docs/git-clone#Documentation/git-clone.txt---bare) flag, then add a global alias to manage files with git.

```bash
# Initialise a new repo, or clone an existing one with the --bare flag
git init --bare $HOME/dotfiles

# Next create an alias that sets the directory to your dotfile (add to .zshrc/ .bashrc)
alias dotfiles='$(where git) --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Hide untracked files
dotfiles config --local status.showUntrackedFiles no
```

Then, from anywhere in your system you can use your newly created alias to add, commit and push files to your repo using all the normal git commands, as well as pull them down onto another system.

```bash
dotfiles add ~/.config/my-file
dotfiles commit -m "A short message"
dotfiles push
```

Both [Chezmoi](https://github.com/twpayne/chezmoi/) and [YADM](https://github.com/TheLocehiliosan/yadm) are a dotfile management tools, which wrap bare git repo functionality, adding some additional QoL features.

To learn more, DistroTube made an excellent [video about bare git repos](https://www.youtube.com/watch?v=tBoLDpTWVOM), and Marcel Krčah has written [a post](https://marcel.is/managing-dotfiles-with-git-bare-repo/) outlining the benefits.


---

### Containerized Userspace

You can also containerize your dotfiles, meaning with a single command, you can spin up a fresh virtual environment on any system, and immediately feel right at home with all your packages and configurations.

This is awesome for a number of reasons: 1) Super minimal dependency installation on the host 2) Blazing fast, as you can pull your built image from a registry, instead of compiling everything locally 3) Cross-platform compatibility, whatever your host OS is, you can always have a familiar Linux system in the container 4) Security, you can control which host resources are accessible within each container

For this, I'm using an Alpine-based Docker container defined in the [`Dockerfile`](https://github.com/Lissy93/dotfiles/blob/master/Dockerfile), to try it out, just run `docker run lissy93/dotfiles`.

Other options could include spinning up VMs with a predefined config, either using something like [Vagrant](https://www.vagrantup.com/) or a [NixOS](https://nixos.org/)-based config.

---

### Security

Something that is important to keep in mind, is security. Often you may have some personal info included in some of your dotfiles. Before storing anything on the internet, double check there's no sensitive info, SSH keys, API keys or plaintext passwords. If you're using git, then any files you wouldn't want to be commited, can just be listed in your [`.gitignore`](https://git-scm.com/docs/gitignore). If any .gitignore'd files are imported by other files, be sure to check they exist, so you don't get errors when cloning onto a fresh system.

Another solution, is to encrypt sensitive info. A great tool for this is [`pass`](https://www.passwordstore.org/) as it makes GPG-encrypting passwords very easy ([this article](https://www.outcoldman.com/en/archive/2015/09/17/keep-sensitive-data-encrypted-in-dotfiles/) outlines how), or you could also just use plain old GPG (as outlined in [this article](https://www.abdullah.today/encrypted-dotfiles/)).


---

## My Dotfiles

### Setup

> **Warning**
> Prior to running the setup script, read through everything and confirm it's what you want.

To set everything up, just recursivley clone the repo, cd into it, allow execution of `install.sh` then run it to install.

```bash
git clone --recursive git@github.com:Lissy93/dotfiles.git ~/.dotfiles
chmod +x ~/.dotfiles/install.sh
~/.dotfiles/install.sh
```

---

### Configuring

The locations for all symlinks are defined in [`.install.conf.yaml`](https://github.com/Lissy93/dotfiles/blob/master/.install.conf.yaml). These are managed using [Dotbot](https://github.com/anishathalye/dotbot), and will be applied whenever you run the [`install.sh`](https://github.com/Lissy93/dotfiles/blob/master/install.sh) script. 

The bootstrap configurations are idempotent (and so the installer can be run multiple times without causing any problems). To only install certain parts of the config, pass the `--only` flag to the install.sh script, similarly `--except` can be used to exclude certain directives.

---

### Aliases

#### Into to Aliases

An alias is simply a command shortcut. These are very useful for long or frequently used commands.

For example, if you frequently find yourself typing `git add .` you could add an alias like `alias gaa='git add .'`, then just type `gaa`. You can also override existing commands, for example to always show hidden files with `ls` you could set `alias ls='ls -a'`.

Aliases should almost always be created at the user-level, and then sourced from your shell config file (usually `.bashrc` or `.zshrc`). System-wide aliases would be sourced from `/etc/profile`. Don't forget that for your changes to take effect, you'll need to restart your shell, or re-source the file containing your aliases, e.g. `source ~/.zshrc`.

You can view a list of defined aliases by running `alias`, or search for a specific alias with `alias | grep 'search-term'`. The `unalias` command is used for removing aliases.

The following section lists the aliases used in my dotfiles.


<details>

<summary><b>Git Aliases</b></summary>

> [`zsh/aliases/git.zsh`](https://github.com/Lissy93/dotfiles/blob/master/zsh/aliases/git.zsh)

Alias | Description
---|---
`g` | git
`gs` | `git status` - List changed files
`ga` | `git add` - Add <files> to the next commit
`gaa` | `git add .` - Add all changed files
`grm` | `git rm` - Remove <file>
`gc` | `git commit` - Commit staged files, needs -m ""
`gcm` | `git commit` takes $1 as commit message
`gps` | `git push` - Push local commits to <origin> <branch>
`gpl` | `git pull` - Pull changes with <origin> <branch>
`gf` | `git fetch` - Download branch changes, without modifying files
`grb` | `git rebase` - Rebase the current HEAD into <branch>
`grba` | `git rebase --abort` - Cancel current rebase sesh
`grbc` | `git rebase --continue` - Continue onto next diff
`gm` | `git merge` - Merge <branch> into your current HEAD
`gi` | `git init` - Initiialize a new empty local repo
`gcl` | `git clone` - Downloads repo from <url>
`gch` | `git checkout` - Switch the HEAD to <branch>
`gb` | `git branch` - Create a new <branch> from HEAD
`gd` | `git diff` - Show all changes to untracked files
`gtree` | `git log --graph --oneline --decorate` # Show branch tree
`gl` | `git log`
`gt` | `git tag` - Tag the current commit, 1 param
`gtl` | `git tag -l` - List all tags, optionally with pattern
`gtlm` | `git tag -n` - List all tags, with their messages
`gtp` | `git push --tags` - Publish tags
`gr` | `git remote`
`grs` | `git remote show` - Show current remote origin
`grl` | `git remote -v` - List all currently configured remotes
`grr` | `git remote rm origin` - Remove current origin
`gra` | `git remote add` - Add new remote origin
`grurl` | `git remote set-url origin` - Sets URL of existing origin
`guc` | `git revert` - Revert a <commit>
`gu` | `git reset` - Reset HEAD pointer to a <commit>, perserves changes
`gua` | `git reset --hard HEAD` - Resets all uncommited changes
`gnewmsg` | `git commit --amend -m` - Update <message> of previous commit
`gclean` | `git clean -df` - Remove all untracked files
`glfsi` | `git lfs install`
`glfst` | `git lfs track`
`glfsls` | `git lfs ls-files`
`glfsmi` | `git lfs migrate import --include=`
`gplfs` | `git lfs push origin "$(git_current_branch)" --all` - Push LFS changes to current branch
`gj` | Find and cd into the root of your current project (based on where the .git directory
`clone` | Shorthand for clone, run `clone user/repo`, if user isn't specified will default to yourself
`gsync` | Sync fork against upstream repo
`gfrb` | Fetch, rebase and push updates to current branch. Optionally specify target, defaults to 'master'
`gignore` | Integrates with gitignore.io to auto-populate .gitignore file
`gho` | Opens the current repo + branch in GitHub
`ghp` | Opens pull request tab for the current GH repo


</details>


<details>

<summary><b>Flutter Aliases</b></summary>

> [`zsh/aliases/flutter.zsh`](https://github.com/Lissy93/dotfiles/blob/master/zsh/aliases/flutter.zsh)

Alias | Description
---|---
`fl` | flutter - Main fultter command
`flattach` | `flutter attach` - Attaches flutter to a running flutter application with enabled observatory
`flb` | `flutter build` - Build flutter application
`flchnl` | `flutter channel` - Switches flutter channel (requires input of desired channel)
`flc` | `flutter clean` - Cleans flutter project
`fldvcs` | `flutter devices` - List connected devices (if any)
`fldoc` | `flutter doctor` - Runs flutter doctor
`flpub` | `flutter pub` - Shorthand for flutter pub command
`flget` | `flutter pub get` - Installs dependencies
`flr` | `flutter run` - Runs flutter app
`flrd` | `flutter run --debug` - Runs flutter app in debug mode (default mode)
`flrp` | `flutter run --profile` - Runs flutter app in profile mode
`flrr` | `flutter run --release` - Runs flutter app in release mode
`flupgrd` | `flutter upgrade` - Upgrades flutter version depending on the current channel

</details>


<details>

<summary><b>Node.js Aliases</b></summary>

> [`zsh/aliases/node-js.zsh`](https://github.com/Lissy93/dotfiles/blob/master/zsh/aliases/node-js.zsh)


##### Yarn

Alias | Description
---|---
`ys` | `yarn start`
`yt` | `yarn test`
`yb` | `yarn build`
`yl` | `yarn lint`
`yd` | `yarn dev`
`yp` | `yarn publish`
`yr` | `yarn run`
`ya` | `yarn add`
`ye` | `yarn remove`
`yi` | `yarn install`
`yg` | `yarn upgrade`
`yu` | `yarn update`
`yf` | `yarn info`
`yz` | `yarn audit`
`yc` | `yarn autoclean`
`yk` | `yarn check`
`yh` | `yarn help`
`yarn-nuke` | Removes node_modules, yarn.lock, package-lock.json and does a full fresh reinstall of dependencies
`yv` | Prints out the current version of Node.js, Yarn, NPM, NVM and git

##### NPM

Alias | Description
---|---
`npmi` | `npm install`
`npmu` | `npm uninstall`
`npmr` | `npm run`
`npms` | `npm start`
`npmt` | `npm test`
`npml` | `npm run lint`
`npmd` | `npm run dev`
`npmp` | `npm publish`
`npmo` | Opens NPM docs, either for the current package, or a specific dependency passes as param

##### NVM

Alias | Description
---|---
`nvmi` | `nvm install`
`nvmu` | `nvm use`
`nvml` | `nvm ls`
`nvmr` | `nvm run`
`nvme` | `nvm exec`
`nvmw` | `nvm which`
`nvmlr` | `nvm ls-remote`
`nvmlts` | `nvm install --lts && nvm use --lts`
`nvmlatest` | `nvm install node --latest-npm && nvm use node`
`nvmsetup` | Runs the NVM installation script, and sets up the NVM environment


</details>


<details>

<summary><b>General Aliases</b></summary>

> [`zsh/aliases/general.zsh`](https://github.com/Lissy93/dotfiles/blob/master/zsh/aliases/general.zsh)


##### Single-Letter Frequently-Used Commands (only set if not already in use)

Alias | Description
---|---
`a` | alias`
`c` | `clear`
`d` | `date`
`e` | `exit`
`f` | `find`
`g` | `grep`
`h` | `history`
`i` | `id`
`j` | `jobs`
`l` | `ls`
`m` | `man`
`p` | `pwd`
`s` | `sudo`
`t` | `touch`
`v` | `vim`

##### File listing options

Alias | Description
---|---
`la` | `ls -A` - List all files/ includes hidden
`ll` | `ls -lAFh` - List all files, with full details
`lm` | `ls -tA -1` - List files sorted by last modified
`lb` | `ls -lhSA` - List all files sorted by biggest
`lr` | `ls -R` - List files in sub-directories, recursivley
`lf` | `ls -A \| grep` - Use grep to find files
`ln` | `find . -type f \| wc -l` - Shows number of files
`ld` | `ls -l \| grep "^d"` - List directories only
`la` | `exa -aF --icons` - List all files, including hidden (only if `exa` is installed)
`ll` | `exa -laF --icons` - Show files with all details (only if `exa` is installed)
`lm` | `exa -lahr --color-scale --icons -s=modified` - Sort by date modified, most revent first (only if `exa` is installed)
`lb` | `exa -lahr --color-scale --icons -s=size` - Sort by size largest first (only if `exa` is installed)
`tree` | `f() { exa -aF --tree -L=${1:-2} --icons };f` - List files as tree (only if `exa` is installed)
`lz` | List the contents of a specified compressed archive. Supported formats include zip, rar, tar, tar.gz and ace

##### Getting Around

Alias | Description
---|---
`mkcd` | Create new directory, and cd into it. Takes new directory name as param
`mkcp` | Copies a directory, and navigates into it
`mkmv` | Moves a directory, and navigates into it

# Getting outa directories

Alias | Description
---|---
`c~` | Navigate to ~
`c.` | Go up 1 directory
`c..` | Go up 2 directories
`c...` | Go up 3 directories
`c....` | Go up 4 directories
`c.....` | Go up 5 directories
`cg` | Navigate to base of git project

##### Finding files and directories

Alias | Description
---|---
`dud` | `du -d 1 -h` - List sizes of files within directory
`duf` | `du -sh *` - List total size of current directory
`ff` | `find . -type f -name` - Find a file by name within current directory
`fd` | `find . -type d -name` - Find direcroy by name

##### Command line history

Alias | Description
---|---
`h` | `history` - Shows full history
`h-search` | `fc -El 0 \| grep` - Searchses for a word in terminal history
`top-history` | `history 0 \| awk '{print $2}' \| sort \| uniq -c \| sort -n -r \| head` - Most used

##### Head / tail shortcuts

Alias | Description
---|---
`H` | `\| head` - Pipes output to head (the first part of a file)
`T` | `\| tail` - Pipes output to tail (the last part of a file)
`G` | `\| grep` - Pipes output to grep to search for some word
`L` | `\| less` - Pipes output to less, useful for paging
`M` | `\| most` - Pipes output to more, useful for paging
`LL` | `2>&1 \| less` - Writes stderr to stdout and passes it to less
`CA` | `2>&1 \| cat -A` - Writes stderr to stdout and passes it to cat
`NE` | `2> /dev/null` - Silences stderr
`NUL` | `> /dev/null 2>&1` - Silences both stdout and stderr
`P` | `2>&1\| pygmentize -l pytb` - Writes stderr to stdout, and passes to pygmentize

##### Find + manage aliases

Alias | Description
---|---
`al` | `alias \| less` - List all aliases
`as` | `alias \| grep` - Search aliases
`ar` | `unalias` - Remove given alias

##### System Monitoring

Alias | Description
---|---
`meminfo` | `free -m -l -t` - Show free and used memory
`memhog` | `ps -eo pid,ppid,cmd,%mem --sort=-%mem \| head` - Processes consuming most mem
`cpuhog` | `ps -eo pid,ppid,cmd,%cpu --sort=-%cpu \| head` - Processes consuming most cpu
`cpuinfo` | `lscpu` - Show CPU Info
`distro` | `cat /etc/*-release` - Show OS info

##### Utilities

Alias | Description
---|---
`myip` | `curl icanhazip.com` - Fetches and displays public IP
`weather` | `curl wttr.in` - Fetches and displays local weather
`weather-short` | `curl "wttr.in?format=3"`
`cheat` | `curl cheat.sh/` - Gets manual for a Linux command
`tinyurl` | `curl -s "http://tinyurl.com/api-create.php?url=` - URL shortening
`ports` | `netstat -tulanp` - List currently used ports
`crypto` | `cointop` - Launch cointop (only registered if installed)
`gto` | `gotop` - Launch gotop (only registered if installed)

##### Random lolz

Alias | Description
---|---
`cls` | `clear;ls` - Clear and ls
`plz` | `fc -l -1 | cut -d' ' -f2- | xargs sudo` - Re-run last cmd as root
`yolo` | `git add .; git commit -m "YOLO"; git push origin master` - Why not..
`when` | `date` - Show date
`whereami` | `pwd` - Just show current path
`dog` | `cat` - I don't know why...
`gtfo` | `exit` - This just feels better than exit


</details>



---

### Utilities

// TODO

---

### Packages


The dotfiles can also optionally install any packages that you may need. This is useful for quickly setting up new systems, but it's important that you remove / comment out any packages that you don't need.

The list of software is stored in the [`installs/`]() directory, and the file that's used will vary depending on the host operating system.

- Arch (and Arch-based systems, like Manjaro) - []() uses pacman
- Debian (and Debian-based systems, like Ubuntu) - []() uses apt
- Alpine - []() uses [apk](https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html)
- Mac OS - [`.Brewfile`]() uses [Homebrew](https://brew.sh/)
- Windows - [`windows.sh`]() uses [winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/) and [scoop](https://scoop.sh/)


---

### ZSH

// TODO

---

### Vim

The entry point for the Vim config is the [`vimrc`](https://github.com/Lissy93/dotfiles/blob/master/vim/vimrc), but the main editor settings are defined in [`vim/editor.vim`](https://github.com/Lissy93/dotfiles/blob/master/vim/editor.vim)

##### Plugins

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


---

### Tmux


Fairly standard Tmux configuration, strongly based off Tmux-sensible. Configuration is defined in [`.tmux.conf`](https://github.com/Lissy93/dotfiles/blob/master/tmux/tmux.conf)

Tmux plugins are managed using [TMP](https://github.com/tmux-plugins/tpm) and defined in [`.tmux.conf`](https://github.com/Lissy93/dotfiles/blob/master/tmux/tmux.conf). To install them from GitHub, run `prefix` + <kbd>I</kbd> from within Tmux, and they will be cloned int `~/.tmux/plugins/`.

##### Plugins

- [Tmux-sensible](https://github.com/tmux-plugins/tmux-sensible): `tmux-plugins/tmux-sensible` - General, sensible Tmux config
- [Tmux-continuum](https://github.com/tmux-plugins/tmux-continuum): `tmux-plugins/tmux-continuum` - Continuously saves and environment with automatic restore
- [Tmux-yank](https://github.com/tmux-plugins/tmux-yank): `tmux-plugins/tmux-yank` - Allows access to system clipboard
- [Tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight): `tmux-plugins/tmux-prefix-highlight` - Highlight Tmux prefix key when pressed
- [Tmux-online-status](https://github.com/tmux-plugins/tmux-online-status): `tmux-plugins/tmux-online-status` - Displays network status
- [Tmux-open](https://github.com/tmux-plugins/tmux-open): `tmux-plugins/tmux-open` - Bindings for quick opening selected path/ url
- [Tmux-mem-cpu-load](https://github.com/thewtex/tmux-mem-cpu-load): `thewtex/tmux-mem-cpu-load` - Shows system resources


---

### Git

// TODO


---

## Dependencies

These dot files make use of the following packages, and hence they are required

- [zsh](https://www.zsh.org/) - Interactive Shell
- [nvim](http://neovim.io/) - Extensible Vim-based text editor
- [tmux](https://github.com/tmux/tmux) - Detachable terminal multiplexer
- [ranger](https://ranger.github.io/) - CLI-based file manager with VI bindings
- [git](https://git-scm.com/) - Version control system

They can be easily installed/ updated with your package manger, e.g:
- Ubuntu Server: `sudo apt install -y zsh neovim tmux ranger git`
- Arch Linux:  `sudo pacman -S zsh neovim tmux ranger git`
- Alpine: `apk add zsh neovim tmux ranger git`
- MacOS: `brew install zsh neovim tmux ranger git`

Depending on your setup, the following utils may also be required: `make`, `ctags`, `fzf` and `python3-pip`

