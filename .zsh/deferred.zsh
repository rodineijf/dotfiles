# Tools that were previously deferred via zsh-defer.

# rbenv
eval "$(rbenv init -)"

# NVM
export NVM_DIR="/Users/rodinei.fagundes/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

# Conda
__conda_setup="$(/Users/rodinei.fagundes/miniforge3/bin/conda shell.zsh hook 2>/dev/null)"
if [ $? -eq 0 ]; then eval "$__conda_setup"
elif [ -f "/Users/rodinei.fagundes/miniforge3/etc/profile.d/conda.sh" ]; then
  . "/Users/rodinei.fagundes/miniforge3/etc/profile.d/conda.sh"
else export PATH="/Users/rodinei.fagundes/miniforge3/bin:$PATH"
fi
unset __conda_setup

# Navi
eval "$(navi widget zsh)"

# Atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
