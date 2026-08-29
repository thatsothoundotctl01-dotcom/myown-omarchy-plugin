# Command Palette

A summoned `menu`-kind Omarchy plugin: one key opens a fuzzy-searchable
list of your own scripts, apps, and system actions. Adding a new action
never requires touching QML — you just add a line to a JSON config file.

## Install (development)

```sh
mkdir -p ~/.config/omarchy/plugins/yourname.command-palette
cp manifest.json Menu.qml README.md \
   ~/.config/omarchy/plugins/yourname.command-palette/

omarchy plugin validate ~/.config/omarchy/plugins/yourname.command-palette
qmllint -I "$OMARCHY_PATH/shell" \
   ~/.config/omarchy/plugins/yourname.command-palette/Menu.qml

omarchy plugin enable yourname.command-palette
omarchy-shell shell rescanPlugins
```

## Configure your actions

Copy the example config to where the plugin actually reads from:

```sh
mkdir -p ~/.config/omarchy/command-palette
cp actions.example.json ~/.config/omarchy/command-palette/actions.json
```

Then edit `~/.config/omarchy/command-palette/actions.json` — each entry:

```json
{ "label": "Lock screen", "command": "omarchy-lock-screen", "keywords": "power", "hint": "system" }
```

- `label` — what's shown in the list
- `command` — shell command run via `sh -c` when you select it
- `keywords` — optional extra text matched by the search filter
- `hint` — optional small right-aligned tag (category label)

The plugin **watches the file** (`FileView.watchChanges`), so edits apply
immediately — no restart needed.

## Bind a key to open it

Add to your Hyprland config:

```
bind = SUPER, P, exec, omarchy-shell shell summon yourname.command-palette '{}'
```

Then inside the palette: type to filter, ↑/↓ to move, Enter to run,
Escape to close.

## Remove

```sh
omarchy plugin remove yourname.command-palette
```

## Notes / things to verify

Same caveat as the keybinds cheatsheet: I don't have the real source for
`Menu`, `MenuKeyCatcher`, or `FileView` in `qs.Ui`/`qs.Commons`, so treat
the base-component names and their signals (`onUpRequested`,
`onEnterRequested`, etc.) as best-effort guesses modeled on the documented
`Panel`/`PanelKeyCatcher` pattern. Before relying on this:

1. Compare against the real `omarchy.menu` plugin source at
   `$OMARCHY_PATH/shell/plugins/menu/Menu.qml` and copy its actual base
   class and key-handling API.
2. Confirm `Quickshell.execDetached` and `FileView` are the real APIs for
   running commands / watching files in this Quickshell version — check
   `$OMARCHY_PATH/shell/plugins/clipboard/Clipboard.qml` or
   `reminders/ReminderFlow.qml`, which likely do similar things.

`omarchy plugin validate`, `qmllint`, and
`qs log -p "$OMARCHY_PATH/shell" --tail 100` are your fastest feedback
loop for fixing whatever doesn't match.
