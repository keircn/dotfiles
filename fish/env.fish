#!/usr/bin/env fish

if test -z "$XDG_CONFIG_HOME"
    set -gx XDG_CONFIG_HOME "$HOME/.config"
end

if test -z "$XDG_CONFIG_DIR"
    set -gx XDG_CONFIG_DIR "$HOME/.config"
end

if test -z "$XDG_DATA_HOME"
    set -gx XDG_DATA_HOME "$HOME/.local/share"
end

if test -z "$XDG_DATA_DIRS"
    set -gx XDG_DATA_DIRS "$XDG_DATA_HOME:/usr/local/share:/usr/share"
end

if test -z "$XDG_STATE_HOME"
    set -gx XDG_STATE_HOME "$HOME/.local/state"
end

if test -z "$XDG_CACHE_HOME"
    set -gx XDG_CACHE_HOME "$HOME/.cache"
end

if test -z "$XDG_DESKTOP_DIR"
    set -gx XDG_DESKTOP_DIR "$HOME/desktop"
end

if test -z "$XDG_DOWNLOAD_DIR"
    set -gx XDG_DOWNLOAD_DIR "$HOME/downloads"
end

if test -z "$XDG_TEMPLATES_DIR"
    set -gx XDG_TEMPLATES_DIR "$HOME/templates"
end

if test -z "$XDG_PUBLICSHARE_DIR"
    set -gx XDG_PUBLICSHARE_DIR "$HOME/public"
end

if test -z "$XDG_DOCUMENTS_DIR"
    set -gx XDG_DOCUMENTS_DIR "$HOME/documents"
end

if test -z "$XDG_MUSIC_DIR"
    set -gx XDG_MUSIC_DIR "$HOME/music"
end

if test -z "$XDG_PICTURES_DIR"
    set -gx XDG_PICTURES_DIR "$HOME/pictures"
end

if test -z "$XDG_VIDEOS_DIR"
    set -gx XDG_VIDEOS_DIR "$HOME/videos"
end

if test -z "$LESSHISTFILE"
    set -gx LESSHISTFILE /tmp/less-hist
end

if test -z "$PARALLEL_HOME"
    set -gx PARALLEL_HOME "$XDG_CONFIG_HOME/parallel"
end
