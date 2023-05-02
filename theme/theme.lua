local themes_path =
    string.format("%s/.config/awesome/theme/", os.getenv("HOME"))
local dpi = require("beautiful.xresources").apply_dpi

local theme = {}

theme.wallpaper = themes_path .. "background.jpg"
theme.font = "CaskaydiaCoveNerd Font SemiLight 12"
theme.notification_font = "CaskaydiaCoveNerd Font SemiLight 12"
theme.taglist_font = "CaskaydiaCoveNerd Font SemiLight 16"
theme.notification_spacing = dpi(8)
theme.fg_normal = "#000000"
theme.fg_focus = "#FFFFFF"
theme.fg_urgent = "#FF5250"
theme.bg_normal = "#000000"
theme.bg_focus = "#000000"
theme.bg_urgent = "#000000"
theme.bg_systray = theme.bg_normal
theme.gap_single_client = true
theme.border_width = dpi(2)
theme.border_normal = "#000000"
theme.border_focus = "#FFFFFF"
theme.border_marked = "#FF5250"
theme.titlebar_bg_focus = "#000000"
theme.titlebar_bg_normal = "#000000"
theme.systray_icon_spacing = dpi(4)
theme.mouse_finder_color = "#FF5250"
theme.hotkeys_bg = "#000000"
theme.hotkeys_fg = "#FFFFFF"
theme.hotkeys_label_fg = "#000000"
theme.hotkeys_modifiers_fg = "#888888"
theme.hotkeys_group_margin = dpi(8)
theme.menu_height = dpi(25)
theme.menu_width = dpi(250)
theme.menu_border_color = "#FFFFFF"
theme.menu_border_width = dpi(2)
theme.taglist_squares_sel = themes_path .. "icons/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "icons/taglist/squarez.png"
theme.taglist_fg_empty = "#666666"
theme.taglist_fg_occupied = "#666666"
theme.taglist_fg_focus = "#FFFFFF"
theme.tasklist_fg_normal = "#666666"
theme.menu_fg_normal = "#666666"
theme.awesome_icon = themes_path .. "icons/menu/awesome.png"
theme.menu_submenu_icon = themes_path .. "icons/menu/submenu.png"
theme.layout_tile = themes_path .. "icons/layouts/tile.png"
theme.layout_tileleft = themes_path .. "icons/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "icons/layouts/tilebottom.png"
theme.layout_tiletop = themes_path .. "icons/layouts/tiletop.png"
theme.layout_fairv = themes_path .. "icons/layouts/fairv.png"
theme.layout_fairh = themes_path .. "icons/layouts/fairh.png"
theme.layout_spiral = themes_path .. "icons/layouts/spiral.png"
theme.layout_dwindle = themes_path .. "icons/layouts/dwindle.png"
theme.layout_max = themes_path .. "icons/layouts/max.png"
theme.layout_fullscreen = themes_path .. "icons/layouts/fullscreen.png"
theme.layout_magnifier = themes_path .. "icons/layouts/magnifier.png"
theme.layout_floating = themes_path .. "icons/layouts/floating.png"
theme.layout_cornernw = themes_path .. "icons/layouts/cornernw.png"
theme.layout_cornerne = themes_path .. "icons/layouts/cornerne.png"
theme.layout_cornersw = themes_path .. "icons/layouts/cornersw.png"
theme.layout_cornerse = themes_path .. "icons/layouts/cornerse.png"
theme.titlebar_close_button_focus = themes_path ..
                                        "icons/titlebar/right/close/focus.png"
theme.titlebar_close_button_focus_hover = themes_path ..
                                              "icons/titlebar/right/close/focus-hover.png"
theme.titlebar_close_button_focus_press = themes_path ..
                                              "icons/titlebar/right/close/focus-press.png"
theme.titlebar_close_button_normal = themes_path ..
                                         "icons/titlebar/right/close/normal.png"
theme.titlebar_close_button_normal_hover = themes_path ..
                                               "icons/titlebar/right/close/normal-hover.png"
theme.titlebar_close_button_normal_press = themes_path ..
                                               "icons/titlebar/right/close/normal-press.png"
theme.titlebar_minimize_button_focus = themes_path ..
                                           "icons/titlebar/right/minimize/focus.png"
theme.titlebar_minimize_button_focus_hover = themes_path ..
                                                 "icons/titlebar/right/minimize/focus-hover.png"
theme.titlebar_minimize_button_focus_press = themes_path ..
                                                 "icons/titlebar/right/minimize/focus-press.png"
theme.titlebar_minimize_button_normal = themes_path ..
                                            "icons/titlebar/right/minimize/normal.png"
theme.titlebar_minimize_button_normal_hover = themes_path ..
                                                  "icons/titlebar/right/minimize/normal-hover.png"
theme.titlebar_minimize_button_normal_press = themes_path ..
                                                  "icons/titlebar/right/minimize/normal-press.png"
theme.titlebar_maximized_button_focus_active = themes_path ..
                                                   "icons/titlebar/right/maximize/focus-press.png"
theme.titlebar_maximized_button_normal_active = themes_path ..
                                                    "icons/titlebar/right/maximize/normal.png"
theme.titlebar_maximized_button_focus_inactive = themes_path ..
                                                     "icons/titlebar/right/maximize/focus.png"
theme.titlebar_maximized_button_normal_inactive = themes_path ..
                                                      "icons/titlebar/right/maximize/normal.png"
theme.titlebar_maximized_button_focus_active_hover = themes_path ..
                                                         "icons/titlebar/right/maximize/focus-hover.png"
