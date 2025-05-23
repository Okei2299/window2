import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.8

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
                z: -1 // Asettaa sen pohjimmalle kerrokselle
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

    // Weather button
    Button {
        id: weatherButton  // Maarittaa painikkeen tunnisteen
        property real startX: 0  // Tallentaa hiiren X-sijainnin painettaessa
        property real startY: 0  // Tallentaa hiiren Y-sijainnin painettaessa
        width: 100  // Asettaa painikkeen leveyden
        height: 100  // Asettaa painikkeen korkeuden
        y: 200  // Asettaa painikkeen alkuperaisen pystysuuntaisen sijainnin
        x: 500  // Asettaa painikkeen alkuperaisen vaakasuuntaisen sijainnin
        text: "Weather"  // Nayttaa painikkeen tekstin
        font.bold: true  // Tekee painikkeen tekstista lihavoidun
        font.pixelSize: 18  // Asettaa fontin koon
        opacity: brightness  // Saataa painikkeen lapinakyvyytta dynaamisesti

        // Maarittaa painikkeen taustatyylin
        background: Rectangle {
            color: theme ? "grey" : "lightgrey"  // Asettaa taustavarin dark- ja lightmoden mukaan
            border.color: theme ? "white" : "black"  // Muuttaa reunuksen varia dark- ja lightmoden perusteella
            border.width: 2  // Maarittaa reunuksen leveyden
            opacity: brightness  // Varmistaa, etta tausta vastaa brightnessSliderin lapinakyvyytta
        }

        // Maarittaa hiiren interaktioalueen painikkeelle
        MouseArea {
            id: weatherdragArea  // Maarittaa hiiren alueen tunnisteen
            anchors.fill: parent  // Laajentaa hiiren alueen kattamaan koko painikkeen

            onPressed: function(mouse) {
                // Kutsutaan, kun kayttaja painaa painiketta hiirella

                weatherButton.startX = mouse.x;
                // Tallentaa hiiren X-koordinaatin painallushetkella
                // Kaytetaan myohemmin laskemaan siirtyma vetamisen aikana

                weatherButton.startY = mouse.y;
                // Tallentaa hiiren Y-koordinaatin painallushetkella
                // Mahdollistaa tarkan vetamisen ilman hyppyja
            }

            onClicked: weatherwebPopup.visible = true  // Avaa weatherwebPopup, kun painiketta klikataan

            onPositionChanged: function(mouse) {
                // Kutsutaan aina, kun hiiren sijainti muuttuu

                let newX = weatherButton.x + (mouse.x - weatherButton.startX);
                // Laskee uuden X-aseman siirtyman perusteella
                    // - `mouse.x - weatherButton.startX`: laskee hiiren siirtyman X-akselilla
                    // - `weatherButton.x + ...`: siirtaa painiketta tasta siirtymasta

                let newY = weatherButton.y + (mouse.y - weatherButton.startY);
                // Laskee uuden Y-aseman siirtyman perusteella
                    // - `mouse.y - weatherButton.startY`: laskee hiiren siirtyman Y-akselilla
                    // - `weatherButton.y + ...`: siirtaa painiketta tasta siirtymasta

                weatherButton.x = Math.max(0, Math.min(newX, root.width - weatherButton.width));
                // Varmistaa, etta painikkeen X-asema pysyy nayton sisalla
                // - `Math.min(newX, root.width - weatherButton.width)`: estaa painikkeen menemasta ruudun oikean reunan yli
                // - `Math.max(0, ...)`: estaa painikkeen menemasta ruudun vasemman reunan ulkopuolelle

                weatherButton.y = Math.max(clockBar.height, Math.min(newY, root.height - weatherButton.height));
                // Varmistaa, etta painikkeen Y-asema pysyy nayton sisalla
                // - `Math.min(newY, root.height - weatherButton.height)`: estaa painikkeen menemasta ruudun alareunan yli
                // - `Math.max(clockBar.height, ...)`: estaa painikkeen menemasta ylapuolelle, jos clockBar on tiella


                // Esta paallekkaisyys valikon kanssa
                if (weatherButton.x + weatherButton.width > menuContainer.x &&  // Tarkistaa, onko painikkeen oikea reuna valikon vasemman reunan ulkopuolella
                    weatherButton.x < menuContainer.x + menuContainer.width &&  // Tarkistaa, onko painikkeen vasen reuna valikon oikean reunan sisapuolella
                    weatherButton.y + weatherButton.height > menuContainer.y &&  // Tarkistaa, onko painikkeen alaosa valikon ylareunan alapuolella
                    weatherButton.y < menuContainer.y + menuContainer.height) {  // Tarkistaa, onko painikkeen ylaosa valikon alareunan ylapuolella

                    weatherButton.y = menuContainer.y + menuContainer.height;  // Siirtaa painikkeen valikon alapuolelle, jos ne menevat paallekkain
                }
            }
        }
    }





    // Google Button
    Button {
        id: googleButton
        property real startX: 0 // Tallentaa hiiren X-sijainnin painettaessa
        property real startY: 0 // Tallentaa hiiren Y-sijainnin painettaessa
        width: 100
        height: 100
        y: 20
        x: 10
        text: "Google"
        font.pixelSize: 18
        opacity: brightness

        background: Rectangle {
            radius: width / 2 // Muuntaa nelion ympyraksi
            color: theme ? "lightgray" : "#4285F4"
            border.color: theme ? "white" : "black"
            border.width: 2
            opacity: brightness
        }

        // Maarittaa hiiren interaktioalueen painikkeelle
        MouseArea {
            id: googledragArea // Maarittaa hiiren alueen tunnisteen
            anchors.fill: parent // Laajentaa hiiren alueen kattamaan koko painikkeen

            onPressed: function(mouse) {
                // Kutsutaan, kun kayttaja painaa painiketta hiirella

                googleButton.startX = mouse.x;
                // Tallentaa hiiren X-koordinaatin painallushetkella
                // Kaytetaan myohemmin laskemaan siirtyma vetamisen aikana

                googleButton.startY = mouse.y;
                // Tallentaa hiiren Y-koordinaatin painallushetkella
                // Mahdollistaa tarkan vetamisen ilman hyppyja
            }
            onClicked: googlewebPopup.visible = true // Avaa googlewebPopup, kun painiketta klikataan

            onPositionChanged: function(mouse) {
                // Kutsutaan aina, kun hiiren sijainti muuttuu

                let newX = googleButton.x + (mouse.x - googleButton.startX);
                // Laskee uuden X-aseman siirtyman perusteella
                    // - `mouse.x - googleButton.startX`: laskee hiiren siirtyman X-akselilla
                    // - `googleButton.x + ...`: siirtaa painiketta tasta siirtymasta

                let newY = googleButton.y + (mouse.y - googleButton.startY);
                // Laskee uuden Y-aseman siirtyman perusteella
                    // - `mouse.y - googleButton.startY`: laskee hiiren siirtyman Y-akselilla
                    // - `googleButton.y + ...`: siirtaa painiketta tasta siirtymasta

                googleButton.x = Math.max(0, Math.min(newX, root.width - googleButton.width));
                // Varmistaa, etta painikkeen X-asema pysyy nayton sisalla
                // - `Math.min(newX, root.width - googleButton.width)`: estaa painikkeen menemasta ruudun oikean reunan yli
                // - `Math.max(0, ...)`: estaa painikkeen menemasta ruudun vasemman reunan ulkopuolelle

                googleButton.y = Math.max(clockBar.height, Math.min(newY, root.height - googleButton.height));
                // Varmistaa, etta painikkeen Y-asema pysyy nayton sisalla
                // - `Math.min(newY, root.height - googleButton.height)`: estaa painikkeen menemasta ruudun alareunan yli
                // - `Math.max(clockBar.height, ...)`: estaa painikkeen menemasta ylapuolelle, jos clockBar on tiella

                // Esta paallekkaisyys valikon kanssa
                if (googleButton.x + googleButton.width > menuContainer.x && // Tarkistaa, onko painikkeen oikea reuna valikon vasemman reunan ulkopuolella
                    googleButton.x < menuContainer.x + menuContainer.width && // Tarkistaa, onko painikkeen vasen reuna valikon oikean reunan sisapuolella
                    googleButton.y + googleButton.height > menuContainer.y && // Tarkistaa, onko painikkeen alaosa valikon ylareunan alapuolella
                    googleButton.y < menuContainer.y + menuContainer.height) { // Tarkistaa, onko painikkeen ylaosa valikon alareunan ylapuolella

                    googleButton.y = menuContainer.y + menuContainer.height; // Siirtaa painikkeen valikon alapuolelle, jos ne menevat paallekkain
                }
            }
        }
    }


    // Start up animation
    Rectangle {
        id: animationBoard
        width: root.width  // Maarittaa leveys samaksi kuin rootin leveys
        height: root.height  // Maarittaa korkeus samaksi kuin rootin korkeus
        color: "black"  // Asettaa taustavarin mustaksi
        z: 2  // Tekee animationBoard kerroksesta ulomman, kuin kellopalkista ja Menusta

        Rectangle {
            id: loadingCircle
            width: 300  // Maarittaa loadingCirclen leveyden
            height: 300  // Maarittaa loadingCirclen korkeuden
            radius: width / 2  // Asettaa reunojen pyoristykset, tehden tasta ympyra
            border.width: 8  // Maarittaa reunuksen leveyden
            anchors.centerIn: animationBoard  // Keskittaa ympyra animationBoardiin

            gradient: Gradient {
                GradientStop { position: 0.0; color: "purple" }  // Maarittaa aloitusvarin
                GradientStop { position: 1.0; color: "blue" }  // Maarittaa lopetusvarin
            }

            NumberAnimation {
                id: spinAnim
                target: loadingCircle  // Maarittaa animaation kohteen
                property: "rotation"  // Maarittaa, mita ominaisuutta animoidaan
                from: 0  // Aloittaa pyorityksen 0°
                to: 360  // Pyorittaa 360°
                duration: 10000  // Maarittaa kestoksi 10 sekuntia (1000 = 1s)
                loops: Animation.Infinite  // Toistaa spinAnim ikuisesti
                easing.type: Easing.Linear  // Maarittaa tasaisen pyorimisliikkeen ilman kiihtyvyytta
            }

            Component.onCompleted: spinAnim.start()  // Kaynnistaa animaation heti kun loadingCircle on luotu
        }

        Text {
            id: loadingText
            text: "Loading..."  // teksti loadingCirclen alla
            color: "#000C7B"  // Tekstin vari (tummansininen)
            font.pixelSize: 100  // Tekstin koko
            font.bold: true  // Tekee tekstista lihavoidun
            anchors.top: loadingCircle.bottom  // Asettaa tekstin ympyran alapuolelle
            anchors.horizontalCenter: loadingCircle.horizontalCenter  // Keskittaa tekstin vaakasuunnassa (horizontal)
        }

        Timer {
            interval: 10000  // Maarittaa ajan (10 sekuntia)
            running: true  // Kaynnistaa Timer automaattisesti
            onTriggered: animationBoard.visible = false  // Piilottaa animaation kaynnistysajan paatyttya
        }
    }


    // UTC+3 Clock
    Rectangle {
        id: clockBar
        width: root.width  // Maarittaa leveys samaksi kuin rootilla
        height: 19  // clockBarin pituus on 19 px
        color: theme ? "#555" : "#ddd"  // Maarittaa varin light- ja dark-moden mukaan
        opacity: brightness  // Saataa lapinakyvyytta brightnessSliderilla
        z: 1  // Maarittaa clockBarin toisiksi uloimmaksi layeriksi

        property var _now: new Date()  // Luo uuden ajan muuttujan

        Text {
            id: dateTimeDisplay
            anchors.centerIn: parent  // Keskittaa tekstin kellopalkkiin
            text: (Qt.formatDateTime(clockBar._now, "hh:mm")) // hh:mm = tunti:minuutti
                  + " " + Qt.formatDateTime(clockBar._now, "dd.MM") // dd.MM = paiva.kuukausi
            // Nayttaa kellonajan ja paivamaaran

            font.pixelSize: 16  // Maarittaa fontin koon
            font.bold: true  // Tekee tekstista lihavoidun
            color: theme ? "white" : "black"  // Maarittaa tekstin light- ja dark-moden mukaan
            opacity: brightness  // Saataa tekstin lapinakyvyytta
        }
    }

    Timer {
        interval: 1000  // Asettaa paivitysvalin 1 sekuntiin
        running: true  // Kaynnistaa ajastimen heti
        repeat: true  // Varmistaa, etta ajastin jatkaa toistamista

        onTriggered: {
            var now = new Date();  // Luo uuden aikaoli
            now.setUTCHours(now.getUTCHours() + 3);  // Asettaa ajan UTC+3 mukaan
            clockBar._now = now;  // Tallentaa paivitetyn ajan

            dateTimeDisplay.text = Qt.formatDateTime(clockBar._now, "dd/MM") + " " + Qt.formatDateTime(clockBar._now, "hh.mm");
            // Paivittaa kellonajan ja paivamaaran naytossa
        }
    }


