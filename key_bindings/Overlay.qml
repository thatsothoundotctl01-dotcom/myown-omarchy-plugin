import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Fullscreen overlay: lists every Hyprland keybind currently loaded,
// with a live text filter. Read-only — it never edits your config.
Overlay {
  id: root
  moduleName: "yourname.keybinds-cheatsheet"

  property var binds: []      // parsed hyprctl binds -j
  property string filterText: ""

  readonly property var filteredBinds: {
    if (filterText.length === 0) return binds
    const q = filterText.toLowerCase()
    return binds.filter(function(b) {
      return b.combo.toLowerCase().includes(q) ||
             b.dispatcher.toLowerCase().includes(q) ||
             b.arg.toLowerCase().includes(q)
    })
  }

  function comboFor(b) {
    var mods = b.modmask ? b.modmaskString : ""
    return (mods ? mods + " + " : "") + b.key
  }

  function refresh() {
    hyprctlProc.running = true
  }

  Process {
    id: hyprctlProc
    command: ["hyprctl", "binds", "-j"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const raw = JSON.parse(text)
          root.binds = raw.map(function(b) {
            return {
              combo: (b.modmask ? modmaskToString(b.modmask) + " + " : "") + (b.key || b.keycode || ""),
              dispatcher: b.dispatcher || "",
              arg: b.arg || "",
              description: b.description || ""
            }
          })
        } catch (e) {
          root.binds = []
          console.warn("keybinds-cheatsheet: failed to parse hyprctl output", e)
        }
      }
    }
  }

  // Hyprland's modmask is a bitmask; decode the common modifiers.
  function modmaskToString(mask) {
    var parts = []
    if (mask & 64) parts.push("SUPER")
    if (mask & 4)  parts.push("CTRL")
    if (mask & 8)  parts.push("ALT")
    if (mask & 1)  parts.push("SHIFT")
    return parts.join(" ")
  }

  onOpenedChanged: if (opened) refresh()

  Rectangle {
    anchors.fill: parent
    color: Color.overlayBackground

    OverlayKeyCatcher {
      anchors.fill: parent
      onCloseRequested: root.close()

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.space(32)
        spacing: Style.space(16)

        Text {
          text: "Keyboard Shortcuts"
          color: Color.foreground
          font.family: Style.font.family
          font.pixelSize: Style.font.displayLarge
          font.bold: true
        }

        TextInput {
          id: searchField
          Layout.fillWidth: true
          Layout.preferredHeight: Style.space(40)
          color: Color.foreground
          font.family: Style.font.family
          font.pixelSize: Style.font.subtitle
          focus: true
          onTextChanged: root.filterText = text

          Text {
            visible: searchField.text.length === 0
            text: "Type to filter..."
            color: Color.foregroundMuted
            font: searchField.font
          }
        }

        ListView {
          id: list
          Layout.fillWidth: true
          Layout.fillHeight: true
          clip: true
          model: root.filteredBinds
          spacing: Style.space(4)

          delegate: RowLayout {
            width: list.width
            spacing: Style.space(12)

            Rectangle {
              radius: Style.space(4)
              color: Color.chipBackground
              implicitWidth: comboText.implicitWidth + Style.space(16)
              implicitHeight: comboText.implicitHeight + Style.space(8)

              Text {
                id: comboText
                anchors.centerIn: parent
                text: modelData.combo
                color: Color.accent
                font.family: Style.font.family
                font.pixelSize: Style.font.body
                font.bold: true
              }
            }

            Text {
              Layout.fillWidth: true
              text: modelData.description.length > 0
                    ? modelData.description
                    : (modelData.dispatcher + " " + modelData.arg)
              color: Color.foreground
              font.family: Style.font.family
              font.pixelSize: Style.font.body
              elide: Text.ElideRight
            }
          }
        }
      }
    }
  }
}

