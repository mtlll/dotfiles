# Lines configured by zsh-newuser-install
HISTFILE=~/.zshhistory
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

#color setup
autoload -U colors && colors
eval "$(dircolors -b)" #this is to add better colors to ls

# End of lines added by compinstall

#prompt(s)
PROMPT="%{$fg[green]%}%n@%M%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ "
#RPROMPT="%*"

setopt extended_glob
#aliases
alias ls="ls -h --color=auto"
alias grep="grep --color=auto"
#key bindings

bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

function zle-line-init zle-keymap-select {
    NORMAL_PROMPT="%{$fg[red]%} -- NORMAL --  %{$reset_color%}"
    INSERT_PROMPT="%{$fg[red]%} -- INSERT --  %{$reset_color%}"
    RPROMPT="${${KEYMAP/vicmd/$NORMAL_PROMPT}/(main|viins)/$INSERT_PROMPT} $EPS1"
#RPROMPT=$KEYMAP
    zle reset-prompt
}

function verb-visual {
	zle visual-mode
	RPROMPT=$KEYMAP
	zle reset-prompt
}

zle -N verb-visual
bindkey -M vicmd "v" verb-visual
zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

function precmd
{
    title "zsh" "(%55<...<%~)"
}

function preexec
{
    title "$1"
}

function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\e]2;$a :: $2\a" # plain xterm title
    print -Pn "\ek$a\e\\"      # screen title (in ^A")
    print -Pn "\e_$2   \e\\"   # screen location
    ;;
  xterm*|rxvt*)
    print -Pn "\e]2;$a$2\a" # plain xterm title
    ;;
  esac
}


export PATH="$HOME/.cargo/bin:$PATH"