theme.titlebar_maximized_button_normal_active_hover = themes_path ..
                                                          "icons/titlebar/right/maximize/normal-hover.png"
theme.titlebar_maximized_button_focus_inactive_hover = themes_path ..
                                                           "icons/titlebar/right/maximize/focus-hover.png"
theme.titlebar_maximized_button_normal_inactive_hover = themes_path ..
                                                            "icons/titlebar/right/maximize/normal-hover.png"
theme.titlebar_maximized_button_focus_active_press = themes_path ..
                                                         "icons/titlebar/right/maximize/focus-press.png"
theme.titlebar_maximized_button_normal_active_press = themes_path ..
                                                          "icons/titlebar/right/maximize/normal-press.png"
theme.titlebar_maximized_button_focus_inactive_press = themes_path ..
                                                           "icons/titlebar/right/maximize/focus-press.png"
theme.titlebar_maximized_button_normal_inactive_press = themes_path ..
                                                            "icons/titlebar/right/maximize/normal-press.png"
theme.titlebar_sticky_button_normal_inactive = themes_path ..
                                                   "icons/titlebar/left/sticky/normal.png"
theme.titlebar_sticky_button_normal_inactive_hover = themes_path ..
                                                         "icons/titlebar/left/sticky/inactive.png"
theme.titlebar_sticky_button_normal_inactive_press = themes_path ..
                                                         "icons/titlebar/left/sticky/inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path ..
                                                 "icons/titlebar/left/sticky/normal.png"
theme.titlebar_sticky_button_normal_active_hover = themes_path ..
                                                       "icons/titlebar/left/sticky/active.png"
theme.titlebar_sticky_button_normal_active_press = themes_path ..
                                                       "icons/titlebar/left/sticky/active.png"
theme.titlebar_sticky_button_focus_inactive = themes_path ..
                                                  "icons/titlebar/left/sticky/inactive.png"
theme.titlebar_sticky_button_focus_inactive_hover = themes_path ..
                                                        "icons/titlebar/left/sticky/inactive.png"
theme.titlebar_sticky_button_focus_inactive_press = themes_path ..
                                                        "icons/titlebar/left/sticky/inactive.png"
theme.titlebar_sticky_button_focus_active = themes_path ..
                                                "icons/titlebar/left/sticky/active.png"
theme.titlebar_sticky_button_focus_active_hover = themes_path ..
                                                      "icons/titlebar/left/sticky/active.png"
theme.titlebar_sticky_button_focus_active_press = themes_path ..
                                                      "icons/titlebar/left/sticky/active.png"
theme.titlebar_ontop_button_normal_inactive = themes_path ..
                                                  "icons/titlebar/left/ontop/normal.png"
theme.titlebar_ontop_button_normal_inactive_hover = themes_path ..
                                                        "icons/titlebar/left/ontop/inactive.png"
theme.titlebar_ontop_button_normal_inactive_press = themes_path ..
                                                        "icons/titlebar/left/ontop/inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path ..
                                                "icons/titlebar/left/ontop/normal.png"
theme.titlebar_ontop_button_normal_active_hover = themes_path ..
                                                      "icons/titlebar/left/ontop/active.png"
theme.titlebar_ontop_button_normal_active_press = themes_path ..
                                                      "icons/titlebar/left/ontop/active.png"
theme.titlebar_ontop_button_focus_inactive = themes_path ..
                                                 "icons/titlebar/left/ontop/inactive.png"
theme.titlebar_ontop_button_focus_inactive_hover = themes_path ..
                                                       "icons/titlebar/left/ontop/inactive.png"
theme.titlebar_ontop_button_focus_inactive_press = themes_path ..
                                                       "icons/titlebar/left/ontop/inactive.png"
theme.titlebar_ontop_button_focus_active = themes_path ..
                                               "icons/titlebar/left/ontop/active.png"
theme.titlebar_ontop_button_focus_active_hover = themes_path ..
                                                     "icons/titlebar/left/ontop/active.png"
theme.titlebar_ontop_button_focus_active_press = themes_path ..
                                                     "icons/titlebar/left/ontop/active.png"
theme.titlebar_floating_button_normal_inactive = themes_path ..
                                                     "icons/titlebar/left/floating/normal.png"
theme.titlebar_floating_button_normal_inactive_hover = themes_path ..
                                                           "icons/titlebar/left/floating/inactive.png"
theme.titlebar_floating_button_normal_inactive_press = themes_path ..
                                                           "icons/titlebar/left/floating/inactive.png"
theme.titlebar_floating_button_normal_active = themes_path ..
                                                   "icons/titlebar/left/floating/normal.png"
theme.titlebar_floating_button_normal_active_hover = themes_path ..
                                                         "icons/titlebar/left/floating/active.png"
theme.titlebar_floating_button_normal_active_press = themes_path ..
                                                         "icons/titlebar/left/floating/active.png"
theme.titlebar_floating_button_focus_inactive = themes_path ..
                                                    "icons/titlebar/left/floating/inactive.png"
theme.titlebar_floating_button_focus_inactive_hover = themes_path ..
                                                          "icons/titlebar/left/floating/inactive.png"
theme.titlebar_floating_button_focus_inactive_press = themes_path ..
                                                          "icons/titlebar/left/floating/inactive.png"
theme.titlebar_floating_button_focus_active = themes_path ..
                                                  "icons/titlebar/left/floating/active.png"
theme.titlebar_floating_button_focus_active_hover = themes_path ..
                                                        "icons/titlebar/left/floating/active.png"
theme.titlebar_floating_button_focus_active_press = themes_path ..
                                                        "icons/titlebar/left/floating/active.png"

return theme
