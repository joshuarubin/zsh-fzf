if [ -d "$HOME/.fzf" ]; then
  path[1,0]="$HOME/.fzf/bin"
  export MANPATH="$MANPATH:$HOME/.fzf/man"

  source "$HOME/.fzf/shell/completion.zsh"
  source "$HOME/.fzf/shell/key-bindings.zsh"

  _fzf_compgen_path() {
    ag -g "" "$1"
  }

  if [ -f "$HOME/.fzf.conf" ]; then
    source "$HOME/.fzf.conf"
  fi

  fzf-history-widget-accept() {
    fzf-history-widget
    zle accept-line
  }
  zle     -N     fzf-history-widget-accept
  bindkey '^X^R' fzf-history-widget-accept

  fzf-history-widget() {
    local selected num
    setopt localoptions noglobsubst pipefail 2> /dev/null
    selected=( $(fc -l 1 | eval "$(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r --expect=ctrl-x $FZF_CTRL_R_OPTS -q ${(q)LBUFFER}") )
    local ret=$?
    if [ -n "$selected" ]; then
      local accept=0
      if [[ $selected[1] = ctrl-x ]]; then
        accept=1
        shift selected
      fi
      num=$selected[1]
      if [ -n "$num" ]; then
        zle vi-fetch-history -n $num
        [[ $accept = 1 ]] && zle accept-line
      fi
    fi
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
  }
fi
