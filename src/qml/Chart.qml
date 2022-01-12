import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3
import "qrc:/qml/components" 1.0 as C
import Theme 1.0

Item {
    Flickable {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: labelsFlow.top
        anchors.topMargin: Theme.em(1)
        anchors.bottomMargin: Theme.em(2)
        contentWidth: width
        contentHeight: chartView.height
        clip: true
        onHeightChanged: chartView.height = Math.max(height, 500)

        ScrollBar.vertical: ScrollBar {}

        ChartView {
            id: chartView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            legend.visible: false
            antialiasing: true
            backgroundColor: Theme.backgroundColor

            HorizontalBarSeries {
                id: horizontalBarSeries
                labelsVisible: true
                labelsPosition: AbstractBarSeries.LabelsInsideEnd
                visible: barCategoryAxis.categories.length > 0

                axisX: ValueAxis {
                    id: valueAxis
                    labelFormat: "%d"
                    labelsColor: Theme.textColor
                    gridLineColor: Theme.viewBackgroundColor
                }

                axisY: BarCategoryAxis {
                    id: barCategoryAxis
                    labelsColor: Theme.textColor
                    gridLineColor: Theme.viewBackgroundColor
                }

                BarSet {
                    id: barSet
                    borderColor: color
                    color: Theme.altAccentColor
                    labelColor: Theme.foregroundColor
                }
            }

            Label {
                id: label
                anchors.centerIn: parent
                font: Theme.font
                color: Theme.textColor
                text: "Откройте текстовый файл"
                visible: !horizontalBarSeries.visible
            }
        }
    }

    Flow {
        id: labelsFlow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: progressBar.top
        anchors.margins: Theme.em(1)
        spacing: Theme.em(2)

        Label {
            id: allWordsCountLabel
            font: Theme.smallFont
            color: Theme.textColor
        }

        Label {
            id: uniqueWordsCountLabel
            font: Theme.smallFont
            color: Theme.textColor
        }

        Label {
            id: elapsedTimeLabel
            font: Theme.smallFont
            color: Theme.textColor
        }
    }

    C.ProgressBar {
        id: progressBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.em(1)
        visible: value > 0
    }

    Connections {
        target: Core

        function onProgressChanged(data) {
            if (data.words) {
                barCategoryAxis.categories = data.words

                var t = []
                var maxCount = 0
                for (var i = 0; i < data.counts.length; i++) {
                    t.push(data.counts[i])
                    if (data.counts[i] > maxCount)
                        maxCount = data.counts[i]
                }
                barSet.values = t
                delete t

                valueAxis.max = maxCount

                allWordsCountLabel.text = "Всего слов: " + data.allWordsCount
                uniqueWordsCountLabel.text = "Уникальных слов: " + data.uniqueWordsCount
            }

            elapsedTimeLabel.text = "Прошло времени: " + data.elapsedTime
            progressBar.value = data.progress
        }
    }
}
