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
fi
