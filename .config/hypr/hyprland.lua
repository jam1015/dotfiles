-- ~/.config/hypr/hyprland.lua
-- Ported from hyprland.conf (river-classic modal keybind scheme).

hl.config({
    debug = { disable_logs = false },
})

-- ─── A) Monitors ──────────────────────────────────────────────────────────────
hl.monitor({ output = "DP-11", mode = "1920x1080@60", position = "0x0",    scale = 1,   transform = 1 })
hl.monitor({ output = "DP-13", mode = "1920x1080@60", position = "1080x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "2880x1920@60", position = "1080x1080", scale = 1.6 })
hl.monitor({ output = "",      mode = "preferred",    position = "auto",  scale = 1 })

-- ─── B) Environment Variables ─────────────────────────────────────────────────
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("QT_IM_MODULES",       "wayland;fcitx")
hl.env("QT_IM_MODULE",        "fcitx")
hl.env("XMODIFIERS",          "@im=fcitx")
hl.env("SDL_IM_MODULE",       "fcitx")
hl.env("GLFW_IM_MODULE",      "ibus")
hl.env("GTK_THEME",           "Arc-Dark")
hl.env("QT_STYLE_OVERRIDE",   "adwaita")
hl.env("QT_QPA_PLATFORMTHEME","qt5ct")
hl.env("GCM_PROFILE_FILE",    "/usr/share/color/icc/framework-2.8k.icc")
hl.env("ICC_PROFILE",         "/usr/share/color/icc/framework-2.8k.icc")
hl.env("XCURSOR_THEME",       "Breeze5")
hl.env("XCURSOR_SIZE",        "24")

-- ─── C) Autostart ─────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/monitor_setup.sh")
    hl.exec_cmd("dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XAUTHORITY")
    hl.exec_cmd("sh -c 'killall fcitx5; fcitx5 -d'")
    hl.exec_cmd("swaync")
    hl.exec_cmd("sh -c 'sleep 2 && swaync-client --dnd-on'")
    hl.exec_cmd("sh -c 'pkill -9 polkit-gnome-authentication-agent-1; /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1'")
    hl.exec_cmd("wlsunset")
    hl.exec_cmd("waybar --config ~/.config/waybar/config-hyprland.jsonc")
    hl.exec_cmd("swayidle timeout 1200 'swaylock -f --color 000000' before-sleep 'swaylock -f --color 000000'")
    hl.exec_cmd("sh -c 'sleep 1 && ~/.config/hypr/scripts/set_global_workspace.sh 1'")
    -- Prewarm a kitty --single-instance daemon so the first mod+Return is fast.
    hl.exec_cmd("kitty --single-instance --class=kitty-prewarm sh -c 'exec sleep infinity'")
end)

-- ─── D) Input / General / Decoration / Misc / Master ──────────────────────────
hl.config({
    input = {
        kb_layout     = "us",
        kb_options    = "ctrl:nocaps,compose:ralt",
        follow_mouse  = 1,
        mouse_refocus = true,
        repeat_rate   = 45,
        repeat_delay  = 195,
        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        warp_on_change_workspace = true,
    },

    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 2,
        col = {
            -- Active = saturated purple→magenta gradient.
            active_border   = { colors = { "rgba(a020f0ff)", "rgba(d946efff)" }, angle = 45 },
            -- Inactive = deep purple-black so unfocused windows recede.
            inactive_border = "rgba(15121fff)",
        },
        layout = "master",
    },

    decoration = {
        rounding = 0,
        shadow = { enabled = false },
    },

    misc = {
        background_color        = "rgb(02091c)",
        disable_hyprland_logo   = true,
        disable_splash_rendering = false,
    },

    master = {
        new_status  = "slave",
        mfact       = 0.55,
        orientation = "left",
    },

    animations = {
        enabled = false,
    },
})

