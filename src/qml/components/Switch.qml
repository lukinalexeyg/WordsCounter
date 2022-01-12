import QtQuick 2.12
import Theme 1.0

Item {
    id: control
    width: Theme.em(4.4)
    height: Theme.em(2.4)

    property bool on: false
    property int padding: Theme.em(0.4)
    property int count: 0

    Rectangle {
        id: background
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.accentColor

        MouseArea {
            anchors.fill: parent
            onClicked: toggle()
        }
    }

    Rectangle {
        id: knob
        x: control.padding
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.foregroundColor
        width: background.height - 2*control.padding
        height: width
        radius: Theme.radius - 1

        MouseArea {
            id: knobMouseArea
            anchors.fill: parent
            drag.target: knob
            drag.axis: Drag.XAxis
            drag.minimumX: control.padding
            drag.maximumX: background.width - knob.width - control.padding
            onClicked: toggle()
            onReleased: releaseSwitch()
        }
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: control; on: true }
            PropertyChanges { target: knob; x: knobMouseArea.drag.maximumX }
        },
        State {
            name: "off"
            PropertyChanges { target: control; on: false }
            PropertyChanges { target: knob; x: knobMouseArea.drag.minimumX }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: "x"
            duration: 250
            easing.type: Theme.animationEasingType
        }
    }

    function releaseSwitch() {
        var knobHorCenterX = knob.x + knob.width/2;

        if (control.state == "off" && knobHorCenterX < control.width/2) {
            knob.x = knobMouseArea.drag.minimumX;
            return;
        }

        if (control.state == "on" && knobHorCenterX > control.width/2) {
            knob.x = knobMouseArea.drag.maximumX;
            return;
        }

        toggle();
    }

    function toggle() {
        if (control.state == "on")
            control.state = "off";
        else
            control.state = "on";
    }
}
