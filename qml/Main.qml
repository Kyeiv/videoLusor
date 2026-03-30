import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 800
    height: 600
    visible: true
    title: "videoLusor Player"

    // Store position and dimensions to restore after FullScreen
    property int savedX: x
    property int savedY: y
    property int savedWidth: width
    property int savedHeight: height

    MediaPlayer {
        id: mediaPlayer
        videoOutput: videoDisplay
        audioOutput: AudioOutput {}
        source: "file:///D:/file_example_MP4_1920_18MG.mp4" 
    }

    Item {
        anchors.fill: parent

        VideoOutput {
            id: videoDisplay
            anchors.fill: parent
        }

        // Global Interaction Area
        MouseArea {
            id: globalMouseArea
            anchors.fill: parent
            hoverEnabled: true
            // Notify the control bar that the mouse is moving in the view
            onPositionChanged: controlBar.interact()
            
            onDoubleClicked: {
                if (root.visibility === Window.FullScreen) {
                    exitFullScreen()
                } else {
                    enterFullScreen()
                }
            }
            // Cursor hides when the bar hides
            cursorShape: controlBar.opacity > 0 ? Qt.ArrowCursor : Qt.BlankCursor

            function enterFullScreen() {
                // Save current state before they are lost to FullScreen
                savedX = root.x
                savedY = root.y
                savedWidth = root.width
                savedHeight = root.height
                root.visibility = Window.FullScreen
            }

            function exitFullScreen() {
                root.visibility = Window.Windowed
                // Restore the position and dimensions we saved
                root.x = savedX
                root.y = savedY
                root.width = savedWidth
                root.height = savedHeight
            }
        }

        // 2. THE CONTROL BAR (Extracted)
        ControlBar {
            id: controlBar
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            z: 10
            mediaPlayer: mediaPlayer
        }
    }
}