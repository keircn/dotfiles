#!/usr/bin/env fish

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CONFIG_DIR "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_DATA_DIRS "$XDG_DATA_HOME:/usr/local/share:/usr/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DESKTOP_DIR "$HOME/desktop"
set -gx XDG_DOWNLOAD_DIR "$HOME/downloads"
set -gx XDG_TEMPLATES_DIR "$HOME/templates"
set -gx XDG_PUBLICSHARE_DIR "$HOME/public"
set -gx XDG_DOCUMENTS_DIR "$HOME/documents"
set -gx XDG_MUSIC_DIR "$HOME/music"
set -gx XDG_PICTURES_DIR "$HOME/pictures"
set -gx XDG_VIDEOS_DIR "$HOME/videos"
set -gx LESSHISTFILE /tmp/less-hist
set -gx PARALLEL_HOME "$XDG_CONFIG_HOME/parallel"
set -gx STEAM_COMPAT_DATA_PATH "$HOME/.local/share/steam-local/compatdata"
