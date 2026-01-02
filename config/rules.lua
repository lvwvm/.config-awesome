-- Client rules configuration
local awful = require("awful")
local beautiful = require("beautiful")

local rules = {}

function rules.create(clientkeys, clientbuttons)
  return {
    -- All clients will match this rule.
    {
      rule = {},
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        size_hints_honor = false, -- Remove gaps between terminals
        screen = awful.screen.preferred,
        callback = awful.client.setslave,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen
      }
    },
    -- Floating clients.
    {
      rule_any = {
        instance = {
          "DTA", -- Firefox addon DownThemAll.
          "copyq" -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin", -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"
        },
        name = {
          "Event Tester" -- xev.
        },
        role = {
          "AlarmWindow", -- Thunderbird's calendar.
          "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
        }
      },
      properties = {floating = true}
    },
    -- Add titlebars to normal clients and dialogs
    {
      rule_any = {type = {"normal", "dialog"}},
      properties = {titlebars_enabled = true}
    }
  }
end

return rules
