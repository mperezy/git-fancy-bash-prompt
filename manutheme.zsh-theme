function toon {
  echo -n ""
}

get_git_dirty() {
  git diff --quiet || echo '*'
}

# Reference: https://gist.github.com/jnjosh/4464653

#use extended color pallete if available
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
else
    turquoise="$fg[cyan]"
    orange="$fg[yellow]"
    purple="$fg[magenta]"
    hotpink="$fg[red]"
    limegreen="$fg[green]"
fi

RESET_COLOR="%{${reset_color}%}"
BACKGROUND_WHITE="%{$bg[white]%}"
BOLD_BLACK="%{$fg_bold[black]%}"

getHeadHashCommit() {
  inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
  [ "$inside_git_repo" ] && echo "\n$(log "The HEAD commit hash is =>")$(header $(getLastCommitsHash yes 1 | cut -d' ' -f 2 | cut -c-7))"
}

# Add up/down arrows after branch name, if there are changes to pull/to push
zstyle ':vcs_info:git+post-backend:*' hooks git-post-backend-updown
+vi-git-post-backend-updown() {
  hook_com[branch]+="%f" # end coloring

  git rev-parse @{upstream} >/dev/null 2>&1 || hook_com[branch]+="%f ${BACKGROUND_WHITE}${BOLD_BLACK}(This branch is not pushed yet)${RESET_COLOR}" return
  
  local -a updown; updown=( $(git rev-list --left-right --count HEAD...@{upstream} ) )
  local -a unstaged; unstaged=( $(git diff --name-status | sed '/^U/d' | wc -l | tr -d ' ' ) )
  local -a staged; staged=( $(git diff --staged --name-status | sed '/^U/d' | wc -l | tr -d ' ' ) )
  local -a stashed; stashed=( $(git stash list | sed '/^U/d' | wc -l | tr -d ' ') )
  local -a untracked; untracked=( $(git ls-files --others --exclude-standard | sed '/^U/d' | wc -l | tr -d ' ' ) )

  (( updown[2] )) && hook_com[branch]+=" ↓·${updown[2]}"
  (( updown[1] )) && hook_com[branch]+=" ↑·${updown[1]}"

  (( unstaged || staged || stashed || untracked )) && hook_com[branch]+="%F{red} |"
  (( unstaged )) && hook_com[branch]+=" %{$turquoise%}✚${unstaged}${RESET_COLOR}"
  (( staged )) && hook_com[branch]+=" %{$limegreen%}●${staged}${RESET_COLOR}"
  (( stashed )) && hook_com[branch]+=" %{$orange%}⚑${stashed}${RESET_COLOR}"
  (( untracked )) && hook_com[branch]+=" %{$purple%}…${untracked}${RESET_COLOR}"

  return 0
}

autoload -Uz vcs_info
zstyle ':vcs_info:hg:*' get-revision true
zstyle ':vcs_info:*' actionformats \
    '%F{5}%F{5}[%F{2}%b%F{3}|%F{1}%a%c%u%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    "%F{5}%F{5}[%F{2}%b%c%u%F{5}]%f "
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn

check_git_files () {
  git_status=$(git status --short --untracked-files=all 2>/dev/null)

  if [ -z "$git_status" ]
  then
  else
    echo "\n$git_status"
  fi
}

get_date() {
  echo $(date +%d/%m/%y)
}

get_hours() {
  echo $(date +%H:%M:%S)
}

theme_precmd () {
    vcs_info
    # func
}

# %n -> username
# %m -> hostname

setopt prompt_subst
PROMPT='%{$fg[white]%}$(toon)%{$reset_color%} %{$fg_bold[cyan]%}%n%{$fg[white]%}:%{$fg[yellow]%}%~/ %{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}$(getHeadHashCommit)$(check_git_files)
%{$fg[red]%}«%{$fg[green]%}$(get_date)%  %{$fg[magenta]%}$(get_hours)%{$fg[red]%}»%{$reset_color%}%{$fg_bold[white]%} $% %{$reset_color%} '

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
