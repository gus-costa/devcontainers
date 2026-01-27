#!/bin/bash
# Base Image Test Suite
# Tests the base devcontainer image configuration
# See: specs/base-template.md

cd $(dirname "$0")

source test-utils.sh dev

# =============================================================================
# Test OS Packages
# See: specs/base-template.md#installed-packages
# =============================================================================

# Run common package tests (includes essential tools, locale, shell)
checkCommon

# =============================================================================
# Test Git Installation and Configuration
# See: specs/base-template.md#installed-packages
# =============================================================================

check "git-installed" git --version

# Test git-delta installation and configuration
# See: specs/base-template.md#git-enhancements
check "git-delta-installed" delta --version
check "git-delta-configured" sh -c "git config --system core.pager | grep delta"
check "git-delta-side-by-side" sh -c "git config --system delta.side-by-side | grep true"
check "git-delta-hyperlinks" sh -c "git config --system delta.hyperlinks | grep true"

# =============================================================================
# Test User Configuration
# See: specs/base-template.md#user-configuration
# =============================================================================

check "dev-user-exists" id dev
check "dev-user-home" test -d /home/dev
check "dev-user-shell" sh -c "getent passwd dev | grep /bin/zsh"

# =============================================================================
# Test Shell Configuration
# See: specs/base-template.md#shell
# =============================================================================

check "zsh-installed" zsh --version
check "oh-my-zsh-installed" test -d $HOME/.oh-my-zsh
check "oh-my-zsh-git-plugin" test -d $HOME/.oh-my-zsh/plugins/git
check "oh-my-zsh-fzf-plugin" test -d $HOME/.oh-my-zsh/plugins/fzf
check "powerlevel10k-theme" test -f $HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# Test fzf installation
# See: specs/base-template.md#shell
check "fzf-installed" fzf --version

# =============================================================================
# Test Environment Variables
# See: specs/base-template.md#environment-variables
# =============================================================================

check "env-lang" sh -c "echo \$LANG | grep en_US.UTF-8"
check "env-lc-all" sh -c "echo \$LC_ALL | grep en_US.UTF-8"
check "env-language" sh -c "echo \$LANGUAGE | grep en_US:en"
check "env-shell" sh -c "echo \$SHELL | grep /bin/zsh"
check "env-devcontainer" sh -c "echo \$DEVCONTAINER | grep true"
check "env-powerlevel9k" sh -c "echo \$POWERLEVEL9K_DISABLE_GITSTATUS | grep true"

# =============================================================================
# Test Command History Persistence
# See: specs/base-template.md#volumes
# =============================================================================

check "commandhistory-dir" test -d /commandhistory
check "commandhistory-owner" sh -c "stat -c '%U:%G' /commandhistory | grep dev:dev"

# =============================================================================
# Test Locale Configuration
# See: specs/base-template.md#installed-packages
# =============================================================================

check "locale-en-us" locale -a | grep en_US.utf8

# Report result
reportResults