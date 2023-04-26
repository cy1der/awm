local awful = require 'awful'
local gmath = require 'gears.math'
local mod = require 'bindings.mod'

client.connect_signal('request::default_mousebindings', function()
    awful.mouse.append_client_mousebindings {
        awful.button {
            modifiers = {},
            button = 1,
            on_press = function(c)
                c:activate{context = 'mouse_click'}
            end
        }, awful.button {
            modifiers = {mod.super},
            button = 1,
            on_press = function(c)
                c:activate{context = 'mouse_click', action = 'mouse_move'}
            end
        }, awful.button {
            modifiers = {mod.super},
            button = 3,
            on_press = function(c)
                c:activate{context = 'mouse_click', action = 'mouse_resize'}
            end
        }, awful.button {
            modifiers = {mod.super},
            button = 6,
            on_press = function()
                local c = client.focus
                if not c then return end
                local tags = c.screen.tags
                c:move_to_tag(tags[gmath.cycle(#tags,
                                               c.screen.selected_tag.index - 1)])
                awful.tag.viewprev()
            end
        }, awful.button {
            modifiers = {mod.super},
            button = 7,
            on_press = function()
                local c = client.focus
                if not c then return end
                local tags = c.screen.tags
                c:move_to_tag(tags[gmath.cycle(#tags,
                                               c.screen.selected_tag.index + 1)])
                awful.tag.viewnext()
            end
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
end)
