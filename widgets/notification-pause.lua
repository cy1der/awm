local awful = require "awful"
local naughty = require "naughty"
local wibox = require "wibox"

local HOME = os.getenv("HOME")
local path_to_icons = HOME ..
                          "/.config/awesome/theme/icons/widgets/notifications/"

local dnd = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
        image = path_to_icons .. "on.png",
        resize = true
    },
    valign = "center",
    layout = wibox.container.place
}

local on = path_to_icons .. "on.png"
local off = path_to_icons .. "off.png"
local s = true
dnd:buttons{
    awful.button({}, 1, function()
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
