#!/usr/bin/env zsh

setopt prompt_subst
setopt PROMPT_CR
setopt PROMPT_SP
setopt PROMPT_SUBST
setopt PROMPT_PERCENT

autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zmodload zsh/cap
zmodload zsh/datetime

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'
# zstyle ':vcs_info:*' formats '%(%b)%S%u%c'
export PROMPT_EOL_MARK=''

function _preexec() {
  typeset -g prompt_timestamp=$EPOCHSECONDS
}

function _precmd() {
  integer elapsed=$(( EPOCHSECONDS - ${prompt_timestamp:-$EPOCHSECONDS} ))

  local hh=$(( elapsed / 3600 ))
  local mm=$(( elapsed / 60 % 60 ))
  local ss=$(( elapsed % 60 ))
  local human="$(printf '%02d:%02d:%02d' $hh $mm $ss)"
  local newline=$'\n%{\r%}'
  vcs_info

  PROMPT="%F{green}%*%f  %F{blue}%~%f  [%F{yellow}${human}%f]"
  PROMPT+=${newline}                                                  
  PROMPT+="%F{242}${vcs_info_msg_0_:-}%f "
  PROMPT+="%(?.%F{magenta}»%f .%F{red}»%f ) "
}

add-zsh-hook preexec _preexec
add-zsh-hook precmd _precmd
