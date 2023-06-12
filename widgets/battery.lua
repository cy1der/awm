local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local dpi = require('beautiful').xresources.apply_dpi
local gears = require("gears")

local HOME = os.getenv("HOME")

local battery_widget = {}
local function worker()
    local font = "CaskaydiaCoveNerd Font SemiLight 12"
    local path_to_icons = HOME ..
                              "/.config/awesome/theme/icons/widgets/battery/"

    if not gfs.dir_readable(path_to_icons) then
        naughty.notify {
            title = "Battery Widget",
            text = "Folder with icons doesn't exist: " .. path_to_icons
        }
    end

    local icon_widget = wibox.widget {
        {id = "icon", widget = wibox.widget.imagebox, resize = true},
        valign = "center",
        layout = wibox.container.place
    }

    local level_widget = wibox.widget {
        font = font,
        widget = wibox.widget.textbox
    }

    battery_widget = wibox.widget {
        wibox.container
            .margin(icon_widget, 0, dpi(4), dpi(2), dpi(2), "#000000"),
        level_widget,
        layout = wibox.layout.fixed.horizontal
    }

    local popup = wibox {
        ontop = true,
        visible = false,
        shape = gears.shape.rectangle,
        border_width = dpi(2),
        border_color = "#FFFFFF",
        height = dpi(86),
        width = dpi(512)
    }

    local function show_battery_status()
        awful.spawn.easy_async(
            [[bash -c 'acpi| grep -v "rate information unavailable"']],
            function(out, _, _, _)
                popup.visible = not popup.visible

                popup:setup{
                    {
                        {
                            {
                                font = "CaskaydiaCoveNerd Font Bold 12",
                                markup = "Battery",
                                layout = wibox.widget.textbox
                            },
                            {
                                font = "CaskaydiaCoveNerd Font Regular 12",
                                markup = out,
                                layout = wibox.widget.textbox
                            },
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

                awful.placement.top(popup,
                                    {margins = {top = dpi(24)}, parent = mouse})
            end)
    end

    local function show_battery_warning()
        naughty.notify {
            icon = path_to_icons .. "discharging/20.png",
            text = "Battery Low",
            title = "Please consider charging",
            screen = mouse.screen,
            urgency = "critical"
        }
    end

    local last_battery_check = os.time();

    watch([[ bash -c 'acpi -i | grep -v "rate information unavailable"' ]], 3,
          function(widget, out)
        local battery_info = {}
        local capacities = {}

        for s in out:gmatch("[^\r\n]+") do
            local status, charge_str, _ = string.match(s,
                                                       '.+: ([%a%s]+), (%d?%d?%d)%%,?(.*)')
            if status ~= nil then
                table.insert(battery_info,
                             {status = status, charge = tonumber(charge_str)})
            else
                local cap_str = string.match(s, '.+:.+last full capacity (%d+)')
                table.insert(capacities, tonumber(cap_str))
            end
        end

        local capacity = 0

        for _, cap in ipairs(capacities) do capacity = capacity + cap end

        local charge = 0
        local status

        for i, batt in ipairs(battery_info) do
            if capacities[i] ~= nil then
                if batt.charge >= charge then
                    status = batt.status
                end

                charge = charge + batt.charge * capacities[i]
            end
        end

        charge = charge / capacity

        level_widget.text = string.format('%d%%', charge)

        local iconBatteryStatus
        local iconBatteryLevel

        if status == "Charging" then
            iconBatteryStatus = "charging"
        else
            iconBatteryStatus = "discharging"
        end

        if ((charge >= 0 and charge <= 30) and status ~= 'Charging' and
            os.difftime(os.time(), last_battery_check) > 300) then
            last_battery_check = os.time()
            show_battery_warning()
        end

        if (charge >= 0 and charge < 10) then
            iconBatteryLevel = "0"
        elseif (charge >= 10 and charge < 20) then
            iconBatteryLevel = "10"
        elseif (charge >= 20 and charge < 30) then
            iconBatteryLevel = "20"
        elseif (charge >= 30 and charge < 40) then
            iconBatteryLevel = "30"
        elseif (charge >= 40 and charge < 50) then
            iconBatteryLevel = "40"
        elseif (charge >= 50 and charge < 60) then
            iconBatteryLevel = "50"
        elseif (charge >= 60 and charge < 70) then
            iconBatteryLevel = "60"
        elseif (charge >= 70 and charge < 80) then
            iconBatteryLevel = "70"
        elseif (charge >= 80 and charge < 90) then
            iconBatteryLevel = "80"
        elseif (charge >= 90 and charge < 100) then
            iconBatteryLevel = "90"
        else
            iconBatteryLevel = "100"
        end

        widget.icon:set_image(path_to_icons .. iconBatteryStatus .. "/" ..
                                  iconBatteryLevel .. ".png")
    end, icon_widget)

    battery_widget:buttons(gears.table.join(
                               awful.button({}, 1, nil, function()
            show_battery_status()
        end)))

    return wibox.container.margin(battery_widget, 0, 0)
end

return setmetatable(battery_widget,
                    {__call = function(_, ...) return worker() end})
