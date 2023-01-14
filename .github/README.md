<h1 align="center"><code>~/.Dotfiles</code></h1>
<p align="center"><i>My dotfiles for configuring literally everything (automatically!)</i></p>
<p align="center">
  <a href="https://github.com/lissy93/dotfiles" title="Automate all the things!">
    <img width="140" src="https://github.com/Lissy93/dotfiles/raw/master/.github/logo.png" />
  </a>
</p>
<h3 align="center"><code>$HOME, sweet $HOME</code></h3>

## Contents
- [Introduction to Dotfiles](#intro)
    - [What are dotfiles?](#what-are-dotfiles)
    - [Why do you need them?](#why-you-need-a-dotfile-system)
    - [XDG Directories](#xdg-directories)
    - [Containerized Userspace](#containerized-userspace)
    - [Security](#security)
    - [Dotfile Management Systems](#dotfile-management-systems)
    - [So copy paste, right?](#so-copy-paste-right)
- [My Dots](#my-dotfiles)
    - [Setup](#setup)
    - [Directory Structure](#directory-structure)
    - [Install Script](#install-script)
    - [Configuring](#configuring)
    - [Colors](#color-theme)
    - [Aliases](#aliases)
    - [Packages](#packages)
    - [System Preferences](#system-preferences)
    - [Config Files](#config-files)
    - [ZSH](#zsh)
    - [Vim](#vim)
    - [Tmux](#tmux)
    - [Git](#git)
    - [Dependencies](#dependencies)
    - [Utilities](#utilities)
        
---

## Intro

### What are dotfiles?

One of the beautiful things about Linux, is how easily customizable everything is. Usually these custom configurations are stored in files that start with a dot (hence dotfiles!), and typically located in your users home `~`, or better yet `~/.config` (even this can be customized, for apps that respect the XDG Base Directory spec). Some examples of dotfiles that you're likely already familiar with include `.gitconfig`, `.zshrc` or `.vimrc`.

You will often find yourself tweaking your configs over time, so that your system perfectly matches your needs. It makes sense to back these files up, so that you don't need to set everything up from scratch each time you enter a new environment. Git is a near-perfect system for this, as it allows for easy roll-backs, branches and it's well supported with plenty of hosting options (like here on GitHub).

Once everything's setup, you'll be able to SSH into a fresh system or reinstall your OS, then just run your script and go from zero to feeling at right at home within a minute or two.

It's not hard to create your own dotfile repo, it's great fun and you'll learn a ton along the way!

---

### Why you need a Dotfile System?

By using a dotfile system, you can set up a brand new machine in minutes, keep settings synced across multiple environments, easily roll-back changes, and never risk loosing your precious config files. 

This is important, because as a developer, we usually have multiple machines (work / personal laptops, cloud servers, virtual machines, some GH codespaces, maybe a few Pis, etc). And you're much more productive when working from a familiar environment, with all your settings applied just how you like them. But it would be a pain to have to set each of these machines up manually. Even if you've only got a single device, how much time would you loose if your data became lost or corrupted?

---

### XDG Directories

The location of most config files can be defined using the [XDG base directory specification](https://specifications.freedesktop.org/basedir-spec), which is honored by most apps. This lets you specify where config, log, cache and data files are stored, keeping your top-level home directory free from clutter. You can do this by setting environmental variables, usually within the [`.zshenv`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh.zshenv) file.

Variable | Location
--- | ---
`XDG_CONFIG_HOME` | `~/.config`
`XDG_DATA_HOME`   | `~/.local/share`
`XDG_BIN_HOME`   | `~/.local/bin`
`XDG_LIB_HOME`    | `~/.local/lib`
`XDG_CACHE_HOME`  | `~/.local/var/cache`

---

### Containerized Userspace

You can also containerize your dotfiles, meaning with a single command, you can spin up a fresh virtual environment on any system, and immediately feel right at home with all your configurations, packages, aliases and utils.

This is awesome for a number of reasons: 1) Super minimal dependency installation on the host 2) Blazing fast, as you can pull your built image from a registry, instead of compiling everything locally 3) Cross-platform compatibility, whatever your host OS is, you can always have a familiar Linux system in the container 4) Security, you can control which host resources are accessible within each container

For this, I'm using an Alpine-based Docker container defined in the [`Dockerfile`](https://github.com/Lissy93/dotfiles/blob/master/Dockerfile), to try it out, just run `docker run lissy93/dotfiles`.

Other options could include spinning up VMs with a predefined config, either using something like [Vagrant](https://www.vagrantup.com/) or a [NixOS](https://nixos.org/)-based config.

---

### Security

Something that is important to keep in mind, is security. Often you may have some personal info included in some of your dotfiles. Before storing anything on the internet, double check there's no sensitive info, SSH keys, API keys or plaintext passwords. If you're using git, then any files you wouldn't want to be commited, can just be listed in your [`.gitignore`](https://git-scm.com/docs/gitignore). If any .gitignore'd files are imported by other files, be sure to check they exist, so you don't get errors when cloning onto a fresh system.

Another solution, is to encrypt sensitive info. A great tool for this is [`pass`](https://www.passwordstore.org/) as it makes GPG-encrypting passwords very easy ([this article](https://www.outcoldman.com/en/archive/2015/09/17/keep-sensitive-data-encrypted-in-dotfiles/) outlines how), or you could also just use plain old GPG (as outlined in [this article](https://www.abdullah.today/encrypted-dotfiles/)).

---


### Dotfile Management Systems

In terms of managing and applying your dotfiles, you can make things simple, or complex as you like.

The two most common approaches are be either [symlinking](#option-1---symlinking), or using [git bare repo](#option-2---git-bare-repo), but you could also do things manually by writing a simple script.

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

#### Dotfile Dependencies

In terms of managing dependencies, using either [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) or [git subtree](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt) will let you keep dependencies in your project, while also separate from your own code and easily updatable.


---

### So copy paste, right?

Zach Holman wrote a great article titled [Dotfiles Are Meant to Be Forked](https://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/). I personally disagree with this, since your dotfiles are usually highly personalized, so what's right for one developer, likely won't be what someone else is looking for. They're also typically something you build up over time, and although some repos may provide a great starting point, it's really important to know what everything does, and how it works.

By all means feel free to take what you want from mine. I've taken care to ensure that each file is standalone, and well documented so that certain files can just be dropped into any system. But I cannot stress enough the importance of reading through files to ensure it's actually what you want. 

If you're looking for some more example dotfile repos to get you started, I can highly recommend taking a look at: [@holman/dotfiles](https://github.com/holman/dotfiles), [@nickjj/dotfiles](https://github.com/nickjj/dotfiles), [@caarlos0/dotfiles](https://github.com/caarlos0/dotfiles), [@cowboy/dotfiles](https://github.com/cowboy/dotfiles), [@drduh/config](https://github.com/drduh/config).

There's even more to check out at [webpro/awesome-dotfiles](https://github.com/webpro/awesome-dotfiles), [dotfiles.github.io](https://dotfiles.github.io/) and [r/unixporn](https://www.reddit.com/r/unixporn/).

---

## My Dotfiles

<p align="center"><img width="380" src="https://i.ibb.co/rH30RbM/Dotfiles.png" /></p>

### Setup

> **Warning**
> Prior to running the setup script, read through everything and confirm it's what you want.

Let's Go!

```bash
bash <(curl -s https://raw.githubusercontent.com/Lissy93/dotfiles/master/lets-go.sh)
```

This will execute the quick setup script (in [`lets-go.sh`](https://github.com/Lissy93/dotfiles/blob/master/lets-go.sh)), which just clones the repo (if not yet present), then executes the [`install.sh`](https://github.com/Lissy93/dotfiles/blob/master/install.sh) script. You can re-run this at anytime to update the dotfiles. You can also optionally pass in some variables to change the install location (`DOTFILES_DIR`) and source repo (`DOTFILES_REPO`) to use your fork.

The install script [does several things](#install-script), it takes care of checking dependencies are met, updating dotfiles and symlinks, configuring CLI (Vim, Tmux, ZSH, etc), and will prompt the user to install listed packages, update the OS and apply any system preferences. The script is idempotent, so it can be run multiple times without changing the result, beyond the initial application.

_Alternatively, you can clone the repo yourself, cd into it, allow execution of [`install.sh`](https://github.com/Lissy93/dotfiles/blob/master/install.sh) then run it to install or update._

<details>
<summary>Example</summary>


```bash
git clone --recursive git@github.com:Lissy93/dotfiles.git ~/.dotfiles
chmod +x ~/.dotfiles/install.sh
~/.dotfiles/install.sh
```

You'll probably want to fork the repo, then clone your fork instead, so update the above commands with the path to your repo, and optionally change the clone location on your disk.

Once the repo is cloned, you can modify whatever files you like before running the install script. The [Directory Structure](#directory-structure) section provides an overview of where each file is located. Then see the [Configuring](#configuring) section for setting file paths and symlink locations. 

</details>

---


### Directory Structure

<pre>
~
└──.
   ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/config">config/</a>               # All configuration files
   │ ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/bash">bash/</a>               # Bash (shell) config
   │ ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/tmux">tmux/</a>               # Tmux (multiplexer) config
   │ ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/vim">vim/</a>                # Vim (text editor) config
   │ ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/zsh">zsh/</a>                # ZSH (shell) config
   │ ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/macos">macos/</a>              # Config files for Mac-specific apps
   │ └── <a href="https://github.com/Lissy93/dotfiles/tree/master/desktop-apps">desktop-apps/</a>       # Config files for GUI apps
   ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/scripts">scripts/</a>              # Bash scripts for automating tasks
   │ ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/scripts/installs">installs/</a>           # Scripts for software installation
   │ │ ├── <a href="https://github.com/Lissy93/dotfiles/blob/master/scripts/installs/Brewfile">Brewfile</a>          # Package installs for MacOS via Homebrew
   │ │ ├── <a href="https://github.com/Lissy93/dotfiles/blob/master/scripts/installs/arch-pacman.sh">arch-pacman.sh</a>    # Package installs for Arch via Pacman
   │ │ └── <a href="https://github.com/Lissy93/dotfiles/blob/master/scripts/installs/flatpak.sh">flatpak.sh</a>        # Package installs for Linux desktops via Flatpak
   │ ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/scripts/linux">linux/</a>              # Automated configuration for Linux
   │ │ └── <a href="https://github.com/Lissy93/dotfiles/blob/master/scripts/linux/dconf-prefs.sh">dconf-prefs.sh</a>    # Setting GNOME settings via dconf util
   │ └── <a href="https://github.com/Lissy93/dotfiles/tree/master/scripts/macos-setup">macos-setup/</a>        # Scripts for setting up Mac OS machines
   │   ├── <a href="https://github.com/Lissy93/dotfiles/blob/master/scripts/macos-setup/macos-apps.sh">macos-apps.sh</a>     # Sets app preferences
   │   ├── <a href="https://github.com/Lissy93/dotfiles/blob/master/scripts/macos-setup/macos-preferences.sh">macos-prefs.sh</a>    # Sets MacOS system preferences
   │   └── <a href="https://github.com/Lissy93/dotfiles/blob/master/scripts/macos-setup/macos-security.sh">macos-security.sh</a> # Applies MacOS security and privacy settings
   ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/utils">utils/</a>                # Handy Shell utilitis for various day-to-day tasks
   ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/.github">.github/</a>              # Meta files for GitHub repo
   ├── <a href="https://github.com/Lissy93/dotfiles/tree/master/lib">lib/</a>                  # External dependencies, as git sub-modules
   ├── <a href="https://github.com/Lissy93/dotfiles/blob/master/lets-go.sh">lets-go.sh</a>            # One-line remote installation entry point
   ├── <a href="https://github.com/Lissy93/dotfiles/blob/master/install.sh">install.sh</a>            # All-in-one install and setup script
   └── <a href="https://github.com/Lissy93/dotfiles/blob/master/symlinks.yaml">symlinks.yml</a>          # List of symlink locations
</pre>


---

### Install Script

The setup script ([`install.sh`](https://github.com/Lissy93/dotfiles/blob/master/install.sh)) will do the following:

- **Setup**
  - Print welcome message, and a summary of proposed changes, and prompt user to continue
  - Ensure that core dependencies are met (git, zsh, vim)
  - Set variables by reading any passed parameters, or fallback to sensible defaults (see [`.zshenv`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/.zshenv))  
- **Dotfiles**
  - If dotfiles not yet present, will clone from git, otherwise pulls latest changes
  - Setup / update symlinks each file to it's correct location on disk
- **System Config**
  - Checks default shell, if not yet set, will prompt to set to zsh
  - Installs Vim plugins via Plug
  - Installs Tmux plugins via TPM
  - Installs ZSH plugins via Antigen
  - Prompts to apply system preferences (for compatible OS / DE)
  - On MacOS arranges apps into folders within the Launchpad view
  - On MacOS prompts to set essential privacy + security settings
  - On MacOS prompts to set system preferences and app settings
- **App Installations**
  - On MacOS if Homebrew is not yet installed, will prompt to install it
  - On MacOS will prompt to install user apps listed in Brewfile, via Homebrew
  - On Linux will prompt to install listed CLI apps via native package manager (pacman or apt)
  - On Linux desktop systems, will prompt to istall desktop apps via Flatpak
  - Checks OS is up-to-date, prompts to install updates if available
- **Finishing up**
  - Outputs time taken and a summary of changes applied
  - Re-sources ZSH and refreshes current session
  - Prints a pretty Tux ASCII picture
  - Exits

The install script can accept several flags and environmental variables to configure installation:
- **Flags**
  - `--help` - Prints help menu / shows info, without making any changes
  - `--auto-yes` - Doesn't prompt for any user input, always assumes Yes (use with care!)
  - `--no-clear` - Doesn't clear the screen before starting (useful if being run by another app)
- **Env Vars**
  - `REPO_NAME` - The repository name to pull, e.g. `Lissy93/Dotfiles`
  - `DOTFILES_DIR` - The directory to clone source dotfiles into

---

### Configuring

The locations for all symlinks are defined in [`symlinks.yaml`](https://github.com/Lissy93/dotfiles/blob/master/symlinks.yaml). These are managed using [Dotbot](https://github.com/anishathalye/dotbot), and will be applied whenever you run the [`install.sh`](https://github.com/Lissy93/dotfiles/blob/master/install.sh) script. The symlinks set locations based on XDG paths, all of which are defined in [`.zshenv`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/.zshenv).

---

## Color Theme

---

### Aliases

#### Into to Aliases

An alias is simply a command shortcut. These are very useful for shortening long or frequently used commands.

<details>
<summary>How to use Aliases</summary>

For example, if you often find yourself typing `git add .` you could add an alias like `alias gaa='git add .'`, then just type `gaa`. You can also override existing commands, for example to always show hidden files with `ls` you could set `alias ls='ls -a'`.

Aliases should almost always be created at the user-level, and then sourced from your shell config file (usually `.bashrc` or `.zshrc`). System-wide aliases would be sourced from `/etc/profile`. Don't forget that for your changes to take effect, you'll need to restart your shell, or re-source the file containing your aliases, e.g. `source ~/.zshrc`.

You can view a list of defined aliases by running `alias`, or search for a specific alias with `alias | grep 'search-term'`. The `unalias` command is used for removing aliases.

</details>

#### My Aliases

All aliases in my dotfiles are categorised into files located in [`zsh/aliases/`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/aliases/) which are imported in [`zsh/.zshrc`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/.zshrc#L9-L14).

The following section lists all (or most) the aliases by category:

<details>

<summary><b>Git Aliases</b></summary>

> [`zsh/aliases/git.zsh`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/aliases/git.zsh)

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

> [`zsh/aliases/flutter.zsh`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/aliases/flutter.zsh)

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

> [`zsh/aliases/node-js.zsh`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/aliases/node-js.zsh)


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

> [`zsh/aliases/general.zsh`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/aliases/general.zsh)


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

##### Getting outa directories

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

### Packages

The dotfile installation script can also, detect which system and environemnt you're running, and optionally prompt to update and install listed packages and applications.

Package lists are stored in [`scripts/installs/`](https://github.com/Lissy93/dotfiles/tree/master/scripts/installs) directory, with separate files for different OSs. The install script will [pick the appropriate file](https://github.com/Lissy93/dotfiles/blob/22c6a04fdb22c140448b7d15ef8187c3a424ab47/install.sh#L243-L260) based on your distro.

You will be prompted before anything is installed. Be sure to remove / comment out anything you do not need before proceeding.

- Linux (desktop): [`flatpak.sh`](https://github.com/Lissy93/dotfiles/blob/master/scripts/installs/flatpak.sh) - Desktop apps can be installed on Linux systems via [Flatpack](https://flatpak.org/)
- Mac OS: [`Brewfile`](https://github.com/Lissy93/dotfiles/blob/master/scripts/installs/Brewfile) - Mac apps installed via [Homebrew](https://brew.sh/)
- Arch (and Arch-based systems, like Manjaro): [`arch-pacman.sh`](https://github.com/Lissy93/dotfiles/blob/master/scripts/installs/arch-pacman.sh) - Arch CLI apps installed via [pacman](https://wiki.archlinux.org/title/Pacman)
- Debian (and Debian-based systems, like Ubuntu): [`debian-apt.sh`](https://github.com/Lissy93/dotfiles/blob/master/scripts/installs/debian-apt.sh) - Debian CLI apps installed via [apt](https://wiki.debian.org/Apt)
- Alpine: [`aplpine-apk.sh`](https://github.com/Lissy93/dotfiles/blob/master/scripts/installs/aplpine-apk.sh) - Alpine CLI apps installed via [apk](https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html)

The following section lists apps installed for each category:

#### Command Line

<details>
<summary>CLI Essentials</summary>

- [`git`](https://git-scm.com/) - Version controll
- [`neovim`](https://neovim.io/) - Text editor
- [`ranger`](https://ranger.github.io/) - Directory browser
- [`tmux`](https://github.com/tmux/tmux/wiki) - Term multiplexer

</details>

<details>
<summary>CLI Basics</summary>

- [`aria2`](https://github.com/aria2/aria2) - Resuming download util _(better wget)_
- [`bat`](https://github.com/sharkdp/bat) - Output highlighting _(better cat)_
- [`ctags`](https://github.com/universal-ctags/ctags) - Indexing of file info + headers
- [`diff-so-fancy`](https://github.com/so-fancy/diff-so-fancy) - Readable file compares _(better diff)_
- [`entr`](https://eradman.com/entrproject/) - Run command whenever file changes
- [`duf`](https://github.com/muesli/duf) - Get info on mounted disks _(better df)_
- [`exa`](https://github.com/ogham/exa) - Listing files with info _(better ls)_
- [`exiftool`](https://exiftool.org/) - Reading and writing exif metadata
- [`fdupes`](https://github.com/jbruchon/jdupes) - Duplicate file finder
- [`fzf`](https://github.com/junegunn/fzf) - Fuzzy file finder and filtering
- [`hyperfine`](https://github.com/sharkdp/hyperfine) - Benchmarking for arbitrary commands
- [`jq`](https://github.com/stedolan/jq) - JSON parser
- [`most`](https://www.jedsoft.org/most/) - Multi-window scroll pager _(better less)_
- [`procs`](https://github.com/dalance/procs) - Advanced process viewer _(better ps)_
- [`rip`](https://github.com/nivekuil/rip) - Safe and ergonomic deletion tool _(better rm)_
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) - Searching within files _(better grep)_
- [`rsync`](https://rsync.samba.org/) - Fast, incremental file transfer
- [`scc`](https://github.com/boyter/scc) - Count lines of code _(better cloc)_
- [`sd`](https://github.com/chmln/sd) - RegEx find and replace _(better sed)_
- [`thefuck`](https://github.com/nvbn/thefuck) - Auto-correct miss-typed commands
- [`tldr`](https://github.com/tldr-pages/tldr) - Community-maintained docs _(better man)_
- [`tree`](https://gitlab.com/OldManProgrammer/unix-tree) - Directory listings as tree
- [`trash-cli`](https://github.com/andreafrancia/trash-cli) - Record + restore removed files
- [`watch`](https://gitlab.com/procps-ng/procps) - Run commands periorically
- [`xsel`](https://github.com/kfish/xsel) - Copy paste access to X clipboard
- [`zoxide`](https://github.com/ajeetdsouza/zoxide) - Easy navigation _(better cd)_

</details>

<details>
<summary>CLI Monitoring and Performance Apps</summary>

- [`bandwhich`](https://github.com/imsnif/bandwhich) - Bandwidth utilization monitor 
- [`ctop`](https://github.com/bcicen/ctop) - Container metrics and monitoring
- [`bpytop`](https://github.com/aristocratos/bpytop) - Resource monitoring _(like htop)_
- [`glances`](https://github.com/nicolargo/glances) - Resource monitor + web and API
- [`gping`](https://github.com/orf/gping) - Interactive ping tool, with graph
- [`ncdu`](https://dev.yorhel.nl/ncdu) - Disk usage analyzer and monitor _(better du)_
- [`speedtest-cli`](https://github.com/sivel/speedtest-cli) - Command line speed test utility
- [`dog`](https://github.com/ogham/dog)  - DNS lookup client _(better dig)_

</details>

<details>
<summary>CLI Productivity Apps</summary>

- [`browsh`](https://github.com/browsh-org/browsh) - CLI web browser
- [`buku`](https://github.com/jarun/buku) - Bookmark manager
- [`cmus`](https://github.com/cmus/cmus) - Music browser / player
- [`khal`](https://github.com/pimutils/khal) - Calendar client
- [`mutt`](https://gitlab.com/muttmua/mutt) - Email client
- [`newsboat`](https://github.com/newsboat/newsboat) - RSS / ATOM news reader
- [`rclone`](https://github.com/rclone/rclone) - Manage cloud storage
- [`task`](https://github.com/GothenburgBitFactory/taskwarrior) - Todo + task management

</details>

<details>
<summary>CLI Dev Suits</summary>

- [`httpie`](https://httpie.io/) - HTTP / API testing testing client
- [`lazydocker`](https://github.com/jesseduffield/lazydocker) - Full Docker management app
- [`lazygit`](https://github.com/jesseduffield/lazygit) - Full Git managemtne app
- [`kdash`](https://github.com/kdash-rs/kdash/) - Kubernetes dashboard app

</details>

<details>
<summary>CLI External Sercvices</summary>

- [`ngrok`](https://ngrok.com/) - Reverse proxy for sharing localhost
- [`tmate`](https://github.com/tmate-io/tmate) - Share a terminal session via internet
- [`asciinema`](https://asciinema.org/) - Recording + sharing terminal sessions
- [`navi`](https://github.com/denisidoro/navi) - Browse, search, read cheat sheets

</details>

<details>
<summary>CLI Fun</summary>

- [`cowsay`](https://github.com/piuccio/cowsay) - Have an ASCII cow say your message
- [`figlet`](http://www.figlet.org/) - Output text as big ASCII art text
- [`lolcat`](https://github.com/busyloop/lolcat) - Make console output raibow colored
- [`neofetch`](https://github.com/dylanaraps/neofetch) - Show system data and ditstro info

</details>

#### Software Development

<details>
<summary>Development Apps</summary>

- [Android Studio](https://developer.android.com/studio/) - IDE for Android development
- [Boop](https://github.com/IvanMathy/Boop) - Test transformation tool _(MacOS Only)_
- [iterm2](https://iterm2.com/) - Better terminal emulator _(MacOS Only)_
- [Postman](https://www.postman.com/) - HTTP API testing app
- [Sourcetree](https://www.sourcetreeapp.com/) - Git visual client _(MacOS Only)_
- [Virtual Box](https://www.virtualbox.org/) - VM management console
- [VS Code](https://code.visualstudio.com/) - Code editor

</details>

<details>
<summary>Development Langs, Compilers, Package Managers and SDKs</summary>

- `docker` - Containers
- `gcc` - GNU C++ compilers
- `go` - Compiler for Go Lang
- `gradle` - Build tool for Java
- `lua` - Lua interpreter
- `luarocks` - Package manager for Lua
- `node` - Node.js
- `nvm` - Switching node versions
- `openjdk` - Java development kit
- `python` - Python interpriter
- `rust` - Rust language
- `android-sdk` - Android software dev kit

</details>

<details>
<summary>Development Utils</summary>

- [`gh`](https://cli.github.com/) - Interact with GitHub PRs, issues, repos
- [`scrcpy`](https://github.com/Genymobile/scrcpy) - Display and control Andrdroid devices
- [`terminal-notifier`](https://github.com/julienXX/terminal-notifier) - Trigger Mac notifications from terminal _(MacOS Only)_
- [`tig`](https://jonas.github.io/tig/) - Text-mode interface for git
- [`ttygif`](https://github.com/icholy/ttygif) - Generate GIF from terminal commands + output

</details>

<details>
<summary>Network and Security Testing</summary>

- [`bettercap`](https://www.bettercap.org/) - Network, scanning and moniroting
- [`nmap`](https://nmap.org/) - Port scanning
- [`wrk`](https://github.com/giltene/wrk2) - HTTP benchmarking
- [`burp-suite`](https://portswigger.net/burp) - Web security testing
- [`metasploit`](https://www.metasploit.com/) - Pen testing framework
- [`owasp-zap`](https://owasp.org/www-project-zap/) - Web app security scanner
- [`wireshark`](https://www.wireshark.org/) - Network analyzer + packet capture

</details>

<details>
<summary>Security Utilities</summary>

- [`bcrypt`](https://bcrypt.sourceforge.net/) - Encryption utility, using blowfish
- [`clamav`](https://www.clamav.net/) - Open source virus scanning suite
- [`git-crypt`](https://www.agwa.name/projects/git-crypt/) - Transparent encryption for git repos
- [`lynis`](https://cisofy.com/lynis/) - Scan system for common security issues
- [`openssl`](https://www.openssl.org/) - Cryptography and SSL/TLS Toolkit
- [`rkhunter`](https://rkhunter.sourceforge.net/) - Search / detect potential root kits
- [`veracrypt`](https://www.veracrypt.fr/code/VeraCrypt/) - File and volume encryption

</details>

#### Desktop Applications

<details>
<summary>Creativity</summary>

- [Audacity](https://www.audacityteam.org/) - Multi-track audio editor and recording
- [Blender](https://www.blender.org/) - 3D modelling, rendering and sculpting
- [Cura](https://ultimaker.com/software/ultimaker-cura) - 3D Printing software, for slicing models
- [DarkTable](https://www.darktable.org/) - Organize and bulk edit photos (similar to Lightroom)
- [Dia](https://wiki.gnome.org/Apps/Dia) - Versatile diagramming tool, useful for UML
- [Gimp](https://www.gimp.org/) - Image and photo editing application
- [HandBrake](https://handbrake.fr/) - For converting video from any format to a selection of modern codecs
- [InkScape](https://inkscape.org/) - Digital drawing/ illustration
- [OBS Studio](https://obsproject.com/) - Streaming and screencasting
- [Shotcut](https://www.shotcut.org/) - Video editor
- [Synfig Studio](https://www.synfig.org/) - 2D animation

</details>

<details>
<summary>Media</summary>

- [Calibre](https://calibre-ebook.com/) - E-Book reader
- [Spotify](https://spotify.com) - Propietary music streaming
- [Transmission](https://transmissionbt.com/) - Torrent client
- [VLC](https://www.videolan.org/vlc/) - Media player
- [Pandoc](https://pandoc.org/) - Universal file converter
- [Youtube-dl](https://youtube-dl.org/) - YouTube video downloader

</details>

<details>
<summary>Personal Applications</summary>

- [1Password](https://1password.com/) - Password manager _(proprietary)_
- [Tresorit](https://tresorit.com/) - Encrypted file backup _(proprietary)_
- [Standard Notes](https://standardnotes.com/) - Encrypted synced notes
- [Signal](https://www.signal.org) - Link to encrypted mobile messenger
- [Ledger Live](https://www.ledger.com/ledger-live) - Crypto hardware wallet manager
- [ProtonMail-Bridge](https://proton.me/mail/bridge) - Decrypt ProtonMail emails
- [ProtonVPN](https://protonvpn.com/) - Client app for ProtonVPN

</details>

<details>
<summary>Browsers</summary>

- [Firefox](https://www.mozilla.org/en-GB/firefox/)
- [Chromium](https://github.com/ungoogled-software/ungoogled-chromium)
- [Tor](https://www.torproject.org/)

</details>

#### MacOS Apps

<details>
<summary>MacOS Mods and Imrovments</summary>

- `alt-tab` - Much better alt-tab window switcher
- `anybar` - Custom programatic menubar icons
- `copyq` - Clipboard manager _(cross platform)_
- `espanso` - Live text expander _(cross-platform)_
- `finicky` - Website-specific default browser
- `hiddenbar` - Hide / show annoying menubar icons
- `iproute2mac` - MacOS port of netstat and ifconfig
- `lporg` - Backup and restore launchpad layout
- `m-cli` - All in one MacOS management CLI app
- `mjolnir` - Util for loading Lua automations
- `openinterminal` - Finder button, opens directory in terminal
- `popclip` - Popup options for text on highlight
- `raycast` - Spotlight alternative
- `shottr` - Better screenshot utility
- `skhd` - Hotkey daemon for macOS
- `stats` - System resource usage in menubar
- `yabai` - Tiling window manager

</details>

---

### System Preferences

The installation script can also prompt you to confiture system settings and user preferences. This is useful for setting up a completely fresh system in just a few seconds.

#### MacOS

MacOS includes a built-in utility named [`defaults`](https://real-world-systems.com/docs/defaults.1.html), which lets you configure all system and app preferences programatically through the command line. This is very powerful, as you can write a script that configures every aspect of your system enabling you to setup a brand new machine in seconds.

All settings are then updated in the `.plist` files stored in `~/Library/Preferences`. This can also be used to configure preferences for any installed app on your system, where the application is specified by its domain identifier - you can view a full list of your configurable apps by running `defaults domains`.


In my dotfiles, the MacOS preferences will configure everything from system security to launchpad layout.
The Mac settings are located in [`scripts/macos-setup/`](https://github.com/Lissy93/dotfiles/tree/master/scripts/macos-setup), and are split into three files:
- [`macos-security.sh`](https://github.com/Lissy93/dotfiles/blob/master/scripts/macos-setup/macos-security.sh) - Sets essential security settings, disables telementry, disconnects unused ports, enforces signing, sets logout timeouts, and much more
- [`macos-preferences.sh`](https://github.com/Lissy93/dotfiles/blob/master/scripts/macos-setup/macos-preferences.sh) - Configures all user preferences, including computer name, highlight color, finder options, spotlight settings, hardware preferences and more
- [`macos-apps.sh`](https://github.com/Lissy93/dotfiles/blob/master/scripts/macos-setup/macos-apps.sh) - Applies preferences to any installed desktop apps, such as Terminal, Time Machine, Photos, Spotify, and many others

Upon running each script, a summary of what will be changed will be shown, and you'll be prompted as to weather you'd like to continue. Each script also handles permissions, compatibility checking, and graceful fallbacks. Backup of original settings will be made, and a summary of all changes made will be logged as output when the script is complete.

If you choose to run any of these scripts, take care to read it through first, to ensure you understand what changes will be made, and optionally update or remove anything as you see fit.

---

### Config Files

All config files are located in [`./config/`](https://github.com/Lissy93/dotfiles/tree/master/config/).

Configurations for ZSH, Tmux, Vim, and a few others are in dedicated sub-directories (covered in the section below). While all other, small config files are located in the [`./config/general`](https://github.com/Lissy93/dotfiles/tree/master/config/general) direcroty, and include:

- [`.bashrc`](https://github.com/Lissy93/dotfiles/blob/master/config/general/.bashrc)
- [`.curlrc`](https://github.com/Lissy93/dotfiles/blob/master/config/general/.curlrc)
- [`.gemrc`](https://github.com/Lissy93/dotfiles/blob/master/config/general/.gemrc)
- [`.gitconfig`](https://github.com/Lissy93/dotfiles/blob/master/config/general/.gitconfig)
- [`.gitignore_global`](https://github.com/Lissy93/dotfiles/blob/master/config/general/.gitignore_global)
- [`.wgetrc`](https://github.com/Lissy93/dotfiles/blob/master/config/general/.wgetrc)
- [`dnscrypt-proxy.toml`](https://github.com/Lissy93/dotfiles/blob/master/config/general/dnscrypt-proxy.toml)
- [`gpg.conf`](https://github.com/Lissy93/dotfiles/blob/master/config/general/gpg.conf)
- [`starship.toml`](https://github.com/Lissy93/dotfiles/blob/master/config/general/starship.toml)

---

### ZSH

[ZSH](https://www.zsh.org/) (or Z shell) is a UNIX command interpriter (shell), similar to and compatible with Korn shell (KSH). Compared to Bash, it includes many useful features and enchanements, notably in the CLI editor, advanced behaviour customization options, filename globbing, recursive path expansion, completion, and it's easyily extandable through plugins. For more info about ZSH, see the [Introduction to ZSH Docs](https://zsh.sourceforge.io/FAQ/zshfaq01.html).

My ZSH config is located in [`config/zsh/`](https://github.com/Lissy93/dotfiles/tree/master/config/zsh)

---

### Vim

The entry point for the Vim config is the [`vimrc`](https://github.com/Lissy93/dotfiles/blob/master/config/vim/vimrc), but the main editor settings are defined in [`vim/editor.vim`](https://github.com/Lissy93/dotfiles/blob/master/config/vim/editor.vim)

#### Vim Plugins

Vim plugins are managed using [Plug](https://github.com/junegunn/vim-plug) defined in [`vim/plugins.vim`](https://github.com/Lissy93/dotfiles/blob/master/config/vim/setup-vim-plug.vim).
To install them from GitHub, run `:PlugInstall` (see [options](https://github.com/junegunn/vim-plug#commands)) from within Vim. They will also be installed or updated when you run the main dotfiles setup script ([`install.sh`](https://github.com/Lissy93/dotfiles/blob/d4b8426629e7fbbd6d17d0b87f0bb863d6618bfd/install.sh#L132-L134)).

The following plugins are being used:

<details>

<summary><b>Layout & Navigation</b></summary>

- **[Airline](https://github.com/vim-airline/vim-airline)**: `vim-airline/vim-airline` - A very nice status line at the bottom of each window, displaying useful info
- **[Nerd-tree](https://github.com/preservim/nerdtree)**: `preservim/nerdtree` - Alter files in larger projects more easily, with a nice tree-view pain
- **[Matchup](https://github.com/andymass/vim-matchup)**: `andymass/vim-matchup` - Better % naviagtion, to highlight and jump between open and closing blocks
- **[TagBar](https://github.com/preservim/tagbar)**: `preservim/tagbar` - Provides an overview of the structure of a long file, shows tags ordered by scope
- **[Gutentags](https://github.com/ludovicchabant/vim-gutentags)**: `ludovicchabant/vim-gutentags` - Manages tag files
- **[Fzf](https://github.com/junegunn/fzf.vim)**: `junegunn/fzf` and `junegunn/fzf.vim` - Command-line fuzzy finder and corresponding vim bindings
- **[Deoplete.nvim](https://github.com/Shougo/deoplete.nvim)**: `Shougo/deoplete.nvim` - Extensible and asynchronous auto completion framework
- **[Smoothie](https://github.com/psliwka/vim-smoothie)**: `psliwka/vim-smoothie` - Smooth scrolling, supporting `^D`, `^U`, `^F` and `^B`
- **[DevIcons](https://github.com/ryanoasis/vim-devicons)**: `ryanoasis/vim-devicons` - Adds file-type icons to Nerd-tree and other plugins

</details>


<details>

<summary><b>Operations</b></summary>

- **[Nerd-Commenter](https://github.com/preservim/nerdcommenter)**: `preservim/nerdcommenter` - For auto-commenting code blocks
- **[Ale](https://github.com/dense-analysis/ale)**: `dense-analysis/ale` - Checks syntax asynchronously, with lint support
- **[Surround](https://github.com/tpope/vim-surround)**: `tpope/vim-surround` - Easily surround selected text with brackets, quotes, tags etc
- **[IncSearch](https://github.com/haya14busa/incsearch.vim)**: `haya14busa/incsearch.vim` - Efficient incremental searching within files
- **[Vim-Visual-Multi](https://github.com/mg979/vim-visual-multi)**: `mg979/vim-visual-multi` - Allows for inserting/ deleting in multiple places simultaneously
- **[Visual-Increment](https://github.com/triglav/vim-visual-increment)**: `triglav/vim-visual-increment` - Create an increasing sequence of numbers/ letters with `Ctrl` + `A`/`X`
- **[Vim-Test](https://github.com/janko/vim-test)**: `janko/vim-test` - A wrapper for running tests on different granularities
- **[Syntastic](https://github.com/vim-syntastic/syntastic)**: `vim-syntastic/syntastic` - Syntax checking that warns in the gutter when there's an issue

</details>


<details>

<summary><b>Git</b></summary>

- **[Git-Gutter](https://github.com/airblade/vim-gitgutter)**: `airblade/vim-gitgutter` - Shows git diff markers in the gutter column
- **[Vim-fugitive](https://github.com/tpope/vim-fugitive)**: `tpope/vim-fugitive` - A git wrapper for git that lets you call a git command using `:Git`
- **[Committia](https://github.com/rhysd/committia.vim)**: `rhysd/committia.vim` - Shows a diff, status and edit window for git commits
- **[Vim-Git](https://github.com/tpope/vim-git)**: `tpope/vim-git` - Runtime files for git in vim, for  git, gitcommit, gitconfig, gitrebase, and gitsendemail

</details>


<details>

<summary><b>File-Type Plugins</b></summary>

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

</details>


<details>

<summary><b>Themes</b></summary>


</details>

---

### Tmux


Fairly standard Tmux configuration, strongly based off Tmux-sensible. Configuration is defined in [`.tmux.conf`](https://github.com/Lissy93/dotfiles/blob/master/config/tmux/tmux.conf)

Tmux plugins are managed using [TMP](https://github.com/tmux-plugins/tpm) and defined in [`.tmux.conf`](https://github.com/Lissy93/dotfiles/blob/master/config/tmux/tmux.conf). To install them from GitHub, run `prefix` + <kbd>I</kbd> from within Tmux, and they will be cloned int `~/.tmux/plugins/`.

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

Git aliases for ZSH are located in [`/zsh/aliases/git.zsh`](https://github.com/Lissy93/dotfiles/blob/master/config/zsh/aliases/git.zsh), and are documented under the [Aliases](https://github.com/lissy93/dotfiles#my-aliases) section, above.

---

## Dependencies

It's strongly recomended to have the following packages installed on your system before proceeding:

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

---

### Utilities


The dotfiles also contains several handy bash scripts to carry out useful tasks with slightly more ease.

Each of these scripts is standalone, without any dependencies, and can be executed directly to use. 
Alternatively, they can be sourced from within a .zshrc / .bashrc, for use anywhere via their alias.

For usage instructions about any of them, just append the `--help` flag.

- [Transfer]() - Quickly transfer files or folders to the internet
- [Web Search]() - Open a specific search engine with a given query
- [QR Code]() - Generates a QR code for a given string, to transfer data to mobile device
- [Weather]() - Shows current and forecasted weather for your location
- [Color Map]() - Just outputs your terminal emulators supported color pallete
- [Welcome]() - Used for first login, prints personalised greeting, system info, and other handy info
- [Online]() - Checks if you are connected to the internet



#### Transfer

Quickly transfer a file, group of files or directory via the transfer.sh service.<br>
To get started, run `transfer <file(s) / folder>`, for more info, run `transfer --help`

If multiple files are passed in, they will automatically be compressed into an archive.
You can change the file transfer service, or use a self-hosted instance by setting the URL in `FILE_TRANSFER_SERVICE`
The file can be either run directly, or sourced in your `.zshrc` and used via the `transfer` alias.

> For info, run `transfer --help`<br>
> Source: [`utils/transfer.sh`](https://github.com/Lissy93/dotfiles/blob/master/utils/transfer.sh)

#### Web Search

Quickly open web search results for a given query using a selected search engine. To get started, run `web-search`, or `web-search --help` for more info.

Usage:

All parameters are optional, to get started just run `web-search` or `web-search <search provider (optional)> <query (optional)>`, the `ws` alias can also be used. If a search engine isn't specified, you'll be prompted to select one from the list. Similarly, if a query hasn't been included you'll be asked for that too.

- `web-search` - Opens interactive menu, you'll be prompted to select a search engine from the list then enter your query
- `web-search <search term>` - Specify a search term, and you'll be prompted to select the search engine
  - For example, `web-search Hello World!`
- `web-search <search engine>` - Specify a search engine, and you'll be prompted for your search term
  - For example, `web-search duckduckgo`
- `web-search <search engine> <search engine>` - Specify both a search engine and query, and results will open immediately 
  - For example, `web-search wikipedia Matrix Defense`

<details>

<summary><b>Supported Search Providers</b></summary>

The following search engines are supported by default:
- DuckDuckGo: `ws duckduckgo` (or `wsddg`)
- Wikipedia: `ws wikipedia` or (`wswiki`)
- GitHub: `ws github` (or `wsgh`)
- StackOverflow: `ws stackoverflow` (or `wsso`)
- Wolframalpha: `ws wolframalpha` (or `wswa`)
- Reddit: `ws reddit` (or `wsrdt`)
- Maps: `ws maps` (or `wsmap`)
- Google: `ws google` (or `wsggl`)
- Grep App: `ws grepapp` (or `wsgra`)

</details>

The alias `ws` will also resolve to `web-search`, if it's not already in use. You can either run the script directly, e.g.`~/.config/utils/web-search.sh` (don't forget to `chmod +x` the file first, to make it executable), or use the `web-search` / `ws` alias anywhere, once it has been source'd from your .zshrc. 

> For info, run `web-search --help`<br>
> Source: [`utils/web-search.sh`](https://github.com/Lissy93/dotfiles/blob/master/utils/web-search.sh)

<details>

<summary>Try now!</summary>

```bash
bash <(curl -s https://raw.githubusercontent.com/Lissy93/dotfiles/master/utils/web-search.sh)
```

</details>


---

---


<!-- License + Copyright -->
<p  align="center">
  <i>© <a href="https://aliciasykes.com">Alicia Sykes</a> 2022</i><br>
  <i>Licensed under <a href="https://gist.github.com/Lissy93/143d2ee01ccc5c052a17">MIT</a></i><br>
  <a href="https://github.com/lissy93"><img src="https://i.ibb.co/4KtpYxb/octocat-clean-mini.png" /></a><br>
  <sup>Thanks for visiting :)</sup>
</p>

<!-- Dinosaur -->
<!-- 
                        . - ~ ~ ~ - .
      ..     _      .-~               ~-.
     //|     \ `..~                      `.
    || |      }  }              /       \  \
(\   \\ \~^..'                 |         }  \
 \`.-~  o      /       }       |        /    \
 (__          |       /        |       /      `.
  `- - ~ ~ -._|      /_ - ~ ~ ^|      /- _      `.
              |     /          |     /     ~-.     ~- _
              |_____|          |_____|         ~ - . _ _~_-_
-->

