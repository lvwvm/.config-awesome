-- Menu configuration
local awful = require("awful")
local beautiful = require("beautiful")
local freedesktop = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local menu = {}

function menu.create(terminal, browser, filemanager, editor)
  local myawesomemenu = {
    {
      "hotkeys",
      function()
        return false, hotkeys_popup.show_help
      end
    },
    {"manual", terminal .. " -e man awesome"},
    {"edit config", string.format("%s %s", editor, awesome.conffile)},
    {"edit theme", string.format("%s %s", editor, ".config/awesome/themes/homestead/theme.lua")},
    {"restart", awesome.restart}
  }

  local myexitmenu = {
    {
      "log out",
      function()
        awesome.quit()
      end,
      "/usr/share/icons/Papirus-Dark/symbolic/actions/system-log-out-symbolic.svg"
    },
    {"suspend", "systemctl suspend", "/usr/share/icons/Papirus-Dark/symbolic/actions/system-suspend-symbolic.svg"},
    {"hibernate", "systemctl hibernate", "/usr/share/icons/Papirus-Dark/symbolic/actions/system-hibernate-symbolic.svg"},
    {"reboot", "systemctl reboot", "/usr/share/icons/Papirus-Dark/symbolic/actions/system-reboot-symbolic.svg"},
    {"shutdown", "poweroff", "/usr/share/icons/Papirus-Dark/symbolic/actions/system-shutdown-symbolic.svg"}
  }

  local mymainmenu =
    freedesktop.menu.build(
      {
        before = {
          {"Terminal", terminal, "/usr/share/icons/Papirus/64x64/apps/terminal.svg"},
          {"Browser", browser, "/usr/share/icons/Papirus/64x64/apps/firefox.svg"},
          {"Files", filemanager, "/usr/share/icons/Papirus/64x64/apps/system-file-manager.svg"}
        },
        after = {
          {"Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome16.png"},
          {"Exit", myexitmenu, "/usr/share/icons/Papirus-Dark/symbolic/actions/application-exit-symbolic.svg"}
        }
      }
    )

  local mylauncher =
    awful.widget.launcher(
      {
        image = beautiful.awesome_icon,
        menu = mymainmenu
      }
    )

  return mymainmenu, mylauncher
end

return menu
