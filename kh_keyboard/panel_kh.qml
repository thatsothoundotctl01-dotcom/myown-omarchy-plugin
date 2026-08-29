import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// Small popup panel: shows every configured keyboard layout with the
// active one highlighted, plus a reminder of the toggle shortcut.
// Follows the documented clock-panel pattern (Panel base + KeyboardPanel
// anchored to the bar button, PanelKeyCatcher handles Escape).
Panel {
  id: root
  moduleName: "yourname.khmer-layout-switcher"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null

  function open() { root.controller.show() }
  function close() { root.controller.hide() }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.hostWidget || root, direction)
    return false
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(220))
    contentHeight: panel.fittedContentHeight(content.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: content
        width: parent.width
        spacing: Style.space(8)

        Text {
          width: parent.width
          text: "Keyboard Layouts"
          color: root.barForeground
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.subtitle
          font.bold: true
        }

        Repeater {
          model: root.hostWidget ? root.hostWidget.allLayouts : []
          delegate: Rectangle {
            width: content.width
            height: Style.space(28)
            radius: Style.space(4)
            color: (root.hostWidget &&
                    modelData.toLowerCase().includes(
                      root.hostWidget.currentLayout === "KH" ? "khmer" : "english"))
                   ? Color.chipBackground : "transparent"

            Text {
              anchors.left: parent.left
              anchors.leftMargin: Style.space(8)
              anchors.verticalCenter: parent.verticalCenter
              text: modelData
              color: root.barForeground
              font.family: root.bar ? root.bar.fontFamily : Style.font.family
              font.pixelSize: Style.font.body
            }
          }
        }

        Text {
          width: parent.width
          text: "Left-click the badge to switch layout"
          color: root.barForeground
          opacity: 0.6
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          wrapMode: Text.WordWrap
        }
      }
    }
  }
}

