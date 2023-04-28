local naughty = require("naughty")
local wibox = require("wibox")
local xresources = require 'beautiful.xresources'
local dpi = xresources.apply_dpi
local global_state = require("signals.naughty.global_state")
local html_entities = require("util.html_entities")

naughty.connect_signal('request::display_error', function(message, startup)
    naughty.notification {
        urgency = 'critical',
        title = 'Error' .. (startup and ' during startup!' or '!'),
        message = message
    }
end)

naughty.connect_signal("request::display", function(n)
    global_state.cache.notifications_update(n)

    local border_color = "#FFFFFF"
    local timeout = 5
    local notification_widget_no_icon = {
        margins = dpi(12),
        widget = wibox.container.margin,
        {
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(8),
            fill_space = true,
            {
                widget = wibox.widget.textbox,
                font = "CaskaydiaCoveNerd Font SemiBold 12",
                ellipsize = "end",
                valign = "center",
                markup = html_entities.decode(n.title)
            },
            {
                widget = wibox.widget.textbox,
                font = "CaskaydiaCoveNerd Font SemiLight 12",
                ellipsize = "end",
                valign = "center",
                markup = html_entities.decode(n.message)
            },
            naughty.list.actions
        }
    }
    local notification_widget = {
        margins = dpi(12),
        widget = wibox.container.margin,
        {
            layout = wibox.layout.fixed.horizontal,
            fill_space = true,
            spacing = dpi(16),
            {
                widget = wibox.container.place,
                valign = "center",
                {
                    widget = wibox.container.constraint,
                    width = dpi(256),
                    height = dpi(256),
                    strategy = "max",
                    {
                        widget = naughty.widget.icon,
                        notification = n,
                        resize_strategy = "scale",
                        scaling_quality = "best",
                        upscale = true,
                        downscale = true,
                        resize = true
                    }
                }
            },
            {
                widget = wibox.container.place,
                valign = "center",
                halign = "left",
                {
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(8),
                    {
                        widget = wibox.widget.textbox,
                        font = "CaskaydiaCoveNerd Font SemiBold 12",
                        ellipsize = "end",
                        valign = "center",
                        markup = html_entities.decode(n.title)
                    },
                    {
                        widget = wibox.widget.textbox,
                        font = "CaskaydiaCoveNerd Font SemiLight 12",
                        ellipsize = "end",
                        valign = "center",
                        markup = html_entities.decode(n.message)
                    },
                    naughty.list.actions
                }
            }
        }
    }

    if n.urgency == "low" then
        timeout = 3
        border_color = "#43A047"
    elseif n.urgency == "critical" then
        timeout = 86400
        border_color = "#FF5250"
    end

    if n.icon == nil then
        n.timeout = timeout
        naughty.layout.box {
            notification = n,
            maximum_height = dpi(256),
            ontop = true,
            position = "top_right",
            bg = "#000000",
            fg = "#FFFFFF",
            border_width = dpi(2),
            border_color = border_color,
            widget_template = {
                widget = wibox.container.constraint,
                width = dpi(200),
                strategy = "exact",
                notification_widget_no_icon
            }
        }
    else
        n.timeout = timeout
        naughty.layout.box {
            notification = n,
            maximum_height = dpi(288),
            ontop = true,
            position = "top_right",
            bg = "#000000",
            fg = "#FFFFFF",
            border_width = dpi(2),
            border_color = border_color,
            widget_template = {
                widget = wibox.container.constraint,
                width = dpi(200),
                strategy = "exact",
                notification_widget
            }
        }
    end
end)
