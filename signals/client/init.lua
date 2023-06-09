local awful = require 'awful'
require 'awful.autofocus'
local wibox = require 'wibox'

client.connect_signal('request::titlebars', function(c)
    awful.titlebar(c, {size = 36}).widget = {
        {
            { -- Left
                wibox.container.margin(awful.titlebar.widget.stickybutton(c), 7,
                                       7, 7, 7, "#000000"),
                wibox.container.margin(awful.titlebar.widget.floatingbutton(c),
                                       7, 7, 7, 7, "#000000"),
                wibox.container.margin(awful.titlebar.widget.ontopbutton(c), 7,
                                       7, 7, 7, "#000000"),
                wibox.container.margin(awful.titlebar.widget.iconwidget(c), 7,
                                       7, 7, 7, "#000000"),
                layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.margin
        },
        { -- Middle
            {align = "center", widget = awful.titlebar.widget.titlewidget(c)},
            buttons = {
                awful.button {
                    modifiers = {},
                    button = 1,
                    on_press = function()
                        c:activate{context = 'titlebar', action = 'mouse_move'}
                    end
                }, awful.button {
                    modifiers = {},
                    button = 3,
                    on_press = function()
                        c:activate{
                            context = 'titlebar',
                            action = 'mouse_resize'
                        }
                    end
                }
            },
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            wibox.container.margin(awful.titlebar.widget.minimizebutton(c), 7,
                                   7, 7, 7, "#000000"),
            wibox.container.margin(awful.titlebar.widget.maximizedbutton(c), 7,
                                   7, 7, 7, "#000000"),
            wibox.container.margin(awful.titlebar.widget.closebutton(c), 7, 7,
                                   7, 7, "#000000"),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
