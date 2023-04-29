local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local CMD =
    [[sh -c "grep '^cpu.' /proc/stat; ps -eo '%p|%c|%C|' -o "%mem" -o '|%a' --sort=-%cpu ]] ..
        [[| head -11 | tail -n +2"]]

local CMD_slim = [[grep --max-count=1 '^cpu.' /proc/stat]]

local HOME_DIR = os.getenv("HOME")

local cpu_widget = {}
local cpu_rows = {spacing = 4, layout = wibox.layout.fixed.vertical}
local is_update = true
local process_rows = {layout = wibox.layout.fixed.vertical}

local function split(string_to_split, separator)
    if separator == nil then separator = "%s" end
    local t = {}

    for str in string.gmatch(string_to_split, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end

    return t
end

local function starts_with(str, start) return str:sub(1, #start) == start end

local function create_textbox(args)
    return wibox.widget {
        text = args.text,
        align = args.align or 'left',
        markup = args.markup,
        forced_width = args.forced_width or 40,
        widget = wibox.widget.textbox
    }
end

local function create_process_header(params)
    local res = wibox.widget {
        create_textbox {markup = '<b>PID</b>'},
        create_textbox {markup = '<b>Name</b>'},
        {
            create_textbox {markup = '<b>%CPU</b>'},
            create_textbox {markup = '<b>%MEM</b>'},
            params.with_action_column and create_textbox {forced_width = 20} or
                nil,
            layout = wibox.layout.align.horizontal
        },
        layout = wibox.layout.ratio.horizontal
    }
    res:ajust_ratio(2, 0.2, 0.47, 0.33)

    return res
end

local function create_kill_process_button()
    return wibox.widget {
        {
            id = "icon",
            image = HOME_DIR ..
                '/.config/awesome/theme/icons/widgets/cpu/kill.svg',
            resize = false,
            opacity = 0.1,
            widget = wibox.widget.imagebox
        },
        widget = wibox.container.background
    }
end

local function worker(user_args)

    local args = user_args or {}

    local width = 50
    local step_width = 2
    local step_spacing = 0
    local color = "#FFFFFF" -- args.color or beautiful.fg_normal
    local background_color = "#00000000"
    local enable_kill_button = true
    local process_info_max_length = -1
    local timeout = 1

    local cpugraph_widget = wibox.widget {
        max_value = 100,
        background_color = background_color,
        forced_width = width,
        step_width = step_width,
        step_spacing = step_spacing,
        widget = wibox.widget.graph,
        color = "linear:0,0:0,20:0,#FFCC66:0.3,#FF5250:0.6," .. color
    }

    local popup_timer = gears.timer {timeout = timeout}

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

    local cpus = {}
    popup_timer:connect_signal('timeout', function()
        awful.spawn.easy_async(CMD, function(stdout, _, _, _)
            local i = 1
            local j = 1
            for line in stdout:gmatch("[^\r\n]+") do
                if starts_with(line, 'cpu') then

                    if cpus[i] == nil then cpus[i] = {} end

                    local name, user, nice, system, idle, iowait, irq, softirq,
                          steal, _, _ = line:match(
                                            '(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')

                    local total = user + nice + system + idle + iowait + irq +
                                      softirq + steal

                    local diff_idle = idle -
                                          tonumber(
                                              cpus[i]['idle_prev'] == nil and 0 or
                                                  cpus[i]['idle_prev'])
                    local diff_total = total -
                                           tonumber(
                                               cpus[i]['total_prev'] == nil and
                                                   0 or cpus[i]['total_prev'])
                    local diff_usage = (1000 * (diff_total - diff_idle) /
                                           diff_total + 5) / 10

                    cpus[i]['total_prev'] = total
                    cpus[i]['idle_prev'] = idle

                    local row = wibox.widget {
                        create_textbox {text = name},
                        create_textbox {text = math.floor(diff_usage) .. '%'},
                        {
                            max_value = 100,
                            value = diff_usage,
                            forced_height = 20,
                            forced_width = 150,
                            paddings = 1,
                            margins = 4,
                            border_width = 1,
                            border_color = beautiful.bg_focus,
                            background_color = beautiful.bg_normal,
                            bar_border_width = 1,
                            bar_border_color = beautiful.bg_focus,
                            color = "linear:150,0:0,0:0,#D08770:0.3,#BF616A:0.6," ..
                                beautiful.fg_normal,
                            widget = wibox.widget.progressbar

                        },
                        layout = wibox.layout.ratio.horizontal
                    }
                    row:ajust_ratio(2, 0.15, 0.15, 0.7)
                    cpu_rows[i] = row
                    i = i + 1
                else
                    if is_update == true then

                        local columns = split(line, '|')

                        local pid = columns[1]
                        local comm = columns[2]
                        local cpu = columns[3]
                        local mem = columns[4]
                        local cmd = columns[5]

                        local kill_proccess_button =
                            enable_kill_button and create_kill_process_button() or
                                nil

                        local pid_name_rest = wibox.widget {
                            create_textbox {text = pid},
                            create_textbox {text = comm},
                            {
                                create_textbox {text = cpu, align = 'center'},
                                create_textbox {text = mem, align = 'center'},
                                kill_proccess_button,
                                layout = wibox.layout.fixed.horizontal
                            },
                            layout = wibox.layout.ratio.horizontal
                        }
                        pid_name_rest:ajust_ratio(2, 0.2, 0.47, 0.33)

                        local row = wibox.widget {
                            {
                                pid_name_rest,
                                top = 4,
                                bottom = 4,
                                widget = wibox.container.margin
                            },
                            widget = wibox.container.background
                        }

                        row:connect_signal("mouse::enter", function(c)
                            c:set_bg(beautiful.bg_focus)
                        end)
                        row:connect_signal("mouse::leave", function(c)
                            c:set_bg(beautiful.bg_normal)
                        end)

                        if enable_kill_button then
                            row:connect_signal("mouse::enter", function()
                                kill_proccess_button.icon.opacity = 1
                            end)
                            row:connect_signal("mouse::leave", function()
                                kill_proccess_button.icon.opacity = 0.1
                            end)

                            kill_proccess_button:buttons(
                                awful.util.table.join(awful.button({}, 1,
                                                                   function()
                                    row:set_bg('#ff0000')
                                    awful.spawn.with_shell('kill -9 ' .. pid)
                                end)))
                        end

                        awful.tooltip {
                            objects = {row},
                            mode = 'outside',
                            preferred_positions = {'bottom'},
                            timer_function = function()
                                local text = cmd
                                if process_info_max_length > 0 and text:len() >
                                    process_info_max_length then
                                    text = text:sub(0,
                                                    process_info_max_length - 3) ..
                                               '...'
                                end

                                return text:gsub('%s%-', '\n\t-'):gsub(':/',
                                                                       '\n\t\t:/')
                            end
                        }

                        process_rows[j] = row

                        j = j + 1
                    end

                end
            end
        end)
    end)

    return cpu_widget
end

return setmetatable(cpu_widget,
                    {__call = function(_, ...) return worker(...) end})
