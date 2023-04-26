local beautiful = require 'beautiful'
local awful = require 'awful'

awful.util.spawn_with_shell("~/.config/awesome/autostart")
beautiful.init("~/.config/awesome/theme/theme.lua")

require 'bindings'
require 'rules'
require 'signals'
require 'modules'
