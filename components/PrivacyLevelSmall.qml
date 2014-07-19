import QtQuick 2.0

Item {
    id: item
    property int fillLevel: 0
    height: 40
    clip: true

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 24
        //radius: 4
        color: "#DBDBDB"
    }

    Rectangle {
        id: bar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 1
        height: 24
        //radius: 4
        color: "#FFFFFF"

        Rectangle {
            id: fillRect
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 4
            //radius: 2
            width: row.x

            color: {
                if(item.fillLevel < 3) return "#FF6C3C"
                if(item.fillLevel < 13) return "#FFE00A"
                return "#36B25C"
            }

            Timer {
                interval: 500
                running: true
                repeat: false
                onTriggered: fillRect.loaded = true
            }

            property bool loaded: false
            Behavior on width {
                enabled: fillRect.loaded
                NumberAnimation { duration: 100; easing.type: Easing.InQuad }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Arial"
            font.pixelSize: 11
            font.letterSpacing: -1
            font.bold: true
            color: "#000000"
            x: row.x + (row.positions[0] !== undefined ? row.positions[0].currentX - 5 : 0) - width
            text: qsTr("LOW")
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Arial"
            font.pixelSize: 11
            font.letterSpacing: -1
            font.bold: true
            color: "#000000"
            x: row.x + (row.positions[4] !== undefined ? row.positions[4].currentX - 5 : 0) - width
            text: qsTr("MEDIUM")
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Arial"
            font.pixelSize: 11
            font.letterSpacing: -1
            font.bold: true
            color: "#000000"
            x: row.x + (row.positions[13] !== undefined ? row.positions[13].currentX - 5 : 0) - width
            text: qsTr("HIGH")
        }

        MouseArea {
            anchors.fill: parent
            function positionBar() {
                var xDiff = 999999
                var index = -1
                for(var i = 0; i < 14; ++i) {
                    var tmp = Math.abs(row.positions[i].currentX + row.x - mouseX)
                    if(tmp < xDiff) {
                        xDiff = tmp
                        index = i
                    }
                }

                if(index !== -1) {
                    fillRect.width = Qt.binding(function(){ return row.positions[index].currentX + row.x })
                    item.fillLevel = index
                }
            }

            onClicked: positionBar()
            onMouseXChanged: positionBar()
        }
    }

    Row {
        id: row
        anchors.right: bar.right
        anchors.rightMargin: 8
        anchors.top: bar.bottom
        anchors.topMargin: 5
        property var positions: new Array()

        Row {
            id: row2
            spacing: ((bar.width - 8) / 2) / 4

            Repeater {
                model: 4

                delegate: Rectangle {
                    id: delegateItem2
                    property int currentX: x + row2.x
                    height: 8
                    width: 1
                    color: "#DBDBDB"
                    Component.onCompleted: {
                        row.positions[index] = delegateItem2
                    }
                }
            }
        }

        Row {
            id: row1
            spacing: ((bar.width - 8) / 2) / 10

            Repeater {
                model: 10

                delegate: Rectangle {
                    id: delegateItem1
                    property int currentX: x + row1.x
                    height: index === 4 ? 8 : 4
                    width: 1
                    color: "#DBDBDB"
                    Component.onCompleted: {
                        row.positions[index + 4] = delegateItem1
                    }
                }
            }
        }
    }
}