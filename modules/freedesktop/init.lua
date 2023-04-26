local Gio = require("lgi").Gio
local awful_menu = require("awful.menu")
local menu_gen = require("menubar.menu_gen")
local menu_utils = require("menubar.utils")

local io, pairs, string, table, os = io, pairs, string, table, os

menu_utils.wm_name = ""

local menu = {}

function menu.is_dir(path)
    return Gio.File.new_for_path(path):query_file_type({}) == "DIRECTORY"
end

local existent_paths = {}
for k, v in pairs(menu_gen.all_menu_dirs) do
    if menu.is_dir(v) then table.insert(existent_paths, v) end
end
menu_gen.all_menu_dirs = existent_paths

function menu.has_value(tab, val)
    for index, value in pairs(tab) do if val:find(value) then return true end end
    return false
end

function menu.build(args)
    local args = args or {}
    local before = args.before or {}
    local after = args.after or {}
    local skip_items = args.skip_items or {}
    local sub_menu = args.sub_menu or false

    local result = {}
    local _menu = awful_menu({items = before})

    menu_gen.generate(function(entries)

        for k, v in pairs(menu_gen.all_categories) do
            table.insert(result, {k, {}, v.icon})
        end

        for k, v in pairs(entries) do
            for _, cat in pairs(result) do
                if cat[1] == v.category then
                    if not menu.has_value(skip_items, v.name) then
                        table.insert(cat[2], {v.name, v.cmdline, v.icon})
                    end
                    break
                end
            end
        end

        for i = #result, 1, -1 do
            local v = result[i]
            if #v[2] == 0 then

                table.remove(result, i)
            else

                table.sort(v[2], function(a, b)
                    return string.byte(a[1]) < string.byte(b[1])
                end)

                v[1] = menu_gen.all_categories[v[1]].name
            end
        end

        table.sort(result, function(a, b)
            return string.byte(a[1]) < string.byte(b[1])
        end)

        if sub_menu then result = {{sub_menu, result}} end

        for _, v in pairs(result) do _menu:add(v) end
        for _, v in pairs(after) do _menu:add(v) end
    end)

    menu.menu = _menu

    return _menu
end

return menu
