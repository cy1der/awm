local awful = require 'awful'
local hotkeys_popup = require 'awful.hotkeys_popup'
require 'awful.hotkeys_popup.keys'
local menubar = require 'menubar'

local apps = require 'config.apps'
local mod = require 'bindings.mod'
local switcher = require 'modules.switcher'

menubar.utils.terminal = apps.terminal

-- general awesome keys
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.super},
        key = 's',
        description = 'show help',
        group = 'awesome',
        on_press = hotkeys_popup.show_help
    }, awful.key {
        modifiers = {mod.super, mod.ctrl},
        key = 'r',
        description = 'reload awesome',
        group = 'awesome',
        on_press = awesome.restart
    }
}

-- applications keys
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.super},
        key = 'Return',
        description = 'open terminal',
        group = 'applications',
        on_press = function() awful.spawn(apps.terminal) end
    }, awful.key {
        modifiers = {mod.super},
        key = 'b',
        description = 'open browser',
        group = 'applications',
        on_press = function() awful.util.spawn_with_shell('firefox') end
    }, awful.key {
        modifiers = {mod.super},
        key = "d",
        description = "open Discord",
        group = "applications",
        on_press = function()
            awful.util.spawn_with_shell("/usr/lib/discord/Discord")
        end
    }, awful.key {
        modifiers = {mod.super},
        key = "p",
        description = "open file manager",
        group = "applications",
        on_press = function() awful.util.spawn_with_shell("thunar") end
    }, awful.key {
        modifiers = {mod.super},
        key = "l",
        description = "open Obsidian",
        group = "applications",
        on_press = function()
            awful.util.spawn_with_shell("/opt/obsidian/obsidian")
        end
    }, awful.key {
        modifiers = {mod.super},
        key = "v",
        description = "open CopyQ",
        group = "applications",
        on_press = function() awful.util.spawn_with_shell("copyq toggle") end
    }
}

-- rofi keys
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.super},
        key = 'x',
        description = "open power menu",
        group = "rofi",
        on_press = function()
            awful.util.spawn_with_shell('~/.config/awesome/rofi/bin/powermenu')
        end
    }, awful.key {
        modifiers = {mod.super, mod.shift},
        key = 'c',
        description = "open calculator",
        group = "rofi",
        on_press = function()
            awful.util.spawn_with_shell('rofi -show calc -terse')
        end
    }, awful.key {
        modifiers = {mod.super},
        key = 'z',
        description = "open network menu",
        group = "rofi",
        on_press = function()
            awful.util.spawn_with_shell('networkmanager_dmenu')
        end
    }, awful.key {
        modifiers = {mod.super},
        key = 'r',
        description = "open app menu",
        group = "rofi",
        on_press = function()
            awful.util.spawn_with_shell('rofi -show drun')
        end
    }, awful.key {
        modifiers = {mod.super},
        key = 'period',
        description = "open emoji selector",
        group = "rofi",
        on_press = function()
            awful.util.spawn_with_shell('rofi -show emoji')
        end
    }, awful.key {
        modifiers = {mod.super, mod.shift},
        key = 's',
        description = "open SSH menu",
        group = "rofi",
        on_press = function()
            awful.util.spawn_with_shell('rofi -show ssh')
        end
    }, awful.key {
        modifiers = {mod.super, mod.shift},
        key = 'f',
        description = "open file manager",
        group = "rofi",
        on_press = function()
            awful.util.spawn_with_shell('rofi -show filebrowser')
        end
    }, awful.key {
        modifiers = {mod.ctrl, mod.alt},
        key = 'Tab',
        description = "open window switcher",
        group = "rofi",
        on_press = function()
            awful.util.spawn_with_shell('rofi -show window')
        end
    }
}

-- screen keys
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.ctrl},
        key = "Print",
        description = "screenshot area",
        group = "screen",
        on_press = function()
            awful.util.spawn_with_shell('~/.config/awesome/scripts/flameshot')
        end
    }, awful.key {
        modifiers = {mod.shift},
        key = "Print",
        description = "screenshot desktop",
        group = "screen",
        on_press = function()
            awful.util.spawn_with_shell(
                '~/.config/awesome/scripts/flameshot-full')
        end
    }
}

-- system keys
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.super, mod.shift},
        key = "l",
        description = "lock screen",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell(
                "env XSECURELOCK_NO_COMPOSITE=1 xsecurelock")
        end
    }, awful.key {
        modifiers = {},
        key = "XF86AudioMute",
        description = "toggle mute audio",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell('amixer sset Master toggle')
        end
    }, awful.key {
        modifiers = {},
        key = "XF86AudioRaiseVolume",
        description = "increase volume",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell('amixer -Mq sset Master,0 5%+ unmute')
        end
    }, awful.key {
        modifiers = {},
        key = "XF86AudioLowerVolume",
        description = "decrease volume",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell('amixer -Mq sset Master,0 5%- unmute')
        end
    }, awful.key {
        modifiers = {},
        key = "XF86AudioMicMute",
        description = "toggle mute microphone",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell('~/.config/awesome/scripts/toggle-mic')
        end
    }, awful.key {
        modifiers = {},
        key = "XF86MonBrightnessUp",
        description = "increase brightness",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell('brightnessctl set +5%')
        end
    }, awful.key {
        modifiers = {},
        key = "XF86MonBrightnessDown",
        description = "decrease brightness",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell('brightnessctl set 5%-')
        end
    }, awful.key {
        modifiers = {},
        key = "XF86Display",
        description = "open display settings",
        group = "system",
        on_press = function() awful.util.spawn_with_shell('arandr') end
    }, awful.key {
        modifiers = {},
        key = "XF86WLAN",
        description = "open network manager",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell('alacritty -e "nmtui"')
        end
    }, awful.key {
        modifiers = {},
        key = "XF86Bluetooth",
        description = "open bluetooth manager",
        group = "system",
        on_press = function()
            awful.util.spawn_with_shell('blueman-manager')
        end
    }
}

