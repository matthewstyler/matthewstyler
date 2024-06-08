PS1="t~"

function parse_git_branch() {
  git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/%{\x1B[3m%}\1%{\x1B[23m%}/p'
}

function git_status_info() {
    local git_status=$(git status --porcelain 2> /dev/null)
    if [[ -n "$git_status" ]]; then
        echo "🚨"
    else
        echo "✅"
    fi
}

fixup_rebase() {
    # stage all changes
    git add .

    # Get the commit hash of the last commit
    LAST_COMMIT=$(git rev-parse HEAD)

    # Create a fixup commit for the last commit
    git commit --fixup=$LAST_COMMIT

    # Optionally amend the commit message
    # git commit --amend

    # Rebase interactively using autosquash, finish rebase
    git rebase -i --autosquash $LAST_COMMIT^
}

COLOR_DEF=$'%f'
COLOR_USR=$'%F{243}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_DIR}%~|${COLOR_GIT}$(parse_git_branch)$(git_status_info)${COLOR_DEF}'
alias lastbranch='git checkout -' 
alias mybranch="git branch --list 'tm/*' --sort=-committerdate | head -n 10"
alias unstage="git reset"
alias hist="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
alias lastbranches="git branch --sort=-committerdate"
alias uncommit="git reset HEAD~1"
