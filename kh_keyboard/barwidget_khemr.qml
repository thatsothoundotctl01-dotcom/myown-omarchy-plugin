import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

// Bar widget: shows the active keyboard layout as a short badge (EN/KH).
// Left-click cycles to the next layout via hyprctl. Right-click / normal
// click also opens a small details panel listing all configured layouts.
// Structure follows the documented clock bar-widget example: BarWidget.qml
// is the manifest entry point, it loads Panel.qml internally via a Loader.
BarWidget {
  id: root
  moduleName: "yourname.khmer-layout-switcher"

  property string currentLayout: "EN"
  property var allLayouts: []   // e.g. ["English (US)", "Khmer"]

  readonly property bool opened: panelLoader.item
    ? panelLoader.item.opened === true
    : false
  readonly property bool popoutSwitchClosing: panelLoader.item
    ? panelLoader.item.popoutSwitchClosing === true
    : false

  function open() {
    if (panelLoader.item) panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item) panelLoader.item.close()
  }

  function toggle() {
    if (panelLoader.item) panelLoader.item.toggle()
  }

  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  function injectPanel() {
    if (!panelLoader.item) return
    panelLoader.item.bar = root.bar
    panelLoader.item.anchorItem = button
    panelLoader.item.hostWidget = root
  }

  function refreshLayout() {
    layoutQuery.running = true
  }

  function cycleLayout() {
    cycleProc.running = true
  }

  // Reads the active device layout from Hyprland. Field names/shape here
  // are a best-effort guess at `hyprctl devices -j` output for the main
  // keyboard entry — verify against your own `hyprctl devices -j | jq .`
  // and adjust the parsing below if it differs.
  Process {
    id: layoutQuery
    command: ["hyprctl", "devices", "-j"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const data = JSON.parse(text)
          const kb = (data.keyboards || []).find(function(k) { return k.main === true }) ||
                     (data.keyboards || [])[0]
          if (kb) {
            root.allLayouts = (kb.layout || "").split(",").map(function(s) { return s.trim() })
            const active = kb.active_keymap || ""
            root.currentLayout = active.toLowerCase().includes("khmer") ? "KH" : "EN"
          }
        } catch (e) {
          console.warn("khmer-layout-switcher: failed to parse hyprctl devices", e)
        }
      }
    }
  }

  Process {
    id: cycleProc
    command: ["hyprctl", "switchxkblayout", "current", "next"]
    onExited: root.refreshLayout()
  }

  // Poll lightly so external layout changes (e.g. from a keybind) still
  // update the badge without needing this widget clicked first.
  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: root.refreshLayout()
  }

  Component.onCompleted: root.refreshLayout()

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onBarChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.currentLayout
    tooltipText: "Keyboard layout: " + root.currentLayout + " — click to switch, right-click for details"
    onPressed: function(buttonCode) {
      if (buttonCode === Qt.LeftButton) {
        root.cycleLayout()
      } else if (buttonCode === Qt.RightButton) {
        root.toggle()
      }
    }
  }
}

