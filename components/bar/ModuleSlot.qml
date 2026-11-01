import QtQuick
import Quickshell.Hyprland
import qs.Commons
import qs.Commons as Commons
import qs.Ui
import "../.."
import ".."
import "../hub"

Item {
    id: slot

    required property var barRoot
    required property var entry
    property string region: ""
    property real screenWidth: 1920
    readonly property string moduleName: barRoot.entryId(entry)
    readonly property var moduleSettings: barRoot.entrySettings(entry)
    readonly property string customType: barRoot.customModuleType(entry)
    readonly property bool controlHubModule: moduleName === "spectra.emblem"
    readonly property var registryMetadata: barRoot.barWidgetRegistry.metadataFor(barRoot.canonicalWidgetId(moduleName))
    readonly property bool firstParty: registryMetadata && registryMetadata.firstParty === true
    readonly property string pluginApiId: registered ? barRoot.canonicalWidgetId(moduleName) : "bar-entry:" + moduleName
    // Re-evaluate when the registry mutates (Component reference changes,
    // plugin enabled/disabled, etc.). Reading the `widgets` property creates
    // the binding dependency — the wrapped function call alone wouldn't.
    readonly property var registryComponent: {
        var w = barRoot.barWidgetRegistry.widgets;
        if (customType)
            return null;

        var registryName = barRoot.canonicalWidgetId(moduleName);
        return w[registryName] ? w[registryName].component : null;
    }
    readonly property bool qmlCustom: customType === "qml"
    readonly property bool commandCustom: customType === "command"
    readonly property bool imageCustom: customType === "image"
    readonly property bool registered: registryComponent !== null
    readonly property var activeItem: {
        if (slot.controlHubModule)
            return controlHubLoader.item;

        if (registered)
            return registryLoader.item;

        if (qmlCustom)
            return qmlLoader.item;

        return componentLoader.item;
    }
    readonly property bool hovered: moduleHover.hovered
    readonly property bool dragSource: barRoot.barDragSource === slot
    readonly property bool panelOpen: barRoot.activePopout === slot.activeItem
    readonly property bool desktopWorkspace: slot.moduleName === "omarchy.active-window" && Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.toplevels.values.length === 0
    // Modules bigger than the mark they want (a text label in a padded slot,
    // a multi-line stack on a vertical bar) can say how long the open-panel
    // dot should be along the bar, so it tracks what the module paints
    // instead of a fraction of whatever slot it happens to fill.
    readonly property real panelIndicatorExtent: {
        var key = barRoot.vertical ? "openPanelIndicatorHeight" : "openPanelIndicatorWidth";
        var hint = activeItem && key in activeItem ? activeItem[key] : undefined;
        if (hint !== undefined && hint !== null && hint > 0)
            return Math.round(hint);

        return Math.max(Style.space(10), Math.round((barRoot.vertical ? slot.height : slot.width) * 0.55));
    }

    // Optional Waybar-style overrides on a layout entry. An empty value keeps
    // the native widget behaviour; a command replaces it for that input only.
    function settingAction(name) {
        var value = moduleSettings ? moduleSettings[name] : undefined;
        return value === undefined || value === null ? "" : String(value);
    }

    function entryAction(button) {
        if (button === Qt.RightButton)
            return settingAction("onRightClick");

        if (button === Qt.MiddleButton)
            return settingAction("onMiddleClick");

        return settingAction("onClick");
    }

    function scrollAction(up) {
        return settingAction(up ? "onScrollUp" : "onScrollDown");
    }

    function injectProps() {
        var target = activeItem;
        if (!target)
            return ;

        if (slot.controlHubModule) {
            target.anchorItem = slot;
            target.bar = barRoot;
            return ;
        }
        if ("bar" in target)
            target.bar = firstParty ? barRoot : barRoot.pluginBarApiFor(pluginApiId, moduleName, registered);

        if ("moduleName" in target) {
            try {
                target.moduleName = moduleName;
            } catch (error) {
            } // built-in widgets declare a readonly name
        }
        if ("settings" in target) {
            try {
                target.settings = moduleSettings;
            } catch (error) {
            } // custom modules derive readonly settings from entry
        }
    }

    implicitWidth: {
        if (barRoot.vertical)
            return activeItem && activeItem.visible ? barRoot.barSize : 0;

        if (moduleName === "spectra.emblem")
            return Theme.badgeWidth(screenWidth);

        if (moduleName === "omarchy.active-window")
            return Math.max(150, Theme.sectionWidth(screenWidth, "left") - 160);

        if (moduleName === "omarchy.media")
            return Math.max(150, Theme.sectionWidth(screenWidth, "right") - 175);

        if (moduleName === "omarchy.system-update")
            return Style.bar.statusSlot + 18;

        return activeItem && activeItem.visible ? activeItem.implicitWidth : 0;
    }
    implicitHeight: moduleName === "spectra.emblem" && !barRoot.vertical ? Theme.badgeHeight : (activeItem && activeItem.visible ? activeItem.implicitHeight : (moduleName === "omarchy.media" || moduleName === "omarchy.active-window" || moduleName === "omarchy.system-update" ? barRoot.barSize : 0))
    width: implicitWidth
    height: implicitHeight
    z: modulePointer.dragging ? 100 : (moduleName === "spectra.emblem" ? 5 : 0)
    Component.onCompleted: barRoot.registerModuleSlot(slot)
    Component.onDestruction: {
        if (barRoot.barDragSource === slot)
            barRoot.clearBarDrag();

        barRoot.unregisterModuleSlot(slot);
    }
    onActiveItemChanged: Qt.callLater(injectProps)
    onModuleSettingsChanged: injectProps()

    Component {
        id: emptyModuleComponent

        Item {
            implicitWidth: 0
            implicitHeight: 0
            visible: false
        }

    }

    HoverHandler {
        id: moduleHover
    }

    PrismPanel {
        visible: !barRoot.vertical && slot.moduleName === "omarchy.active-window"
        x: Theme.segmentHeight / 2
        y: -(Theme.segmentHeight - slot.height) / 2
        width: slot.width + 6 - Theme.segmentHeight / 2
        height: Theme.segmentHeight
        fillColor: Theme.focusSegment
        leftSkew: -height
        rightSkew: -height
        embedded: true
        divideLeft: true
        divideRight: false
        z: -1
    }

    PrismPanel {
        visible: !barRoot.vertical && slot.moduleName === "omarchy.media"
        x: 0
        y: -(Theme.segmentHeight - slot.height) / 2
        width: slot.width - Theme.segmentHeight / 2
        height: Theme.segmentHeight
        fillColor: Theme.focusSegment
        leftSkew: height
        rightSkew: height
        embedded: true
        z: -1
    }

    ArchBadge {
        visible: !barRoot.vertical && slot.moduleName === "spectra.emblem"
        anchors.fill: parent
        z: -1
    }

    Text {
        visible: !barRoot.vertical && slot.moduleName === "omarchy.active-window" && (!slot.activeItem || !slot.activeItem.visible)
        anchors.centerIn: parent
        text: "Desktop"
        color: Theme.muted
        font.family: barRoot.fontFamily
        font.pixelSize: 11
        z: 1
    }

    Text {
        visible: !barRoot.vertical && slot.moduleName === "omarchy.active-window" && slot.activeItem && slot.activeItem.title
        anchors.centerIn: parent
        width: Math.max(0, parent.width - 24)
        text: slot.activeItem && slot.activeItem.title ? slot.activeItem.title : ""
        color: barRoot.barForeground
        font.family: barRoot.fontFamily
        font.pixelSize: 11
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        z: 1
    }

    Text {
        visible: !barRoot.vertical && slot.moduleName === "omarchy.media" && (!slot.activeItem || !slot.activeItem.visible)
        anchors.centerIn: parent
        text: "󰐊  No media"
        color: Theme.muted
        font.family: barRoot.fontFamily
        font.pixelSize: 11
    }

    Text {
        visible: !barRoot.vertical && slot.moduleName === "omarchy.system-update"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 2
        text: "\uf019"
        color: barRoot.barForeground
        font.family: barRoot.fontFamily
        font.pixelSize: 14
        z: 1
    }

    Text {
        visible: !barRoot.vertical && slot.moduleName === "omarchy.system-update"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 2
        text: "|"
        color: Theme.muted
        font.family: barRoot.fontFamily
        font.pixelSize: 11
        z: 1
    }

    BorderSurface {
        visible: slot.dragSource
        anchors.fill: parent
        anchors.margins: Style.space(1)
        color: barRoot.transparent ? "transparent" : barRoot.background
        borderSpec: Border.flat(barRoot.barForeground, 1)
        radius: Math.min(Style.cornerRadius, height / 2)
        opacity: barRoot.transparent ? 0.22 : 0.32
    }

    Loader {
        id: componentLoader

        active: !slot.controlHubModule && !slot.qmlCustom && !slot.imageCustom && !slot.registered
        sourceComponent: slot.commandCustom ? customCommandModuleComponent : emptyModuleComponent
        anchors.fill: parent
        opacity: slot.moduleName === "spectra.emblem" ? 0 : (slot.dragSource ? 0.22 : 1)
        onLoaded: {
            slot.injectProps();
            Qt.callLater(slot.injectProps);
        }
    }

    Loader {
        id: controlHubLoader

        active: slot.controlHubModule
        sourceComponent: controlHubComponent
        anchors.fill: parent
        onLoaded: {
            slot.injectProps();
            Qt.callLater(slot.injectProps);
        }
    }

    Loader {
        id: registryLoader

        active: slot.registered
        sourceComponent: slot.registered ? slot.registryComponent : null
        anchors.fill: parent
        opacity: slot.moduleName === "omarchy.active-window" || slot.moduleName === "omarchy.system-update" || slot.desktopWorkspace ? 0 : (slot.dragSource ? 0.22 : 1)
        onLoaded: {
            slot.injectProps();
            Qt.callLater(slot.injectProps);
        }
    }

    Loader {
        id: qmlLoader

        active: slot.qmlCustom
        source: slot.qmlCustom ? barRoot.customModuleSource(slot.entry) : ""
        anchors.fill: parent
        opacity: slot.dragSource ? 0.22 : 1
        onLoaded: {
            slot.injectProps();
            Qt.callLater(slot.injectProps);
        }
    }

    Rectangle {
        id: openPanelIndicator

        readonly property int inset: Style.space(2)

        visible: opacity > 0
        opacity: slot.panelOpen && !slot.dragSource && !slot.controlHubModule ? 0.9 : 0
        color: Commons.Color.accent
        radius: Math.min(width, height) / 2
        width: barRoot.vertical ? Style.space(2) : slot.panelIndicatorExtent
        height: barRoot.vertical ? slot.panelIndicatorExtent : Style.space(2)
        // The mark sits on the module's inner edge — the one facing the
        // desktop — so it underlines a top bar, overlines a bottom one, and
        // points inward from a left or right one. It reads as pointing at the
        // panel that opens on that side.
        // Snap toward the start of the slot, matching native glyph rendering.
        x: barRoot.vertical ? (barRoot.position === "left" ? parent.width - width - inset : inset) : Math.floor((parent.width - width) / 2)
        y: barRoot.vertical ? Math.floor((parent.height - height) / 2) : (barRoot.position === "top" ? parent.height - height - inset : inset)
        z: 50

        Behavior on opacity {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }

        }

    }

    BarDragController {
        id: modulePointer

        barRoot: slot.barRoot
        slot: parent
        hoverSource: moduleHover
    }

    Component {
        id: customCommandModuleComponent

        CommandModule {
            barRoot: slot.barRoot
            entry: slot.entry
        }

    }

    Component {
        id: controlHubComponent

        ArchControlHub {
            anchorItem: slot
            bar: barRoot
        }

    }

}
