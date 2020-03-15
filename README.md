Dotfiles, vim 8 configurations and plugins using cool tools that can alwo work on the command line (e.g. fzf, ack, silver_searcher, autojump, ...)

#### System Requirements
- **Vim v8+ with python3 support** (for YouCompleteMe plugin)
- **Python 3**
- git v1.9+ (for depth=1 clones)
- wget (for installing tools)
- RedHat/CentOS (currently using yum for installing optional tools, but those can be installed separately) -
- sudo privileges to install autojump, ag, fzf, and ycm

#### Installing
```bash
    $ cd $HOME
    $ get clone --depth 1 https://github.com/tr-sw/dotfiles.git
    $ ./dotfiles/install.sh -all
```
#### Install options
```bash
  Usage:
    install.sh [options]

  Options:
      --all            Install all (j,ag,ack,fzf,ycm,gitconfig) 
      --no-j           No autojump
      --no-ag          No ag (the_silver_searcher)
      --no-ack         No ack advanced grep
      --no-fzf         No fzf fuzzy file finder
      --no-ycm         No YouCompleteMe vim plugin

  Examples:

    To install all options
       $ cd ~
       $ ./dotfiles/install.sh -all

    To install everything except ack and YouCompleteMe (ycm):
       $ cd ~
       $ ./dotfiles/install.sh --no-ack --no-ycm

  NOTES:
    1. This will create .gitconfig with "[include] .gitconfig.d/*.inc"
       if and only if the git user.name and user.email are not currently set 
    2. This install will NOT backup your existing dotfiles.
    3. Autojump, AG, and YouCompleteMe require sudo privileges
```
