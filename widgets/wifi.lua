local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")

local icon_path = os.getenv("HOME") ..
                      "/.config/awesome/theme/icons/widgets/wifi/"

local function net_stats(card, which)
    local prefix = {[0] = "", [1] = "K", [2] = "M", [3] = "G", [4] = "T"}

    local function readAll(file)
        local f = assert(io.open(file, "rb"))
        local content = f:read()
        f:close()
        return content
    end

    local function round(num, numDecimalPlaces)
        local mult = 10 ^ (numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end

    local f
    if (which == "d") then
        f = readAll("/sys/class/net/" .. card .. "/statistics/rx_bytes")
    else
        if (which == "u") then
            f = readAll("/sys/class/net/" .. card .. "/statistics/tx_bytes")
        end
    end

    local count = 0
    local stat = tonumber(f)
    while (stat > 1024) do
        stat = (stat / 1024)
        count = count + 1
    end

    local result = (round(stat, 2) .. " " .. prefix[count] .. "B")
    return result
end

local wireless = {}
local function worker()
    local widgets_table = {}
    local connected = false

    local interface = "wlp0s20f3"
    local timeout = 3
    local font = beautiful.font
    local widget = wibox.layout.fixed.horizontal()

    local net_icon = wibox.widget.imagebox(icon_path .. "off.png")
    local net_text = wibox.widget.textbox()
    net_text.font = font
    net_text:set_text(" N/A ")
    local signal_level
    local function net_update()
        awful.spawn.easy_async(
            "awk 'NR==3 {printf \"%3.0f\" ,($3/70)*100}' /proc/net/wireless",
            function(stdout) signal_level = tonumber(stdout) end)
        if signal_level == nil then
            connected = false
            net_text:set_text(" N/A ")
            net_icon:set_image(icon_path .. "off.png")
        else
            local iconStrength
            connected = true
            net_text:set_text(string.format("%" .. 3 .. "d%%", signal_level))

            if (signal_level >= 1 and signal_level < 20) then
                iconStrength = "0"
            elseif (signal_level >= 20 and signal_level < 40) then
                iconStrength = "1"
            elseif (signal_level >= 40 and signal_level < 60) then
                iconStrength = "2"
            elseif (signal_level >= 60 and signal_level < 80) then
                iconStrength = "3"
            else
                iconStrength = "4"
            end

            net_icon:set_image(icon_path .. iconStrength .. ".png")
        end
    end

    net_update()
    gears.timer.start_new(timeout, function()
        net_update()
        return true
    end)

    widgets_table["imagebox"] = net_icon
    widgets_table["textbox"] = net_text
    if widget then
        widget:add(net_icon)
        widget:add(net_text)
        wireless:attach(widget)
    end

    local function text_grabber()
        local msg = ""
        if connected then
            local mac = "N/A"
            local essid = "N/A"
            local bitrate = "N/A"
            local inet = "N/A"

            local f = io.popen("iw dev " .. interface .. " link")

            if f then
                for line in f:lines() do
                    mac = string.match(line, "Connected to ([0-f:]+)") or mac
                    essid = string.match(line, "SSID: (.+)") or essid
                    bitrate = string.match(line, "tx bitrate: (.+/s)") or
                                  bitrate
                end
                f:close()
            end

            f = io.popen("ip addr show " .. interface)
            if f then
                for line in f:lines() do
                    inet = string.match(line, "inet (%d+%.%d+%.%d+%.%d+)") or
                               inet
                end
                f:close()
            end

            local signal = ""
            local metrics_down = ""
            local metrics_up = ""
            local tdown = net_stats(interface, "d")
            local tup = net_stats(interface, "u")
            metrics_down = "DOWN:\t\t" .. tdown .. "\n"
            metrics_up = "UP:\t\t" .. tup .. "\n"

            msg = "ESSID:\t\t" .. essid .. "\n" .. "IP:\t\t" .. inet .. "\n" ..
                      "BSSID\t\t" .. mac .. "\n" .. "" .. metrics_down .. "" ..
                      metrics_up .. "" .. signal .. "Bit rate:\t" .. bitrate

        else
            msg = "Wireless network is disconnected"
        end

        return msg
    end

    local notification = nil
    function wireless:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function wireless:show(t_out)
        wireless:hide()

        notification = naughty.notify({
            text = text_grabber(),
            timeout = t_out,
            screen = mouse.screen,
            position = naughty.config.defaults.position,
            title = "Interface: " .. interface
        })
    end

    return widget or widgets_table
end

function wireless:attach(widget)
    widget:connect_signal('mouse::enter', function() wireless:show(0) end)
    widget:connect_signal('mouse::leave', function() wireless:hide() end)
    return widget
end

return setmetatable(wireless, {__call = function(_, ...) return worker() end})
