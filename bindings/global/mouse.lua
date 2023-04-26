local awful = require 'awful'
local widgets = require 'widgets'
local mod = require 'bindings.mod'

awful.mouse.append_global_mousebindings {
    awful.button {
        modifiers = {},
        button = 3,
        on_press = function() widgets.mainmenu:toggle() end
    }, awful.button {
        modifiers = {},
        button = 6,
        on_press = function() awful.tag.viewprev() end
    }, awful.button {
        modifiers = {},
        button = 7,
        on_press = function() awful.tag.viewnext() end
    }
}
