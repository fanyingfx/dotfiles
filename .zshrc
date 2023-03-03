# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zplug/init.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
eval "$(zoxide init zsh)"
eval "$(mcfly init zsh)"
SAVEHIST=1000
HISTFILE=~/.zsh_history


zplug "zsh-users/zsh-completions", defer:0
zplug "zsh-users/zsh-autosuggestions", defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search" #,defer:3,on:"zsh-users/zsh-syntax-highlighting"

#zplug "plugins/docker", from:oh-my-zsh
#zplug "plugins/composer", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
#zplug "lib/completion", from:oh-my-zsh
#zplug "plugins/sudo", from:oh-my-zsh
zplug "b4b4r07/enhancd", use:init.sh


zplug load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=$PATH:$HOME/.local/bin


# My Alias
alias vim=nvim
alias ls=exa

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
