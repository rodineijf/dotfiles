# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Ruby gems
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$GEM_HOME/bin:$PATH"

# Emacs
export PATH="$HOME/.config/emacs/bin:$PATH"

# Java
export JAVA_HOME=$(/usr/libexec/java_home -v21)

# FVM
export PATH="$HOME/fvm/bin:$PATH"

# Local bin
export PATH="$PATH:$HOME/.local/bin"