// Menu
Rectangle {
    id: menuContainer
    width: root.width / 5 // Maarittaa menun leveydeksi 1/5 rootin leveydesta
    height: expanded ? root.height / 8 : root.height / 10  // Maarittaa korkeuden laajennettuna tai suljettuna
    color: theme ? "#333" : "grey"  // Asettaa varin light- ja dark-moden mukaan
    anchors.right: clockBar.right  // Pitaa Menun oikealla kellopalkin kanssa linjassa
    anchors.top: clockBar.bottom  // Asettaa Menun kellopalkin alapuolelle
    radius: 5  // Pyoristaa kulmat tehden reunat pehmeammiksi
    property bool expanded: false  // Muuttuja joka maarittaa, onko menu laajennettu
    opacity: brightness  // Saataa menun lapinakyvyytta dynaamisesti

    MouseArea {
        anchors.fill: parent  // Laajentaa MouseArean koko menun sisalle
        onClicked: {
            menuContainer.expanded = !menuContainer.expanded;
            // Vaihtaa menun tilan avattuun tai suljettuun

            menuText.text = menuContainer.expanded ? "⬆Close⬆" : "⬇Menu⬇";
            // Vaihtaa napin tekstin sen mukaan, onko menu avattu tai suljettu

            menuText.color = menuContainer.expanded ? "black" : "grey";
            // Vaihtaa tekstin varin light- ja dark moden mukaan
        }
    }

    Text {
        id: menuText
        text: "⬇Menu⬇"  // Menun oletusteksti, kun se on suljettu
        font.pixelSize: 20  // Maarittaa fontin koon
        anchors.centerIn: parent  // Keskittaa tekstin menun sisalle
        color: "grey"  // Asettaa tekstin varin oletuksena harmaaksi
    }
}

