#!/usr/bin/env bash

git submodule init
git submodule update

base=(
    bash
    git
)

config=(
    benben
    fastfetch
    fish
    fuzzel
    ghostty
    helix
    hypr
    mako
    niri
    waybar
    zellij
)

stowit() {
    local target=$1
    local app=$2

    if [[ "$target" == "$XDG_CONFIG_HOME" ]]; then
        echo "→ Stowing ${app} into ${target}/${app}"
        mkdir -p "${target}/${app}"
        pushd "$app" > /dev/null
        stow -v -R -t "${target}/${app}" .
        popd > /dev/null
    else
        echo "→ Stowing ${app} into ${target}"
        stow -v -R -t "${target}" "${app}"
    fi
}

echo ""
echo "Stowing base apps into $HOME"
for app in "${base[@]}"; do
    stowit "$HOME" "$app"
done

echo ""
echo "Stowing config apps into $XDG_CONFIG_HOME"
for app in "${config[@]}"; do
    stowit "$XDG_CONFIG_HOME" "$app"
done

echo ""
echo "ALL DONE"

