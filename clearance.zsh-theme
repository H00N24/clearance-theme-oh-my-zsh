# Clearance ZSH Theme

# A minimalist oh-my-zsh theme with git, nix-shell and virtualenv prompt 
# Based on 
# * Avit theme (https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/avit.zsh-theme) 
# * Clearance theme for Fish (https://github.com/oh-my-fish/theme-clearance)


if [[ $USER == "root" ]]; then
  CARETCOLOR="red"
else
  CARETCOLOR="white"
fi

function _git_branch_name() {
  echo "$(command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')"
}

function _git_is_dirty() {
  echo "$(command git status -s --ignore-submodules=dirty 2> /dev/null)"
}

function _current_dir() {
  local _max_pwd_length="65"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    echo "%{$fg[blue]%}%-2~ ... %1~%{$reset_color%} "
  else
    echo "%{$fg[blue]%}%~%{$reset_color%} "
  fi
}


function _make_prompt() {
  echo -e ''

  if [[ -n $SSH_CONNECTION ]]; then
    local me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    local me="%n"
  fi
  if [[ -n $me ]]; then
    echo -n "%{$fg[cyan]%}$me%{$reset_color%}:"
  fi

  echo -n "$(_current_dir)"

  if [[ $(_git_branch_name) ]]
  then
    local git_branch=$(_git_branch_name)

    if [[ $(_git_is_dirty) ]]
    then
      local git_info="(%{$fg[yellow]%}$git_branch±%{$reset_color%})"
    else
      local git_info="(%{$fg[green]%}$git_branch%{$reset_color%})"
    fi
    echo -n " · $git_info" 
  fi

  if [[ -n "$IN_NIX_SHELL" ]]; then
    echo -n " %{$fg[cyan]%}[nix-shell]%{$reset_color%}"
  fi

  echo ''

  if [[ ${VIRTUAL_ENV+x} ]]
  then
      echo -n "%{$fg[cyan]%} [$(basename "$VIRTUAL_ENV")]%{$reset_color%}"
  fi


  echo -n "%{$fg[$CARETCOLOR]%} ⟩ %{$reset_color%}"
}


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"


# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'

PROMPT='$(_make_prompt)'

PROMPT2='  '
