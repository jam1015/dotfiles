# ============================================================================
# ZSH COMPLETION CONFIGURATION (Oh My Zsh replacement)
# ============================================================================

# Configuration flags
ZSH_COMPLETION_VERBOSE_MISSING=${ZSH_COMPLETION_VERBOSE_MISSING:-true}  # Set to false to silence missing file warnings
ZSH_ENABLE_AUTOSUGGESTIONS=${ZSH_ENABLE_AUTOSUGGESTIONS:-true}          # Set to false to disable autosuggestions even if installed
ZSH_ENABLE_SYNTAX_HIGHLIGHTING=${ZSH_ENABLE_SYNTAX_HIGHLIGHTING:-true}  # Set to false to disable syntax highlighting even if installed

# Helper function for checking and sourcing files
source_if_exists() {
    local file="$1"
    local package="$2"
    local description="$3"
    
    if [[ -f "$file" ]]; then
        source "$file"
        return 0
    else
        if [[ "$ZSH_COMPLETION_VERBOSE_MISSING" == true ]]; then
            echo "⚠ $description not found at: $file"
            echo "  → Install with: sudo pacman -S $package"
        fi
        return 1
    fi
}

# ============================================================================
# CORE COMPLETION SETUP
# ============================================================================

# Initialize completion system
if command -v compinit >/dev/null 2>&1; then
    autoload -Uz compinit
    
    # Check for and create completion dump directory
    if [[ ! -d "$HOME/.cache/zsh" ]]; then
        mkdir -p "$HOME/.cache/zsh"
    fi
    
    # Initialize completions with dump file for faster loading
    compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"
else
    if [[ "$ZSH_COMPLETION_VERBOSE_MISSING" == true ]]; then
        echo "⚠ compinit not found - core zsh completion system unavailable"
    fi
fi

# Load additional completions from zsh-completions package
if [[ -d "/usr/share/zsh/site-functions" ]]; then
    fpath=(/usr/share/zsh/site-functions $fpath)
elif [[ "$ZSH_COMPLETION_VERBOSE_MISSING" == true ]]; then
    echo "⚠ zsh-completions directory not found"
    echo "  → Install with: sudo pacman -S zsh-completions"
fi

# ============================================================================
# COMPLETION STYLES
# ============================================================================

# Menu selection with arrow keys
zstyle ':completion:*' menu select

# Case-insensitive, partial-word, and substring completion
zstyle ':completion:*' matcher-list \
    'm:{a-z}={A-Z}' \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=* l:|=*'

# Colorize completion menu (uses LS_COLORS if available)
if [[ -n "$LS_COLORS" ]]; then
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
else
    # Fallback colors if LS_COLORS not set
    zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34'
fi

# Format completion categories
zstyle ':completion:*:descriptions' format '%U%B%F{cyan}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%F{yellow}%d (errors: %e)%f%b'

# Group completions by category
zstyle ':completion:*' group-name ''

# Completion caching for faster responses
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"

# Partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Better process killing completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ============================================================================
# PLUGINS (from pacman packages)
# ============================================================================

# Autosuggestions (fish-like)
if [[ "$ZSH_ENABLE_AUTOSUGGESTIONS" == true ]]; then
    source_if_exists \
        "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
        "zsh-autosuggestions" \
        "Zsh autosuggestions plugin"
    
    # Configure autosuggestions if loaded
    if [[ -n "$ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE" ]] || command -v _zsh_autosuggest_start >/dev/null 2>&1; then
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept suggestion
    fi
fi

# Syntax highlighting (optional but nice)
if [[ "$ZSH_ENABLE_SYNTAX_HIGHLIGHTING" == true ]]; then
    source_if_exists \
        "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
        "zsh-syntax-highlighting" \
        "Zsh syntax highlighting plugin"
fi

# ============================================================================
# SHELL OPTIONS
# ============================================================================

# Completion options
setopt COMPLETE_IN_WORD    # Complete from both ends of a word
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word
setopt PATH_DIRS           # Perform path search even on command names with slashes
setopt AUTO_MENU           # Show completion menu on a successive tab press
setopt AUTO_LIST           # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash
setopt MENU_COMPLETE       # Cycle through completions with repeated tabs
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor

# History options (helps with autosuggestions)
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS        # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS       # Do not display a line previously found
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file
setopt SHARE_HISTORY           # Share history between all sessions

# Directory options
setopt AUTO_CD              # Auto cd into directories without typing cd
setopt AUTO_PUSHD          # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS   # Do not store duplicates in the stack
setopt PUSHD_SILENT        # Do not print the directory stack after pushd or popd

# Globbing options
setopt GLOB_DOTS           # Include hidden files in globbing
setopt EXTENDED_GLOB       # Use extended globbing syntax

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# ============================================================================
# KEY BINDINGS
# ============================================================================

# Enable Emacs key bindings (change to 'bindkey -v' for vi bindings)
bindkey -e

# Common key bindings for completion
bindkey '^[[Z' reverse-menu-complete  # Shift+Tab to go backward in menu
bindkey '^R' history-incremental-search-backward  # Ctrl+R for history search

# ============================================================================
# STARTUP MESSAGE (optional)
# ============================================================================

if [[ "$ZSH_COMPLETION_VERBOSE_MISSING" == true ]] && [[ -n "$ZSH_COMPLETION_SHOW_STARTUP" ]]; then
    echo "Zsh completion loaded from ~/.config/zsh/completion.zsh"
fi
