function toon {
  echo -n ""
}

get_git_dirty() {
  git diff --quiet || echo '*'
}

#ZSH_THEME_GIT_PROMPT_MODIFIED=" ✚"
#ZSH_THEME_GIT_PROMPT_STASHED=" ●"
#ZSH_THEME_GIT_PROMPT_AHEAD="↑·"
#ZSH_THEME_GIT_PROMPT_BEHIND="↓·"
#ZSH_THEME_GIT_PROMPT_NO_REMOTE_TRACKING="${WhiteBg}${BoldBlack}(your branch is no pushed yet)"

# Add up/down arrows after branch name, if there are changes to pull/to push
zstyle ':vcs_info:git+post-backend:*' hooks git-post-backend-updown
+vi-git-post-backend-updown() {
  git rev-parse @{upstream} >/dev/null 2>&1 || return
  local -a x; x=( $(git rev-list --left-right --count HEAD...@{upstream} ) )
  hook_com[branch]+="%f" # end coloring
  (( x[2] )) && hook_com[branch]+=" ↓·${x[2]}"
  (( x[1] )) && hook_com[branch]+=" ↑·${x[1]}"
  return 0
}

#zstyle ':vcs_info:*' formats "%u%c%m"
#zstyle ':vcs_info:git*+set-message:*' hooks untracked-git

#+vi-untracked() {
#  if [[ -n "$(git ls-files --others --exclude standard)" ]]; then
#      hook_com[misc]='?'
#  else
#      hook_com[misc]=''
#  fi
#}

hasStashedFiles() {
  getStashedCount=$(git rev-list --walk-reflogs --count refs/stash)
  stashedFlag=" $fg_bold[cyan]⚑$getStashedCount$reset_color"

  if [ -z "$getStashedCount" ]
  then
  else 
    echo $stashedFlag
  fi
}

getStagedCount() {
  stagedFiles=$(git diff --staged --name-status | sed '/^U/d' | wc -l | tr -d ' ')

  if [ $stagedFiles = 0 ]
  then
  else
    echo $stagedFiles
  fi
}

getUnstagedCount() {
  unstagedFiles=$(git diff --name-status | sed '/^U/d' | wc -l | tr -d ' ')

  if [ $unstagedFiles = 0 ]
  then
  else
    echo $unstagedFiles
  fi
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "%F{cyan} ✚"   #$(getUnstagedCount)"   # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr "%F{green} ●"   #$(getStagedCount)"  # display this when there are staged changes
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
PROMPT='%{$fg[white]%}$(toon)%{$reset_color%} %{$fg_bold[cyan]%}%n%{$fg[white]%}:%{$fg[yellow]%}%~/ %{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}$(check_git_files)
%{$fg[red]%}«%{$fg[green]%}$(get_date)% %{$fg[magenta]%}$(get_hours)%{$fg[red]%}»%{$reset_color%}%{$fg_bold[white]%} $% %{$reset_color%} '

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
