
# Thanks to: http://codersopinion.com/blog/16-awesome-git-aliases-that-you-will-love/

[alias]

##### General

    # list all aliases
    la = "!git config -l | grep alias | cut -c 7-"

    # quickie
    c = "!git add -A && git commit -m " 

    co = checkout
    cob = checkout -b
    f = fetch -p
    c = commit
    p = push
    ba = branch -a
    bd = branch -d
    bD = branch -D
    dc = diff --cached

    st = status -sb

    # review changes before adding them
    a = add -p

    # fetch with rebase. Fetches from all remotes, syncs remotes with origin, and applies commits
    fr = !git fetch --all && git rebase origin/master

    sl = stash list
    ss = stash save

##### Logs 

    plog = log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'

    # with relative date
    tlog = log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative

    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit


##### Branches and merges
    
    n = !git checkout -b

    # remove all branches that have been merged into the branch you're on
    bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d"

    # list branches sorted by last modified
    b = "!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"


##### Tags

    # show last tag
    lt = describe --tags --abbrev=0
