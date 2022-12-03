// Copyright (C) 2022 Kambiz Asadzadeh
// SPDX-License-Identifier: LGPL-3.0-only

import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import Clipboard 1.0 // Import clipboard method!

ApplicationWindow {
    id: appRoot
    width: 1080
    height: 1080
    maximumWidth: 1080
    maximumHeight: 1080
    visible: true
    title: qsTr("eLink")
    color: "#ffffff"

    QtObject {
        id: appObject
        readonly property string apiUrl : "https://cutt.ly/api/api.php?key=" // From https://cutt.ly
        readonly property string apiKey : "6bb7bd2402a2632c879a38ac827ecc7473697";
        readonly property string method : "POST";

        property string longLink : linkUrl.text;
        property string finalLink : "";
        property string linkTitle : "";

    }

    FontSystem { id: fontSystem; }

    Clipboard { id: clipboard }

    function dataRequest(type)
    {
        var req = new XMLHttpRequest();
        req.open(appObject.method, appObject.apiUrl + appObject.apiKey + "&short=" + appObject.longLink);
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                let result = JSON.parse(req.responseText);
                //Data
                appObject.finalLink = JSON.stringify(result.url.shortLink)
                appObject.linkTitle = JSON.stringify(result.url.title)
                appObject.longLink = JSON.stringify(result.url.fullLink)
            }
            busyIndicator.running = false;
            mainItem.implicitHeight = 172
            finalResultRow.visible = true
        }
        req.onerror = function(){
            console.log("Error!")
        }
        req.send()
    }

    Pane {
        anchors.fill: parent
        background: appRoot.background

        ColumnLayout {
            width: parent.width
            Layout.fillWidth: true
            anchors.centerIn: parent

            spacing: 16

            Text {
                font.family: fontSystem.getContentFontBold.name
                font.pixelSize: fontSystem.h1
                font.bold: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                text: qsTr("Create Short Links")
                color: "#3b349b"
            }

            Text {
                font.family: fontSystem.getContentFont.name
                font.pixelSize: fontSystem.h5
                font.bold: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                text: qsTr("A short link is a link that has been shortened with a URL shortener.")
                color: "#85878d"
            }



            Item {
                id: mainItem
                width: 640
                implicitHeight: 120
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Behavior on implicitHeight {
                    NumberAnimation { duration: 200; }
                }

                RectangularGlow {
                    id: effect
                    anchors.fill: mainBorder
                    glowRadius: 32
                    spread: 0.1
                    color: "#f2f1fb"
                    cornerRadius: mainBorder.radius + glowRadius
                }

                Rectangle {
                    id: mainBorder
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    anchors.fill: parent
                    color: "#ffffff"
                    border.width: 1
                    border.color: "#f6f5fc"
                    radius: 15
                }

                ColumnLayout {
                    width: parent.width
                    Layout.fillWidth: true
                    Item { height: 20; }

                    Rectangle {
                        width: parent.width / 1.2
                        height: 64
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        color: "#f6f5fc"
                        radius: 10
                        ColumnLayout {
                            anchors.fill: parent
                            Item { width: 10; }
                            RowLayout {
                                width: parent.width
                                Layout.fillWidth: true
                                Item { width: 15; }

                                Text {
                                    font.family: fontSystem.getAwesomeSolid.name
                                    font.styleName: "Solid"
                                    text: "\uf0c1"
                                    color: "#b0b0b0"
                                }

                                TextField {
                                    id: linkUrl
                                    font.family: fontSystem.getContentFont.name
                                    font.pixelSize: fontSystem.h5
                                    width: parent.width
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    height: 32
                                    placeholderText: "Paste a link to shorten it."
                                    placeholderTextColor: "#c6c6cb"
                                    background: Rectangle {
                                        height: parent.height
                                        border.width: 0
                                        radius: 5
                                        color: "#f6f5fc"
                                        Behavior on border.color {
                                            ColorAnimation {
                                                duration: 200
                                            }
                                        }
                                    }
                                }

                                BusyIndicator {
                                    id: busyIndicator
                                    width: 48
                                    height: 48
                                    running: false
                                    contentItem: Item {
                                        implicitWidth: 16
                                        implicitHeight: 16

                                        Item {
                                            id: itemProgress
                                            x: parent.width / 2 - 16
                                            y: parent.height / 2 - 16
                                            width: 32
                                            height: 32
                                            opacity: busyIndicator.running ? 1 : 0

                                            Behavior on opacity {
                                                OpacityAnimator {
                                                    duration: 250
                                                }
                                            }

                                            RotationAnimator {
                                                target: itemProgress
                                                running: busyIndicator.visible && busyIndicator.running
                                                from: 0
                                                to: 360
                                                loops: Animation.Infinite
                                                duration: 1250
                                            }

                                            Repeater {
                                                id: repeater
                                                model: 3

                                                Rectangle {
                                                    x: itemProgress.width / 2 - width / 2
                                                    y: itemProgress.height / 2 - height / 2
                                                    implicitWidth: 5
                                                    implicitHeight: 5
                                                    radius: 2.5
                                                    color: "#7a73e0"
                                                    transform: [
                                                        Translate {
                                                            y: -Math.min(itemProgress.width, itemProgress.height) * 0.5 + 7
                                                        },
                                                        Rotation {
                                                            angle: index / repeater.count * 360
                                                            origin.x: 2.5
                                                            origin.y: 2.5
                                                        }
                                                    ]
                                                }
                                            }
                                        }
                                    }
                                }


                                Button {
                                    id: shortButton
                                    implicitWidth: 72
                                    implicitHeight: 38
                                    font.family: fontSystem.getContentFont.name
                                    font.pixelSize: fontSystem.h5
                                    text: "Shorten"

                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        transparentBorder: true
                                        horizontalOffset: 0
                                        verticalOffset: 3
                                        color: "#c8c5f1"
                                        radius: 16
                                        samples: 32
                                        spread: 0.0

                                    }

                                    background: Rectangle {
                                        id: shortButtonBack
                                        anchors.fill: parent
                                        color: "#7a73e0"
                                        radius: 10
                                        z: 2
                                    }
                                    contentItem: Text {
                                        text: shortButton.text
                                        font.bold: false
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        opacity: enabled ? 1.0 : 0.3
                                        color: "#fff"
                                        anchors.fill: parent
                                        elide: Text.ElideRight
                                        scale: shortButton.down ? 0.9 : 1.0
                                        z: 3
                                        Behavior on scale {
                                            NumberAnimation {duration: 70;}
                                        }
                                    }

                                    onClicked: {
                                        if(linkUrl.text !== "") {
                                            busyIndicator.running = true;
                                            dataRequest();
                                        }
                                    }

                                }

                                Item { width: 5; }
                            }
                            Item { width: 10; }
                        }

                    }

                    Item { height: 20; }

                    RowLayout {
                        id: finalResultRow
                        width: parent.width
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        visible: false
                        Text {
                            font.family: fontSystem.getContentFont.name
                            font.pixelSize: 16
                            font.bold: false
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            text: qsTr(appObject.finalLink)
                            color: "#85878d"
                        }
                        Text {
                            font.family: fontSystem.getAwesomeSolid.name
                            font.styleName: "Light"
                            font.pixelSize: 16
                            text: "\uf0c5"
                            color: "#b0b0b0"
                            scale: copyArea.containsPress ? 0.7 : 1.0
                            Behavior on scale {
                                NumberAnimation { duration: 200;}
                            }

                            MouseArea {
                                id: copyArea
                                anchors.fill: parent
                                onClicked: {
                                    clipboard.text = appObject.finalLink
                                    finalRect.visible = true
                                    finalAnim.start()
                                }
                            }
                        }
                    }
                }
                Item {}
            }
            Text {
                font.family: fontSystem.getContentFont.name
                font.pixelSize: fontSystem.h6
                font.bold: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                text: qsTr("The API is available only to registered users API key can be generate in account edit page")
                color: "#85878d"
            }
            Text {
                font.family: fontSystem.getContentFont.name
                font.pixelSize: 10
                font.bold: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onLinkActivated: Qt.openUrlExternally(link)
                text: '<html><style type="text/css"></style>Created by <strong><a href="https://github.com/KambizAsadzadeh">Kambiz Asadzadeh</a></strong>, based on C++ & Qt Quick.</html>'
                color: "#85878d"
            }
        }
    }

    Item {
        id: crossShape
        x: 32
        y: 100
        width: 128
        height: 128
        rotation: 45
        Rectangle {
            width: 64
            height: 5
            color: "#3c359c"
        }
        Rectangle {
            width: 64
            height: 5
            color: "#3c359c"
            rotation: 90
        }
    }

    Item {
        id: rectangleShape
        x: 932
        y:800
        width: 64
        height: 64
        rotation: 45
        Rectangle {
            width: 64
            height: 64
            color: "transparent"
            border.width: 4
            border.color: "#766fde"
        }
    }

    Item {
        id: circleShape
        x: 232
        y: 850
        width: 86
        height: 86
        rotation: 45
        Rectangle {
            width: 86
            height: 86
            color: "#766fde"
            radius: width
        }
    }

    Item {
        id: backgroundColorized
        width: 300
        height: 300
        z: -2
        RectangularGlow {
            id: glowOne
            x: 875
            y: 500
            width: 300
            height: 300
            cornerRadius: 300
            color: 'transparent'
            opacity: 0.4
            SequentialAnimation on color {
                running:true
                loops: Animation.Infinite
                ColorAnimation { target: glowOne; from: "#ccfb37ff"; to: "#cc18b2de"; property: 'color'; duration: 1100;}
                ColorAnimation { target: glowOne; from: "#cc18b2de"; to: "#ccfb37ff"; property: 'color'; duration: 1100;}
            }
        }
        RectangularGlow {
            id: glowTwo
            x: -60
            y: -60
            width: 300
            height: 300
            cornerRadius: 300
            color: 'transparent'
            opacity: 0.4
            SequentialAnimation on color {
                running:true
                loops: Animation.Infinite
                ColorAnimation { target: glowTwo; from: "#cc18b2de"; to: "#ccfb37ff"; property: 'color'; duration: 1100;}
                ColorAnimation { target: glowTwo; from: "#ccfb37ff"; to: "#cc18b2de"; property: 'color'; duration: 1100;}
            }
        }

    }

    Rectangle {
        id: finalRect
        anchors.centerIn: parent
        color: "#3c359c"
        width: 500
        height: 500
        radius: width
        visible: false
        Text {
            anchors.centerIn: parent
            font.family: fontSystem.getContentFont.name
            font.pixelSize: 32
            font.bold: false
            color: "#fff"
            text: qsTr("Copied!")
        }
        NumberAnimation {
            id: finalAnim
            target: finalRect
            property: "scale"
            from: 3.0
            to: 0.0
            duration: 500
            easing.type: Easing.InExpo
        }
    }

}
