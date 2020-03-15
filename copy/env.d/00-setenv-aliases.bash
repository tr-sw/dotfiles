
#--------------------------
#  Aliases
#--------------------------


alias vi='vim'

alias rm='rm -i --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'


alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'

# get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4  head -10'

# get top process eating cpu 
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# tree listing
alias t1='tree -n -L 1'
alias t2='tree -n -L 2'
alias t3='tree -n -L 3'
alias t4='tree -n -L 4'
alias t5='tree -n -L 5'

