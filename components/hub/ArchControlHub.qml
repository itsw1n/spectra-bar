import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "../.."
import ".."

Item {
  id: controlHub
  required property Item anchorItem
  required property QtObject bar
  property bool opened: false
  readonly property bool voxtypeAvailable: agentsControl.voxtypeAvailable
  readonly property bool recorderAvailable: agentsControl.recorderAvailable
  readonly property bool revealInactiveIndicators: true
  readonly property var modeRows: [microphone, awake, dnd, nightlight, recording, dictation, reminder, aiUsage]
  readonly property var navigationRows: modeRows.concat([systemMenu])
  property int selectedIndex: -1
  readonly property bool recordingActive: recording.active
  readonly property bool microphoneActive: microphone.active
  implicitWidth: anchorItem ? anchorItem.width : 68
  implicitHeight: Theme.badgeHeight

  function selectRow(row) {
    var index = navigationRows.indexOf(row)
    if (index >= 0 && row.ready) selectedIndex = index
  }

  function moveSelection(direction) {
    var count = navigationRows.length
    var index = selectedIndex
    if (index < 0) index = direction > 0 ? -1 : 0
    for (var step = 0; step < count; step++) {
      index = (index + direction + count) % count
      if (navigationRows[index].ready) {
        selectedIndex = index
        return
      }
    }
    selectedIndex = -1
  }

  function activateSelection() {
    if (selectedIndex >= 0 && selectedIndex < navigationRows.length)
      navigationRows[selectedIndex].activate(Qt.LeftButton)
  }

  function refresh() {
    for (var i = 0; i < modeRows.length; i++) {
      var control = modeRows[i].control
      if (control && typeof control.refresh === "function") control.refresh()
    }
  }

  function open() {
    if (bar && typeof bar.requestPopout === "function") bar.requestPopout(controlHub)
    if (bar && typeof bar.refreshIndicators === "function") bar.refreshIndicators()
    refresh()
    opened = true
    selectedIndex = -1
    moveSelection(1)
    Qt.callLater(function() { if (controlHub.opened) content.forceActiveFocus() })
  }
  function close() { opened = false; selectedIndex = -1 }
  function toggle() { if (opened) close(); else open() }

  Component.onDestruction: if (bar && bar.activePopout === controlHub) bar.releasePopout(controlHub)

  IpcHandler {
    target: "spectra.hub"
    enabled: !!controlHub.bar && controlHub.bar.findPanelWidget("spectra.emblem") === controlHub
    function open(): void { controlHub.open() }
    function close(): void { controlHub.close() }
    function toggle(): void { controlHub.toggle() }
  }

  OmarchyControls {
    id: agentsControl
    anchors.fill: parent
    bar: controlHub.bar
    indicatorHost: controlHub
    modeId: "Agents"
    hideButton: true
  }

  WidgetButton {
    anchors.fill: parent
    bar: controlHub.bar
    labelVisible: false
    hasVisualContent: true
    tooltipText: "Arch Control Hub"
    onPressed: controlHub.toggle()
  }

  // Privacy status occupies an overlay, never a slot in the bar's main row.
  Row {
    x: controlHub.width + 2
    anchors.verticalCenter: parent.verticalCenter
    BarIconButton {
      visible: controlHub.recordingActive
      bar: controlHub.bar
      text: recording.control ? recording.control.activeText : ""
      slotSize: 18
      opticalSize: 13
      active: true
      tooltipText: "Recording in progress — click to stop"
      onPressed: recording.activate(Qt.LeftButton)
    }
    BarIconButton {
      visible: controlHub.microphoneActive
      bar: controlHub.bar
      text: "󰍬"
      slotSize: 18
      opticalSize: 13
      active: true
      tooltipText: "Microphone in use — open controls"
      onPressed: controlHub.open()
    }
  }

  KeyboardPanel {
    id: popup
    anchorItem: controlHub.anchorItem
    bar: controlHub.bar
    owner: controlHub
    open: controlHub.opened
    centerOnBar: false
    margin: 2
    gap: 2
    padding: 10
    borderSpec: Border.flat(Theme.border, 1)
    contentWidth: 300
    contentHeight: fittedContentHeight(column.implicitHeight)
    focusTarget: content

    PanelKeyCatcher {
      id: content
      anchors.fill: parent
      opacity: controlHub.opened ? 1 : 0
      focus: controlHub.opened
      onMoveRequested: function(dx, dy) { if (dy !== 0) controlHub.moveSelection(dy) }
      onTabRequested: function(direction) { controlHub.moveSelection(direction) }
      onActivateRequested: controlHub.activateSelection()
      onCloseRequested: controlHub.close()
      transform: Translate {
        y: controlHub.opened ? 0 : -6
        Behavior on y { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
      }
      Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

      Column {
        id: column
        width: parent.width
        spacing: 2
        Item {
          width: parent.width
          height: 32
          Text {
            anchors.left: parent.left
            anchors.leftMargin: 7
            anchors.verticalCenter: parent.verticalCenter
            text: "ARCH CONTROL HUB"
            color: Theme.accent
            font.family: controlHub.bar.fontFamily
            font.pixelSize: 11
            font.letterSpacing: 0.5
          }
          Item {
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            width: 24
            height: 24
            Text { anchors.centerIn: parent; text: "×"; color: Theme.muted; font.pixelSize: 18 }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: controlHub.close() }
          }
        }

        HubControlRow {
          id: microphone
          hub: controlHub
          width: parent.width
          modeId: "Microphone"
          caption: "Microphone"
          unavailableReason: "No microphone input is available"
        }
        HubControlRow {
          id: awake
          hub: controlHub
          width: parent.width
          modeId: "StayAwake"
          caption: "Stay Awake"
        }
        HubControlRow {
          id: dnd
          hub: controlHub
          width: parent.width
          modeId: "Dnd"
          caption: "Do Not Disturb"
        }
        HubControlRow {
          id: nightlight
          hub: controlHub
          width: parent.width
          modeId: "NightLight"
          caption: "Night Light"
        }
        HubControlRow {
          id: recording
          hub: controlHub
          width: parent.width
          modeId: "ScreenRecording"
          caption: "Screen Recording"
          available: controlHub.recorderAvailable
          unavailableReason: "gpu-screen-recorder is not installed"
          closeOnActivate: true
        }
        HubControlRow {
          id: dictation
          hub: controlHub
          width: parent.width
          modeId: "Dictation"
          caption: "Dictation"
          available: controlHub.voxtypeAvailable
          unavailableReason: "Voxtype is not installed"
          closeOnActivate: true
        }
        HubControlRow {
          id: reminder
          hub: controlHub
          width: parent.width
          modeId: "Reminder"
          caption: "Reminders"
          closeOnActivate: true
        }

        HubControlRow {
          id: aiUsage
          hub: controlHub
          width: parent.width
          modeId: "Agents"
          caption: "AI Usage"
          externalControl: agentsControl.control
          iconText: "󱚣"
          unavailableReason: "AI usage panel is unavailable"
          closeOnActivate: true
        }

        Rectangle { width: parent.width; height: 1; color: Theme.badgeRidge }
        Item {
          id: systemMenu
          width: parent.width
          height: 32
          readonly property bool ready: true
          readonly property bool selected: controlHub.opened
            && controlHub.navigationRows[controlHub.selectedIndex] === systemMenu
          function activate(button) {
            controlHub.close()
            controlHub.bar.run("omarchy-menu summon system")
          }
          Rectangle {
            anchors.fill: parent
            color: systemMenu.selected ? Theme.badge : "transparent"
            border.width: systemMenu.selected ? 1 : 0
            border.color: Theme.border
            radius: 3
          }
          WidgetButton {
            anchors.fill: parent
            bar: controlHub.bar
            text: "󰤄  System menu"
            fontSize: 11
            tooltipText: "Lock, suspend, restart, or shut down"
            onPressed: systemMenu.activate(Qt.LeftButton)
          }
        }
        Text {
          width: parent.width
          height: 22
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          text: "↑/↓ Navigate · Enter Select · Esc Close"
          color: Theme.muted
          font.family: controlHub.bar.fontFamily
          font.pixelSize: 10
        }
      }
    }
  }
}
