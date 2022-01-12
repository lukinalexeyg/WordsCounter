import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import "qrc:/qml/components" 1.0 as C
import Theme 1.0

Dialog {
    id: control
    anchors.centerIn: parent
    visible: false
    contentWidth: Theme.em(50)
    contentHeight: Theme.em(20)
    Material.background: Theme.backgroundColor

    property alias titleText: titleLabel.text
    property alias titleColor: headerRectangle.color

    property alias messageText: messageLabel.text
    property alias messageHorizontalAlignment: messageLabel.horizontalAlignment
    property alias messageVerticalAlignment: messageLabel.verticalAlignment

    property alias buttonText: button.text
    property alias buttonWidth: button.width
    property alias buttonHeight: button.height

    header: Rectangle {
        height: Theme.em(5)
        color: Theme.backgroundColor

        Label {
            id: titleLabel
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: Theme.font
            color: Theme.textColor
        }

        Rectangle {
            id: headerRectangle
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.em(0.1)
        }
    }

    contentItem: Rectangle {
        color: Theme.backgroundColor

        Label {
            id: messageLabel
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: Theme.font
            color: Theme.textColor
            elide: Text.ElideRight
            wrapMode: Text.Wrap
        }
    }

    footer: Rectangle {
        height: button.height + 2*button.anchors.bottomMargin
        color: Theme.backgroundColor

        C.Button {
            id: button
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.em(1)
            width: Theme.em(10)
            height: Theme.em(4)
            text: "Ok"
            outline: true
            onClicked: control.close()
        }
    }
}
