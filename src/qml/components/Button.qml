import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12 as QC
import QtQuick.Controls.Material 2.12
import Theme 1.0

Item {
    id: control

    property alias text: button.text
    property bool flat: false
    property bool hovered: button.hovered
    property alias icon: button.icon
    property alias action: button.action
    property alias display: button.display
    property bool outline: false
    property int borderWidth: 0

    signal entered()
    signal exited()
    signal clicked()

    QC.Button {
        id: button
        anchors.fill: parent
        anchors.topMargin: -6
        anchors.bottomMargin: -6
        flat: control.flat || control.outline
        font: Theme.font

        Binding {
            target: button
            property: "background.color"
            value: colorItem.backgroundColor
        }

        Binding {
            target: button
            property: "contentItem.color"
            value: colorItem.foregroundColor
        }

        Binding {
            target: button
            property: "background.radius"
            value: Theme.radius
        }

        Binding {
            target: button
            property: "font.bold"
            value: true
        }

        Binding {
            target: button
            property: "font.capitalization"
            value: Font.MixedCase
        }

        Item {
            id: colorItem
            property color backgroundColor: !control.outline
                                            ? (control.enabled ? Theme.accentColor : Theme.altAccentColor)
                                            : (Theme.backgroundColor)
            property color foregroundColor: !control.outline
                                            ? (control.enabled ? Theme.foregroundColor : Theme.altTextColor)
                                            : (control.enabled ? Theme.accentColor : Theme.altTextColor)
        }

        MouseArea {
            anchors.fill: parent
            anchors.topMargin: 6
            anchors.bottomMargin: 6
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: control.entered()
            onExited: control.exited()
        }

        onClicked: control.clicked()
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: control.borderWidth
        border.color: !control.outline
                      ? Theme.altTextColor
                      : (control.enabled ? Theme.accentColor : Theme.altTextColor)
        radius: Theme.radius
        visible: border.width > 0
    }
}
