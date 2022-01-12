pragma Singleton

import QtQuick 2.12
//import QtQuick.Controls.Material 2.12

AbstractTheme {
    property AbstractTheme current: light
    property AbstractTheme light: LightTheme {}
    property AbstractTheme dark: DarkTheme {}

    backgroundColor: current.backgroundColor
    altBackgroundColor: current.altBackgroundColor

    viewBackgroundColor: current.viewBackgroundColor

    foregroundColor: current.foregroundColor
    altForegroundColor: current.altForegroundColor

    altTextColor: current.altTextColor
    textColor: current.textColor

    accentColor: current.accentColor
    altAccentColor: current.altAccentColor

    highlightColor: current.highlightColor
    altHighlightColor: current.altHighlightColor

    warningColor: current.warningColor
    altWarningColor: current.altWarningColor

    shadowColor: current.shadowColor

    baseSize: current.baseSize
    borderWidth: current.borderWidth
    radius: current.radius

    smallFont: current.smallFont
    font: current.font
    largeFont: current.largeFont

    property int animationDuration: 400
    property int animationEasingType: Easing.InOutQuad

    Behavior on backgroundColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on altBackgroundColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on viewBackgroundColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on foregroundColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on altForegroundColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on textColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on altTextColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on accentColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on altAccentColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on highlightColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on altHighlightColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on warningColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on altWarningColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on shadowColor { ColorAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on baseSize { NumberAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on borderWidth { NumberAnimation { duration: animationDuration; easing.type: animationEasingType } }
    Behavior on radius { NumberAnimation { duration: animationDuration; easing.type: animationEasingType } }

    function em(value) {
        return baseSize * value;
    }

    function isLight() {
        return current == light;
    }
}