-- ─── E) Animations (disabled via animations.enabled = false above) ────────────
-- Preserved for reference; re-enable by setting animations.enabled = true and
-- uncommenting the block below.
--
-- hl.curve("snap",     { type = "bezier", points = { { 0.05, 0.9  }, { 0.1, 1.0 } } })
-- hl.curve("snappier", { type = "bezier", points = { { 0.05, 0.95 }, { 0.1, 1.0 } } })
-- hl.curve("linear",   { type = "bezier", points = { { 0.0,  0.0  }, { 1.0, 1.0 } } })
-- hl.curve("easeOut",  { type = "bezier", points = { { 0.0,  0.9  }, { 0.2, 1.0 } } })
-- hl.curve("crazy",    { type = "bezier", points = { { -1,  -1    }, { 2,   2   } } })
--
-- hl.animation({ leaf = "windows",          enabled = true,  speed = 2, bezier = "snappier", style = "popin 85%" })
-- hl.animation({ leaf = "windowsOut",       enabled = true,  speed = 2, bezier = "snappier", style = "slide" })
-- hl.animation({ leaf = "windowsMove",      enabled = true,  speed = 5, bezier = "snap" })
-- hl.animation({ leaf = "border",           enabled = true,  speed = 5, bezier = "linear" })
-- hl.animation({ leaf = "borderangle",      enabled = false, speed = 5, bezier = "linear" })
-- hl.animation({ leaf = "fade",             enabled = true,  speed = 5, bezier = "linear" })
-- hl.animation({ leaf = "workspaces",       enabled = true,  speed = 5, bezier = "easeOut",  style = "slide" })
-- hl.animation({ leaf = "specialWorkspace", enabled = true,  speed = 5, bezier = "snap",     style = "slidevert" })
-- hl.animation({ leaf = "layersOut",        enabled = true,  speed = 1, bezier = "snappier", style = "fade" })

-- ─── F) Window Rules ──────────────────────────────────────────────────────────
local float_classes = {
    "Yad", "Galculator", "Blueberry.py", "Xsane",
    "org.pulseaudio.pavucontrol", "qt5ct",
    "Bluetooth-sendto", "Pamac-manager",
}
for _, cls in ipairs(float_classes) do
    hl.window_rule({ match = { class = cls }, float = true })
end
hl.window_rule({ match = { title = "About" }, float = true })
-- Park the kitty prewarm window on a special workspace so it stays invisible.
hl.window_rule({ match = { class = "kitty-prewarm" }, workspace = "special:prewarm silent" })

-- ─── G) Top-level (no-submap) binds ───────────────────────────────────────────

