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
