#!/usr/bin/env bash

export ZSHRC="$ZDOTDIR/.zshrc"
export LESSHISTFILE=$XDG_CACHE_HOME/lesshst

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer/

export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GOPATH="$XDG_DATA_HOME/go"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

export PATH=$GOPATH/bin:$PATH
