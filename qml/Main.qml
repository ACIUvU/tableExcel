import Felgo 3.0
import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import Tools 1.0
import "qrc:/qml/component"

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    NavigationStack {

        FlickablePage {
            Item {
                id: root
                //width: 1340
                //height: 780
                //anchors.fill:parent
                width:parent.width
                height: parent.height
                property string sourceFileName: ""

                //放到最后去
                //连接对象创建到QML信号的连接

                /*
                Connections {
                    target:tableStatus
                    //tableStatus.onSourceJsonFilePathChanged:

                    onSourceJsonFilePathChanged: {
                        if (sourceJsonFilePath) {
                            //先置空，再赋值，保证能多次加载同一个文件
                            root.sourceFileName = ""
                            root.sourceFileName = sourceJsonFilePath;
                        }
                    }
                }
                */


                //左上角
                /*
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    spacing: 5
                    Label {
                        id: mcuVersionLabel
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Mcu版本")
                        color: "#272727"
                    }

                    TextField {
                        id: mcuVersionText
                        anchors.verticalCenter: parent.verticalCenter

                        selectByMouse: true
                        background: Rectangle {
                            implicitWidth: 100
                            height: 26
                            radius: 4
                            color: "transparent"
                            border.color: mcuVersionArea.containsMouse ? "#0099cc" : "#b8b9ba"
                        }
                        //验证器
                        validator:RegExpValidator {
                            regExp: /[0-9a-zA-Z.]*/
    /*
                        }
                        onDisplayTextChanged: {
                            jsonListModel.mcuVersion = text
                            if (isInited)
                                tableStatus.hasSaved = false;
                        }
                        property bool isInited: false
                        MouseArea {
                            id: mcuVersionArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onContainsMouseChanged: {
                                if (containsMouse) {
                                    cursorShape = Qt.IBeamCursor;
                                } else {
                                    cursorShape = Qt.ArrowCursor;
                                }
                            }
                            onClicked: {
                                mouse.accepted = false;
                            }
                            onDoubleClicked: { mouse.accepted = false; }
                            onPressAndHold: {
                                mouse.accepted = false;
                            }
                            onPositionChanged: {
                                mouse.accepted = false;
                            }
                            onPressed: {
                                mouse.accepted = false;
                            }
                            onReleased: { mouse.accepted = false; }
                        }
                    }
                    Item {
                        height: parent.height
                        width: 20
                    }
                    Label {
                        id: heartBeatIntervalLabel
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("心跳帧频率")
                        color: "#272727"
                    }
                    TextField {
                        id: heartBeatIntervalText
                        anchors.verticalCenter: parent.verticalCenter
                        selectByMouse: true
                        validator:RegExpValidator {
                            regExp: /[0-9]*/
/*
                        }
                        property bool isInited: false
                        onDisplayTextChanged: {
                            if (!text || parseInt(text) === 0)
                                text = "1000"
                            jsonListModel.heartBeatInterval = parseInt(text)
                            if (isInited)
                                tableStatus.hasSaved = false;
                        }
                        background: Rectangle {
                            implicitWidth: 100
                            height: 26
                            radius: 4
                            color: "transparent"
                            border.color: heartBeatIntervalArea.containsMouse ? "#0099cc" : "#b8b9ba"
                        }
                        MouseArea {
                            id: heartBeatIntervalArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onContainsMouseChanged: {
                                if (containsMouse) {
                                    cursorShape = Qt.IBeamCursor;
                                } else {
                                    cursorShape = Qt.ArrowCursor;
                                }
                            }
                            onClicked: {
                                mouse.accepted = false;
                            }
                            onDoubleClicked: { mouse.accepted = false; }
                            onPressAndHold: {
                                mouse.accepted = false;
                            }
                            onPositionChanged: {
                                mouse.accepted = false;
                            }
                            onPressed: {
                                mouse.accepted = false;
                            }
                            onReleased: { mouse.accepted = false; }
                        }
                    }
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("ms")
                        color: "#272727"
                    }
                }
*/

                //右下角
                //FMHoverButton名字该改一改
                Row {

                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: 5
                    width: parent.width
                    spacing: 10
                    MHoverButton {
                        tipText: qsTr("加载")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource:  "qrc:/Image/Project/import.png"
                        frontImageSource: "qrc:/Image/Project/importBlue.png"
                        onClicked: {
                            forceActiveFocus();
                            mcuJsonfileDialog.openFile()
                        }
                    }

                    MHoverButton {
                        anchors.verticalCenter: parent.verticalCenter
                        tipText: {
                            if (root.sourceFileName)
                                return qsTr("保存至" + root.sourceFileName)
                            else
                                return qsTr("另存为");
                        }
                        backImageSource: "qrc:/Image/Project/save.png"
                        frontImageSource: "qrc:/Image/Project/saveBlue.png"
                        onClicked: {
                            forceActiveFocus();
                            root.noProjectSave();
                        }
                    }

                    MHoverButton {
                        tipText: qsTr("另存为")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource: "qrc:/Image/Project/saveas.png"
                        frontImageSource: "qrc:/Image/Project/saveasBlue.png"
                        onClicked: {
                            forceActiveFocus();
                            var err = tabRect.checkData();
                            if (err) {
                                root.showMessageBox(err)
                            } else {
                                root.saveAs();
                            }
                        }
                    }
/*
                    CheckBox {
                        id: indentCheckBox
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Indented格式")

                        onCheckStateChanged: {
                            tableStatus.saveWithIndented = (indentCheckBox.checkState == Qt.Checked)
                        }
                        Component.onCompleted: checked = tableStatus.saveWithIndented
                        indicator: Rectangle {
                            id: indicRect
                            implicitWidth: 22
                            implicitHeight: 22
                            radius: 3
                            anchors {
                                verticalCenter: indentCheckBox.verticalCenter
                                left: indentCheckBox.left
                                leftMargin: 5
                            }
                            color: "transparent"
                            border.width: 1.2
                            border.color: "#363636"
                            Rectangle {
                                width: 10
                                height: 10
                                anchors.centerIn: parent
                                color: "#FF5933"
                                visible: indentCheckBox.checked
                            }
                        }
                        contentItem: Text {
                            anchors.left: indicRect.right
                            anchors.leftMargin: 4
                            text: indentCheckBox.text
                            font: indentCheckBox.font
                            color: "#272727"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
*/
                    Item {
                        height: parent.height
                        width: 50
                    }
                    Item {
                        height: parent.height
                        width: currentFileText.width + 10
                        visible: true
                        Text {
                            id: currentFileText
                            text: qsTr("当前文件 " + root.sourceFileName);
                            visible: root.sourceFileName
                            anchors.centerIn: parent
                            //将此属性设置为删除适合文本项宽度的文本部分
                            elide: Text.ElideLeft
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                Row {
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 5
                        right: parent.right
                        rightMargin: 5
                    }
                    spacing: 10
                    MHoverButton {
                        id: undoButton
                        tipText: qsTr("撤销")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource: "qrc:/Image/Table/undo.png"
                        frontImageSource: "qrc:/Image/Table/undoB.png"
                        property int count: 0
                        buttonEnabled: count > 0
                        onClicked: {
                            tabRect.undo();
                            tableStatus.hasSaved = false;
                        }
                        Rectangle {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            width: 16
                            height: width
                            radius: width/2
                            color: "red"
                            visible: undoButton.count > 0
                            Text {
                                anchors.centerIn: parent
                                text: undoButton.count
                                color: "white"
                            }
                        }
                    }
                    MHoverButton {
                        id:redoButton
                        tipText: qsTr("恢复")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource: "qrc:/Image/Table/redo.png"
                        frontImageSource: "qrc:/Image/Table/redoB.png"
                        property int count: 0
                        buttonEnabled: count > 0

                        onClicked: {
                            tabRect.redo();
                            tableStatus.hasSaved = false;
                        }
                        Rectangle {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            width: 16
                            height: width
                            radius: width/2
                            color: "red"
                            visible: redoButton.count > 0
                            Text {
                                anchors.centerIn: parent
                                text: redoButton.count
                                color: "white"
                            }
                        }
                    }
                    //        FMHoverButton {
                    //            tipText: qsTr("上方添加一行")
                    //            backImageSource: "qrc:/Image/Table/insert-rowG.png"
                    //            frontImageSource: "qrc:/Image/Table/insert-rowB.png"
                    //            onClicked: {
                    //                tabRect.addRowsAbove(1);
                    //                tableStatus.hasSaved = false;
                    //            }
                    //        }
                    MHoverButton {
                        tipText: qsTr("下方添加一行")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource: "qrc:/Image/Table/insert-below.png"
                        frontImageSource: "qrc:/Image/Table/insert-belowB.png"
                        onClicked: {
                            tabRect.addRowsBelow(1);
                            tableStatus.hasSaved = false;
                        }
                    }
                    MHoverButton {
                        tipText: qsTr("末尾添加一行")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource: "qrc:/Image/Table/append-row.png"
                        frontImageSource: "qrc:/Image/Table/append-rowB.png"
                        onClicked: {
                            tabRect.addRowsTail(1);
                            tableStatus.hasSaved = false;
                        }
                    }
                    MHoverButton {
                        tipText: qsTr("删除当前行")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource: "qrc:/Image/Table/delete-row.png"
                        frontImageSource: "qrc:/Image/Table/delete-rowB.png"
                        onClicked: {
                            tabRect.removeRowsFromCurrent();
                            tableStatus.hasSaved = false;
                        }
                    }
                    MHoverButton {
                        tipText: qsTr("清空")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource: "qrc:/Image/Table/clear.png"
                        frontImageSource: "qrc:/Image/Table/clearB.png"
                        onClicked: {
                            root.showClearAllBox();
                        }
                    }

                    MSpinButton {
                        tipText: qsTr("末尾添加多行")
                        anchors.verticalCenter: parent.verticalCenter
                        backImageSource: "qrc:/Image/Table/append-mulit-row.png"
                        frontImageSource: "qrc:/Image/Table/append-mulit-rowB.png"
                        onTrigger: {
                            tabRect.addRowsTail(count);
                        }
                    }
                }


                //        文件读写
                FileIO {
                    id: fileIO
                }
                FileInfo {
                    id: fileInfo
                }

                TabBar {
                    id: columnTabBar
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    width: 300
                    height: 35
                    currentIndex: 0
                    TabButton {
                        id: signalsButton
                        text: qsTr("今日安排")
                        //text: qsTr("今日事程")
                        contentItem: Text {
                            anchors.centerIn: signalsButton
                            text: signalsButton.text
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: signalsButton.checked ? "#30D5FD" : "#787878"    //"#d5d5d5"
                        }
                        background: Rectangle {
                            implicitWidth: 120
                            implicitHeight: 35
                            color: "#F1F4F9"
                        }
                    }
                    TabButton {
                        id: specialSignalsButton
                        //text: qsTr("表格二")
                        text: qsTr("本周事程")
                        contentItem: Text {
                            anchors.centerIn: specialSignalsButton
                            text: specialSignalsButton.text
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: specialSignalsButton.checked ? "#30D5FD" : "#787878"    //"#d5d5d5"
                        }
                        background: Rectangle {
                            implicitWidth: 120
                            implicitHeight: 35
                            color: "#F1F4F9"
                        }
                    }
                    TabButton {
                        id: commandsButton
                        //text: qsTr("表格三")
                        text: qsTr("当月目标")
                        contentItem: Text {
                            anchors.centerIn: commandsButton
                            text: commandsButton.text
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: commandsButton.checked ? "#30D5FD" : "#787878"   //"#d5d5d5"
                        }
                        background: Rectangle {
                            implicitWidth: 120
                            implicitHeight: 35
                            color: "#F1F4F9"
                        }
                    }
                }

                Row {
                    anchors {
                        right: parent.right
                        rightMargin: 20
                        top: parent.top
                        topMargin: 5
                    }
                    spacing: 10
                    MTextButton {
                        id: findButton
                        width: 260
                        hitText: qsTr("搜索...")

                        backImageSourceOne: "qrc:/Image/Tools/arrowUpGray.png"
                        frontImageSourceOne: "qrc:/Image/Tools/arrowUpBlue.png"
                        isAtAboveOne: true

                        backImageSourceTwo: "qrc:/Image/Tools/arrowDownGray.png"
                        frontImageSourceTwo: "qrc:/Image/Tools/arrowDownBlue.png"
                        isAtAboveTwo: true
                        onTrigger: {
                            root.find(text)
                        }
                    }
                    MHoverButton {
                        id: templateButton
                        tipText: qsTr("导入模板")
                        backImageSource: "qrc:/Image/Tools/importG.png"
                        frontImageSource: "qrc:/Image/Tools/importO.png"
                        isAtAbove: true
                        onClicked: {
                            root.showTemplateBox();
                        }
                    }
                    /*
                    MHoverButton {
                        id: checkButton
                        tipText: qsTr("检查")
                        backImageSource: "qrc:/Image/Tools/checkG.png"
                        frontImageSource: "qrc:/Image/Tools/checkR.png"
                        isAtAbove: true
                        onClicked: {
                            tabRect.check();
                        }
                    }
                    MHoverButton {
                        id: timButton
                        tipText: qsTr("提示")
                        backImageSource: "qrc:/Image/Tools/promptG.png"
                        frontImageSource: "qrc:/Image/Tools/promptR.png"
                        isAtAbove: true
                        onClicked: {
                            var fixedName = ""
                            for (var i = 0; i < tabRect.fixedNames.length; ++i) {
                                if (i % 4 == 0)
                                    fixedName += "<br>"
                                fixedName += tabRect.fixedNames[i] + " ";
                            }
                            var tips = "
                1、bits必须大于0 <br>
                2、状态帧 必须包含以下固定名称: %1<br>
                3、下行帧 必须包含 applicationState<br>
                4、max表示计算后的数据， 计算方法:<br>
                    (原始数据 × coefficient) + offset
                ".arg(fixedName);
                            root.showMessageBox(tips);
                        }
                    }
                    */
                }
                Item {
                    id: tabRect
                    anchors {
                        left: columnTabBar.left
                        top: columnTabBar.bottom
                        right: parent.right
                        bottom: parent.bottom
                        bottomMargin: 50
                    }
                    signal addRowsAbove(int count);
                    signal addRowsBelow(int count);
                    signal addRowsTail(int count);
                    signal removeRowsFromCurrent();
                    signal clear();
                    signal updateDatas();
                    signal check();
                    signal find(string text);
                    signal redo();
                    signal undo();

                    TableStatus {
                        id: tableStatus
                    }

                    /*
                    Connections {
                        target:tableStatus
                        //tableStatus.onSourceJsonFilePathChanged:

                        onSourceJsonFilePathChanged: {
                            if (sourceJsonFilePath) {
                                //先置空，再赋值，保证能多次加载同一个文件
                                root.sourceFileName = ""
                                root.sourceFileName = sourceJsonFilePath;
                            }
                        }
                    }
                    */

                    property alias currentIndex : columnTabBar.currentIndex
                    onCurrentIndexChanged: {
                        if (currentIndex === 0) {
                            thismonthTable.visible = false;
                            thisweekTable.visible = false;
                            thisdayTable.visible = true;
                            connectToThisday();
                        } else if (currentIndex === 1) {
                            thismonthTable.visible = false;
                            thisweekTable.visible = true;
                            thisdayTable.visible = false;
                            connectToThisweek();
                        } else if (currentIndex === 2) {
                            thismonthTable.visible = true;
                            thisweekTable.visible = false;
                            thisdayTable.visible = false;
                            connectToCommands();
                        }
                        updateSignalsName();
                        updateDatas();
                    }

                    Component.onCompleted: {
                        thismonthTable.visible = false;
                        thisweekTable.visible = false;
                        thisdayTable.visible = true;
                        connectToThisday();
                    }
                    function connectToThisday() {
                        tabRect.addRowsAbove.disconnect(thismonthTable.addRowsAbove)
                        tabRect.addRowsBelow.disconnect(thismonthTable.addRowsBelow)
                        tabRect.addRowsTail.disconnect(thismonthTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.disconnect(thismonthTable.removeRowsFromCurrent)
                        tabRect.clear.disconnect(thismonthTable.clear)
                        tabRect.updateDatas.disconnect(thismonthTable.updateDatas)
                        tabRect.check.disconnect(thismonthTable.check)
                        tabRect.find.disconnect(thismonthTable.find)
                        tabRect.redo.disconnect(thismonthTable.redo)
                        tabRect.undo.disconnect(thismonthTable.undo)
                        thismonthTable.showInfo.disconnect(tabRect.showInfo)

                        tabRect.addRowsAbove.disconnect(thisweekTable.addRowsAbove)
                        tabRect.addRowsBelow.disconnect(thisweekTable.addRowsBelow)
                        tabRect.addRowsTail.disconnect(thisweekTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.disconnect(thisweekTable.removeRowsFromCurrent)
                        tabRect.clear.disconnect(thisweekTable.clear)
                        tabRect.updateDatas.disconnect(thisweekTable.updateDatas)
                        tabRect.check.disconnect(thisweekTable.check)
                        tabRect.find.disconnect(thisweekTable.find)
                        tabRect.redo.disconnect(thisweekTable.redo)
                        tabRect.undo.disconnect(thisweekTable.undo)
                        thisweekTable.showInfo.disconnect(tabRect.showInfo)

                        tabRect.addRowsAbove.connect(thisdayTable.addRowsAbove)
                        tabRect.addRowsBelow.connect(thisdayTable.addRowsBelow)
                        tabRect.addRowsTail.connect(thisdayTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.connect(thisdayTable.removeRowsFromCurrent)
                        tabRect.clear.connect(thisdayTable.clear)
                        tabRect.updateDatas.connect(thisdayTable.updateDatas)
                        tabRect.check.connect(thisdayTable.check)
                        tabRect.find.connect(thisdayTable.find)
                        tabRect.redo.connect(thisdayTable.redo)
                        tabRect.undo.connect(thisdayTable.undo)
                        thisdayTable.showInfo.connect(tabRect.showInfo)

                        findButton.buttonOneClickFuc = thisdayTable.findLast
                        findButton.buttonTwoClickFuc = thisdayTable.findNext
                        findButton.current = Qt.binding(function() {
                            return thisdayTable.currentFindIndex + 1;
                        })
                        findButton.count = Qt.binding(function() {
                            return thisdayTable.findResult.length;
                        })
                        undoButton.count = Qt.binding(function() {
                            return thisdayTable.undoCount;
                        })
                        redoButton.count = Qt.binding(function() {
                            return thisdayTable.redoCount;
                        })
                    }
                    function connectToThisweek() {
                        tabRect.addRowsAbove.disconnect(thisdayTable.addRowsAbove)
                        tabRect.addRowsBelow.disconnect(thisdayTable.addRowsBelow)
                        tabRect.addRowsTail.disconnect(thisdayTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.disconnect(thisdayTable.removeRowsFromCurrent)
                        tabRect.clear.disconnect(thisdayTable.clear)
                        tabRect.updateDatas.disconnect(thisdayTable.updateDatas)
                        tabRect.check.disconnect(thisdayTable.check)
                        tabRect.find.disconnect(thisdayTable.find)
                        tabRect.redo.disconnect(thisdayTable.redo)
                        tabRect.undo.disconnect(thisdayTable.undo)
                        thisdayTable.showInfo.disconnect(tabRect.showInfo)

                        tabRect.addRowsAbove.disconnect(thismonthTable.addRowsAbove)
                        tabRect.addRowsBelow.disconnect(thismonthTable.addRowsBelow)
                        tabRect.addRowsTail.disconnect(thismonthTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.disconnect(thismonthTable.removeRowsFromCurrent)
                        tabRect.clear.disconnect(thismonthTable.clear)
                        tabRect.updateDatas.disconnect(thismonthTable.updateDatas)
                        tabRect.check.disconnect(thismonthTable.check)
                        tabRect.find.disconnect(thismonthTable.find)
                        tabRect.redo.disconnect(thismonthTable.redo)
                        tabRect.undo.disconnect(thismonthTable.undo)
                        thismonthTable.showInfo.disconnect(tabRect.showInfo)

                        tabRect.addRowsAbove.connect(thisweekTable.addRowsAbove)
                        tabRect.addRowsBelow.connect(thisweekTable.addRowsBelow)
                        tabRect.addRowsTail.connect(thisweekTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.connect(thisweekTable.removeRowsFromCurrent)
                        tabRect.clear.connect(thisweekTable.clear)
                        tabRect.updateDatas.connect(thisweekTable.updateDatas)
                        tabRect.check.connect(thisweekTable.check)
                        tabRect.find.connect(thisweekTable.find)
                        tabRect.redo.connect(thisweekTable.redo)
                        tabRect.undo.connect(thisweekTable.undo)
                        thisweekTable.showInfo.connect(tabRect.showInfo)

                        findButton.buttonOneClickFuc = thisweekTable.findLast
                        findButton.buttonTwoClickFuc = thisweekTable.findNext
                        findButton.current = Qt.binding(function() {
                            return thisweekTable.currentFindIndex + 1;
                        })
                        findButton.count = Qt.binding(function() {
                            return thisweekTable.findResult.length;
                        })
                        undoButton.count = Qt.binding(function() {
                            return thisweekTable.undoCount;
                        })
                        redoButton.count = Qt.binding(function() {
                            return thisweekTable.redoCount;
                        })
                    }

                    function connectToCommands() {
                        tabRect.addRowsAbove.disconnect(thisdayTable.addRowsAbove)
                        tabRect.addRowsBelow.disconnect(thisdayTable.addRowsBelow)
                        tabRect.addRowsTail.disconnect(thisdayTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.disconnect(thisdayTable.removeRowsFromCurrent)
                        tabRect.clear.disconnect(thisdayTable.clear)
                        tabRect.updateDatas.disconnect(thisdayTable.updateDatas)
                        tabRect.check.disconnect(thisdayTable.check)
                        tabRect.find.disconnect(thisdayTable.find)
                        tabRect.redo.disconnect(thisdayTable.redo)
                        tabRect.undo.disconnect(thisdayTable.undo)
                        thisdayTable.showInfo.disconnect(tabRect.showInfo)

                        tabRect.addRowsAbove.disconnect(thisweekTable.addRowsAbove)
                        tabRect.addRowsBelow.disconnect(thisweekTable.addRowsBelow)
                        tabRect.addRowsTail.disconnect(thisweekTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.disconnect(thisweekTable.removeRowsFromCurrent)
                        tabRect.clear.disconnect(thisweekTable.clear)
                        tabRect.updateDatas.disconnect(thisweekTable.updateDatas)
                        tabRect.check.disconnect(thisweekTable.check)
                        tabRect.find.disconnect(thisweekTable.find)
                        tabRect.redo.disconnect(thisweekTable.redo)
                        tabRect.undo.disconnect(thisweekTable.undo)
                        thisweekTable.showInfo.disconnect(tabRect.showInfo)

                        tabRect.addRowsAbove.connect(thismonthTable.addRowsAbove)
                        tabRect.addRowsBelow.connect(thismonthTable.addRowsBelow)
                        tabRect.addRowsTail.connect(thismonthTable.addRowsTail)
                        tabRect.removeRowsFromCurrent.connect(thismonthTable.removeRowsFromCurrent)
                        tabRect.clear.connect(thismonthTable.clear)
                        tabRect.updateDatas.connect(thismonthTable.updateDatas)
                        tabRect.check.connect(thismonthTable.check)
                        tabRect.find.connect(thismonthTable.find)
                        tabRect.redo.connect(thismonthTable.redo)
                        tabRect.undo.connect(thismonthTable.undo)
                        thismonthTable.showInfo.connect(tabRect.showInfo)

                        findButton.buttonOneClickFuc = thismonthTable.findLast
                        findButton.buttonTwoClickFuc = thismonthTable.findNext
                        findButton.current = Qt.binding(function() {
                            return thismonthTable.currentFindIndex + 1;
                        })
                        findButton.count = Qt.binding(function() {
                            return thismonthTable.findResult.length;
                        })
                        undoButton.count = Qt.binding(function() {
                            return thismonthTable.undoCount;
                        })
                        redoButton.count = Qt.binding(function() {
                            return thismonthTable.redoCount;
                        })
                    }
                    function showInfo(info) {
                        root.showMessageBox(info)
                    }

                    function checkData() {
                        var err1 =  thisdayTable.checkWithoutShowInfo();
                        if (err1) {
                            return "今日安排 " + err1;
                        }

                        var err2 = thisweekTable.checkWithoutShowInfo();
                        if (err2) {
                            return "本周事程 " + err2;
                        }

                        var err3 = thismonthTable.checkWithoutShowInfo();
                        if (err3) {
                            return "当月目标" + err3
                        }
                        /*
                        if (jsonListModel.mcuVersion === "" || jsonListModel.mcuVersion === "0") {
                            return "请输入Mcu版本";
                        }
                        return "";
                        */
                    }

                    function clearReocrder() {
                        thisdayTable.clearRecorder();
                        thisweekTable.clearRecorder();
                        thismonthTable.clearRecorder();
                    }
                    property variant signalNames;
                    function updateSignalsName() {
                        var array = [];
                        //手动放入一个空字符串
                        array.push("")
                        var model = jsonListModel.thisday;
                        for (var i = 0; i < model.count; ++i) {
                            var obj = model.get(i);
                            if (obj.name) {
                                array.push(obj.name)
                            }
                        }
                        signalNames = array;
                    }
                    //header数据
                    //今日安排
                    readonly property var signalsHeaderModel: [
                        //"name", "bits", "coefficient", "offset", "min", "max", "invalid", "description"
                        "事件", "优先级","标签","description"
                    ]
                    //本周事程
                    readonly property var specialSignalHeaderModel: [
                        //"type", "name", "description"
                        "事件","优先级", "日期","description"
                    ]
                    //当月目标
                    readonly property var commandsHeaderModel: [
                        //"name","bits","default","min", "max", "description"
                        "事件","优先级","日期","结束日期","description"
                    ]
                    //固定名称
                    readonly property var fixedNames : [
                        "rpm", "igOn", "theme", "language", "dateTime",
                        "enterKey", "backKey", "nextKey", "prevKey", "speed",
                        "hwVersionMax", "hwVersionMid", "hwVersionMin",
                        "mcuVersionMax", "mcuVersionMid", "mcuVersionMin", "projectModeEnabled"
                    ]
                    Rectangle {
                        id: busyRect
                        z: 3
                        anchors.fill: parent
                        visible: false
                        function open() {
                            visible = true;
                        }
                        function close() {
                            busyTimer.restart()
                        }
                        Timer {
                            id: busyTimer
                            running: false
                            repeat: false
                            interval: 500
                            onTriggered: busyRect.visible = false
                        }
                        BusyIndicator {
                            id: busyIndicator
                            running: true
                            anchors.centerIn: parent
                            visible: parent.visible
                        }
                    }
                    //data数据
                    MJsonListModel {
                        id: jsonListModel
                        //heartBeatIntervalQuery: "$.heartBeatInterval"
                        //mcuVersionQuery: "$.version"
                        /*
                        thisdayQuery: "$.signals[*]"
                        thisweekQuery: "$.specialSignals[*]"
                        thismonthQuery: "$.commands[*]"
                        */
                        thisdayQuery: "$.today[*]"
                        thisweekQuery: "$.week[*]"
                        thismonthQuery: "$.month[*]"

                        property string source: root.sourceFileName
                        onSourceChanged: {
                            if (source) {
                                //heartBeatIntervalText.isInited = false
                                //mcuVersionText.isInited = false
                                loadFromSource(source);
                            }
                        }
                        onErrorChanged:  {
                            if (error) {
                                //加载出错时，弹窗提示错误信息
                                busyRect.close();
                                root.showMessageBox(error);
                            }
                        }
                        onParseStart: {
                            busyRect.open();
                        }
                        onParseEnd: {
                            tabRect.updateDatas();
                            //mcuVersionText.text = mcuVersion
                            //heartBeatIntervalText.text = heartBeatInterval
                            //heartBeatIntervalText.isInited = true
                            //mcuVersionText.isInited = true
                            busyRect.close();
                            //tableStatus.hasLoadedModel = true;
                            tableStatus.setMcuData(jsonListModel.getModelData(false));
                            tabRect.clearReocrder();
                            var err = tabRect.checkData();
                            if (err) {
                                root.showMessageBox(err)
                            }
                        }
                    }

                    MTable {
                        id: thisdayTable
                        visible: false
                        dataModel: jsonListModel.thisday
                        headerModel: tabRect.signalsHeaderModel
                        fixedNames: tabRect.fixedNames
                        tableType: "today"
                        onDataEdited: {
                            tableStatus.hasSaved = false;
                            //将数据string给出到TableStatus
                            tableStatus.setMcuData(jsonListModel.getModelData(false));
                        }
                    }
                    MTable {
                        id: thisweekTable
                        visible: false
                        dataModel: jsonListModel.thisweek
                        headerModel: tabRect.specialSignalHeaderModel
                        fixedNames: [""]
                        tableType: "week"
                        onDataEdited: {
                            tableStatus.hasSaved = false;
                            //将数据string给出到TableStatus
                            tableStatus.setMcuData(jsonListModel.getModelData(false));
                        }
                    }
                    MTable {
                        id: thismonthTable
                        visible: false
                        dataModel: jsonListModel.thismonth
                        headerModel: tabRect.commandsHeaderModel
                        fixedNames: ["applicationState"]
                        tableType: "month"
                        signalNames: tabRect.signalNames
                        onDataEdited: {
                            tableStatus.hasSaved = false;
                            //将数据string给出到TableStatus
                            tableStatus.setMcuData(jsonListModel.getModelData(false));
                        }
                    }
                }
                Component {
                    id: templateWindow
                    Item {
                        y: 28
                        width: 400
                        height: 200
                        Row {
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -20
                            spacing: 30
                            Repeater {
                                model: ListModel {
                                    ListElement {
                                        name: "正常工作日";
                                        backIcon: "qrc:/Image/Template/simpleTemplateIconG.png";
                                        frontIcon: "qrc:/Image/Template/simpleTemplateIcon.png";
                                        path:":/Json/sample.json"
                                    }
                                    ListElement {
                                        name: "项目过程";
                                        backIcon: "qrc:/Image/Template/fuelCarG.png";
                                        frontIcon: "qrc:/Image/Template/fuelCar.png";
                                        path:":/Json/fuelCar.json"
                                    }
                                    ListElement {
                                        name: "考试月";
                                        backIcon: "qrc:/Image/Template/electrombileG.png";
                                        frontIcon: "qrc:/Image/Template/electrombile.png";
                                        path:":/Json/electricCar.json"
                                    }

                                    ListElement {
                                        name: "假期";
                                        backIcon: "qrc:/Image/Template/hybridG.png";
                                        frontIcon: "qrc:/Image/Template/hybrid.png";
                                        path:":/Json/mixingCar.json"
                                    }

                                }
                                MHoverButton {
                                    width: 50
                                    height: 50
                                    backImageSource: backIcon
                                    frontImageSource: frontIcon
                                    tipText: name
                                    onClicked: {
                                        var ret = tableStatus.loadTemplateFile(path)
                                        if (ret !== "") {
                                            console.log(ret)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                function loadFromJson(filePath) {
                    //先置空，再赋值，保证能多次加载同一个文件
                    root.sourceFileName = ""
                    root.sourceFileName = filePath;
                    columnTabBar.currentIndex = 0;
                    tableStatus.hasSaved = true;
                }
                function saveToJson(filePath, withReloadEvent) {
                    var err = jsonListModel.saveModelsToFile(filePath, tableStatus.saveWithIndented)
                    if (err !== "") {
                        root.showMessageBox(qsTr("保存出错： " + err));
                    } else {
                        tableStatus.hasSaved = true;
                        root.sourceFileName = filePath;
                    }
                }
                function showClearAllBox() {
                    popDialog.reset();
                    popDialog.open();
                    popDialog.title = "警告"
                    popDialog.cancleButtonVisible = true;
                    popDialog.text = "确定要清空全部内容吗？"
                    popDialog.width = 400;
                    popDialog.height = 200;
                    popDialog.okClickFunc = function() {
                        tabRect.clear();
                        tableStatus.hasSaved = false;
                        popDialog.close();
                    }
                }
                function showMessageBox(message) {
                    popDialog.reset();
                    popDialog.open();
                    popDialog.title = "提示"
                    popDialog.cancleButtonVisible = false;
                    popDialog.text = message
                    popDialog.width = 600;
                    popDialog.height = 400;
                    popDialog.okClickFunc = function() {
                        tabRect.clear();
                        tableStatus.hasSaved = false;
                        popDialog.close();
                    }

                }
                function showTemplateBox() {
                    popDialog.reset();
                    popDialog.open();
                    popDialog.title = "模板库"
                    popDialog.okButtonText = "关闭"
                    popDialog.cancleButtonVisible = false;
                    popDialog.text = ""
                    popDialog.width = 400;
                    popDialog.height = 200;
                    popDialog.contentComponent = templateWindow
                }
                function noProjectSave() {
                    var err = tabRect.checkData();
                    if (err) {
                        root.showMessageBox(err)
                    } else {
                        if (root.sourceFileName) {
                            root.saveToJson(root.sourceFileName, false);
                        } else {
                            saveAs();
                        }
                    }
                }
                function projectSave() {
                    if (tableStatus.sourceJsonFilePath) {
                        var err = tabRect.checkData();
                        if (err) {
                            root.showMessageBox(err)
                        } else {
                            root.saveToJson(tableStatus.sourceJsonFilePath, false);
                        }
                    }
                }
                function saveAs() {
                    var err = tabRect.checkData();
                    if (err) {
                        root.showMessageBox(err)
                    } else {
                        mcuJsonfileDialog.saveFile();
                    }
                }
                function projectClose() {
                    thisdayTable.clear();
                    thisweekTable.clear();
                    thismonthTable.clear();
                    root.sourceFileName = "";
                    tableStatus.hasSaved = true;
                    //heartBeatIntervalText.isInited = false
                    //mcuVersionText.isInited = false
                }


                function find(text) {
                    tabRect.find(text)
                }
                //加载，保存 对话框
                FileDialog {
                    id: mcuJsonfileDialog
                    visible: false
                    folder: shortcuts.home
                    selectFolder: false
                    selectMultiple: false
                    sidebarVisible: true
                    nameFilters: [ "Json files (*.json )"]
                    property bool useForSave: false
                    //Dialog得到的路径都是url，为了避免url和string到处混用(file://)，这里约定:
                    //在Dialog内部给出的路径全部转换为string，再传递给dialog外部，外部不使用url
                    onAccepted: {
                        if (useForSave) {
                            root.saveToJson(fileInfo.toLocal(fileUrl), false);
                        } else {
                            root.loadFromJson(fileInfo.toLocal(fileUrl));
                        }
                    }
                    function openFile() {
                        useForSave = false
                        title = qsTr("选择一个 json 格式的文件")
                        nameFilters = [ "json files (*.json )"]
                        selectExisting = true;
                        open();
                    }
                    function saveFile() {
                        useForSave = true
                        nameFilters = [ "json files (*.json )"]
                        title = qsTr("创建一个 json 文件")
                        selectExisting = false;
                        open();
                    }
                }
                MPopDialog {
                    id: popDialog
                    width: 600
                    height: 400
                }
            }
        }

    }
}
