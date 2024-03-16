#!/usr/bin/env bash

function show-colors-combi() {
    clear;
    for fore in $(seq 30 37); do
        printf "\e[%sm \\\e[%sm \e[m\n" "$fore" "$fore";
        for mode in 1 4 5; do
            printf "\e[%s;%sm \\\e%s;%sm \e[m" "$fore" "$mode" "$fore" "$mode";
            for back in $(seq 40 47); do
                printf "\e[%s;%s;%sm \\\e[%s;%s;%sm \e[m" "$fore" "$back" "$mode" "$fore" "$back" "$mode";
            done;
            echo;
        done;
        echo;
    done;
    printf " \\\e[m\n"
}

function show-brew-unused-deps() {
    brew list --formula | \
    xargs -P$(($(sysctl -n hw.ncpu) - 1)) -I{} \
        sh -c 'brew uses --installed {} | wc -l | xargs printf "%20s is used by %2d formulae.\n" {}' | \
    grep ' 0 formulae'
}

function remove_spm_cache() {
    rm -rf ~/Library/Caches/org.swift.swiftpm
    rm -rf ~/Library/org.swift.swiftpm
}
