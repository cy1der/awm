local awful = require "awful"
local naughty = require "naughty"
local wibox = require "wibox"
local global_state = require "signals.naughty.global_state"
local html_entities = require "util.html_entities"
local gears = require "gears"
local xresources = require "beautiful.xresources"
local dpi = xresources.apply_dpi
local beautiful = require "beautiful"

local HOME = os.getenv("HOME")
local path_to_icons = HOME ..
                          "/.config/awesome/theme/icons/widgets/notifications/"

local on = path_to_icons .. "on.png"
local off = path_to_icons .. "off.png"
local s = true

local dnd = wibox.widget {
    {
        {id = "icon", widget = wibox.widget.imagebox, image = on, resize = true},
        id = "place",
        valign = 'center',
        layout = wibox.container.place
    },
    {
        {
            {id = "text", widget = wibox.widget.textbox, font = beautiful.font},
            id = "text_container",
            widget = wibox.container.background,
            fg = "#FFFFFF"
        },
        id = "margin",
        widget = wibox.container.margin,
        left = dpi(8)
    },
    layout = wibox.layout.fixed.horizontal
}

dnd.margin.text_container.text:set_markup(global_state.cache.unread)

local popup = wibox {
    ontop = true,
    visible = false,
    shape = gears.shape.rectangle,
    border_width = dpi(2),
    border_color = "#FFFFFF",
    height = dpi(804),
    width = dpi(512)
}

local function update_popup()
    local p = 0
    local min_notifications = 7

    local notification_widgets = {}
    for _, n in ipairs(global_state.cache.notifications) do
        local border_color = "#FFFFFF"

        if n.get_urgency(n) == "low" then
            border_color = "#43A047"
        elseif n.get_urgency(n) == "critical" then
            border_color = "#FF5250"
        end

        local widget

        if n.get_icon(n) == nil then
            widget = wibox.widget {
                widget = wibox.container.constraint,
                width = dpi(530),
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
        else
            widget = wibox.widget {
                widget = wibox.container.constraint,
                width = dpi(530),
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
                            layout = wibox.layout.fixed.horizontal,
                            fill_space = true,
                            spacing = dpi(16),
                            {
                                widget = wibox.container.place,
                                valign = "center",
                                {
                                    widget = wibox.container.constraint,
                                    width = dpi(64),
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
                                        font = "CaskaydiaCoveNerd Font Light 9",
                                        ellipsize = "end",
                                        valign = "center",
                                        markup = (n.get_app_name(n) ~= "" and
                                            n.get_app_name(n) or "awesome") ..
                                            " | " .. n.date
                                    },
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
                                    }
                                }
                            }
                        }
                    }
                }
            }
        end

        table.insert(notification_widgets, #notification_widgets + 1,
                     {widget = widget, n = n})
    end

    local list = wibox.layout.fixed.vertical()
    list.spacing = dpi(8)

    if #notification_widgets > 0 then
        for _, widget in ipairs(notification_widgets) do
            widget.widget:buttons(gears.table.join(
                                      awful.button({}, 1, nil, function()
                    local indexToRemove
                    for i, value in ipairs(global_state.cache.notifications) do
                        if value == widget.n then
                            indexToRemove = i
                            break
                        end
                    end

                    if indexToRemove then
                        table.remove(global_state.cache.notifications,
                                     indexToRemove)
                        update_popup()
                    end
                end)))

            list:add(widget.widget)
        end

        list:connect_signal("button::press", function(_, _, _, button)
            if button == 5 then -- up scrolling
                if p < #list.children and
                    ((#list.children - p) >= min_notifications) then
                    p = p + 1
                    list.children[p].visible = false
                end
            elseif button == 4 then -- down scrolling
                if p > 0 then
                    list.children[p].visible = true
                    p = p - 1
                end
            end
        end)

        local clear_notifs = wibox.widget {
            widget = wibox.container.background,
            bg = "#000000",
            fg = "#FFFFFF",
            shape_border_width = dpi(2),
            shape_border_color = "#FFFFFF",
            shape = gears.shape.rectangle,
            {
                {
                    {
                        widget = wibox.widget.textbox,
                        font = "CaskaydiaCoveNerd Font SemiBold 36",
                        markup = "󰎟 ",
                        align = "center",
                        forced_width = dpi(52),
                        forced_height = dpi(52)
                    },
                    layout = wibox.layout.align.horizontal
                },
                widget = wibox.container.margin,
                margins = dpi(8)
            }
        }

        clear_notifs:buttons(gears.table.join(
                                 awful.button({}, 1, nil, function()
                global_state.cache.notifications = {}
                update_popup()
            end)))

        local header = wibox.layout.align.horizontal()
        header:set_right(clear_notifs)
        header:set_left(wibox.widget {
            widget = wibox.widget.textbox,
            font = "CaskaydiaCoveNerd Font Bold 24",
            markup = "Notifications",
            valign = "center"
        })

        popup:setup{
            {
                {
                    header,
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
                    font = "CaskaydiaCoveNerd Font SemiBold 24",
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
end

dnd:buttons{
    awful.button({}, 1, function()
        global_state.cache.unread = 0
        dnd.margin.text_container.text:set_markup(global_state.cache.unread)

        update_popup()

        awful.placement.top(popup, {margins = {top = dpi(24)}, parent = mouse})
        popup.visible = not popup.visible
    end), awful.button({}, 3, function()
        s = not s
        if s then
            dnd.place.icon:set_image(on)
            global_state.cache.show = true
        else
            dnd.place.icon:set_image(off)
            global_state.cache.show = false
        end
    end)
}

return {dnd = dnd, update_popup = update_popup, popup = popup}
