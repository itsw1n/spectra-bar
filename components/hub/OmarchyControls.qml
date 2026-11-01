import QtQuick
import Quickshell
import Quickshell.Io

// All assumptions about native Omarchy control paths and button APIs live here.
Item {
    id: adapter

    required property var bar
    required property var indicatorHost
    required property string modeId
    property var externalControl: null
    property bool hideButton: false
    property bool loadNative: true
    property string omarchyPath: Quickshell.env("OMARCHY_PATH")
    property bool voxtypeAvailable: false
    property bool recorderAvailable: false
    readonly property var control: externalControl || nativeLoader.item
    readonly property var button: findButton(control)
    readonly property bool ready: button !== null && (modeId !== "Microphone" || (control && control.source !== null))
    readonly property bool active: control ? (modeId === "Agents" ? control.opened : (modeId === "Microphone" ? control.inUse : control.active)) : false
    readonly property string hint: modeId === "Agents" ? "AI usage, rate limits, and token history" : (button ? button.tooltipText : "")
    readonly property string stateText: {
        if (!ready)
            return "Unavailable";

        if (modeId === "Agents")
            return control.providers.length > 0 ? "View usage" : "No usage yet";

        if (modeId === "Microphone")
            return control.muted ? "Muted" : (control.inUse ? "In use" : "Ready");

        if (modeId === "Reminder")
            return control.reminderCount > 0 ? String(control.reminderCount) : "None";

        if (modeId === "Dictation")
            return control.state === "idle" ? "Ready" : control.state;

        return active ? "On" : "Off";
    }

    function press(mouseButton) {
        if (ready)
            button.triggerPress(mouseButton);

    }

    function scroll(delta) {
        if (ready && typeof button.wheelMoved === "function")
            button.wheelMoved(delta);

    }

    function findButton(item) {
        if (!item)
            return null;

        if (typeof item.triggerPress === "function")
            return item;

        var children = item.children || [];
        for (var i = 0; i < children.length; i++) {
            var result = findButton(children[i]);
            if (result)
                return result;

        }
        return null;
    }

    function inject() {
        if (!control)
            return ;

        control.bar = bar;
        if ("indicatorHost" in control)
            control.indicatorHost = indicatorHost;

        if ("indicatorBlock" in control)
            control.indicatorBlock = "single";

        if (modeId === "Agents")
            control.ipcTarget = "spectra.hub.agents";

        if (hideButton && button)
            button.visible = false;

    }

    onBarChanged: inject()
    onControlChanged: inject()
    onButtonChanged: inject()

    Loader {
        id: nativeLoader

        anchors.fill: parent
        active: adapter.loadNative && adapter.externalControl === null
        source: {
            var base = "file://" + adapter.omarchyPath + "/shell/plugins/";
            if (adapter.modeId === "Agents")
                return base + "agents/Panel.qml";

            if (adapter.modeId === "Microphone")
                return base + "bar/widgets/Microphone.qml";

            return base + "bar/indicators/" + adapter.modeId + ".qml";
        }
        onLoaded: adapter.inject()
    }

    // Probe optional tools once in the hub's persistent AI adapter.
    Process {
        running: adapter.modeId === "Agents" && adapter.hideButton
        command: ["bash", "-c", "for tool in voxtype gpu-screen-recorder; do command -v \"$tool\" >/dev/null && printf '%s\\n' \"$tool\"; done"]

        stdout: SplitParser {
            onRead: function(tool) {
                if (tool.trim() === "voxtype")
                    adapter.voxtypeAvailable = true;

                if (tool.trim() === "gpu-screen-recorder")
                    adapter.recorderAvailable = true;

            }
        }

    }

}
