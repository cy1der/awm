local awful = require("awful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")

local function INC_VOLUME_CMD(step) return 'amixer sset Master ' .. step .. '%+' end
local function DEC_VOLUME_CMD(step) return 'amixer sset Master ' .. step .. '%-' end

local volume = {}
local ICON_DIR = os.getenv("HOME") ..
                     '/.config/awesome/theme/icons/widgets/volume/'

local function get_widget()
    local font = beautiful.font
    local icon_dir = ICON_DIR

    return wibox.widget {
        {
            {id = "icon", resize = true, widget = wibox.widget.imagebox},
            valign = 'center',
            layout = wibox.container.place
        },
        {id = 'txt', font = font, widget = wibox.widget.textbox},
        layout = wibox.layout.fixed.horizontal,
        set_volume_level = function(self, new_value)
            self:get_children_by_id('txt')[1]:set_text(new_value .. "%")
            local volume_icon_name
            if self.is_muted then
                volume_icon_name = 'mute'
            else
                local new_value_num = tonumber(new_value)
                if (new_value_num >= 0 and new_value_num < 33) then
                    volume_icon_name = "low"
                elseif (new_value_num < 66) then
                    volume_icon_name = "medium"
                else
                    volume_icon_name = "high"
                end
            end
            self:get_children_by_id('icon')[1]:set_image(icon_dir ..
                                                             volume_icon_name ..
                                                             '.png')
        end,
        mute = function(self)
            self.is_muted = true
            self:get_children_by_id('icon')[1]:set_image(icon_dir .. 'mute.png')
        end,
        unmute = function(self) self.is_muted = false end
    }

end

local function worker()
    local refresh_rate = 1
    local step = 5

    volume.widget = get_widget()

    local function update_graphic(widget, stdout)
        local mute = string.match(stdout, "%[(o%D%D?)%]")
        if mute == 'off' then
            widget:mute()
        elseif mute == 'on' then
            widget:unmute()
        end
        local volume_level = string.match(stdout, "(%d?%d?%d)%%")
        volume_level = string.format("% 3d", volume_level or 0)
        widget:set_volume_level(volume_level)
    end

    function volume:inc(s)
        spawn.easy_async(INC_VOLUME_CMD(s or step), function(stdout)
            update_graphic(volume.widget, stdout)
        end)
    end

    function volume:dec(s)
        spawn.easy_async(DEC_VOLUME_CMD(s or step), function(stdout)
            update_graphic(volume.widget, stdout)
        end)
    end

    function volume:toggle()
        spawn.easy_async('amixer sset Master toggle', function(stdout)
            update_graphic(volume.widget, stdout)
        end)
    end

    volume.widget:buttons(awful.util.table.join(
                              awful.button({}, 4, function() volume:inc() end),
                              awful.button({}, 5, function() volume:dec() end),
                              awful.button({}, 1, function()
            volume:toggle()
        end)))

    watch('amixer sget Master', refresh_rate, update_graphic, volume.widget)

    return volume.widget
end

return setmetatable(volume, {__call = function(_) return worker() end})
