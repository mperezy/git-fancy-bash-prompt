function toon {
  echo -n ""
}

get_git_dirty() {
  git diff --quiet || echo '*'
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # display this when there are staged changes
zstyle ':vcs_info:*' actionformats \
    '%F{5}%F{5}[%F{2}%b%F{3}|%F{1}%a%c%u%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}%F{5}[%F{2}%b%c%u%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn

check_files () {
  git_status=$(git status --short --untracked-files=all 2>/dev/null)

  if [ -z "$git_status" ]
  then
  else
    echo $git_status
  fi
}

current_time() {
  echo "$fg[red]«$fg[green]"$(date +%d/%m/%y)" $fg[magenta]"$(date +%H:%M:%S)"$fg[red]»$reset_color $ "
}

func () {
  echo ""
  check_files
  current_time
}

theme_precmd () {
    vcs_info
    # func
}

setopt prompt_subst
# PROMPT='%{$fg[magenta]%}$(toon)%{$reset_color%} %~/ %{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}'
PROMPT='%{$fg[cyan]%}$(toon)%{$reset_color%} %{$fg[yellow]%}%~/ %{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}$(func)'
# PROMPT="%(?:%{$fg_bold[green]%}%{%G➜%} :%{$fg_bold[red]%}%{%G➜%} )"

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY=" ✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"
