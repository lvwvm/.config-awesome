# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an AwesomeWM (Lua-based tiling window manager) configuration for Manjaro Linux. The configuration uses the "Homestead" theme with a dark blue/teal color scheme.

## Architecture

```
~/.config/awesome/
├── rc.lua                    # Main entry point (wibar, mouse bindings, screen setup)
├── autorun.sh                # Startup script for background services
├── config/
│   ├── vars.lua              # Centralized configuration variables
│   ├── keys.lua              # Keybindings (global, client, tag)
│   ├── rules.lua             # Client rules (floating, titlebars)
│   ├── signals.lua           # Client signals (borders, titlebars, focus)
│   └── menu.lua              # Menu definitions (main menu, exit menu)
└── themes/homestead/
    └── theme.lua             # Theme (colors, fonts, icons)
```

### Module Responsibilities

- **rc.lua**: Main entry point. Loads modules, sets up screens, wibar widgets, and mouse bindings.
- **config/vars.lua**: Single source of truth for applications (terminal, browser, etc.), modkey, and tag count.
- **config/keys.lua**: All keybinding definitions. Functions take dependencies (modkey, terminal, menu) as parameters.
- **config/rules.lua**: Client matching rules for floating windows, titlebars, etc.
- **config/signals.lua**: Client event handlers including smart border management and titlebar setup.
- **config/menu.lua**: Freedesktop menu integration with awesome and exit submenus.
- **themes/homestead/theme.lua**: Theme definitions. Inherits icons from `/usr/share/awesome/themes/cesious`.

## Dependencies

**Lua Libraries:**
- Standard AwesomeWM: `gears`, `awful`, `wibox`, `beautiful`, `naughty`, `menubar`
- External: `lain` (for markup utilities), `freedesktop` (for application menus)

**External Programs:**
- Terminal: `alacritty`
- Browser: `firefox`
- File manager: `pcmanfm`
- Editor: `gedit`
- Launcher: `rofi`
- Screenshots: `i3-scrot`
- Compositor: `picom`

## Testing Configuration Changes

```bash
# Syntax check all Lua files
luac -p rc.lua
luac -p config/*.lua
luac -p themes/homestead/theme.lua

# Restart AwesomeWM to apply changes (from within awesome)
# Mod4+Ctrl+r

# Test in nested X server (safe testing without affecting current session)
Xephyr :1 -screen 1280x720 &
DISPLAY=:1 awesome
```

## Configuration Patterns

**Adding Variables**: Edit `config/vars.lua`. Variables are imported in rc.lua.

**Adding Keybindings**: Edit `config/keys.lua`. Add to appropriate function (`create_globalkeys`, `create_clientkeys`, or `bind_tag_keys`).

**Adding Client Rules**: Edit `config/rules.lua`. Add new rule tables to the array returned by `rules.create()`.

**Adding Signals**: Edit `config/signals.lua`. Add new `client.connect_signal()` or `screen.connect_signal()` calls inside `signals.setup()`.

**Theme Colors**: Edit `themes/homestead/theme.lua`. Custom colors include `wibar_separator` and `wibar_accent`.

## Key Bindings Reference

| Key | Action |
|-----|--------|
| Mod4+Return | Terminal |
| Mod4+Shift+b | Browser |
| Mod4+e | File manager |
| Mod4+Ctrl+Escape | Rofi launcher |
| Mod4+x | Close window |
| Mod4+f | Fullscreen |
| Mod4+m | Maximize |
| Mod4+j/k | Focus next/prev window |
| Mod4+h/l | Resize master width |
| Mod4+Left/Right | Switch tag |
| Mod4+[1-6] | Go to tag |
| Mod4+Shift+[1-6] | Move window to tag |
| Mod4+Ctrl+r | Restart awesome |
| Mod4+s | Show keybinding help |
