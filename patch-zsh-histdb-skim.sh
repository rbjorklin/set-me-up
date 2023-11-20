#!/usr/bin/env bash


# https://nixos.wiki/wiki/Packaging/Binaries

nix-shell -p stdenv --run '\
    patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath /nix/store/7xx6irwzdpj5fwbdbgxm8bb7r179ddmv-sqlite-3.41.2/lib \
        ~/.local/share/zsh-histdb-skim/zsh-histdb-skim'
