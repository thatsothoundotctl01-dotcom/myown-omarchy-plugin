# Keybinds Cheatsheet

A fullscreen Omarchy overlay that lists your **live** Hyprland keybindings
(read from `hyprctl binds -j`, not a hardcoded list), with a live search
filter. Read-only — it never edits your Hyprland config.

## Install (development)

```sh
mkdir -p ~/.config/omarchy/plugins/yourname.keybinds-cheatsheet
cp manifest.json Overlay.qml README.md \
   ~/.config/omarchy/plugins/yourname.keybinds-cheatsheet/
omarchy plugin validate ~/.config/omarchy/plugins/yourname.keybinds-cheatsheet
qmllint -I "$OMARCHY_PATH/shell" \
   ~/.config/omarchy/plugins/yourname.keybinds-cheatsheet/Overlay.qml
omarchy plugin enable yourname.keybinds-cheatsheet
omarchy-shell shell rescanPlugins
```

## Usage

```sh
omarchy-shell shell summon yourname.keybinds-cheatsheet '{}'
```

Bind that command to a key of your choice in your Hyprland config, e.g.:

```
bind = SUPER, slash, exec, omarchy-shell shell summon yourname.keybinds-cheatsheet '{}'
```

Press Escape to close. Type anything to filter by key combo or action.

## Remove

```sh
omarchy plugin remove yourname.keybinds-cheatsheet
```

## Notes / things to verify

This scaffold follows the structure documented in Omarchy's official
plugin development guide (bar-widget/panel example) and the plugin
catalogue at `shell/plugins/README.md`, applied to the `overlay` kind.
Two things are **best-effort guesses** you should confirm against the
real `Overlay` base component and `hyprctl binds -j` output on your
system before relying on it:

1. The exact `Overlay` / `OverlayKeyCatcher` component names and their
   API — cross-check against a built-in overlay such as
   `$OMARCHY_PATH/shell/plugins/emojis/Emojis.qml` or
   `image-picker/ImagePicker.qml`.
2. The `hyprctl binds -j` field names (`modmask`, `key`, `dispatcher`,
   `arg`, `description`) — run `hyprctl binds -j | jq .` yourself and
   adjust the parsing in `Overlay.qml` if your Hyprland version differs.

`omarchy plugin validate` and `qmllint` will catch structural issues;
`qs log -p "$OMARCHY_PATH/shell" --tail 100` will show runtime QML
errors if the overlay doesn't render.
#update readme add actions.json
