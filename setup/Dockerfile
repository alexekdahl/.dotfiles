FROM ubuntu:24.04

ENV LANG=en_DK.UTF-8 \
    LC_ALL=en_DK.UTF-8 \
    TERM=xterm-256color \
    DEBIAN_FRONTEND=noninteractive

# Install minimal base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh curl git locales build-essential sudo ca-certificates wget pkg-config \
 && locale-gen en_DK.UTF-8 \
 && update-locale LANG=en_DK.UTF-8 LC_ALL=en_DK.UTF-8 \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user with passwordless sudo
RUN useradd -m -s /bin/zsh alex && \
    echo "alex ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/alex && \
    chmod 440 /etc/sudoers.d/alex

USER alex
WORKDIR /home/alex

# Combined setup: keeps environment variables across commands
RUN bash -c '\
    set -e; \
    \
    # Clone and setup dotfiles
    curl -fsSL https://raw.githubusercontent.com/alexekdahl/.dotfiles/main/setup/install.sh | bash; \
    \
    # Setup Homebrew PATH for subsequent commands
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"; \
    \
    # Run post-install with Homebrew in PATH
    bash ~/.dotfiles/setup/post-install.sh; \
    mkdir -p ~/dev/personal; \
    '

SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/bin/zsh"]
