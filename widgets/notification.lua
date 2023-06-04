local awful = require "awful"
local naughty = require "naughty"
local wibox = require "wibox"
local global_state = require "signals.naughty.global_state"
local html_entities = require "util.html_entities"
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

dnd:buttons{
    awful.button({}, 1, function()
        local notification_widgets = {}
        for _, n in ipairs(global_state.cache.notifications) do
            -- local border_color = "#FFFFFF"

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
                        markup = html_entities.decode(n.get_title(n))
                    },
                    {
                        widget = wibox.widget.textbox,
                        font = "CaskaydiaCoveNerd Font SemiLight 12",
                        ellipsize = "end",
                        valign = "center",
                        markup = html_entities.decode(n.get_message(n))
                    },
                    n.get_actions(n)
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
                                widget = n.get_icon(n),
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
                                markup = html_entities.decode(n.get_title(n))
                            },
                            {
                                widget = wibox.widget.textbox,
                                font = "CaskaydiaCoveNerd Font SemiLight 12",
                                ellipsize = "end",
                                valign = "center",
                                markup = html_entities.decode(n.get_message(n))
                            },
                            n.get_actions(n)
                        }
                    }
                }
            }

            -- if n.get_urgency(n) == "low" then
            --     border_color = "#43A047"
            -- elseif n.get_urgency(n) == "critical" then
            --     border_color = "#FF5250"
            -- end

            if n.get_icon(n) == nil then
                table.insert(notification_widgets, notification_widget_no_icon)
            else
                table.insert(notification_widgets, notification_widget)
            end
        end

        awful.popup {
            widget = {
                {
                    notification_widgets or
                        {
                            text = 'No notifications',
                            widget = wibox.widget.textbox
                        },
                    layout = wibox.layout.fixed.vertical
                },
                margins = dpi(4),
                widget = wibox.container.margin
            },
            border_color = "#FFFFFF",
            border_width = dpi(2),
            placement = awful.placement.top_right,
            visible = true
        }
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

return dnd

--[[
get_width	function
grant	function
set_run	function
get_ontop	function
get_timeout	function
die	function
set_width	function
get_run	function
get_border_color	function
set_ontop	function
get_margin	function
set_border_color	function
set_title	function
get_id	function
get_urgency	function
set_actions	function
set_margin	function
set_shape	function
set_widget_template	function
get_ignore_suspend	function
_signals	table
set_opacity	function
get_actions	function
set_auto_reset_timeout	function
set_bg	function
get_image	function
set_timeout	function
_setup_class_signals	function
get_border_width	function
get_widget_template	function
set_border_width	function
set_ignore_suspend	function
get_bg	function
is_expired	boolean
deny	function
get_position	function
set_icon_size	function
get_text	function
destroy	function
get_suspended	function
timer	table
set_font	function
get_hover_timeout	function
set_text	function
get_destroy	function
set_destroy	function
set_id	function
set_position	function
get_icon	function
set_screen	function
set_image	function
modulename	function
get_opacity	function
get_font	function
set_fg	function
set_callback	function
add_signal	function
get_ignore	function
get_icon_size	function
set_ignore	function
set_icon	function
reset_timeout	function
set_category	function
get_auto_reset_timeout	function
set_urgency	function
set_hover_timeout	function
get_fg	function
get_callback	function
get_category	function
set_height	function
get_message	function
get_shape	function
get_resident	function
set_preset	function
set_app_name	function
get_title	function
get_images	function
weak_connect_signal	function
get_app_name	function
get_height	function
set_images	function
set_app_icon	function
set_message	function
set_max_width	function
set_resident	function
get_preset	function
get_max_width	function
idx	number
get_clients	function
append_actions	function
_connect_everything	function
emit_signal	function
connect_signal	function
get_app_icon	function
get_screen	function
_gen_next_id	function
_global_receivers	table
_private	table
disconnect_signal	function
]] -- 