Item {
    width: parent.width  // Maarittaa leveydeksi saman kuin parentilla
    height: parent.height  // Maarittaa korkeuden samaksi kuin parentilla
    anchors.centerIn: parent  // Keskittaa Itemin parenttiin

}

Column {
    spacing: 5  // Maarittaa pystysuuntaisen valin elementtien valille
    visible: menuContainer.expanded  // Nayttaa elementin vain, jos menu on laajennettu

    // Settings button
    Rectangle {
        visible: true  // Maarittaa, etta elementti on nakyvissa
        width: 1200  // Asettaa ikkunan leveyden
        height: 800  // Asettaa ikkunan korkeuden
        color: "transparent"  // Tekee taustan lapi nakyvaksi

        Button {
            text: " ⚙ "  // Nayttaa asetusten merkin
            font.pixelSize: 50  // Maarittaa fontin koon
            onClicked: popup.visible = true  // Nayttaa popup-ikkunan kun painiketta klikataan
            anchors.left: parent.right  // Pitaa painikkeen oikeassa reunassa
            y: 19  // Maarittaa pystysijainnin
            width: 80  // Asettaa painikkeen leveyden
            height: 50  // Asettaa painikkeen korkeuden

            contentItem: Text {
                text: parent.text  // Maarittaa tekstiksi painikkeen sisallon
                font.pixelSize: parent.font.pixelSize  // Maarittaa fontin koon samaksi kuin parentin elementin
                anchors.centerIn: parent  // Keskittaa tekstin painikkeen sisalle
                color: theme ? "grey" : "#333"  // Maarittaa tekstin varin light- ja dark moden mukaan
                opacity: brightness  // Saataa lapinakyvyytta

            }

            background: Rectangle {
                color: "#777"  // Asettaa painikkeen taustavarin
                radius: 10  // Pyoristaa reunat
                border.color: "#555"  // Maarittaa reunuksen varin
                border.width: 2  // Maarittaa reunuksen leveyden

                Rectangle {
                    width: parent.width  // Maarittaa taustaelementin leveyden samaksi kuin parentilla
                    height: parent.height  // Maarittaa taustaelementin korkeuden samaksi kuin parentilla
                    radius: parent.radius  // Pyoristaa reunat samaksi kuin parentin elementin
                    color: theme ? "#333" : "grey"  // Muuttaa varin light- ja dark moden mukaan
                    anchors.centerIn: parent  // Keskittaa taustaelementin
                    opacity: brightness  // Saataa lapinakyvyytta
                }
            }
        }

        Popup {
            id: popup  // Maarittaa popup-ikkunan
            width: parent.width * 0.8  // Maarittaa popupin leveyden suhteessa parenttiin
            height: parent.height * 0.8  // Maarittaa popupin korkeuden suhteessa parenttiin
            modal: true  // Estaa vuorovaikutuksen muiden elementtien kanssa popupin ollessa nakyvilla
            focus: true  // Antaa popupille kayttonapin ja keskittymisen
            x: (parent.width - width) / 2  // Keskittaa popupin vaakasuunnassa
            y: (parent.height - height) / 2  // Keskittaa popupin pystysuunnassa

            Rectangle {
                id: backgroundRect  // Maarittaa popupin taustan
                anchors.fill: parent  // Tayttaa popupin kokonaan
                color: theme ? "#FF" : "grey"  // Maarittaa taustavarin teeman mukaan
                radius: 10  // Pyoristaa kulmat

                property real startX: 0  // Tallentaa mousen alkusijainnin X-akselilla
                property real startY: 0  // Tallentaa mousen alkusijainnin Y-akselilla

                MouseArea {
                    id: otherdragArea  // Maarittaa mousen alueen
                    anchors.fill: parent  // Tayttaa taustan kokonaan MouseArealla
                    onPressed: function(mouse) {
                        backgroundRect.startX = mouse.x;  // Tallentaa mousen X-aseman
                        backgroundRect.startY = mouse.y;  // Tallentaa mousen Y-aseman
                    }
                    onPositionChanged: function(mouse) {
                        popup.x += mouse.x - backgroundRect.startX;  // Liikuttaa popupia X-akselilla
                        popup.y += mouse.y - backgroundRect.startY;  // Liikuttaa popupia Y-akselilla
                    }
                }

                Column {
                    spacing: 20  // Maarittaa valin elementtien valille
                    anchors.centerIn: parent  // Keskittaa sarakkeen popupin sisalle

                    Slider {
                        id: brightnessSlider  // Maarittaa brightnessSlider (Kirkkaudensaadin)
                        width: parent.width * 0.9  // Maarittaa leveyden suhteessa parentiin
                        height: 40  // Maarittaa korkeuden
                        from: 0.2  // Asettaa kirkkauden ala-arvon
                        to: 1.0 // Asettaa kirkkauden yla-arvon
                        value: brightness  // Maarittaa nykyisen arvon
                        onValueChanged: brightness = value  // Paivittaa kirkkauden muutoksen mukaan
                    }

                    Button {
                        text: theme ? "Light Mode" : "Dark Mode" // Nayttaa eri tekstit Light- tai dark moden mukaan
                        onClicked: theme = !theme  // Vaihtaa teeman light- ja dark moden valilla
                        contentItem: Text {
                            text: parent.text  // Maarittaa tekstiksi painikkeen sisallon
                            font.pixelSize: 18  // Maarittaa fontin koon
                            color: theme ? "black" : "white"  // Maarittaa varin light- ja dark moden mukaan
                            anchors.centerIn: parent  // Keskittaa tekstin painikkeen sisalle
                        }
                        background: Rectangle {
                        color: theme ? "white" : "black"  // Maarittaa taustavarin light- ja dark moden mukaan
                        radius: 10  // Pyoristaa kulmat
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
    // Maarittaa, onko painike nakyvissa
    // - Nayttaa painikkeen, kun Menu on avattu
    // - Piilottaa painikkeen, kun Menu on suljettu

    width: root.width / 20  // Maarittaa painikkeen leveydeksi 1/20 rootin leveydesta
    height: width // Maarittaa painikkeen korkeuden samaksi kuin leveys, tehden siita neliomaisen
    color: "red"  // Asettaa painikkeen variksi punaisen
    border.color: "black"  // Maarittaa reunuksen varin mustaksi
    border.width: 1  // Maarittaa reunuksen leveydeksi yhden pikselin
    opacity: brightness  // Saataa lapinakyvyytta dynaamisesti

    anchors.left: menuContainer.left  // Pitaa painikkeen linjassa valikon vasemman reunan kanssa
    anchors.bottom: menuContainer.bottom  // Pitaa painikkeen linjassa valikon alareunan kanssa

    Text {
        anchors.centerIn: parent  // Keskittaa tekstin painikkeen sisalle
        text: "Exit"  // Maarittaa tekstiksi "Exit"
        font.pixelSize: 25  // Asettaa fontin koon
        font.family: "Arial"  // Maarittaa fonttityypiksi Arial
    }

    MouseArea {
        anchors.fill: parent  // Laajentaa MouseArean koko painikkeen sisalle
        onClicked: Qt.quit()  // Sulkee taman sovelluksen, kun painiketta klikataan
    }

}







// Weather webwindow
Rectangle {
    id: weathermainContainer
    width: parent.width  // Maarittaa leveys samaksi kuin parentilla
    height: parent.height  // Maarittaa korkeus samaksi kuin parentilla
    color: "transparent"  // Tekee taustan lapi nakyvaksi

    Rectangle {
        id: weatherwebPopup
        property bool isMaximized: false  // Maarittaa, onko popup maksimoitu
        property real startX: 0  // Tallentaa hiiren X-aseman painettaessa
        property real startY: 0  // Tallentaa hiiren Y-aseman painettaessa
        width: 600  // Maarittaa popupin leveyden
        height: 400  // Maarittaa popupin korkeuden
        x: (weathermainContainer.width - width) / 2  // Keskittaa vaakasuunnassa
        y: Math.max(clockBar.height, (weathermainContainer.height - height) / 2) // Varmistaa, ettei weatherwebPopup siirry clockBarin paalle
        visible: false  // Aluksi piilotettuna
        z: 100 // Nostaa popupin korkeimpaan kerrokseen
        border.color: "#222222"  // Maarittaa reunuksen varin
        border.width: 2  // Maarittaa reunuksen leveyden
        color: theme ? "#737373" : "#aaa"  // Taustavari light- ja dark moden mukaan

        Rectangle {
            id: weathertitleBar
            width: parent.width  // Maarittaa leveyden samaksi kuin parentilla
            height: 40  // Maarittaa korkeus 40 pikselia
            color: theme ? "#444" : "#aaa"  // Maarittaa varin light- ja dark moden mukaan

            Text {
                text: "Foreca"  // Nayttaa sivun nimen
                anchors.verticalCenter: parent.verticalCenter  // Keskittaa tekstin pystysuunnassa
                anchors.left: parent.left  // Asettaa tekstin vasemmalle
                anchors.margins: 10  // Maarittaa reunavaran
                font.pixelSize: 16  // Maarittaa fontin koon
                color: theme ? "#black" : "#white"  // Maarittaa varin light- ja dark moden mukaan
            }

            MouseArea {
                id: weatherseconddragArea
                anchors.fill: parent  // Tayttaa koko otsikkopalkin MouseArealla
                onPressed: function(mouse) {
                    weatherwebPopup.startX = mouse.x;  // Tallentaa Mousen X-aseman
                    weatherwebPopup.startY = mouse.y;  // Tallentaa Mousen Y-aseman
                }
                onPositionChanged: function(mouse) {   // Kutsutaan aina, kun kohde siirtyy
                    let newX = weatherwebPopup.x + (mouse.x - weatherwebPopup.startX);   // Laskee uuden sivuttaissuunnan sijainnin hiiren siirtyman perusteella
                    let newY = weatherwebPopup.y + (mouse.y - weatherwebPopup.startY);   // Laskee uuden pystysuunnan sijainnin hiiren siirtyman perusteella

                    // Estaa ikkunan liikkumisen ruudun ulkopuolelle
                    weatherwebPopup.x = Math.max(0, Math.min(newX, root.width - weatherwebPopup.width));   // Varmistaa, etta kohde pysyy sallitulla alueella sivuttaissuunnassa
                    weatherwebPopup.y = Math.max(clockBar.height, Math.min(newY, root.height - weatherwebPopup.height));   // Varmistaa, etts kohde pysyy sallitulla alueella pystysuunnassa
                }
            }

            // Restore down button
            Button {
                id: weatherrestoreButton
                anchors.right: weathercloseButton.left  // Asettaa painikkeen sulkupainikkeen viereen
                anchors.verticalCenter: parent.verticalCenter  // Pitaa painikkeen pystysuunnassa keskella
                anchors.margins: 5  // Maarittaa reunavaran
                visible: weatherwebPopup.isMaximized  // Nayttaa painikkeen vain, kun ikkuna on maksimoitu
                onClicked: {
                    weatherwebPopup.width = 600;  // Palauttaa alkuperaisen leveyden
                    weatherwebPopup.height = 400;  // Palauttaa alkuperaisen korkeuden
                    weatherwebPopup.x = (weathermainContainer.width - weatherwebPopup.width) / 2;   // Keskittaa vaakasuunnassa
                    weatherwebPopup.y = (weathermainContainer.height - weatherwebPopup.height) / 2;   // Keskittaa pystysuunnassa
                    weatherwebPopup.isMaximized = false;   // Paivittaa tilan normaaliksi
                    weatherrestoreButton.visible = false;  // Piilottaa palautuspainikkeen
                    weathermaximizeButton.visible = true;  // Nayttaa maksimi-painikkeen
                }
                background: Rectangle {
                    color: "#AAAAAA"  // Asettaa taustavarin
                    radius: 5  // Pyoristaa reunat
                }
                contentItem: Text {
                    text: " 🗗 "  // Nayttaa palautuspainikkeen kuvakkeen
                    font.pixelSize: 16  // Maarittaa fontin koon
                    font.bold: true  // Tekee tekstista lihavoidun
                    color: "black"  // Maarittaa tekstin varin
                }
            }

            // Maximize button
            Button {
                id: weathermaximizeButton
                anchors.right: weatherrestoreButton.left  // Asettaa painikkeen palautuspainikkeen viereen
                anchors.verticalCenter: parent.verticalCenter  // Pitaa painikkeen keskella pystysuunnassa
                anchors.margins: 5  // Maarittaa reunavaran
                visible: !weatherwebPopup.isMaximized  // Nayttaa painikkeen vain, kun ikkuna ei ole maksimoitu
                onClicked: {
                    weatherwebPopup.width = weathermainContainer.width;  // Asettaa leveyden koko ikkunaksi
                    weatherwebPopup.height = weathermainContainer.height - clockBar.height;  // Asettaa korkeuden
                    weatherwebPopup.x = 0;  // Siirtaa vasempaan reunaan
                    weatherwebPopup.y = clockBar.height;  // Siirtaa kellopalkin alapuolelle
                    weatherwebPopup.isMaximized = true;  // Paivittaa tilan maksimoiduksi
                    weathermaximizeButton.visible = false;  // Piilottaa maksimi-painikkeen
                    weatherrestoreButton.visible = true;  // Nayttaa palautuspainikkeen
                }
                background: Rectangle {
                    color: "#AAAAAA"  // Asettaa taustavarin
                    radius: 5  // Pyoristaa reunat
                }
                contentItem: Text {
                    text: " 🗖 " // Nayttaa maksimi-painikkeen kuvakkeen
                    font.pixelSize: 16  // Maarittaa fontin koon
                    font.bold: true  // Tekee tekstista lihavoidun
                    color: "black" // Maarittaa tekstin varin
                }
            }

            // Close button
            Button {
                id: weathercloseButton
                anchors.right: parent.right  // Asettaa painikkeen oikeaan reunaan
                anchors.verticalCenter: parent.verticalCenter  // Pitaa painikkeen pystysuunnassa keskella
                anchors.margins: 5  // Maarittaa reunavaran
                onClicked: weatherwebPopup.visible = false  // Piilottaa ikkunan kun painiketta klikataan
                background: Rectangle {
                    color: "#E95420" // Asettaa taustavarin punaiseksi
                    radius: 5  // Pyoristaa reunat
                }
                contentItem: Text {
                    text: " ✖ " // Nayttaa sulkemisikonin
                    font.pixelSize: 16  // Maarittaa fontin koon
                    font.bold: true  // Tekee tekstista lihavoidun
                    color: "white" // Maarittaa tekstin varin valkoiseksi
                }
            }
        }

        WebEngineView {
            id: weatherwebView
            width: parent.width - 20  // Maarittaa elementin leveydeksi parentin leveyden -20 pikselia
            height: parent.height - weathertitleBar.height - 20  // Maarittaa korkeuden, parentin korkeuden miinus otsikkopalkin ja 20 pikselia
            anchors.horizontalCenter: parent.horizontalCenter  // Keskittaa vaakasuunnassa parenttiin
            anchors.top: weathertitleBar.bottom  // Asettaa elementin otsikkopalkin alapuolelle
            anchors.margins: 10  // Maarittaa reunavaran kaikille sivuille
        url: "https://www.foreca.fi/Finland/Lemp%C3%A4%C3%A4l%C3%A4/10vrk"  // Maarittaa verkkosivun, joka naytetaan
    }
}





// kaytetty samaa kaavaa kuin weather WebWindowissa

// Google's Browser
Rectangle {
    id: googlemainContainer
    width: parent.width
    height: parent.height
    color: "transparent"

    Rectangle {
        id: googlewebPopup
        property bool isMaximized: false
        property real startX: 0
        property real startY: 0
        width: 600
        height: 400
        x: (googlemainContainer.width - width) / 2
        y: Math.max(clockBar.height, (googlemainContainer.height - height) / 2)
        visible: false
        z: 100
        border.color: "#222222"
        border.width: 2
        color: theme ? "#737373" : "#aaa"

        Rectangle {
            id: googletitleBar
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
                id: googleseconddragArea
                anchors.fill: parent
                onPressed: function(mouse) {
                    googlewebPopup.startX = mouse.x;
                    googlewebPopup.startY = mouse.y;
                }
                onPositionChanged: function(mouse) {
                    let newX = googlewebPopup.x + (mouse.x - googlewebPopup.startX);
                    let newY = googlewebPopup.y + (mouse.y - googlewebPopup.startY);

                    googlewebPopup.x = Math.max(0, Math.min(newX, root.width - googlewebPopup.width));
                    googlewebPopup.y = Math.max(clockBar.height, Math.min(newY, root.height - googlewebPopup.height));
                }
            }

            // Restore down button
            Button {
                id: googlerestoreButton
                anchors.right: googlecloseButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 5
                visible: googlewebPopup.isMaximized
                onClicked: {
                    googlewebPopup.width = 600;
                    googlewebPopup.height = 400;
                    googlewebPopup.x = (googlemainContainer.width - googlewebPopup.width) / 2;
                    googlewebPopup.y = (googlemainContainer.height - googlewebPopup.height) / 2;
                    googlewebPopup.isMaximized = false;
                    googlerestoreButton.visible = false;
                    googlemaximizeButton.visible = true;
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
                id: googlemaximizeButton
                anchors.right: googlerestoreButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 5
                visible: !googlewebPopup.isMaximized
                onClicked: {
                    googlewebPopup.width = googlemainContainer.width;
                    googlewebPopup.height = googlemainContainer.height - clockBar.height; // Adjusted height
                    googlewebPopup.x = 0;
                    googlewebPopup.y = clockBar.height;
                    googlewebPopup.isMaximized = true;
                    googlemaximizeButton.visible = false;
                    googlerestoreButton.visible = true;
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
                id: googlecloseButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 5
                onClicked: googlewebPopup.visible = false
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
                id: googlewebView
                width: parent.width - 20
                height: parent.height - googletitleBar.height - 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: googletitleBar.bottom
                anchors.margins: 10
                url: "https://www.google.com/"
                }
            }
        }
    }
}
