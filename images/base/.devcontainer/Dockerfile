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
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R dev:dev /commandhistory

# Install fzf for fuzzy finding
RUN curl -fsLo /tmp/fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz" && \
    tar -xf /tmp/fzf.tar.gz -C /usr/bin && \
    rm /tmp/fzf.tar.gz

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

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

# Install zsh-in-docker for powerlevel and plugins
RUN sh -c "$(curl -fsSL https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
    -p git \
    -p fzf \
    -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history" \
    -x

# =============================================================================
# Final Setup
# =============================================================================

# Set working directory
WORKDIR /workspace
