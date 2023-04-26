local awful = require 'awful'
local ruled = require 'ruled'

ruled.client.connect_signal('request::rules', function()
    ruled.client.append_rule {
        id = 'global',
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap +
                awful.placement.no_offscreen
        }
    }

    ruled.client.append_rule {
        id = 'floating',
        rule_any = {
            instance = {'copyq', 'pinentry'},
            class = {'Arandr', 'Blueman-manager', 'Gpick'},
            name = {
                'Event Tester' -- xev
            },
            role = {'AlarmWindow', 'ConfigManager', 'pop-up'}
        },
        properties = {floating = true}
    }

    ruled.client.append_rule {
        id = 'titlebars',
        rule_any = {type = {'normal', 'dialog'}},
        properties = {titlebars_enabled = true}
    }
end)
