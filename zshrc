autoload -Uz compinit
compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

ZSH=$HOME/.oh-my-zsh

# # Set zsh theme to be powerlevel10k with patched fontawesome symbols.
POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME='powerlevel10k/powerlevel10k'

# plugins=(
#   git
#   bundler
#   brew
#   gem
#   history-substring-search
#   colored-man-pages
#   vi-mode
#   docker
#   docker-compose
#   taskwarrior
#   systemd
#   terraform
#   helm
#   golang
#   npm
#   yarn
#   web-search
#   aws
#   kops
#   kubectl
#   mvn
# )

# Returns whether the given command is executable or aliased.
_has() {
  return $(whence $1 >/dev/null)
}
# Prepend a directory to path, if it exists and isn't already in the path.
_prepend_to_path() {
  #echo "Fail"
  #echo "path is: $path"
  #echo "prepend: $1"
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
  fi
}

_include(){
  [[ -f "$1" ]] && source "$1"
}
# Append a directory to path, if it exists and isn't already in the path.
_append_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($path $1);
  fi
}

_prepend_to_path ~/.porter
_prepend_to_path /usr/local/bin
_prepend_to_path $HOME/.local/bin
# _prepend_to_path $HOME/Library/Python/3.9/bin       
_prepend_to_path $(gem environment gemdir)/bin
_prepend_to_path $GOBIN 

export EDITOR='vim'

DISABLE_UPDATE_PROMPT=true

# for Homebrew installed rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

bindkey -v # vi mode for shell
bindkey -e # enable C-x-e for shell editor
# key bindings for history search
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

setopt correct
setopt rmstarsilent # silence rm * confirmation

# Use 256 color for tmux.
alias tmux="TERM=screen-256color-bce tmux"
# Attempt to take over existing sessions before creating a new tmux session.
alias t="tmux a -d 2> /dev/null || tmux"

_include ~/.antigenrc
_include ~/.dotfiles/antigen/antigen.zsh

# Use Python 3! https://pythonclock.org
# alias python="python3.9"
# alias pip="pip3"
# alias python='eval $(which python3)'
# alias pip='eval $(which pip3)'
# alias for colorized cat 
alias ccat="pygmentize -O style=dracula"
# Use Neovim instead of classic vim (if available)
if _has nvim; then
  alias vim="nvim"
  alias vi="nvim"
fi

# Explicity bind home and end keys (in case of terminal compatibility issues)
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

if [[ -z "$TMUX" ]]; then
  export TERM="xterm-256color"
fi

# Powerlevel10k configs.
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  context
  vcs
  dir_writeable
  dir
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  command_execution_time
  status
  root_indicator
  background_jobs
  battery
  time
  vi_mode
)
POWERLEVEL9K_PROMPT_ON_NEWLINE=false
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_TIME_FORMAT='%D{%l:%M %p}'
POWERLEVEL9K_TIME_BACKGROUND='purple'

POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='black'
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='cyan'
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND='black'
POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND='green'

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

POWERLEVEL9K_BATTERY_VERBOSE=false

# Source local version of zshrc.
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# Source Oh-My-ZSH.
source $ZSH/oh-my-zsh.sh

# Update completion scripts (which should be defined by homebrew and oh-my-zsh).
rm -f ~/.zcompdump && compinit

# Source fzf scripts via via local installation.
if [ -e ~/.fzf ]; then
  _append_to_path ~/.fzf/bin
fi

