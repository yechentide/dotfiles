#!/usr/bin/env bash

export ZSHRC="${ZDOTDIR}/.zshrc"
export LESSHISTFILE="${XDG_CACHE_HOME}/lesshst"

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer/

export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export GOPATH="${XDG_DATA_HOME}/go"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
export PATH="${HOME}/.local/bin:${GOPATH}/bin:${HOME}/.local/share/npm/bin:${PATH}"
