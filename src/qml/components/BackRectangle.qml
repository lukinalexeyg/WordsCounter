import QtQuick 2.12
import Theme 1.0

Rectangle {
    id: control
    anchors.fill: parent
    color: Theme.shadowColor
    visible: false

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: false
    }

    Behavior on opacity { NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Theme.animationEasingType
        }
    }

    onVisibleChanged: opacity = visible ? 1 : 0
}
