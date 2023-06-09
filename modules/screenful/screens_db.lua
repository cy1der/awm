local defaultOutput = 'eDP1'

outputMapping = {
    ['DP-1'] = 'DP1',
    ['DP-2'] = 'DP2',
    ['DP-3'] = 'DP3',
    ['VGA-1'] = 'VGA1',
    ['LVDS-1'] = 'LVDS1',
    ['HDMI-A-1'] = 'HDMI1',
    ['HDMI-A-2'] = 'HDMI2',
    ['eDP-1'] = 'eDP1',
    ['eDP-2'] = 'eDP2'
}

screens = {
    ['657654565323'] = { -- DP1
        ['connected'] = function(xrandrOutput)
            if xrandrOutput ~= defaultOutput then
                return '--output ' .. defaultOutput ..
                           ' --primary --mode 2560x1440 --pos 0x1080 --rotate normal --output ' ..
                           xrandrOutput ..
                           ' --mode 1920x1080 --pos 320x0 --rotate normal'
            end
            return nil
        end,
        ['disconnected'] = function(xrandrOutput)
            if xrandrOutput ~= defaultOutput then
                return '--output ' .. defaultOutput ..
                           ' --primary --mode 2560x1440 --pos 0x0 --rotate normal'
            end
            return nil
        end
    }
}
--	['0100050'] = { -- HDMI1
--		['connected'] = function (xrandrOutput)
--			if xrandrOutput ~= defaultOutput then
--				return '--output ' .. xrandrOutput .. ' --auto --same-as ' .. defaultOutput
--			end
--			return nil
--		end,
--		['disconnected'] = function (xrandrOutput)
--			if xrandrOutput ~= defaultOutput then
--			return '--output ' .. xrandrOutput .. ' --off --output ' .. defaultOutput .. ' --auto'
--			end
--			return nil
--		end
--	}
