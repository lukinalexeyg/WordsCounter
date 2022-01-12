import QtQuick 2.12

AbstractTheme {
    backgroundColor: "#ffffff"
    altBackgroundColor: "#ffffff"

    viewBackgroundColor: "#f3f3f3"

    foregroundColor: "#ffffff"
    altForegroundColor: "#ffffff"

    textColor: "#4a4849"
    altTextColor: "#949092"

    accentColor: "#35acec"
//    altAccentColor: "#B7C5CC"
    altAccentColor: Qt.darker(accentColor, 1.1)

    highlightColor: "#e5f3ff"
    altHighlightColor: Qt.darker(highlightColor, 1.1)

    warningColor: "#ff4c4c"
    altWarningColor: "#f9f0f0"

    shadowColor: "#40000000"

    baseSize: 10
    borderWidth: baseSize * 0.1
    radius: 2 + baseSize * 0.2

    smallFont.family: "Roboto"
    smallFont.pointSize: 8

    font.family: "Roboto"
    font.pointSize: 10

    largeFont.family: "Roboto"
    largeFont.pointSize: 12
}