-- tags related keybindings
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.super},
        key = 'Left',
        description = 'view preivous',
        group = 'tag',
        on_press = awful.tag.viewprev
    }, awful.key {
        modifiers = {mod.super},
        key = 'Right',
        description = 'view next',
        group = 'tag',
        on_press = awful.tag.viewnext
    }, awful.key {
        modifiers = {mod.super},
        key = 'Escape',
        description = 'go back',
        group = 'tag',
        on_press = awful.tag.history.restore
    }
}

-- focus related keybindings
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.super},
        key = 'j',
        description = 'focus next by index',
        group = 'client',
        on_press = function() awful.client.focus.byidx(1) end
    }, awful.key {
        modifiers = {mod.super},
        key = 'k',
        description = 'focus previous by index',
        group = 'client',
        on_press = function() awful.client.focus.byidx(-1) end
    }, awful.key {
        modifiers = {mod.super},
        key = 'Tab',
        description = 'go back',
        group = 'client',
        on_press = function()
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end
        end
    }, awful.key {
        modifiers = {mod.super, mod.ctrl},
        key = 'j',
        description = 'focus the next screen',
        group = 'screen',
        on_press = function() awful.screen.focus_relative(1) end
    }, awful.key {
        modifiers = {mod.super, mod.ctrl},
        key = 'n',
        description = 'restore minimized',
        group = 'client',
        on_press = function()
            local c = awful.client.restore()
            if c then
                c:active{raise = true, context = 'key.unminimize'}
            end
        end
    }, awful.key {
        modifiers = {mod.alt},
        key = "Tab",
        description = "switch to next client",
        group = "client",
        on_press = function()
            switcher.switch(1, "Mod1", "Alt_L", "Shift", "Tab")
        end
    }, awful.key {
        modifiers = {mod.alt, mod.shift},
        key = "Tab",
        description = "switch to previous client",
        group = "client",
        on_press = function()
            switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
        end
    }
}

-- layout related keybindings
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.super, mod.shift},
        key = 'j',
        description = 'swap with next client by index',
        group = 'client',
        on_press = function() awful.client.swap.byidx(1) end
    }, awful.key {
        modifiers = {mod.super, mod.shift},
        key = 'k',
        description = 'swap with previous client by index',
        group = 'client',
        on_press = function() awful.client.swap.byidx(-1) end
    }, awful.key {
        modifiers = {mod.super},
        key = 'u',
        description = 'jump to urgent client',
        group = 'client',
        on_press = awful.client.urgent.jumpto
    }, awful.key {
        modifiers = {mod.super},
        key = 'l',
        description = 'increase master width factor',
        group = 'layout',
        on_press = function() awful.tag.incmwfact(0.05) end
    }, awful.key {
        modifiers = {mod.super},
        key = 'h',
        description = 'decrease master width factor',
        group = 'layout',
        on_press = function() awful.tag.incmwfact(-0.05) end
    }, awful.key {
        modifiers = {mod.super, mod.shift},
        key = 'h',
        description = 'increase the number of master clients',
        group = 'layout',
        on_press = function() awful.tag.incnmaster(1, nil, true) end
    }, awful.key {
        modifiers = {mod.super, mod.shift},
        key = 'l',
        description = 'decrease the number of master clients',
        group = 'layout',
        on_press = function() awful.tag.incnmaster(-1, nil, true) end
    }, awful.key {
        modifiers = {mod.super, mod.ctrl},
        key = 'h',
        description = 'increase the number of columns',
        group = 'layout',
        on_press = function() awful.tag.incnmaster(1, nil, true) end
    }, awful.key {
        modifiers = {mod.super, mod.ctrl},
        key = 'l',
        description = 'decrease the number of columns',
        group = 'layout',
        on_press = function() awful.tag.incnmaster(-1, nil, true) end
    }, awful.key {
        modifiers = {mod.super},
        key = 'space',
        description = 'select next',
        group = 'layout',
        on_press = function() awful.layout.inc(1) end
    }, awful.key {
        modifiers = {mod.super, mod.shift},
        key = 'space',
        description = 'select previous',
        group = 'layout',
        on_press = function() awful.layout.inc(-1) end
    }
}

awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {mod.super},
        keygroup = 'numrow',
        description = 'only view tag',
        group = 'tag',
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then tag:view_only(tag) end
        end
    }, awful.key {
        modifiers = {mod.super, mod.ctrl},
        keygroup = 'numrow',
        description = 'toggle tag',
        group = 'tag',
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then tag:viewtoggle(tag) end
        end
    }, awful.key {
        modifiers = {mod.super, mod.shift},
        keygroup = 'numrow',
        description = 'move focused client to tag',
        group = 'tag',
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then client.focus:move_to_tag(tag) end
            end
        end
    }, awful.key {
        modifiers = {mod.super, mod.ctrl, mod.shift},
        keygroup = 'numrow',
        description = 'toggle focused client on tag',
        group = 'tag',
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then client.focus:toggle_tag(tag) end
            end
        end
    }, awful.key {
        modifiers = {mod.super},
        keygroup = 'numpad',
        description = 'select layout directrly',
        group = 'layout',
        on_press = function(index)
            local tag = awful.screen.focused().selected_tag
            if tag then tag.layout = tag.layouts[index] or tag.layout end
        end
    }
}
