local awful = require "awful"
local naughty = require "naughty"
local wibox = require "wibox"
local global_state = require "signals.naughty.global_state"
local html_entities = require "util.html_entities"
local gears = require "gears"
local xresources = require "beautiful.xresources"
local dpi = xresources.apply_dpi

local HOME = os.getenv("HOME")
local path_to_icons = HOME ..
                          "/.config/awesome/theme/icons/widgets/notifications/"

local on = path_to_icons .. "on.png"
local off = path_to_icons .. "off.png"
local s = true

local dnd = wibox.widget {
    {id = "icon", widget = wibox.widget.imagebox, image = on, resize = true},
    valign = "center",
    layout = wibox.container.place
}

local popup = wibox {
    ontop = true,
    visible = false,
    shape = gears.shape.rectangle,
    border_width = dpi(2),
    border_color = "#FFFFFF",
    height = dpi(768),
    width = dpi(512)
}

dnd:buttons{
    awful.button({}, 1, function()
        local pointer = 0
        local min_notifications = 8

        local notification_widgets = {}
        for _, n in ipairs(global_state.cache.notifications) do
            local border_color = "#FFFFFF"

            if n.get_urgency(n) == "low" then
                border_color = "#43A047"
            elseif n.get_urgency(n) == "critical" then
                border_color = "#FF5250"
            end

            for key, value in pairs(n) do print(key, value) end

            local widget = wibox.widget {
                widget = wibox.container.constraint,
                width = dpi(504),
                strategy = "exact",
                {
                    widget = wibox.container.background,
                    bg = "#000000",
                    fg = "#FFFFFF",
                    shape_border_width = dpi(2),
                    shape_border_color = border_color,
                    shape = gears.shape.rectangle,
                    {
                        margins = dpi(12),
                        widget = wibox.container.margin,
                        {
                            layout = wibox.layout.fixed.vertical,
                            spacing = dpi(8),
                            fill_space = true,
                            {
                                widget = wibox.widget.textbox,
                                font = "CaskaydiaCoveNerd Font Light 9",
                                ellipsize = "end",
                                valign = "center",
                                markup = n.get_app_name(n) .. " | " .. n.date
                            },
                            {
                                widget = wibox.widget.textbox,
                                font = "CaskaydiaCoveNerd Font SemiBold 12",
                                ellipsize = "end",
                                valign = "center",
                                markup = html_entities.decode(n.get_title(n))
                            },
                            {
                                widget = wibox.widget.textbox,
                                font = "CaskaydiaCoveNerd Font SemiLight 12",
                                ellipsize = "end",
                                valign = "center",
                                markup = html_entities.decode(n.get_message(n))
                            }
                        }
                    }
                }
            }

            table.insert(notification_widgets, #notification_widgets + 1, widget)
        end

        local list = wibox.layout.fixed.vertical()
        list.spacing = dpi(8)

        if #notification_widgets > 0 then
            for _, widget in ipairs(notification_widgets) do
                list:add(widget)
            end

            list:connect_signal("button::press", function(_, _, _, button)
                if button == 5 then -- up scrolling
                    if pointer < #list.children and
                        ((#list.children - pointer) >= min_notifications) then
                        pointer = pointer + 1
                        list.children[pointer].visible = false
                    end
                elseif button == 4 then -- down scrolling
                    if pointer > 0 then
                        list.children[pointer].visible = true
                        pointer = pointer - 1
                    end
                end
            end)

            popup:setup{
                {
                    {
                        {
                            widget = wibox.widget.textbox,
                            font = "CaskaydiaCoveNerd Font SemiBold 12",
                            markup = "Notification History\nRight click to clear",
                            valign = "center"
                        },
                        list,
                        spacing = dpi(8),
                        layout = wibox.layout.fixed.vertical
                    },
                    margins = dpi(12),
                    widget = wibox.container.margin
                },
                widget = wibox.container.background,
                bg = "#000000",
                fg = "#FFFFFF"
            }
        else
            popup:setup{
                {
                    {
                        markup = "No notifications",
                        valign = 'center',
                        align = 'center',
                        layout = wibox.widget.textbox
                    },
                    margins = dpi(12),
                    widget = wibox.container.margin
                },
                widget = wibox.container.background,
                bg = "#000000",
                fg = "#FFFFFF"
            }
        end

        popup.visible = not popup.visible
        awful.placement.top(popup, {margins = {top = dpi(24)}, parent = mouse})

    end), awful.button({}, 3, function()
        s = not s
        if s then
            dnd.icon:set_image(on)
            naughty.resume()
        else
            dnd.icon:set_image(off)
            naughty.suspend()
        end
    end)
}

popup:buttons(awful.util.table.join(awful.button({}, 1, function()
    popup.visible = false
end), awful.button({}, 3, function()
    global_state.cache.notifications = {}
    popup.visible = false
end)))

return dnd
