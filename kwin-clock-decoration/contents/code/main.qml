import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kwin.decoration 1.0 as KDeco

KDeco.Decoration {
    id: deco

    // Basic tunables
    property string timeFormat: "ddd dd.MM.yyyy HH:mm"
    property color activeBgColor: "#2d2f3a"
    property color inactiveBgColor: "#31343f"
    property color activeFgColor: "#f5f5f5"
    property color inactiveFgColor: "#c1c7d0"
    property color borderColor: "#4b5263"
    property int padding: 8

    property bool isActive: deco.client && deco.client.active
    property string timeText: Qt.formatDateTime(new Date(), timeFormat)

    function refreshClock() {
        timeText = Qt.formatDateTime(new Date(), timeFormat)
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: deco.refreshClock()
    }

    Component.onCompleted: deco.refreshClock()

    contentItem: Rectangle {
        id: frame
        anchors.fill: parent
        color: deco.isActive ? deco.activeBgColor : deco.inactiveBgColor
        border.color: deco.borderColor
        border.width: 1
        radius: 6

        RowLayout {
            id: layout
            anchors.fill: parent
            anchors.margins: deco.padding
            spacing: deco.padding

            // Drag area for moving/maximizing/menu
            Item {
                id: dragArea
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: Math.max(clockLabel.implicitHeight, buttonRow.implicitHeight)

                MouseArea {
                    id: dragHandler
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    property bool moveStarted: false

                    onPressed: {
                        moveStarted = false
                        if (mouse.button === Qt.RightButton) {
                            deco.requestShowWindowMenu()
                        }
                    }

                    onDoubleClicked: {
                        if (mouse.button === Qt.LeftButton) {
                            deco.requestToggleMaximization()
                        }
                    }

                    onPositionChanged: {
                        if (!moveStarted && (mouse.buttons & Qt.LeftButton)) {
                            moveStarted = true
                            if (deco.client) {
                                deco.client.startInteractiveMove()
                            }
                        }
                    }

                    onReleased: moveStarted = false
                }
            }

            // Clock text
            Text {
                id: clockLabel
                text: deco.timeText
                color: deco.isActive ? deco.activeFgColor : deco.inactiveFgColor
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
                font.bold: true
                Layout.alignment: Qt.AlignVCenter
            }

            // Buttons
            Row {
                id: buttonRow
                spacing: 4
                Layout.alignment: Qt.AlignVCenter

                KDeco.DecorationButton {
                    type: KDeco.DecorationButtonType.Minimize
                    decoration: deco
                }
                KDeco.DecorationButton {
                    type: KDeco.DecorationButtonType.Maximize
                    decoration: deco
                }
                KDeco.DecorationButton {
                    type: KDeco.DecorationButtonType.Close
                    decoration: deco
                }
            }
        }
    }
}
