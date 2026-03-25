export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  fzf
)
HIST_STAMPS="dd.mm.yyyy"

# Cache compinit — zsh's completion system (compinit) scans all completion files
# and generates a dump (.zcompdump). This is expensive (~400ms).
# skip_global_compinit=1 prevents /etc/zshrc from running compinit before oh-my-zsh.
# Then we run compinit -C (uses the cache) day-to-day, and only recompile
# when the dump is older than 1 day or doesn't exist.
skip_global_compinit=1
source $ZSH/oh-my-zsh.sh
autoload -Uz compinit
if [ "$(find "${ZSH_COMPDUMP:-$HOME/.zcompdump}" -mtime +1 2>/dev/null)" ] || [ ! -f "${ZSH_COMPDUMP:-$HOME/.zcompdump}" ]; then
  compinit
else
  compinit -C
fi

source ~/.zsh/exports.zsh
source ~/.zsh/path.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/nu.zsh
source ~/.zsh/deferred.zsh
