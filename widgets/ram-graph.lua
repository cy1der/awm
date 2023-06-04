local watch = require("awful.widget.watch")
local wibox = require("wibox")

local ramgraph_widget = {}

local function worker()
    local timeout = 1
    local color_used = "#FF5250"
    local color_free = "#333333"
    local color_buf = "#43A047"
    local widget_show_buf = true
    local widget_height = 50
    local widget_width = 50

    ramgraph_widget = wibox.widget {
        border_width = 0,
        colors = {color_used, color_free, color_buf},
        display_labels = false,
        forced_height = widget_height,
        forced_width = widget_width,
        widget = wibox.widget.piechart
    }

    local total, used, free, buff_cache

    watch('bash -c "LANGUAGE=en_US.UTF-8 free | grep -z Mem.*Swap.*"', timeout,
          function(widget, stdout)
        total, used, free, buff_cache = stdout:match(
                                            '(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')

        if widget_show_buf then
            widget.data = {used, free, buff_cache}
        else
            widget.data = {used, total - used}
        end
    end, ramgraph_widget)

    return ramgraph_widget
end

return setmetatable(ramgraph_widget,
                    {__call = function(_, ...) return worker() end})
