import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "ever.telemetry"

  property string cpu: "--"
  property string memory: "--"
  property string temperature: "--"
  property string load: "--"
  property string disk: "--"

  readonly property string summary: "CPU " + cpu + "%  ·  RAM " + memory + "%  ·  " + temperature + "°C"
  readonly property string details: summary + "\nLoad " + load + "  ·  Disk " + disk + "%\nClick to open btop"

  function refresh() {
    if (!telemetry.running) telemetry.running = true
  }

  function updateTelemetry(output) {
    var fields = String(output).trim().split("|")
    if (fields.length !== 5) return
    cpu = fields[0]
    memory = fields[1]
    temperature = fields[2]
    load = fields[3]
    disk = fields[4]
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: telemetry
    command: [Qt.resolvedUrl("telemetry.sh").toString().replace("file://", "")]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateTelemetry(text)
    }
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.summary
    tooltipText: root.details
    horizontalMargin: 8.5
    onPressed: function(mouseButton) {
      if (mouseButton === Qt.LeftButton && root.bar)
        root.bar.run("omarchy-launch-floating-terminal-with-presentation btop")
      else if (mouseButton === Qt.RightButton)
        root.refresh()
    }
  }
}
