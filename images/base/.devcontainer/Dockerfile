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
ARG FZF_VERSION=0.67.0
ARG DELTA_VERSION=0.18.2

# Locale configuration
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    # Container identification
    DEVCONTAINER=true

# =============================================================================
# System Packages
# See: specs/base-template.md#installed-packages
# =============================================================================

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essential tools
    git \
    vim \
    curl \
    ca-certificates \
    gnupg \
    sudo \
    less \
    unzip \
    jq \
    man-db \
    procps \
    zsh \
    # Locale support
    locales \
    # Timezone support
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Configure timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone

# =============================================================================
# User Configuration
# See: specs/base-template.md#user-configuration
# =============================================================================

# Create non-root user 'dev' with UID 1000
RUN useradd -m -s /bin/zsh -u 1000 dev && \
    # Fix ownership of home directory
    chown -R dev:dev /home/dev

# =============================================================================
# Shell Configuration
# See: specs/base-template.md#shell
# =============================================================================

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/home/dev/.local/share/history/.bash_history" \
  && mkdir -p /home/dev/.local/share/history \
  && touch /home/dev/.local/share/history/.bash_history \
  && chown -R dev:dev /home/dev/.local

# Install fzf for fuzzy finding with checksum verification
# See: specs/base-template.md#installed-packages
# Checksums from https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf_0.67.0_checksums.txt
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
      FZF_SHA256="4be08018ca37b32518c608741933ea335a406de3558242b60619e98f25be2be1"; \
    elif [ "$ARCH" = "arm64" ]; then \
      FZF_SHA256="7071f48c2ac0f2bc992d6d33cc36fd675a579a98cc976dda699eea07dd5e9c58"; \
    else \
      echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -fsLo /tmp/fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${ARCH}.tar.gz" && \
    echo "${FZF_SHA256}  /tmp/fzf.tar.gz" | sha256sum -c - && \
    tar -xf /tmp/fzf.tar.gz -C /usr/bin && \
    rm /tmp/fzf.tar.gz

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# =============================================================================
# Git Enhancements
# See: specs/base-template.md#git-enhancements
# =============================================================================

# Install git-delta for better diffs with checksum verification
# See: specs/base-template.md#git-enhancements
# Checksums calculated from official releases at https://github.com/dandavison/delta/releases/tag/0.18.2
# DELTA_VERSION can be overridden via build args (default: 0.18.2)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
      DELTA_SHA256="1658c7b61825d411b50734f34016101309e4b6e7f5799944cf8e4ac542cebd7f"; \
    elif [ "$ARCH" = "arm64" ]; then \
      DELTA_SHA256="937781aa7788e1510858743fff6c9a8b4a69fe0a22a7c8a69493e633227939a9"; \
    else \
      echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb" -o /tmp/git-delta.deb && \
    echo "${DELTA_SHA256}  /tmp/git-delta.deb" | sha256sum -c - && \
    dpkg -i /tmp/git-delta.deb && \
    rm /tmp/git-delta.deb

# Configure git to use delta
RUN git config --system core.pager "delta" && \
    git config --system interactive.diffFilter "delta --color-only" && \
    git config --system delta.navigate true && \
    git config --system delta.side-by-side true && \
    git config --system merge.conflictstyle "diff3" && \
    git config --system diff.colorMoved "default" && \
    git config --system delta.hyperlinks true && \
    git config --system delta.hyperlinks-file-link-format "vscode://file/{path}:{line}"

# Default to non-root user
USER dev

ENV POWERLEVEL9K_DISABLE_GITSTATUS=true

# Install zsh-in-docker for powerlevel and plugins with checksum verification
# See: specs/base-template.md#shell
# Checksum calculated from official release at https://github.com/deluan/zsh-in-docker/releases/tag/v1.2.0
RUN ZSH_IN_DOCKER_SHA256="f74e5b08c295b6c3886654bb63c688e5ea16c58a4209435c4ddbab2c42fe9b41" && \
    curl -fsSL https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh -o /tmp/zsh-in-docker.sh && \
    echo "${ZSH_IN_DOCKER_SHA256}  /tmp/zsh-in-docker.sh" | sha256sum -c - && \
    sh /tmp/zsh-in-docker.sh \
      -p git \
      -p fzf \
      -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/home/dev/.local/share/history/.zsh_history" \
      -x && \
    rm /tmp/zsh-in-docker.sh

COPY --chown=dev:dev env /home/dev/.local/bin/env

RUN echo "\n. \"\$HOME/.local/bin/env\"" >> "/home/dev/.profile" && \
    echo "\n. \"\$HOME/.local/bin/env\"" >> "/home/dev/.bashrc" && \
    echo "\n. \"\$HOME/.local/bin/env\"" >> "/home/dev/.zshrc"

# =============================================================================
# Final Setup
# =============================================================================

# Set working directory
WORKDIR /workspace
