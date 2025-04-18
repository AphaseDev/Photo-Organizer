/**
 * @file POScrollBar.qml
 * @class POScrollBar
 * @author Benoît MOUFLIN
 * @date 2025-04-18
 *
 * @brief The POScrollBar element
 *
 * @module Photo Organizer
 * @note Custom ScrollBar design for Photo Organizer.
 *
 * Copyright (c) 2025 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
import QtQuick
import QtQuick.Controls

ScrollBar {
    id: mainScrollBar

    property real  opacityHovered:      0.7
    property real  opacityIdle:         0.5
    property color tintColorHighlighted: Material.theme == Material.Dark ? Qt.rgba(0.64, 0.64, 0.64, 1.00) : Qt.rgba(0.60, 0.60, 0.60, 1.00)
    property color tintColorHovered:    Qt.hsva(tintColorHighlighted.hsvHue, tintColorHighlighted.hsvSaturation, tintColorHighlighted.hsvValue, opacityHovered)
    property color tintColorIdle:       Qt.hsva(tintColorHighlighted.hsvHue, tintColorHighlighted.hsvSaturation, tintColorHighlighted.hsvValue, opacityIdle)
    readonly property bool isVisible:   size < 1.0

    anchors.rightMargin:                orientation == Qt.Vertical ? 2 : 0
    anchors.bottomMargin:               orientation == Qt.Horizontal ? 2 : 0
    position:                           0.2
    snapMode:                           ScrollBar.SnapOnRelease
    policy:                             ScrollBar.AsNeeded
    hoverEnabled:                       true

    width:                              contentItemIndicator.implicitWidth
    height:                             contentItemIndicator.implicitHeight
    minimumSize:                        0.04 // between 0 and 1
    padding:                            0

    contentItem: Rectangle {
        id: contentItemIndicator

        implicitWidth:      6.0
        implicitHeight:     6.0
        radius:             width * 0.5
        opacity:            mainScrollBar.isVisible ? 0.5 : 0.0
        color:              mainScrollBar.pressed ? mainScrollBar.tintColorHighlighted : (mainScrollBar.hovered ? mainScrollBar.tintColorHovered : mainScrollBar.tintColorIdle)
    }
}
