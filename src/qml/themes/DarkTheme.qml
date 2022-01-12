import QtQuick 2.12

AbstractTheme {
    backgroundColor: "#24292e"
    altBackgroundColor: Qt.lighter(backgroundColor, 1.7)

    viewBackgroundColor: "#1d2125"

    foregroundColor: "#ffffff"
    altForegroundColor: "#ffffff"

    textColor: "#d1d5da"
    altTextColor: "#959da5"

    accentColor: "#0366d6"
    altAccentColor: "#155399"

    highlightColor: "#05264c"
    altHighlightColor: Qt.darker(highlightColor, 1.3)

    warningColor: "#ff4c4c"
    altWarningColor: "#f9f0f0"

    shadowColor: "#60808080"

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