# Configure fzf (if available).
if _has fzf; then
  if [ -e "$HOME/.fzf-tab" ]; then
    source "$HOME/.fzf-tab/fzf-tab.plugin.zsh"
  fi
  # Source fzf key bindings and auto-completion.
  if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
    # Source fzf scripts via Homebrew.
    source /usr/local/opt/fzf/shell/key-bindings.zsh
    source /usr/local/opt/fzf/shell/completion.zsh
  elif [ -e /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  elif [ -e ~/.fzf ]; then
    source ~/.fzf/shell/key-bindings.zsh
    source ~/.fzf/shell/completion.zsh
  elif [ -f ~/.fzf.zsh ]; then
    # Auto-generated completion script when installing from custom path.
  fi

  if _has fd; then
    # Use fd for fzf.
    export FZF_DEFAULT_COMMAND='fd --type f --follow --hidden'
    # Use fd for fzf directory search.
    export FZF_ALT_C_COMMAND='fd --type d --color never'
  elif _has rg; then
    # Use ripgrep for fzf.
    export FZF_DEFAULT_COMMAND='rg --files --hidden'
  fi
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # Source fzf-cd plugin.
  if [[ -f ~/.dotfiles/third_party/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh ]]; then
   # echo "SOURCING interactive zsh plugin"
    source ~/.dotfiles/third_party/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
  fi

  export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"

  # Display source tree and file preview for CTRL-T and ALT-C.
  if _has tree; then
    # Show subdir tree for directories.
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
  fi

  # Bind alt-j/k/d/u to moving the preview window for fzf.
  export FZF_DEFAULT_OPTS="--bind alt-k:preview-up,alt-j:preview-down,alt-u:preview-page-up,alt-d:preview-page-down"

  # Show previews for files and directories.
  # Having `bat` or `highlight` (or any of the other binaries below) installed
  # enables syntax highlighting.
  export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -200'"

  if _has bat; then
    # Export theme for http://github.com/sharkdp/bat.
    export BAT_THEME="TwoDark"
  fi
fi

# Alias hub and git, such that we can use hub commands with git.
if _has hub; then
  eval "$(hub alias -s)"
fi

# Dircolors must be set last, since oh-my-zsh seems to rewrite those values.
if [[ "$(uname -s)" == "Linux" ]]; then
  eval `dircolors ~/.dircolors.256dark`;
else
  export LSCOLORS='ExFxBxDxCxegedabagacad'
fi

# ls after path change
function chpwd() {
    emulate -L zsh
    ls -l
}

function kxsec(){
  tmpl='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'
  #if second parameter is set change tmpl
  if [ -n "$2" ]; then
    tmpl="{{ index .data \"$2\"| base64decode }}"
  fi
  k get secret $1  -o go-template="$tmpl" 
}

	
   

source ~/.dotfiles/shell/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.dotfiles/shell/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=#fff
if [ -f ~/.dir_colors/dircolors ]
  then eval `dircolors ~/.dir_colors/dircolors`
fi
alias sc='bash ~/sshlist'
alias tf='terraform'

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#source ~/.kubectl_fzf.plugin.zsh
#source <(kubectl completion zsh) >> ~/.zshrc
#source ~/.kubectl_fzf.plugin.zsh >> ~/.zshrc


# No Hisotry logging for Jrnl
setopt HIST_IGNORE_SPACE
alias jrnl=" jrnl"
alias kctr='kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath="{.items[0].metadata.name}") bash'


# gh cli 
compctl -K _gh gh
compctl -K _task task
 if type brew &>/dev/null; then
        FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

             autoload -Uz compinit
                  compinit
 fi
#source /opt/homebrew/etc/bash_completion.d/az
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/tillganster/usr/local/bin/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/tillganster/usr/local/bin/etc/profile.d/conda.sh" ]; then
        . "/Users/tillganster/usr/local/bin/etc/profile.d/conda.sh"
    else
        export PATH="/Users/tillganster/usr/local/bin/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

#export GOPATH=$(go env GOPATH)

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH:$GOPATH/bin:/usr/bin"


alias kcx="kubectl ctx"
export rt NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
        [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
alias kns="kubectl ns"
alias tp="telepresence"
export XDG_CONFIG_HOME=~/.xdg

alias bashly='docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly'
createProjectAliases2() {
 eval "alias mercedes-benz='cd $HOME/projects/mercedes-benz'"
  
  for orgdir in $HOME/projects/mercedes-benz/*;
  do
    #echo "Orgdir loop $orgdir"
    organame=$(basename $orgdir)
    eval  "alias $organame='cd $orgdir'"

       
    for repodir in $orgdir/*;
    do
      reponame=$(basename $repodir)
      
      if type $reponame >/dev/null 2>&1; then
       true
      else
        if [ "$reponame" = 'argo' ]; then 
        true
        else 
          eval  "alias $reponame='cd $repodir'" 
          repocodename="$reponame-code"
          eval "alias '$repocodename'='cd $repodir; code .'"
        fi
      fi

      #echo "Repo loop $repodir"
    done

  done
}



createProjectAliases() {
for directory in $HOME/projects/*/*/*
do  
  orgapath=$(echo $directory | xargs dirname)
  orga=$( echo $orgapath | xargs basename)
  githubsourcefolder=$(echo $directory | xargs dirname | xargs dirname )
  githubsource=$(echo $githubsourcefolder | xargs basename )
  project=$(echo $directory | xargs -n 1 basename)
  orgalias="alias $orga='cd $orgapath'"
  projectalias="alias $project='cd $directory'"
  sourcealias="alias $githubsource='cd $githubsourcefolder'"
  #echo $orga
  #echo "Creating alias $projectalias"
  #echo "Creating alias $orgalias"
  eval $projectalias
  eval $sourcealias
  #eval $sourcealias
  eval $orgalias

done
}
if [ -d "$HOME/projects" ]; then
 createProjectAliases2
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# GH CLI ALIASES
#alias ruby="/opt/homebrew/Cellar/ruby/3.2.2_1/bin/ruby"
#alias gem="/opt/homebrew/Cellar/ruby/3.2.2_1/bin/gem"
alias ghmb="GH_HOST=git.i.mercedes-benz.com gh"
export GIT_EXTERNAL_DIFF=difft git diff
 #To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
alias vaultmb="vault -address=https://hcvault.app.corpintra.net/ -namespace=dp"

#export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
alias docker-compose="docker compose"
alias restart-darc="kubectl -n darc rollout restart deployment/host-app-backend-local && kubectl get deployment/host-app-backend-local -n darc -w"
alias dbx="docker buildx build --platform=linux/amd64,linux/arm64"
#export GOROOT="$(brew --prefix golang)/libexec"
#_append_to_path /opt/homebrew/Cellar/postgresql@15/15.9/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
_include  ~/.asdf/plugins/golang/set-env.zsh


compdef _myksecret myksecret
_include /Users/TGANSTE/.config/mbos/mbos_do_completion_zsh.sh

# Load Angular CLI autocompletion.
source <(ng completion script)
