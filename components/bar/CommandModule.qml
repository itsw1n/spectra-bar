import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

WidgetButton {
    id: customRoot

    required property var barRoot
    required property var entry
    readonly property string moduleName: barRoot.entryId(entry)
    readonly property var settings: barRoot.entrySettings(entry)
    property string outputText: ""
    property string outputTooltip: ""
    property bool outputActive: false

    function setting(name, fallback) {
        var value = settings ? settings[name] : undefined;
        return value === undefined || value === null ? fallback : value;
    }

    function update(raw) {
        var data = Util.parseModuleJson(raw);
        var klass = data.class || data.alt || "";
        outputText = data.text || String(raw || "").trim();
        outputTooltip = data.tooltip || String(setting("tooltip", ""));
        outputActive = klass === "active" || (Array.isArray(klass) && klass.indexOf("active") !== -1);
    }

    bar: barRoot
    text: outputText || String(setting("text", ""))
    tooltipText: outputTooltip || String(setting("tooltip", ""))
    active: outputActive
    keepSpace: setting("keepSpace", false) === true
    horizontalMargin: Number(setting("horizontalMargin", 7.5))
    verticalPadding: Number(setting("verticalPadding", 6))
    fontSize: Number(setting("fontSize", 12))
    onPressed: function(button) {
        var command = "";
        if (button === Qt.RightButton)
            command = String(setting("onRightClick", ""));
        else if (button === Qt.MiddleButton)
            command = String(setting("onMiddleClick", ""));
        else
            command = String(setting("onClick", ""));
        if (command)
            barRoot.run(command);

    }

    Process {
        id: customProc

        command: ["bash", "-lc", String(customRoot.setting("exec", ""))]

        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: customRoot.update(text)
        }

    }

    Timer {
        interval: Math.max(1, Number(customRoot.setting("interval", 5))) * 1000
        running: String(customRoot.setting("exec", "")) !== ""
        repeat: true
        triggeredOnStart: true
        onTriggered: barRoot.runProcess(customProc)
    }

}
