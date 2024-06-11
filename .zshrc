alias c='clear'
alias na='nano ~/.zshrc'
alias aarun='sf apex run'
alias aarunf='aarun --file '
alias sfr="sf project retrieve start"
alias sfd="sf project deploy start"
alias sfdv="sf project deploy validate"
alias sfrc="sfr -c"
alias sfrcm="sfrc -m"
alias sfrcd="sfrc -d"
alias sfrcx="sfrc -x"
alias sfdc="sfd -c"
alias sfdcd="sfdc -d"
alias sfdcm="sfdc -m"
alias sfdcx="sfdc -x"
alias gf="git fetch"
alias gp="git pull"
alias gfgp="gf; gp;"
alias gap="git add -p"
alias gaps="gap force-app/main/default/"
alias gapa="gap ."
alias gs="git stash"
alias gsl="gs list"
alias gsn="gs save -m"
alias gsps="gs push force-app/main/default"
alias gsp="gs pop"
alias gsd="gs drop"
alias gsa="gs apply"
alias subl='open -a "Sublime Text"'
alias bbssh="ssh-add -q ~/.ssh/bitbucket_coloplast"
bbssh;
eval
eval "$(zoxide init zsh)" 
SF_AC_ZSH_SETUP_PATH=/Users/hhupeols/Library/Caches/sf/autocomplete/zsh_setup && test -f $SF_AC_ZSH_SETUP_PATH && source $SF_AC_ZSH_SETUP_PATH; # sf autocomplete setup
