# Hellooooo!!

log() {
    echo -e "$(date) -- ${@}"
}

prompt-timing-nocolor() {
    echo -en "$(date) ($(seconds2days ${SECONDS})s)"
}

prompt-timing-right-nocolor() {
    printf "%${COLUMNS}s" "$(prompt-timing-nocolor)"
}

prompt-timing-right() {
    echo -en "\033[01;30m$(prompt-timing-right-nocolor|sed -e 's/  /——/g')\033[00m"
}

gitbranch() {
    echo -n $(git branch 2>/dev/null | grep '\*' | cut -d'*' -f2-|sed -e 's/^\s*//g')
}

gitbranch-color() {
    BRANCH=$(gitbranch)
    GREEN="00;32m"
    YELLOW="00;33m"
    COLOR=${GREEN}
    STATUS="$(git status --porcelain 2>/dev/null)"
    [ -n "${STATUS}" ] && COLOR=${YELLOW}
    echo -en "\033[${COLOR}${BRANCH}\033[00m"
}

git-status-upstream() {
    UPTODATE="01;31m"
    OUTDATED="01;31m"

    COLOR=${OUTDATED}

    BRANCH= gitbranch-color|sed -e 's/(//g'|sed -e 's/)//g'
    STATUS="$(git status 2>/dev/null|grep -i 'Your branch'|sed -e 's/Your branch //g'|sed -e 's/\.//g'|sed -e 's/,//g'|sed -e s/\'//g)"
    echo $STATUS | grep up-to-date >/dev/null 2>&1 && COLOR=${UPTODATE}
    [ -n "${STATUS}" ] && echo -en " \033[${COLOR}${STATUS}\033[00m"
}

git-status-upstream-dont-show-uptodate() {
    printf "$(git-status-upstream)"|grep -v 'up-to-date'
}

git-check-rebase() {
    BRANCH=$(gitbranch)
    [ "${BRANCH}" = "master" ] && return
    [ "${BRANCH}" = "develop" ] && return
    LASTDEVELOP=$(git log --pretty=oneline -1 origin/develop 2>/dev/null|awk '{print $1}')
    [ -z "${LASTDEVELOP}" ] && return
    NEEDSREBASE=$(git log --max-count 500 --pretty=oneline 2>/dev/null|grep -q ${LASTDEVELOP} || echo -n "Rebase needed")
    [ -z "${NEEDSREBASE}" ] && return
    COLOR="00;41m"
    echo -en " \033[${COLOR}${NEEDSREBASE}\033[00m"
}

git-multiline-status-prompt() {
    STATUS=$(git status --short --untracked-files=all 2>/dev/null)
    [ -n "${STATUS}" ] && printf "\n${STATUS}\n\n"
}

seconds2days() { # convert integer seconds to Ddays,HH:MM:SS
    printf "%ddays,%02d:%02d:%02d" $(((($1/60)/60)/24)) \
    $(((($1/60)/60)%24)) $((($1/60)%60)) $(($1%60)) |
    sed 's/^1days/1day/;s/^0days,\(00:\)*//;s/^0//' ; }

