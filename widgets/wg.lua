local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local icon_dir = os.getenv("HOME") .. '/.config/awesome/theme/icons/widgets/wg/'

local wg = wibox.widget {
    {id = "image", resize = true, widget = wibox.widget.imagebox},
    valign = 'center',
    layout = wibox.container.place
}

wg:buttons(gears.table.join(awful.button({}, 1, function()
    awful.spawn.easy_async_with_shell("~/.config/awesome/scripts/toggle_wg",
                                      function(stdout)
        wg.image:set_image(icon_dir .. stdout:gsub("%s+", "") .. ".png")
    end)
end)))

local function worker()
    gears.timer.start_new(20, function()
        awful.spawn.easy_async_with_shell("~/.config/awesome/scripts/check_wg",
                                          function(stdout)
            wg.image:set_image(icon_dir .. stdout:gsub("%s+", "") .. ".png")
        end)
        return true
    end)

    awful.spawn.easy_async_with_shell("~/.config/awesome/scripts/check_wg",
                                      function(stdout)
        wg.image:set_image(icon_dir .. stdout:gsub("%s+", "") .. ".png")
    end)

    return wg
end

return setmetatable(wg, {__call = function(_) return worker() end})
