#!/usr/bin/env bash

export LESSHISTFILE=$XDG_CACHE_HOME/lesshst

export GOPATH="$XDG_DATA_HOME/go"
export PATH=$GOPATH/bin:$PATH

export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer/
