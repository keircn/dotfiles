local mod = "ALT"
local term = "kitty"
local menu = "fuzzel"
local browser = "firefox"

hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@100",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

hl.config({
  general = {
    border_size = 2,
    gaps_in = 6,
    gaps_out = 0,
    allow_tearing = true,
    layout = "dwindle",
    col = {
      active_border = "rgb(685878)",
      inactive_border = "rgb(23232a)",
    },
  },

  decoration = {
    rounding = 8,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    blur = {
      enabled = false,
    },
    shadow = {
      enabled = false,
    },
  },

  animations = {
    enabled = false,
  },

  input = {
    kb_layout = "us",
    kb_options = "ctrl:nocaps",
    repeat_delay = 250,
    repeat_rate = 50,
    follow_mouse = 1,
  },

  dwindle = {
    preserve_split = true,
    smart_resizing = true,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
    vfr = true,
  },

  binds = {
    workspace_back_and_forth = true,
  },
})

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -s b -- wl-paste -t text --watch clipman store --no-persist")
  hl.exec_cmd("uwsm app -s b -- solaar -w hide")
  hl.exec_cmd("uwsm app -s a -- nicotine --hidden")
  hl.exec_cmd("uwsm app -s b -- waybar -c ~/.config/waybar/waybar.jsonc -s ~/.config/waybar/style.css")
  hl.exec_cmd("uwsm app -s b -- fnott")
  hl.exec_cmd("systemctl --user start hypridle.service")
  hl.exec_cmd("uwsm app -s b -- hyprpaper")
  hl.exec_cmd("uwsm app -s b -- /usr/lib/hyprpolkitagent/hyprpolkitagent")
  hl.exec_cmd("uwsm app -s b -- hyprlauncher --daemon")
end)

hl.bind(mod .. " + t", hl.dsp.exec_cmd("uwsm app -- " .. term))
hl.bind(mod .. " + d", hl.dsp.exec_cmd("uwsm app -- " .. menu))
hl.bind(mod .. " + b", hl.dsp.exec_cmd("uwsm app -- " .. browser))
hl.bind(mod .. " + c", hl.dsp.exec_cmd("uwsm app -- clipman pick -t wofi -T=' -G'"))

hl.bind(mod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "r" }))

hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))

hl.bind(mod .. " + x", hl.dsp.layout("preselect r"))
hl.bind(mod .. " + v", hl.dsp.layout("preselect d"))
hl.bind(mod .. " + a", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + s", hl.dsp.group.toggle())
hl.bind(mod .. " + w", hl.dsp.group.lock_active({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + a", hl.dsp.group.lock_active({ action = "disable" }))

hl.bind(mod .. " + m", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.window.tag({ tag = \"-swap\", window = \"tag:swap\" })'; hyprctl dispatch 'hl.dsp.window.tag({ tag = \"+swap\" })'"))
hl.bind(mod .. " + SHIFT + m", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.window.swap({ target = \"tag:swap\" })'"))

hl.bind(mod .. " + minus", hl.dsp.window.move({ workspace = "special:scratch" }))
hl.bind(mod .. " + equal", hl.dsp.workspace.toggle_special("scratch"))

hl.bind(mod .. " + r", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind("SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
  hl.bind("SHIFT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
  hl.bind("SHIFT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
  hl.bind("SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
  hl.bind("Return", hl.dsp.submap("reset"))
  hl.bind("Escape", hl.dsp.submap("reset"))
  hl.bind("catchall", hl.dsp.submap("reset"))
end)

for i = 1, 8 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + c", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + f", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))

hl.bind("Print", hl.dsp.exec_cmd("uwsm app -- grabit"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("uwsm app -- brightnessctl set +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("uwsm app -- brightnessctl set 10%-"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("uwsm app -- wpctl set-volume @DEFAULT_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("uwsm app -- wpctl set-volume @DEFAULT_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("uwsm app -- wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })

hl.bind(mod .. " + SHIFT + s", hl.dsp.exec_cmd("uwsm app -- hyprlock"))
hl.bind(mod .. " + SHIFT + e", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.window_rule({
  name = "floating-chrome-extension",
  match = { class = "chrome-nngceckbapebfimnlniiiahkandclblb-Default" },
  float = true,
  size = { 820, 620 },
  center = true,
  border_size = 2,
})

hl.window_rule({
  name = "float-grabber",
  match = { class = "cr.fr.bionus.Grabber" },
  float = true,
})

hl.window_rule({
  name = "allow-tearing-for-games",
  match = { content = "game" },
  immediate = true,
})
