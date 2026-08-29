# myown-omarchy-plugin

Personal collection of [Omarchy](https://omarchy.org) Quattro shell plugins —
built for full keyboard control, a fast command palette, and Khmer keyboard
support in kh .

Each plugin lives in its own folder with its own `manifest.json` and README.
Enable only the ones you want.

## Plugins

| Folder | Kind | What it does |
|---|---|---|
| [`key_bindings/keybinds-cheatsheet`](key_bindings/keybinds-cheatsheet) | `overlay` | Fullscreen, searchable list of your **live** Hyprland keybindings (read via `hyprctl binds -j`) |
| [`key_bindings/command-palette`](key_bindings/command-palette) | `menu` | Fuzzy-searchable list of your own scripts, apps, and system actions — add new actions by editing one JSON file, no QML |
| [`kh_keyboard/khmer-layout-switcher`](kh_keyboard/khmer-layout-switcher) | `bar-widget` | Shows active keyboard layout (`EN`/`KH`) in the bar; click to toggle, right-click for a layouts panel |

## Requirements

- [Omarchy](https://omarchy.org) Quattro (the Quickshell-based shell rewrite)
- For the Khmer layout switcher: Khmer enabled in your Hyprland `input {}`
  config and Khmer-capable fonts installed — see that plugin's README for
  the two-line setup.

## Install a plugin

Each plugin folder is self-contained. General pattern:

```sh
PLUGIN=command-palette   # or keybinds-cheatsheet / khmer-layout-switcher
PLUGIN_ID=yourname.$PLUGIN

mkdir -p ~/.config/omarchy/plugins/$PLUGIN_ID
cp key_bindings/$PLUGIN/* ~/.config/omarchy/plugins/$PLUGIN_ID/   # adjust path per plugin

omarchy plugin validate ~/.config/omarchy/plugins/$PLUGIN_ID
qmllint -I "$OMARCHY_PATH/shell" ~/.config/omarchy/plugins/$PLUGIN_ID/*.qml

omarchy plugin enable $PLUGIN_ID
omarchy-shell shell rescanPlugins
```

Or clone straight from this repo once it's public:

```sh
omarchy plugin add https://github.com/thatsothoundotctl01-dotcom/myown-omarchy-plugin.git --enable
```

See each plugin's own `README.md` for exact commands, keybind suggestions,
and configuration.

## Structure

```
myown-omarchy-plugin/
├── key_bindings/
│   ├── keybinds-cheatsheet/   # overlay: live Hyprland keybind viewer
│   │   ├── manifest.json
│   │   ├── Overlay.qml
│   │   └── README.md
│   └── command-palette/       # menu: fuzzy action launcher
│       ├── manifest.json
│       ├── Menu.qml
│       ├── actions.example.json
│       └── README.md
├── kh_keyboard/
│   └── khmer-layout-switcher/ # bar-widget: EN/KH layout indicator
│       ├── manifest.json
│       ├── BarWidget.qml
│       ├── Panel.qml
│       └── README.md
└── README.md                  # you are here
```

## Status

⚠️ Work in progress. These plugins are built from Omarchy's documented
plugin patterns and are validated with `omarchy plugin validate` /
`qmllint`, but some QML base-component names are best-effort and should be
cross-checked against the real built-in plugins at
`$OMARCHY_PATH/shell/plugins/` before you fully rely on them. Each
plugin's own README notes exactly what to verify.

## License

MIT — see [`LICENSE`](LICENSE). Plugins run **unsandboxed** with your user
permissions; review the code before enabling anything, including your own. 


