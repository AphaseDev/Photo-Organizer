/**
 * @file POButtonGroup.qml
 * @class POButtonGroup
 * @author Benoît MOUFLIN
 * @date 2025-04-18
 *
 * @brief The POButtonGroup element
 *
 * @module Photo Organizer
 * @note This represents a set of POButtons loaded from a model. It is flickable and located on the right
 * or left side of the parent view.
 *
 * Copyright (c) 2025 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Flickable {
    id: flickArea

    contentHeight:                  contentContainer.height
    clip:                           true

    width:                          contentContainer.width
    height:                         Math.min(contentHeight, parent.height)
    anchors.verticalCenter:         parent.verticalCenter

    property int side:              Qt.AlignLeft
    property alias buttonsModel:    buttonsInstantiator.model

    property var onClickedCallback: function(p_index, p_folderPath, p_labelTitle) {
        /* To override */
        console.debug("# onClicked:", p_index, p_folderPath, p_labelTitle);
    }

    Item {
        id: contentContainer

        width: columnLayout.implicitWidth
        height: columnLayout.implicitHeight

        ColumnLayout {
            id: columnLayout

            Repeater {
                id: buttonsInstantiator

                Item {
                    width:              folderButton.width
                    height:             folderButton.height
                    Layout.alignment:   flickArea.side

                    POButton {
                        id: folderButton

                        x:                   (side == Qt.AlignLeft ? -1 : +1) * Material.roundedScale
                        text:                modelData.labelTitle
                        Material.accent:     modelData.buttonColor.valid ? modelData.buttonColor : Material.Yellow
                        animateHover:        true

                        onClicked: {
                            onClickedCallback(index, modelData.folderPath, modelData.labelTitle);
                        }
                        // DropArea {
                        //     anchors.fill: parent
                        //     onEntered: {
                        //         console.log('DROPPED 1');
                        //     }
                        // }
                    }
                }
            }
        } // Buttons Left
    }

    ScrollBar.vertical: POScrollBar {
        anchors.rightMargin: side == Qt.AlignLeft ? 0 : 2
        anchors.leftMargin:  side == Qt.AlignLeft ? 2 : 0
        anchors.left:        side == Qt.AlignLeft ? parent.left : undefined
        anchors.right:       side == Qt.AlignLeft ? undefined : parent.right
    }
}
