/**
 * @file Utils.js
 * @class Utils
 * @author Benoît MOUFLIN
 * @date 2025-04-18
 *
 * @brief The Utils JS library
 *
 * @module Photo Organizer
 * @note Stores several tool functions for QML.
 *
 * Copyright (c) 2025 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
.pragma library

/**
 * @brief Returns true if the color is dark and should have light content on top
 * @source Inspired from Colours, (c) 2013 by Benjamin Gordon
 */
function blackOrWhiteContrastingColor(p_backgroundColor) {
    var temp = Qt.darker(p_backgroundColor, 1);    // Force conversion to color QML type object
    var a = 1 - ( 0.299 * temp.r + 0.587 * temp.g + 0.114 * temp.b);
    return a < 0.5 ? "black" : "white";
}

function opositeblackOrWhiteColor(p_color) {
    if (Qt.colorEqual(p_color, "black")) {
        return "white";
    } else if (Qt.colorEqual(p_color, "white")) {
        return "black";
    } else {
        return p_color;
    }
}
