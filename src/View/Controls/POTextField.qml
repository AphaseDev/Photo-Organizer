/**
 * @file POTextField.qml
 * @class POTextField
 * @author Benoît MOUFLIN
 * @date 2025-04-03
 *
 * @brief The POTextField element
 *
 * @module Photo Organizer
 * @note Custom TextField component for Photo Organizer.
 *
 * Copyright (c) 2025 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
import QtQuick
import QtQuick.Controls

TextField {
    id: mainTextField

    width:          Math.min(Math.max(parent.width * 0.3, contentWidth + leftPadding + rightPadding), parent.width)
    topPadding:     0
    bottomPadding:  0
    font.family:    "Roboto"
    font.pixelSize: 15

    property var onAcceptedCallback: function() {
        /* To override */
        console.debug("# onAccepted:", mainTextField.text);
    }

    onAccepted: {
        onAcceptedCallback();

        focus = false;
    }
}
