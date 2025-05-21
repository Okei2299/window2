import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.8
import QtMultimedia 5.15

Window {
    id: root
    width: 1280
    height: 800
    visible: true

    color: theme ? "black" : "white"
    property bool theme: false
    property real brightness: 1.0

    Rectangle {
        id: view
        anchors.fill: parent
        color: theme ? "grey" : "#f0f0f0"
        opacity: brightness

        Column {
            anchors.centerIn: parent
            spacing: 10

            Rectangle {
                id: backgroundLayer
                anchors.fill: parent
                z: -1 // Places it at the deepest layer
                color: theme ? "grey" : "#f0f0f0"

                Text {
                    font.pixelSize: root.width / 20
                    color: "black"
                    opacity: brightness
                    text: "linux"
                    anchors.centerIn: parent
                }
            }
        }
    }

    // Google Button
    Button {
        id: googleButton
        property real startX: 0
        property real startY: 0
        width: 100
        height: 100
        y: 20
        x: 10
        text: "Google"
        font.pixelSize: 18
        opacity: brightness

        background: Rectangle {
            radius: width / 2
            color: theme ? "lightgray" : "#4285F4"
            border.color: theme ? "white" : "black"
            border.width: 2
            opacity: brightness
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent

            onPressed: function(mouse) {
                googleButton.startX = mouse.x;
                googleButton.startY = mouse.y;
            }
            onClicked: webPopup.visible = true

            onPositionChanged: function(mouse) {
                let newX = googleButton.x + (mouse.x - googleButton.startX);
                let newY = googleButton.y + (mouse.y - googleButton.startY);

                // Ensure the button stays within the screen boundaries
                googleButton.x = Math.max(0, Math.min(newX, root.width - googleButton.width));
                googleButton.y = Math.max(clockBar.height, Math.min(newY, root.height - googleButton.height));

                // Collision detection with menu
                if (googleButton.x + googleButton.width > menuContainer.x &&
                    googleButton.x < menuContainer.x + menuContainer.width &&
                    googleButton.y + googleButton.height > menuContainer.y &&
                    googleButton.y < menuContainer.y + menuContainer.height) {
                    googleButton.y = menuContainer.y + menuContainer.height; // Push button below menu when colliding
                }
            }
        }
    }


    // Start up animation
    Rectangle {
        id: animationBoard
        width: root.width
        height: root.height
        color: "black"
        z: 2

        Rectangle {
            id: loadingCircle
            width: 300
            height: 300
            radius: width / 2
            border.width: 8
            anchors.centerIn: animationBoard

            gradient: Gradient {
                GradientStop { position: 0.0; color: "purple" }
                GradientStop { position: 1.0; color: "blue" }
            }

            NumberAnimation {
                id: spinAnim
                target: loadingCircle
                property: "rotation"
                from: 0
                to: 360
                duration: 10000
                loops: Animation.Infinite
                easing.type: Easing.Linear
            }

            Component.onCompleted: spinAnim.start()
        }

        Text {
            id: loadingText
            text: "Linux"
            color: "#000C7B"
            font.pixelSize: 100
            font.bold: true
            anchors.top: loadingCircle.bottom
            anchors.horizontalCenter: loadingCircle.horizontalCenter
        }

        Timer {
            interval: 10000
            running: true
            onTriggered: animationBoard.visible = false
        }
    }


    Rectangle {
        id: clockBar
        width: root.width
        height: 19
        color: theme ? "#555" : "#ddd"
        opacity: brightness
        z: 1

        property var _now: new Date()
        property string manualTime: ""

        Text {
            id: dateTimeDisplay
            anchors.centerIn: parent
            text: (clockBar.manualTime !== "" ? clockBar.manualTime : Qt.formatDateTime(clockBar._now, "hh:mm"))
                  + " " + Qt.formatDateTime(clockBar._now, "dd.MM")
            font.pixelSize: 16
            font.bold: true
            color: theme ? "white" : "black"
            opacity: brightness
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            var now = new Date();
            now.setUTCHours(now.getUTCHours() + 3); // Adjust to UTC+3
            clockBar._now = now; // Store updated time

            dateTimeDisplay.text = Qt.formatDateTime(clockBar._now, "dd/MM") + " " + Qt.formatDateTime(clockBar._now, "hh.mm");
        }
    }


// Menu
Rectangle {
    id: menuContainer
    width: root.width / 5
    height: expanded ? root.height / 8 : root.height / 10
    color: theme ? "#333" : "grey"
    anchors.right: clockBar.right // Stays aligned to the right
    anchors.top: clockBar.bottom
    radius: 5
    property bool expanded: false
    opacity: brightness

    MouseArea {
        anchors.fill: parent
        onClicked: {
            menuContainer.expanded = !menuContainer.expanded;
            menuText.text = menuContainer.expanded ? "⬆Close⬆" : "⬇Menu⬇";
            menuText.color = menuContainer.expanded ? "black" : "grey"; // Change color dynamically
        }
    }

    Text {
        id: menuText
        text: "⬇Menu⬇"
        font.pixelSize: 20
        anchors.centerIn: parent
        color: "grey" // Default color when closed
    }
}

Item {
    width: parent.width
    height: parent.height
    anchors.centerIn: parent

}

Column {
    spacing: 5
    visible: menuContainer.expanded

    // Settings button
    Rectangle {
        visible: true
        width: 1200
        height: 800
        color: "transparent"

        Button {
            text: " ⚙ "
            font.pixelSize: 50
            onClicked: popup.visible = true
            anchors.left: parent.right // Stays aligned to the right
            y: 19
            width: 80
            height: 50

            contentItem: Text {
                text: parent.text
                font.pixelSize: parent.font.pixelSize
                anchors.centerIn: parent
                color: theme ? "grey" : "#333"
                opacity: brightness

            }

            background: Rectangle {
                color: "#777"
                radius: 10
                border.color: "#555"
                border.width: 2

                Rectangle {
                    width: parent.width
                    height: parent.height
                    radius: parent.radius
                    color: theme ? "#333" : "grey"
                    anchors.centerIn: parent
                    opacity: brightness
                }
            }
        }

        Popup {
            id: popup
            width: parent.width * 0.8
            height: parent.height * 0.8
            modal: true
            focus: true
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2

            Rectangle {
                id: backgroundRect
                anchors.fill: parent
                color: theme ? "#FF" : "grey"
                radius: 10

                property real startX: 0
                property real startY: 0

                MouseArea {
                    id: otherdragArea
                    anchors.fill: parent
                    onPressed: function(mouse) {
                        backgroundRect.startX = mouse.x;
                        backgroundRect.startY = mouse.y;
                    }
                    onPositionChanged: function(mouse) {
                        popup.x += mouse.x - backgroundRect.startX;
                        popup.y += mouse.y - backgroundRect.startY;
                    }
                }

                Column {
                    spacing: 20
                    anchors.centerIn: parent

                    Slider {
                        id: brightnessSlider
                        width: parent.width * 0.9
                        height: 40
                        from: 0.2
                        to: 1.0
                        value: brightness
                        onValueChanged: brightness = value
                    }

                    Button {
                        text: theme ? "Light Mode" : "Dark Mode"
                        onClicked: theme = !theme
                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 18
                            color: theme ? "black" : "white"
                            anchors.centerIn: parent
                        }
                        background: Rectangle {
                        color: theme ? "white" : "black"
                        radius: 10
                        }
                    }
                }
            }
        }
    }
}