-- Volume (repeatable, works when locked)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_up.sh"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_down.sh"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_mute.sh"), { locked = true })
hl.bind("Prior",                hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_up.sh"),   { locked = true, repeating = true })
hl.bind("Next",                 hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_down.sh"), { locked = true, repeating = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness_up.sh"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness_down.sh"), { locked = true, repeating = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("~/.config/hypr/scripts/media_play_pause.sh"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("~/.config/hypr/scripts/media_next.sh"),       { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("~/.config/hypr/scripts/media_prev.sh"),       { locked = true })

-- Emergency exit / reload
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind("SUPER + SHIFT + E",   hl.dsp.exit())
hl.bind("SUPER + SHIFT + R",   hl.dsp.exec_cmd("hyprctl reload"))

-- Enter prefix submap on Super press.
-- NOTE: modkey-only binds in Lua require the TARGET modmask + release flag.
hl.bind("SUPER + SUPER_L", hl.dsp.submap("prefix"), { release = true })
hl.bind("SUPER + SUPER_R", hl.dsp.submap("prefix"), { release = true })

-- ─── H) prefix submap ─────────────────────────────────────────────────────────
-- Second arg "reset" = auto-reset to default submap after every bind fires.
-- This collapses all the old `bind ...; bind ..., submap, reset` pairs.
hl.define_submap("prefix", "reset", function()

    hl.bind("slash", hl.dsp.exec_cmd("kitty --class=KeybindViewer ~/.config/hypr/scripts/show_keybinds.sh"))
    hl.bind("w",     hl.dsp.exec_cmd("~/.config/hypr/scripts/switch_workspace.sh"))

    -- Double-tap Super → prefix2. Uses submap_universal-style pattern:
    -- inside prefix, Super isn't held, so bare key.
    hl.bind("SUPER_L", hl.dsp.submap("prefix2"))
    hl.bind("SUPER_R", hl.dsp.submap("prefix2"))

    -- Escape / Ctrl+[ → normal (auto-reset handles this, but keep explicit)
    hl.bind("escape",       hl.dsp.submap("reset"))
    hl.bind("CTRL + bracketleft", hl.dsp.submap("reset"))

    -- Window ops
    hl.bind("q",      hl.dsp.window.close())
    hl.bind("return", hl.dsp.exec_cmd("~/.config/hypr/scripts/samedir_term.sh"))

    -- Focus (in-layout)
    hl.bind("j", hl.dsp.layout("cyclenext"))
    hl.bind("k", hl.dsp.layout("cycleprev"))

    -- Output focus
    hl.bind("n", hl.dsp.focus({ monitor = "+1" }))
    hl.bind("p", hl.dsp.focus({ monitor = "-1" }))

    -- Swap in stack
    hl.bind("period", hl.dsp.layout("swapnext"))
    hl.bind("comma",  hl.dsp.layout("swapprev"))

    -- Send window to another output
    hl.bind("bracketright", hl.dsp.window.move({ monitor = "+1" }))
    hl.bind("bracketleft",  hl.dsp.window.move({ monitor = "-1" }))

    -- Float / fullscreen
    hl.bind("c", hl.dsp.window.float({ action = "toggle" }))
    hl.bind("f", hl.dsp.window.fullscreen())

    -- Launchers
    hl.bind("d",         hl.dsp.exec_cmd("~/.config/hypr/scripts/launch_wofi_drun.sh"))
    hl.bind("SHIFT + d", hl.dsp.exec_cmd("~/.config/hypr/scripts/launch_wofi_window.sh"))

    -- Layout orientation
    hl.bind("y", hl.dsp.layout("orientationleft"))
    hl.bind("i", hl.dsp.layout("orientationtop"))
    hl.bind("o", hl.dsp.layout("orientationright"))
    hl.bind("u", hl.dsp.layout("orientationbottom"))

    -- Main ratio
    hl.bind("g",         hl.dsp.exec_cmd("hyprctl dispatch layoutmsg 'mfact +0.05'"))
    hl.bind("SHIFT + g", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg 'mfact -0.05'"))

    -- Main count
    hl.bind("SHIFT + equal", hl.dsp.layout("addmaster"))
    hl.bind("minus",         hl.dsp.layout("removemaster"))

    -- Global workspace switching (all monitors → workspace N)
    for i = 1, 9 do
        hl.bind(tostring(i), hl.dsp.exec_cmd("~/.config/hypr/scripts/set_global_workspace.sh " .. i))
    end
    hl.bind("0", hl.dsp.exec_cmd("~/.config/hypr/scripts/set_global_workspace.sh 10"))
end)

-- ─── I) prefix2 submap ────────────────────────────────────────────────────────
hl.define_submap("prefix2", "reset", function()

    hl.bind("slash", hl.dsp.exec_cmd("kitty --class=KeybindViewer ~/.config/hypr/scripts/show_keybinds.sh"))

    -- Stack rotation
    hl.bind("period", hl.dsp.exec_cmd("~/.config/hypr/scripts/rotate_stack.sh"))
    hl.bind("comma",  hl.dsp.exec_cmd("~/.config/hypr/scripts/rotate_stack_reverse.sh"))

    -- Exit
    hl.bind("SUPER_L",           hl.dsp.submap("reset"))
    hl.bind("SUPER_R",           hl.dsp.submap("reset"))
    hl.bind("escape",            hl.dsp.submap("reset"))
    hl.bind("CTRL + bracketleft", hl.dsp.submap("reset"))

    -- Per-monitor (local) workspace switching
    for i = 1, 9 do
        hl.bind(tostring(i), hl.dsp.focus({ workspace = i }))
    end
    hl.bind("0", hl.dsp.focus({ workspace = 10 }))

    -- Move window to workspace (wofi prompt)
    hl.bind("m", hl.dsp.exec_cmd("~/.config/hypr/scripts/move_window_to_workspace.sh 0"))
    hl.bind("l", hl.dsp.exec_cmd("~/.config/hypr/scripts/move_window_to_workspace.sh 1"))

    -- Apps
    hl.bind("e",     hl.dsp.exec_cmd("emacsclient -c"))
    hl.bind("n",     hl.dsp.exec_cmd("neovide"))
    hl.bind("d",     hl.dsp.exec_cmd("~/.config/hypr/scripts/launch_zsh_runner.sh"))

    -- fcitx5: cycle input method
    hl.bind("space", hl.dsp.exec_cmd("~/.config/hypr/scripts/fcitx5_cycle.sh"))
end)

-- ─── J) Mouse Bindings ────────────────────────────────────────────────────────
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),                     { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(),                   { mouse = true })
hl.bind("SUPER + mouse:274", hl.dsp.window.float({ action = "toggle" }))
