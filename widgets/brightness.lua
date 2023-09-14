local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local naughty = require("naughty")
local beautiful = require("beautiful")

local step = 5

local get_brightness_cmd = 'sh -c "brightnessctl -m | cut -d, -f4 | tr -d %"'
local set_brightness_cmd = "brightnessctl set %d%%"
local inc_brightness_cmd = "brightnessctl set +" .. step .. "%"
local dec_brightness_cmd = "brightnessctl set " .. step .. "-%"

local brightness_widget = {}

local function show_warning(message)
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Brightness Widget",
        text = message
    })
end

local function worker(user_args)
    local args = user_args or {}

    local type = "icon_and_text"
    local path_to_icon = os.getenv("HOME") ..
                             "/.config/awesome/theme/icons/widgets/brightness/"
    local font = args.font or beautiful.font
    local timeout = 3

    local current_level = 0
    local tooltip = args.tooltip or false
    local percentage = true

    if type == 'icon_and_text' then
        brightness_widget.widget = wibox.widget {
            {
                {id = "icon", resize = true, widget = wibox.widget.imagebox},
                -- valign = 'center',
                layout = wibox.container.margin
            },
            {id = 'txt', font = font, widget = wibox.widget.textbox},
            spacing = 4,
            layout = wibox.layout.fixed.horizontal,
            set_value = function(self, level)
                local iconLevel
                local display_level = level
                if percentage then
                    display_level = display_level .. '%'
                end

                local levelnum = tonumber(level)

                if (levelnum >= 0 and levelnum <= 17) then
                    iconLevel = "1"
                elseif (levelnum >= 18 and levelnum <= 34) then
                    iconLevel = "2"
                elseif (levelnum >= 35 and levelnum <= 50) then
                    iconLevel = "3"
                elseif (levelnum >= 51 and levelnum <= 67) then
                    iconLevel = "4"
                elseif (levelnum >= 68 and levelnum <= 85) then
                    iconLevel = "5"
                else
                    iconLevel = "6"
                end

                self:get_children_by_id('icon')[1]:set_image(path_to_icon ..
                                                                 iconLevel ..
                                                                 ".png")
                self:get_children_by_id('txt')[1]:set_text(display_level)
            end
        }
    else
        show_warning(type .. " type is not supported by the widget")
        return

    end

    local update_widget = function(widget, stdout, _, _, _)
        local brightness_level = tonumber(string.format("%.0f", stdout))
        current_level = brightness_level
        widget:set_value(brightness_level)
    end

    function brightness_widget:set(value)
        current_level = value
        spawn.easy_async(string.format(set_brightness_cmd, value), function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
            end)
        end)
    end

    local old_level = 0
    function brightness_widget:toggle()
        if old_level < 0.1 then old_level = 1 end
        if current_level < 0.1 then
            current_level = old_level
        else
            old_level = current_level
            current_level = 0
        end
        brightness_widget:set(current_level)
    end

    function brightness_widget:inc()
        spawn.easy_async(inc_brightness_cmd, function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
            end)
        end)
    end

    function brightness_widget:dec()
        spawn.easy_async(dec_brightness_cmd, function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
            end)
        end)
    end

    brightness_widget.widget:buttons(awful.util.table.join(
                                         awful.button({}, 4, function()
            brightness_widget:inc()
        end), awful.button({}, 5, function() brightness_widget:dec() end)))

    watch(get_brightness_cmd, timeout, update_widget, brightness_widget.widget)

    if tooltip then
        awful.tooltip {
            objects = {brightness_widget.widget},
            timer_function = function() return current_level .. " %" end
        }
    end

    return brightness_widget.widget
end

return setmetatable(brightness_widget,
                    {__call = function(_, ...) return worker(...) end})
