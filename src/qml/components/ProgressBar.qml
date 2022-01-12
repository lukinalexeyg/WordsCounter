import QtQuick 2.12
import Theme 1.0

Rectangle {
    id: control
    width: Theme.em(10)
    height: Theme.em(2)
    radius: Theme.radius
    border.width: 0
    border.color: Theme.altTextColor
    color: Theme.viewBackgroundColor

    property real value: 0
    property alias textVisible: text.visible
    property int textPrecision: 1
    property string textSuffix: "%"

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: control.width * control.value
        radius: Theme.radius
        color: Theme.altAccentColor
        clip: true
    }

    Text {
        id: text
        anchors.centerIn: control
        font: Theme.smallFont
        color: control.value < 0.5 ? Theme.textColor : Theme.foregroundColor
        text: (control.value * 100).toFixed(control.textPrecision) + internal.textSuffix
    }

    Item {
        id: internal
        property string textSuffix:
            (control.textSuffix != "")
            ? (" " + control.textSuffix)
            : ""
    }
}
