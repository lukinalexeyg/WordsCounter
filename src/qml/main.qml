import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import "qrc:/qml/components" 1.0 as C
import Theme 1.0

ApplicationWindow {
    id: mainWindow
    width: 960
    height: 640
    minimumWidth: 300
    minimumHeight: 300
    color: Theme.backgroundColor
    visible: true

    RowLayout {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Theme.em(1)
        height: button.height
        spacing: Theme.em(1)

        C.Button {
            id: button
            width: Theme.em(15)
            height: Theme.em(4)
            text: Core.busy ? "Прервать" : "Открыть файл"
            outline: true
            onClicked: Core.busy ? Core.stop() : fileDialog.visible = true
        }

        Label {
            id: filePathLabel
            Layout.fillWidth: true
            font: Theme.smallFont
            color: Theme.textColor
        }

        C.Button {
            width: Theme.em(14)
            height: Theme.em(4)
            text: "О программе"
            outline: true
            onClicked: {
                messageDialog.contentWidth = Theme.em(36)
                messageDialog.contentHeight = Theme.em(26)
                messageDialog.titleText = "О программе"
                messageDialog.titleColor = Theme.accentColor
                messageDialog.messageText
                        = Qt.application.name
                        + " " + Qt.application.version
                        + "\n\nПодсчет количества слов в текстовых файлах"
                        + "\n\nОснован на Qt " + qtVersion
                        + "\n\nАвтор: " + Qt.application.organization
                messageDialog.messageHorizontalAlignment = Text.AlignHCenter
                messageDialog.visible = true
            }
        }

        C.Switch {
            onOnChanged: Theme.current = !this.on ? Theme.light : Theme.dark
        }
    }

    FileDialog {
        id: fileDialog
        title: "Выберите текстовый файл"
        folder: shortcuts.home
        onAccepted: Core.start(fileDialog.fileUrls)
    }

    Chart {
        id: chart
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
    }

    C.BackRectangle {
        visible: messageDialog.visible
    }

    C.MessageDialog {
        id: messageDialog
    }

    Connections {
        target: Core

        function onFinished(ok) {
            messageDialog.contentWidth = Theme.em(24)
            messageDialog.contentHeight = Theme.em(20)
            messageDialog.titleText = Qt.application.name
            messageDialog.titleColor = ok ? Theme.accentColor : Theme.warningColor
            messageDialog.messageText = ok ? "Подсчет завершен!" : "Подсчет был прерван!"
            messageDialog.messageHorizontalAlignment = Text.AlignHCenter
            messageDialog.visible = true
        }

        function onFileOpenFinished(path, error) {
            if (error === "")
                filePathLabel.text = "Текущий файл: " + path
            else {
                messageDialog.contentWidth = Theme.em(50)
                messageDialog.contentHeight = Theme.em(24)
                messageDialog.titleText = Qt.application.name
                messageDialog.titleColor = Theme.warningColor
                messageDialog.messageText = "Ошибка открытия файла " + path + "\n\n" + error
                messageDialog.messageHorizontalAlignment = Text.AlignLeft
                messageDialog.visible = true
            }
        }
    }
}
