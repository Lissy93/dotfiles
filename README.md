
## Intro

My personal dot files, to configure Linux environment on desktop and server instances.
[Dotbot](https://github.com/anishathalye/dotbot) is being used to create symlinks to the right places.

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

- git
- zsh
- vim
- tmux