local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")

local CMD_slim = [[grep --max-count=1 '^cpu.' /proc/stat]]

local cpu_widget = {}

local function worker()
    local width = 50
    local step_width = 2
    local step_spacing = 0
    local background_color = "#00000000"
    local timeout = 1

    local cpugraph_widget = wibox.widget {
        max_value = 100,
        background_color = background_color,
        forced_width = width,
        step_width = step_width,
        step_spacing = step_spacing,
        widget = wibox.widget.graph,
        color = "linear:0,0:0,30:0,#FF5250:0.4,#FFCC66:0.8,#FFFFFF"
    }

    cpu_widget = wibox.widget {
        {
            cpugraph_widget,
            reflection = {horizontal = true},
            layout = wibox.container.mirror
        },
        bottom = 2,
        color = background_color,
        widget = wibox.container.margin
    }

    local maincpu = {}
    watch(CMD_slim, timeout, function(widget, stdout)

        local _, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
            stdout:match(
                '(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')

        local total = user + nice + system + idle + iowait + irq + softirq +
                          steal

        local diff_idle = idle -
                              tonumber(
                                  maincpu['idle_prev'] == nil and 0 or
                                      maincpu['idle_prev'])
        local diff_total = total -
                               tonumber(
                                   maincpu['total_prev'] == nil and 0 or
                                       maincpu['total_prev'])
        local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) /
                               10

        maincpu['total_prev'] = total
        maincpu['idle_prev'] = idle

        widget:add_value(diff_usage)
    end, cpugraph_widget)

    return cpu_widget
end

return setmetatable(cpu_widget, {__call = function(_, ...) return worker() end})
