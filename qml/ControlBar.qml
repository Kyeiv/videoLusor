import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Layouts

Rectangle {
    id: controlBar
    required property MediaPlayer mediaPlayer

    width: parent ? parent.width * 0.9 : 0
    height: 45
    color: Qt.rgba(0, 0, 0, 0.7)
    radius: 8

    readonly property bool isHovered: controlMouseArea.containsMouse ||
                                    playButton.hovered ||
                                    controlSlider.hovered

    // Public function for Main.qml to trigger visibility
    function interact() {
        controlBar.opacity = 1.0
        if (!isHovered && mediaPlayer.playbackState === MediaPlayer.PlayingState) {
            inactivityTimer.restart()
        } else {
            inactivityTimer.stop()
        }
    }

    // 1. INACTIVITY TIMER
    Timer {
        id: inactivityTimer
        interval: 1000 // Disappear after 1 second of inactivity
        repeat: false
        onTriggered: {
            // Only hide if we aren't hovering controls AND the video is playing
            if (!controlBar.isHovered && mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                controlBar.opacity = 0.0
            }
        }
    }

    // 2. PLAYBACK CONNECTIONS
    Connections {
        target: mediaPlayer
        function onPlaybackStateChanged() {
            controlBar.interact()
        }
    }

    // 3. INTERNAL HOVER LOGIC
    onIsHoveredChanged: {
        controlBar.interact()
    }

    Behavior on opacity { NumberAnimation { duration: 400 } }

    MouseArea {
        id: controlMouseArea
        anchors.fill: parent
        hoverEnabled: true
        // We don't propagate here so that double-clicking the bar itself 
        // doesn't trigger fullscreen toggle in Main
        propagateComposedEvents: false 
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 15

        Button {
            id: playButton
            hoverEnabled: true
            text: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "Pause" : "Play"
            onClicked: mediaPlayer.playbackState === MediaPlayer.PlayingState ? mediaPlayer.pause() : mediaPlayer.play()
        }

        Slider {
            id: controlSlider
            hoverEnabled: true
            Layout.fillWidth: true
            from: 0
            to: mediaPlayer.duration
            value: mediaPlayer.position
            onMoved: mediaPlayer.position = value
        }

        Rectangle {
            id: timerPill
            width: timeLabel.implicitWidth + 24
            height: 32
            radius: 16
            color: Qt.rgba(255, 255, 255, 0.1)
            Text {
                id: timeLabel
                anchors.centerIn: parent
                color: "white"
                font.bold: true
                text: {
                    var pos = Qt.formatTime(new Date(0,0,0,0,0,0,mediaPlayer.position), "mm:ss")
                    var dur = Qt.formatTime(new Date(0,0,0,0,0,0,mediaPlayer.duration), "mm:ss")
                    return pos + " / " + dur
                }
            }
        }
    }
}