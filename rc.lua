-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Lain
local lain = require("lain")

-- Load custom modules
local vars = require("config.vars")
local keys = require("config.keys")
local rules = require("config.rules")
local signals = require("config.signals")
local menu = require("config.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors
    }
  )
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal(
    "debug::error",
    function(err)
      -- Make sure we don't go into an endless error loop
      if in_error then
        return
      end
      in_error = true

      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = "Oops, an error happened!",
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/themes/homestead/theme.lua")
beautiful.notification_font = "NotoSansDisplay Nerd Font Regular Medium 12"

-- Extract variables from config
local terminal = vars.terminal
local browser = vars.browser
local filemanager = vars.filemanager
local editor = vars.editor
local modkey = vars.modkey

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.max
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil

  return function()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({theme = {width = 250}})
    end
  end
end
-- }}}

-- {{{ Menu
local mymainmenu, mylauncher = menu.create(terminal, browser, filemanager, editor)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock("%H:%M ")

local markup = lain.util.markup
local seperator = wibox.widget.textbox(' <span color="' .. beautiful.wibar_separator .. '">| </span>')
local spacer = wibox.widget.textbox(' <span color="' .. beautiful.wibar_separator .. '"> </span>')

-- Create a wibox for each screen and add it
local taglist_buttons =
  gears.table.join(
    awful.button(
      {},
      1,
      function(t)
        t:view_only()
      end
    ),
    awful.button(
      {modkey},
      1,
      function(t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
      {modkey},
      3,
      function(t)
        if client.focus then
          client.focus:toggle_tag(t)
        end
      end
    ),
    awful.button(
      {},
      4,
      function(t)
        awful.tag.viewnext(t.screen)
      end
    ),
    awful.button(
      {},
      5,
      function(t)
        awful.tag.viewprev(t.screen)
      end
    )
  )

local tasklist_buttons =
  gears.table.join(
    awful.button(
      {},
      1,
      function(c)
        if c == client.focus then
          c.minimized = true
        else
          -- Without this, the following
          -- :isvisible() makes no sense
          c.minimized = false
          if not c:isvisible() and c.first_tag then
            c.first_tag:view_only()
          end
          -- This will also un-minimize
          -- the client, if needed
          client.focus = c
          c:raise()
        end
      end
    ),
    awful.button({}, 3, client_menu_toggle_fn()),
    awful.button(
      {},
      4,
      function()
        awful.client.focus.byidx(1)
      end
    ),
    awful.button(
      {},
      5,
      function()
        awful.client.focus.byidx(-1)
      end
    )
  )

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
  function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    local tag_names = {}
    for i = 1, vars.num_tags do
      tag_names[i] = tostring(i)
    end
    awful.tag(tag_names, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(
      gears.table.join(
        awful.button(
          {},
          1,
          function()
            awful.layout.inc(1)
          end
        ),
        awful.button(
          {},
          3,
          function()
            awful.layout.inc(-1)
          end
        ),
        awful.button(
          {},
          4,
          function()
            awful.layout.inc(1)
          end
        ),
        awful.button(
          {},
          5,
          function()
            awful.layout.inc(-1)
          end
        )
      )
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({position = "top", screen = s})

    -- Add widgets to the wibox
    s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      {
        -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
        seperator
      },
      s.mytasklist, -- Middle widget
      {
        -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.systray(),
        mykeyboardlayout,
        seperator,
        mytextclock,
        s.mylayoutbox
      }
    }
  end
)
-- }}}

-- {{{ Mouse bindings
root.buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      function()
        mymainmenu:hide()
      end
    ),
    awful.button(
      {},
      3,
      function()
        mymainmenu:toggle()
      end
    ),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
  )
)
-- }}}

-- {{{ Key bindings
local globalkeys = keys.create_globalkeys(modkey, terminal, mymainmenu)
globalkeys = keys.bind_tag_keys(globalkeys, modkey)

local clientkeys = keys.create_clientkeys(modkey)
local clientbuttons = keys.create_clientbuttons(modkey, mymainmenu)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = rules.create(clientkeys, clientbuttons)
-- }}}

-- {{{ Signals
signals.setup()
-- }}}

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
