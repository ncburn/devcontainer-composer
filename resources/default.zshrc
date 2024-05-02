# export ZSH="$HOME/.oh-my-zsh"
# plugins=(git)
# source $ZSH/oh-my-zsh.sh
EXPORT PATH=$PATH:~/.local/bin

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000

eval "$(oh-my-posh init bash --config ~/citrus-simple.omp.json)"
