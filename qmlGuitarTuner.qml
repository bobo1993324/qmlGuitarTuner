import QtQuick 2.0
import Ubuntu.Components 0.1
import QtMultimedia 5.0

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer..qmlGuitarTuner"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientacdtion: true

    width: units.gu(50)
    height: units.gu(75)
    property int selectedCord: 0
    property variant cordNames: ["E", "A", "D", "G", "B", "E"]
    property variant soundSource: ["6th_String_E.ogg.ogx", "5th_String_A.ogg.ogx",
                                    "4th_String_D.ogg.ogx", "3rd_String_G.ogg.ogx",
                                    "2nd_String_B_.ogg.ogx", "1st_String_E.ogg.ogx"]


    Page {
        title: i18n.tr("Guitar Tuner")

        Label {
            text: cordNames[selectedCord]
            anchors {
                bottom: cordsImage.top
                horizontalCenter: parent.horizontalCenter
            }
            font.pixelSize: units.gu(8)
        }

        Image {
            id: cordsImage
            source: "img/cords.svg"
            height: units.gu(35)
            width: height / sourceSize.height * sourceSize.width
            anchors{
                centerIn: parent
            }
        }
        Item {
            id: pointer
            width: cordsImage.width
            height: units.gu(3)
            anchors.top: cordsImage.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                width: units.gu(4)
                height: width
                x: units.gu(4) + selectedCord * units.gu(3)
                Behavior on x{
                    UbuntuNumberAnimation{}
                }

                source: "img/keyboard-caps.svg"
            }
        }

        Image {
            id: nextImage
            source: "img/go-to.svg"
            width: units.gu(8)
            height: width
            anchors {
                left: cordsImage.right
                verticalCenter: parent.verticalCenter
            }
            opacity: selectedCord < 5 ? 1.0 : 0
            Behavior on opacity{
                UbuntuNumberAnimation{}
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if (selectedCord < 5) {
                        selectedCord ++;
                    }
                }
            }
        }

        Image {
            id: prevImage
            source: "img/go-to.svg"
            width: units.gu(8)
            height: width
            rotation: 180
            anchors {
                right: cordsImage.left
                verticalCenter: parent.verticalCenter
            }
            opacity: selectedCord > 0 ? 1.0 : 0
            Behavior on opacity{
                UbuntuNumberAnimation{}
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if (selectedCord > 0) {
                        selectedCord --;
                    }
                }
            }
        }

        Image {
            id: playImage
            source: audio.isPlaying ? "img/media-playback-pause.svg" : "img/media-playback-start.svg"

            width: units.gu(8)
            height: width
            anchors{
                left: pointer.right
                top: cordsImage.bottom
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if (audio.isPlaying){
                        audio.isPlaying = false;
                        audio.stop()
                    } else {
                        audio.play()
                        audio.isPlaying = true;
                    }
                }
            }
        }

        Audio {
            id: audio
            property bool isPlaying: false
            source: "sound/" + soundSource[selectedCord]
            onStopped: if(audio.isPlaying) play()
        }
    }
}
