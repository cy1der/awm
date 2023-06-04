local beautiful = require 'beautiful'
local awful = require 'awful'
local HOME = os.getenv("HOME")

awful.spawn(string.format("%s/.config/awesome/autostart", HOME))

beautiful.init("~/.config/awesome/theme/theme.lua")

require 'bindings'
require 'rules'
require 'signals'
require 'modules'

io.open(string.format("%s/.cache/awesome/stdout", HOME), "w"):close()
io.open(string.format("%s/.cache/awesome/stderr", HOME), "w"):close()
