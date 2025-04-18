/**
 * @file POButton.qml
 * @class POButton
 * @author Benoît MOUFLIN
 * @date 2025-04-17
 *
 * @brief The POButton element
 *
 * @module Photo Organizer
 * @note Custom Button component for Photo Organizer.
 *
 * Copyright (c) 2025 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
import QtQuick
import QtQuick.Controls

import "../Utils.js" as Utils

Button {
    id: mainButton

    readonly property color labelColor: Utils.blackOrWhiteContrastingColor(Material.background)

    Material.foreground:    down || hovered ? Qt.rgba(labelColor.r, labelColor.g, labelColor.b, 0.5) : labelColor       // Utils.opositeblackOrWhiteColor(labelColor)
    Material.background:    down ? Qt.rgba(Material.accent.r, Material.accent.g-0.08, Material.accent.b-0.38, Material.accent.a)    // Similar to Material.color(Material.Yellow, Material.ShadeA700)
                                    : Material.accent
    Material.roundedScale:  Material.LargeScale

    font.family:            "Roboto"

    property bool animateHover: false
    hoverEnabled:               true
    onHoveredChanged: {
        if (animateHover) {
            if (hovered) {
                scale *= 1.2;
            } else {
                scale /= 1.2;
            }
        }
    }

    Behavior on scale { enabled: animateHover; NumberAnimation { duration: 250; easing { type: Easing.OutBack } } }
}

