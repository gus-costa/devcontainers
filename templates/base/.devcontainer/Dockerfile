# Base Devcontainer Image
# See: specs/base-template.md
#
# Purpose: General-purpose development container with network isolation
# enforced via iptables firewall routing all traffic through Squid proxy.

FROM debian:bookworm-slim

# =============================================================================
# Arguments and Environment
# See: specs/base-template.md#environment-variables
# =============================================================================

ARG TIMEZONE=UTC

# Proxy configuration - routes all traffic through Squid
# See: specs/squid-proxy.md
ENV HTTP_PROXY=http://squid:3128 \
    http_proxy=http://squid:3128 \
    HTTPS_PROXY=http://squid:3128 \
    https_proxy=http://squid:3128 \
    NO_PROXY=localhost,127.0.0.1 \
    no_proxy=localhost,127.0.0.1

# Locale configuration
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

# Container identification
ENV DEVCONTAINER=true

# =============================================================================
# System Packages
# See: specs/base-template.md#installed-packages
# =============================================================================

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essential tools
    git \
    vim \
    curl \
    wget \
    ca-certificates \
    gnupg \
    sudo \
    less \
    unzip \
    jq \
    man-db \
    procps \
    # Networking/Firewall - required for traffic isolation
    iptables \
    ipset \
    iproute2 \
    dnsutils \
    # Locale support
    locales \
    # Timezone support
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Configure locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Configure timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone

# =============================================================================
# Git Enhancements
# See: specs/base-template.md#git-enhancements
# =============================================================================

# Install git-delta for better diffs
RUN ARCH=$(dpkg --print-architecture) && \
    DELTA_VERSION="0.18.2" && \
    curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb" -o /tmp/git-delta.deb && \
    dpkg -i /tmp/git-delta.deb && \
    rm /tmp/git-delta.deb

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# =============================================================================
# User Configuration
# See: specs/base-template.md#user-configuration
# =============================================================================

# Create non-root user 'dev' with UID 1000
RUN useradd -m -s /bin/zsh -u 1000 dev

# Passwordless sudo for firewall script only
RUN echo "dev ALL=(ALL) NOPASSWD: /home/dev/.devcontainer/init-firewall.sh" >> /etc/sudoers.d/dev-firewall && \
    chmod 0440 /etc/sudoers.d/dev-firewall

# =============================================================================
# Shell Configuration
# See: specs/base-template.md#shell
# =============================================================================

# Install zsh
RUN apt-get update && apt-get install -y --no-install-recommends zsh && \
    rm -rf /var/lib/apt/lists/*

# Install zsh-in-docker for powerlevel10k and plugins
RUN sh -c "$(curl -fsSL https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t powerlevel10k/powerlevel10k \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting

# Install fzf for fuzzy finding
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/dev/.fzf && \
    /home/dev/.fzf/install --all --no-update-rc && \
    chown -R dev:dev /home/dev/.fzf

# Configure git to use delta
RUN git config --system core.pager "delta" && \
    git config --system interactive.diffFilter "delta --color-only" && \
    git config --system delta.navigate true && \
    git config --system delta.side-by-side true && \
    git config --system merge.conflictstyle "diff3" && \
    git config --system diff.colorMoved "default"

# =============================================================================
# Final Setup
# =============================================================================

# Fix ownership of home directory
RUN chown -R dev:dev /home/dev

# Set working directory
WORKDIR /workspace

# Default to non-root user
USER dev
