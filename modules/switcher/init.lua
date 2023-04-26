local awful = require('awful')
local gears = require("gears")
awful.client = require('awful.client')

local _M = {}
local cycle_raise_client = true

_M.altTabTable = {}
_M.altTabIndex = 1

function _M.tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function _M.getClients()
    local clients = {}

    local s = mouse.screen;
    local idx = 0
    local c = awful.client.focus.history.get(s, idx)

    while c do
        table.insert(clients, c)

        idx = idx + 1
        c = awful.client.focus.history.get(s, idx)
    end

    local t = s.selected_tag
    local all = client.get(s)

    for i = 1, #all do
        local c = all[i]
        local ctags = c:tags();

        local isCurrentTag = false
        for j = 1, #ctags do
            if t == ctags[j] then
                isCurrentTag = true
                break
            end
        end

        if isCurrentTag then
            local addToTable = true
            for k = 1, #clients do
                if clients[k] == c then
                    addToTable = false
                    break
                end
            end

            if addToTable then table.insert(clients, c) end
        end
    end

    return clients
end

function _M.populateAltTabTable()
    local clients = _M.getClients()

    if _M.tableLength(_M.altTabTable) then
        for ci = 1, #clients do
            for ti = 1, #_M.altTabTable do
                if _M.altTabTable[ti].client == clients[ci] then
                    _M.altTabTable[ti].client.opacity = _M.altTabTable[ti]
                                                            .opacity
                    _M.altTabTable[ti].client.minimized = _M.altTabTable[ti]
                                                              .minimized
                    break
                end
            end
        end
    end

    _M.altTabTable = {}

    for i = 1, #clients do
        table.insert(_M.altTabTable, {
            client = clients[i],
            minimized = clients[i].minimized,
            opacity = clients[i].opacity
        })
    end
end

function _M.cycle(dir)
    _M.altTabIndex = _M.altTabIndex + dir
    if _M.altTabIndex > #_M.altTabTable then
        _M.altTabIndex = 1
    elseif _M.altTabIndex < 1 then
        _M.altTabIndex = #_M.altTabTable
    end

    _M.altTabTable[_M.altTabIndex].client.minimized = false

    if cycle_raise_client == true then
        _M.altTabTable[_M.altTabIndex].client:raise()
    end
end

function _M.switch(dir, mod_key1, release_key, mod_key2, key_switch)
    _M.populateAltTabTable()

    if #_M.altTabTable == 0 then
        return
    elseif #_M.altTabTable == 1 then
        _M.altTabTable[1].client.minimized = false
        _M.altTabTable[1].client:raise()
        return
    end

    _M.altTabIndex = 1

    keygrabber.run(function(mod, key, event)
        if gears.table.hasitem(mod, mod_key1) then
            if (key == release_key or key == "Escape") and event == "release" then

                if key == "Escape" then
                    for i = 1, #_M.altTabTable do
                        _M.altTabTable[i].client.opacity = _M.altTabTable[i]
                                                               .opacity
                        _M.altTabTable[i].client.minimized = _M.altTabTable[i]
                                                                 .minimized
                    end
                else
                    local c
                    for i = 1, _M.altTabIndex - 1 do
                        c = _M.altTabTable[_M.altTabIndex - i].client
                        if not _M.altTabTable[i].minimized then
                            c:raise()
                            client.focus = c
                        end
                    end

                    c = _M.altTabTable[_M.altTabIndex].client
                    c:raise()
                    client.focus = c

                    for i = 1, #_M.altTabTable do
                        if i ~= _M.altTabIndex and _M.altTabTable[i].minimized then
                            _M.altTabTable[i].client.minimized = true
                        end
                        _M.altTabTable[i].client.opacity = _M.altTabTable[i]
                                                               .opacity
                    end
                end

                keygrabber.stop()

            elseif key == key_switch and event == "press" then
                if gears.table.hasitem(mod, mod_key2) then
                    _M.cycle(-1)
                else
                    _M.cycle(1)
                end
            end
        end
    end)

    _M.cycle(dir)

end

return {switch = _M.switch}
