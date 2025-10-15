# Load completion list module
zmodload -i zsh/complist

# Ensure cache directory exists
[[ -d "$HOME/.zsh/cache" ]] || mkdir -p "$HOME/.zsh/cache"

# Initialize completion with optimization
autoload -Uz compinit

# Smart compinit: only run full check once per day
# This uses zsh glob qualifiers:
#   N = NULL_GLOB (don't error if file doesn't exist)
#   mh+24 = modified more than 24 hours ago
if [[ -n "$HOME"/.zcompdump(#qNmh+24) ]]; then
  # Dump is old (>24h) or doesn't exist - do full init
  compinit
else
  # Dump is fresh - skip security check for speed
  compinit -C
fi

# Compile dump file in background if needed
if [[ ! -f "$HOME/.zcompdump.zwc" || "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" ]]; then
  zcompile "$HOME/.zcompdump" &!
fi

# Don't treat certain characters as word separators
WORDCHARS=''

# Completion behavior
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
unsetopt correct_all
typeset -U path

# History file configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000

# History command configuration
setopt extended_history          # Record timestamp of command in HISTFILE
setopt hist_expire_dups_first    # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_space         # Ignore commands that start with space
setopt hist_verify               # Show command with history expansion to user before running it
setopt inc_append_history        # Add commands to HISTFILE in order of execution
setopt share_history             # Share command history data
setopt inc_append_history_time
setopt HIST_FCNTL_LOCK

# Completion options
setopt auto_menu                 # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# Completion styles
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# History search keybindings
# Start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search

# Start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit
