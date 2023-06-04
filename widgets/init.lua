local _M = {}

local awful = require 'awful'
local hotkeys_popup = require 'awful.hotkeys_popup'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local apps = require 'config.apps'
local mod = require 'bindings.mod'
local freedesktop = require 'modules.freedesktop'
local xresources = require 'beautiful.xresources'
local dpi = xresources.apply_dpi

_M.awesomemenu = {
    {
        'Hotkeys',
        function() hotkeys_popup.show_help(nil, awful.screen.focused()) end
    }, {'Manual', apps.manual_cmd}, {
        'Configuation', apps.editor_cmd .. ' ' ..
            string.format("%s/.config/awesome/", os.getenv("HOME"))
    }, {'Restart', function() awesome.restart() end},
    {'Quit', function() awesome.quit() end}
}

_M.mainmenu = freedesktop.build({
    before = {{'Awesome', _M.awesomemenu, beautiful.awesome_icon}}
})

_M.launcher = awful.widget.launcher {
    image = beautiful.awesome_icon,
    menu = _M.mainmenu
}

_M.keyboardlayout = awful.widget.keyboardlayout()

local textclock_nocolor = wibox.widget.textclock("%m/%d/%Y | %I:%M:%S %P", 1)
local textclock_color = wibox.container.background()
textclock_color:set_widget(textclock_nocolor)
textclock_color:set_fg("#FFFFFF")

local battery_nocolor = require 'widgets.battery'
local battery_color = wibox.container.background()
battery_color:set_widget(battery_nocolor())
battery_color:set_fg("#FFFFFF")

local volume_nocolor = require 'widgets.volume'
local volume_color = wibox.container.background()
volume_color:set_widget(volume_nocolor())
volume_color:set_fg("#FFFFFF")

local brightness_nocolor = require 'widgets.brightness'
local brightness_color = wibox.container.background()
brightness_color:set_widget(brightness_nocolor())
brightness_color:set_fg("#FFFFFF")

local wifi_nocolor = require 'widgets.wifi'
local wifi_color = wibox.container.background()
wifi_color:set_widget(wifi_nocolor())
wifi_color:set_fg("#FFFFFF")

_M.notif_pause = require('widgets.notification')
_M.ram = require 'widgets.ram-graph'()
_M.fs = require 'widgets.storage-bar'()
_M.cpu = require 'widgets.cpu-graph'()
_M.wifi = wifi_color
_M.textclock = textclock_color
_M.volume = volume_color
_M.battery = battery_color
_M.brightness = brightness_color

function _M.create_promptbox() return awful.widget.prompt() end

function _M.create_layoutbox(s)
    return awful.widget.layoutbox {
        screen = s,
        buttons = {
            awful.button {
                modifiers = {},
                button = 1,
                on_press = function() awful.layout.inc(1) end
            }, awful.button {
                modifiers = {},
                button = 3,
                on_press = function() awful.layout.inc(-1) end
            }, awful.button {
                modifiers = {},
                button = 4,
                on_press = function() awful.layout.inc(-1) end
            }, awful.button {
                modifiers = {},
                button = 5,
                on_press = function() awful.layout.inc(1) end
            }
        }
    }
end

function _M.create_taglist(s)
    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {
            awful.button {
                modifiers = {},
                button = 1,
                on_press = function(t) t:view_only() end
            }, awful.button {
                modifiers = {mod.super},
                button = 1,
                on_press = function(t)
                    if client.focus then
                        client.focus:move_to_tag(t)
                    end
                end
            },
            awful.button {
                modifiers = {},
                button = 3,
                on_press = awful.tag.viewtoggle
            }, awful.button {
                modifiers = {mod.super},
                button = 3,
                on_press = function(t)
                    if client.focus then
                        client.focus:toggle_tag(t)
                    end
                end
            }
        }
    }
end

function _M.create_tasklist(s)
    return awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button {
                modifiers = {},
                button = 1,
                on_press = function(c)
                    c:activate{
                        context = 'tasklist',
                        action = 'toggle_minimization'
                    }
                end
            }, awful.button {
                modifiers = {},
                button = 3,
                on_press = function()
                    awful.menu.client_list {theme = {width = 250}}
                end
            }, awful.button {
                modifiers = {},
                button = 4,
                on_press = function()
                    awful.client.focus.byidx(-1)
                end
            }, awful.button {
                modifiers = {},
                button = 5,
                on_press = function() awful.client.focus.byidx(1) end
            }
        }
    }
end

function _M.create_wibox(s)
    return awful.wibar {
        screen = s,
        position = 'top',
        height = 48,
        border_width = dpi(2),
        border_color = "#FFFFFF",
        widget = {
            layout = wibox.layout.align.horizontal,
            -- left widgets
            {
                layout = wibox.layout.fixed.horizontal,
                wibox.container.margin(s.layoutbox, dpi(4), dpi(4), dpi(8),
                                       dpi(8), "#000000"),
                s.taglist,
                wibox.container.margin(_M.cpu, dpi(4), dpi(4), dpi(8), dpi(8),
                                       "#000000"),
                _M.ram,
                wibox.container.margin(_M.fs, dpi(4), dpi(4), dpi(8), dpi(8),
                                       "#000000")
            },
            -- middle widgets
            wibox.container.margin(s.tasklist, dpi(8), dpi(8), dpi(8), dpi(8),
                                   "#000000"),
            -- right widgets
            {
                layout = wibox.layout.fixed.horizontal,
                wibox.container.margin(wibox.widget.systray(), dpi(12), dpi(12),
                                       dpi(10), dpi(10), "#000000"),
                wibox.container.margin(_M.volume, dpi(8), dpi(8), dpi(9),
                                       dpi(9), "#000000"),
                wibox.container.margin(_M.brightness, dpi(8), dpi(8), dpi(10),
                                       dpi(10), "#000000"),
                wibox.container.margin(_M.wifi, dpi(8), dpi(8), dpi(9), dpi(9),
                                       "#000000"),
                wibox.container.margin(_M.battery, dpi(8), dpi(8), dpi(8),
                                       dpi(8), "#000000"),
                wibox.container.margin(_M.notif_pause, dpi(4), dpi(4), dpi(10),
                                       dpi(10), "#000000"),
                wibox.container.margin(_M.textclock, dpi(8), dpi(12), 0, 0,
                                       "#000000")
            }
        }
    }
end

return _M