// Exit Button
Rectangle {
    visible: menuContainer ? menuContainer.expanded : !menuContainer.expanded;
    width: root.width / 20
    height: width
    color: "red"
    border.color: "black"
    border.width: 1
    opacity: brightness
    anchors.left: menuContainer.left
    anchors.bottom: menuContainer.bottom

    Text {
        anchors.centerIn: parent
        text: "Exit"
        font.pixelSize: 25
        font.family: "Arial"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Qt.quit()
    }

}




// Web Browser
Rectangle {
    id: mainContainer
    width: parent.width
    height: parent.height
    color: "transparent"

    Rectangle {
        id: webPopup
        property bool isMaximized: false
        property real startX: 0
        property real startY: 0
        width: 600
        height: 400
        x: (mainContainer.width - width) / 2
        y: Math.max(clockBar.height, (mainContainer.height - height) / 2) // Prevent moving over the clock
        visible: false
        z: 100
        border.color: "#222222"
        border.width: 2
        color: theme ? "#737373" : "#aaa"

        Rectangle {
            id: titleBar
            width: parent.width
            height: 40
            color: theme ? "#444" : "#aaa"

            Text {
                text: "Google Chromium"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 10
                font.pixelSize: 16
                color: theme ? "#black" : "#white"
            }

            MouseArea {
                id: seconddragArea
                anchors.fill: parent
                onPressed: function(mouse) {
                    webPopup.startX = mouse.x;
                    webPopup.startY = mouse.y;
                }
                onPositionChanged: function(mouse) {
                    let newX = webPopup.x + (mouse.x - webPopup.startX);
                    let newY = webPopup.y + (mouse.y - webPopup.startY);

                    // Prevent window from moving off-screen
                    webPopup.x = Math.max(0, Math.min(newX, root.width - webPopup.width));
                    webPopup.y = Math.max(clockBar.height, Math.min(newY, root.height - webPopup.height));
                }
            }

            // Restore down button
            Button {
                id: restoreButton
                anchors.right: closeButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 5
                visible: webPopup.isMaximized
                onClicked: {
                    webPopup.width = 600;
                    webPopup.height = 400;
                    webPopup.x = (mainContainer.width - webPopup.width) / 2;
                    webPopup.y = (mainContainer.height - webPopup.height) / 2;
                    webPopup.isMaximized = false;
                    restoreButton.visible = false;
                    maximizeButton.visible = true;
                }
                background: Rectangle {
                    color: "#AAAAAA"
                    radius: 5
                }
                contentItem: Text {
                    text: " 🗗 "
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                }
            }

            // Maximize button
            Button {
                id: maximizeButton
                anchors.right: restoreButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 5
                visible: !webPopup.isMaximized
                onClicked: {
                    webPopup.width = mainContainer.width;
                    webPopup.height = mainContainer.height - clockBar.height; // Adjusted height
                    webPopup.x = 0;
                    webPopup.y = clockBar.height;
                    webPopup.isMaximized = true;
                    maximizeButton.visible = false;
                    restoreButton.visible = true;
                }
                background: Rectangle {
                    color: "#AAAAAA"
                    radius: 5
                }
                contentItem: Text {
                    text: " 🗖 "
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                }
            }

            // Close button
            Button {
                id: closeButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 5
                onClicked: webPopup.visible = false
                background: Rectangle {
                    color: "#E95420"
                    radius: 5
                }
                contentItem: Text {
                    text: " ✖ "
                    font.pixelSize: 16
                    font.bold: true
                    color: "white"
                }
            }
        }

        WebEngineView {
            id: webView
            width: parent.width - 20
            height: parent.height - titleBar.height - 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: titleBar.bottom
            anchors.margins: 10
            url: "https://www.google.com/"
            }
        }
    }
}

