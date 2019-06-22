import QtQuick 2.7
import QtQuick.Controls 1.4 as QC14
import QtQuick.Controls.Styles 1.4 as QCS14
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtQml 2.2
import Tools 1.0

//import "qrc:/qml/component/"
import"component"

Item {
    id: root
    anchors.fill: parent

    //表格的头部
    property var headerModel: [];
    onHeaderModelChanged: {
        tableView.loadHeader();
    }

    property var findResult: []
    property int currentFindIndex: 0
    function findNext() {
        if (findResult.length <= 0) return;
        if (currentFindIndex + 1 < findResult.length) {
            currentFindIndex++;
        } else {
            currentFindIndex = 0;
        }
        tableView.currentRow = findResult[currentFindIndex];
        tableView.positionViewAtRow(findResult[currentFindIndex], ListView.Beginning);
    }
    function findLast() {
        if (findResult.length <= 0) return;
        if (currentFindIndex - 1 >= 0) {
            currentFindIndex--;
        } else {
            currentFindIndex = findResult.length - 1;
        }
        tableView.currentRow = findResult[currentFindIndex];
        tableView.positionViewAtRow(findResult[currentFindIndex], ListView.Beginning);
    }

    //表格的数据
    property ListModel dataModel;
    //用来标识是今日还是本周或者当月: "today" / "month" / "week"
    property string tableType: ""

    //标签选项
    property var signalNames: ["个人","学校","公司","团队","购物","娱乐"]

    property var fixedNames : [""]
    property int undoCount: recorder.undoCount
    property int redoCount: recorder.redoCount

    signal showInfo(string info);
    signal dataEdited()

    //记录器，用来记录增删改操作。
    //cpp文件定义
    OperationRecorder {
        id: recorder
    }

    //更新数据
    function updateDatas() {
        tableView.updateDatas();
    }
    //上方添加count行
    function addRowsAbove(count) {
        tableView.addRowsAbove(count, true);
    }
    //下方添加count行
    function addRowsBelow(count) {
        tableView.addRowsBelow(count, true);
    }

    //末尾添加count行
    function addRowsTail(count) {
        tableView.addRowsTail(count, true);
    }


    //删除当前选中行
    function removeRowsFromCurrent() {
        tableView.removeRowsFromIndex(tableView.currentRow, 1, true);
    }

    //清空
    function clear() {
        tableView.clear(true);
    }


    //检查整字节,检查名字
    function check() {
        var err1 = tableView.checkBitLength();
        var err2 = ""

        if (root.tableType === "week") {
            err2 = tableView.checkSpecialSignals();
        } else {
            err2 = tableView.checkNames();
        }

        var err = "";
        if (err1) err += err1;
        if (err2) err += err2;
        if (err) showInfo(err);
    }

    function checkWithoutShowInfo() {
        var err2 = "";
        err2 = tableView.checkNames();
        return err2;
    }


    function redo() {
        var str = recorder.redo();
        if (!str) return;
        var data = JSON.parse(str);
        if (!data) return;
        var items = [];
        var item;
        if (data.type === OperationRecorder.Add) {
            if (data.count <= 0) {
                return;
            }
            items = data.data;
            for (var i = 0; i < items.length; ++i) {
                item = items[i];
                dataModel.insert(data.index, item);
            }
        } else if (data.type === OperationRecorder.Clear) {
            tableView.clear(false);
        } else if (data.type === OperationRecorder.Delete) {
            tableView.removeRowsFromIndex(data.index, data.count, false);
        } else if (data.type === OperationRecorder.Modify) {
            if (data.row < 0 || data.row >= dataModel.count) return;
            dataModel.setProperty(data.row, data.role, data.dataNew);
        } else {
            console.log("redo nothing");
        }
        tableView.updateDatas();
    }
    function undo() {
        var str = recorder.undo();
        if (!str) return;
        var data = JSON.parse(str);
        if (!data) return;
        var items = [];
        var item;
        if (data.type === OperationRecorder.Add) {
            tableView.removeRowsFromIndex(data.index, data.count, false);
        } else if (data.type === OperationRecorder.Delete) {
            if (data.index < 0 || data.count <= 0) {
                return;
            }
            items = data.data;
            for (var i = 0; i < items.length; ++i) {
                item = items[i];
                dataModel.insert(data.index, item);
            }
        } else if (data.type === OperationRecorder.Clear) {
            items = data.data;
            for (var i = 0; i < items.length; ++i) {
                item = items[i];
                dataModel.append(item);
            }
        } else if (data.type === OperationRecorder.Modify) {
            if (data.row < 0 || data.row >= dataModel.count) return;
            dataModel.setProperty(data.row, data.role, data.data);
        } else {
            console.log("redo nothing");
        }
        tableView.updateDatas();
    }
    function clearRecorder() {
        recorder.clear();
    }
    onVisibleChanged: {
        if (visible) {
            loadHeader();
        }
    }
    function loadHeader() {
        tableView.loadHeader();
    }
    function find(text) {
        tableView.find(text);
    }

    //用来动态创建TableView一列的组件
    Component {
        id: columnComponent
        QC14.TableViewColumn {
            width: 120
        }
    }

    //TabelView header代理
    Component {
        id: headerDelegate
        Rectangle {
            width: 300
            height: 30
            color:  "#2d2d2d"
            border.width: 1
            border.color: "#838383"
            Text {
                id: headerTextInput
                anchors.centerIn: parent
                text: styleData.value === "type" ? "事件编号" : styleData.value
                color: "#e5e5e5"

            }
        }
    }

    //TableView row代理
    Component {
        id: rowDelegate
        Item {
            anchors.leftMargin: 3
            width: tableView.width
            height: 35
        }
    }

    //偏白色
    readonly property color cellBackgroundColor: "#e4e8ec"
    //淡蓝色
    readonly property color cellCurrentRowColor: "#c2ddf5"

    readonly property color cellSelectedColor: "#4baffb"
    //TabelView item代理
    Component {
        id: itemDelegate
        //Loader 动态加载不同的组件
        Loader {
            id: itemLoader
            anchors.fill: parent
            visible: status === Loader.Ready
            //加载表格栏
            sourceComponent: {
                var role = styleData.role;

                if (role === "order")
                    return orderComponent;

                if (role === "事件")
                    return thingComponent;
                else if (role === "优先级")
                    return priorityComponent;
                else if (role === "description")
                    return descriptionComponent;
                //标签
                else if (role === "标签" || role === "maintain")
                    return defaultComponent;
                else if (role === "日期")
                    return minComponent;
                else if (role === "结束日期")
                    return maxComponent;
                else return emptyComponent;
            }

            //Note: 各种component需要写在loader内部。因为要访问styleData，在外部会提示找不到styleData
            Component {
                id: emptyComponent
                Item { }
            }

            Component {
                id: orderComponent
                Rectangle {
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#7f838c"
                    color: isSelected ? cellSelectedColor :
                                        ((tableView.currentRow === styleData.row) ?
                                             cellCurrentRowColor : cellBackgroundColor)

                    property bool isSelected: tableView.currentColumn === styleData.column &&
                                              tableView.currentRow === styleData.row
                    Text {
                        id: orderText
                        anchors.fill: parent
                        text: {
                            return styleData.row+1
                        }
                        color: parent.isSelected ? "white" : "#1c1d1f"

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                updatePositon()
                            }
                            function updatePositon() {
                                tableView.currentColumn = styleData.column;
                                parent.forceActiveFocus();
                            }
                        }
                    }
                }
            }
            Component {
                id: thingComponent
                Rectangle {
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#7f838c"
                    property bool isSelected: tableView.currentColumn === styleData.column &&
                                              tableView.currentRow === styleData.row
                    color: isSelected ? cellSelectedColor :
                                        ((tableView.currentRow === styleData.row) ?
                                             cellCurrentRowColor : cellBackgroundColor)
                    TextInput {
                        id: nameTextInput
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        text: {
                            var obj = dataModel.get(styleData.row);
                            if (obj && obj["事件"])
                                return obj["事件"]
                            return ""
                        }

                        activeFocusOnPress: true
                        selectByMouse: true
                        selectionColor: "#4283aa"
                        selectedTextColor: "#ffffff"
                        color: parent.isSelected ? (isFixedName ? "red" : "#ededed") : "#272727"
                        property bool isUserClicked: false
                        onDisplayTextChanged: {
                            if (isUserClicked) root.dataEdited();
                        }
                        onEditingFinished: {
                            if (styleData.row >= 0 && styleData.value !== text) {
                                tableView.recordModifyData(styleData.row, styleData.role, styleData.value, text);
                                dataModel.setProperty(styleData.row, styleData.role, text);
                                tableView.updateDatas();
                            }
                        }

                        MouseArea {
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
                                if (pressed) {
                                    nameTextInput.isUserClicked = true;
                                    tableView.currentColumn = styleData.column;
                                    parent.forceActiveFocus();
                                }
                                mouse.accepted = false;
                            }
                            onReleased: { mouse.accepted = false; }


                        }

                    }
                }
            }


            Component {
                id: priorityComponent
                Rectangle {
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#7f838c"

                    property bool isSelected: tableView.currentColumn === styleData.column &&
                                              tableView.currentRow === styleData.row
                    color: isSelected ? cellSelectedColor :
                                        ((tableView.currentRow === styleData.row) ?
                                             cellCurrentRowColor : cellBackgroundColor)
                    MSpinBox {
                        id: bitsSpinBox
                        anchors.fill: parent
                        anchors.margins: 1
                        boxShow: parent.isSelected
                        property var modelValue : styleData.value
                        property bool isUserClicked: false
                        onModelValueChanged: {
                            if (modelValue) {
                                value = parseInt(modelValue)
                            }
                        }
                        //小数，最小值，最大值
                        decimals: 0
                        from: 1
                        to: 10
                        onDisplayTextChanged: {
                            if (isUserClicked) root.dataEdited();
                        }
                        onEditingFinished: {
                            if (styleData.row >= 0 && styleData.value !== Number(displayText)) {
                                if (displayText) {
                                    tableView.recordModifyData(styleData.row, styleData.role, styleData.value, Number(displayText))
                                    dataModel.setProperty(styleData.row, styleData.role, Number(displayText));
                                    tableView.updateDatas();
                                }
                            }
                        }
                        onPressedChanged: {
                            if (pressed) {
                                isUserClicked = true;
                                tableView.currentColumn = styleData.column;
                                parent.forceActiveFocus();
                            } else {
                                if (styleData.row >= 0) {
                                    tableView.recordModifyData(styleData.row, styleData.role, styleData.value, value)
                                    dataModel.setProperty(styleData.row, styleData.role, value);
                                    tableView.updateDatas();
                                }
                            }
                        }
                    }
                }
            }

            //起始日期
            Component {
                id: minComponent
                Rectangle {
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#7f838c"
                    property bool isSelected: tableView.currentColumn === styleData.column &&
                                              tableView.currentRow === styleData.row
                    color: isSelected ? cellSelectedColor :
                                        ((tableView.currentRow === styleData.row) ?
                                             cellCurrentRowColor : cellBackgroundColor)
                    TextInput {
                        id: minInput
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        //                        text: (styleData.value !== undefined && styleData.value !== null) ? styleData.value : ""

                        text: {
                            var obj = dataModel.get(styleData.row);
                            if (obj && (obj[styleData.role] !== null) && (obj[styleData.role] !== "") && (obj[styleData.role] !== undefined))
                                //return parseFloat(obj[styleData.role])
                                return obj[styleData.role]
                            return ""
                        }
                        activeFocusOnPress: true
                        selectByMouse: true
                        selectionColor: "#4283aa"
                        selectedTextColor: "#ffffff"
                        color: parent.isSelected ? "#ededed" : "#272727"
                        property bool isUserClicked: false
                        //编辑完成时，将displayText写入model
                        onDisplayTextChanged: {
                            if (isUserClicked) root.dataEdited();
                        }
                        onEditingFinished: {
                            if (styleData.row >= 0 && styleData.value !== text) {
                                tableView.recordModifyData(styleData.row, styleData.role, styleData.value, text);
                                dataModel.setProperty(styleData.row, styleData.role, text);
                                tableView.updateDatas();
                            }
                        }

                        MouseArea {
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
                                if (pressed) {
                                    minInput.isUserClicked = true;
                                    tableView.currentColumn = styleData.column;
                                    parent.forceActiveFocus();
                                }
                                mouse.accepted = false;
                            }
                            onReleased: { mouse.accepted = false; }
                        }
                    }
                }
            }
            Component {
                id: maxComponent
                Rectangle {
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#7f838c"
                    property bool isSelected: tableView.currentColumn === styleData.column &&
                                              tableView.currentRow === styleData.row
                    color: isSelected ? cellSelectedColor :
                                        ((tableView.currentRow === styleData.row) ?
                                             cellCurrentRowColor : cellBackgroundColor)
                    TextInput {
                        id: maxInput
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: {
                            var obj = dataModel.get(styleData.row);
                            if (obj && (obj[styleData.role] !== null) && (obj[styleData.role] !== "") && (obj[styleData.role] !== undefined))
                                //return parseFloat(obj[styleData.role])
                                return obj[styleData.role]
                            return ""
                        }


                        activeFocusOnPress: true
                        selectByMouse: true
                        selectionColor: "#4283aa"
                        selectedTextColor: "#ffffff"
                        color: parent.isSelected ? "#ededed" : "#272727"
                        property bool isUserClicked: false
                        onDisplayTextChanged: {
                            if (isUserClicked) root.dataEdited();
                        }
                        onEditingFinished: {
                            if (styleData.row >= 0 && styleData.value !== text) {
                                tableView.recordModifyData(styleData.row, styleData.role, styleData.value, text);
                                console.log("111111")
                                dataModel.setProperty(styleData.row, styleData.role, text);
                                tableView.updateDatas();
                            }
                        }

                        MouseArea {
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
                                if (pressed) {
                                    maxInput.isUserClicked = true;
                                    tableView.currentColumn = styleData.column;
                                    parent.forceActiveFocus();
                                }
                                mouse.accepted = false;
                            }
                            onReleased: { mouse.accepted = false; }
                        }
                    }
                }
            }
            Component {
                id: descriptionComponent
                Rectangle {
                    width: parent.width
                    height: parent.height * (isSelected ? 4 : 1)
                    border.width: 1
                    border.color: "#7f838c"
                    color: isSelected ? cellSelectedColor :
                                        ((tableView.currentRow === styleData.row) ?
                                             cellCurrentRowColor : cellBackgroundColor)
                    property bool isSelected: tableView.currentColumn === styleData.column &&
                                              tableView.currentRow === styleData.row

                    TextArea {
                        id: descriptTextEdit
                        anchors.fill: parent
                        text: {
                            var obj = dataModel.get(styleData.row);
                            if (obj && obj["description"])
                                return obj["description"]
                            return ""
                        }
                        selectionColor: "#4283aa"
                        selectedTextColor: "#ffffff"
                        color: parent.isSelected ? "#ebebeb" : "#272727"
                        property bool isUserClicked: false
                        activeFocusOnPress: true
                        selectByMouse: true
                        wrapMode: TextEdit.WordWrap
                        onTextChanged: {
                            if (isUserClicked) root.dataEdited();
                        }

                        onEditingFinished: {
                            if (styleData.row >= 0 && styleData.value !== text) {
                                tableView.recordModifyData(styleData.row, styleData.role, styleData.value, text);
                                dataModel.setProperty(styleData.row, styleData.role, text);
                                tableView.updateDatas();
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onContainsMouseChanged: {
                                if (containsMouse) {
                                    cursorShape = Qt.IBeamCursor;
                                } else {
                                    cursorShape = Qt.ArrowCursor;
                                }
                            }
                            onPressed: {
                                if (pressed) {
                                    descriptTextEdit.isUserClicked = true;
                                    tableView.currentColumn = styleData.column;
                                    parent.forceActiveFocus();
                                }
                                mouse.accepted = false;
                            }
                        }
                    }
                }
            }
            Component {
                id: defaultComponent
                Rectangle {
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#7f838c"
                    color: isSelected ? cellSelectedColor :
                                        ((tableView.currentRow === styleData.row) ?
                                             cellCurrentRowColor : cellBackgroundColor)
                    property bool isSelected: tableView.currentColumn === styleData.column &&
                                              tableView.currentRow === styleData.row
                    property alias isMaintain: defaultCheckBox.checked
                    CheckBox {
                        id: defaultCheckBox

                        anchors.left: parent.left
                        anchors.leftMargin: 3
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 3
                        anchors.bottomMargin: 3
                        implicitWidth: 35
                        text: ""
                        indicator: Rectangle {
                            implicitWidth: 25
                            implicitHeight: 25
                            anchors {
                                verticalCenter: defaultCheckBox.verticalCenter
                                left: defaultCheckBox.left
                                leftMargin: 5
                            }
                            radius: 4
                            color: "transparent"
                            border.color: parent.parent.isSelected ? "#cecfd3" : "#f1f4f9"
                            border.width: 2
                            Rectangle {
                                width: 14
                                height: 14
                                anchors.centerIn: parent
                                radius: 2
                                color: defaultCheckBox.checked ? "#f1f4f9" : "#cecfd3"
                                // visible: defaultCheckBox.checked
                            }
                        }
                        checked: {
                            var obj = dataModel.get(styleData.row)
                            if (obj && obj.maintain) {
                                return true;
                            }
                            return false;
                        }
                        onCheckedChanged: {
                            tableView.currentColumn = styleData.column;
                            parent.forceActiveFocus();
                            if (tableView.controlKeyPressed && styleData.row >= 0 ) {
                                if (styleData.selected) {
                                    tableView.selection.deselect(styleData.row);
                                } else {
                                    tableView.selection.select(styleData.row);
                                }
                            } else {
                                tableView.selection.clear();
                                tableView.selection.select(styleData.row)
                            }
                        }
                    }
                    ComboBox {
                        id: defaultComboBox

                        anchors.left: defaultCheckBox.right
                        anchors.leftMargin: 3
                        anchors.right: parent.right
                        anchors.rightMargin: 3
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 3
                        anchors.bottomMargin: 3
                        visible: isMaintain
                        onVisibleChanged: {
                            if(visible) {
                                updateIndex();
                            }
                        }
                        model: root.signalNames
                        property bool isUserClicked: true
                        property bool isInited: false
                        property string modelValue: {
                            var obj = dataModel.get(styleData.row)
                            var ret;
                            if (obj && obj["maintain"]) {
                                ret = obj["maintain"];
                                isInited = true;
                            } else {
                                ret = "";
                                isInited = false;
                            }
                            return ret;
                        }
                        currentIndex: 0
                        onCurrentIndexChanged: {
                            setTextToDatamodel(currentIndex)
                            if (isUserClicked) root.dataEdited();
                        }
                        function updateIndex() {
                            if (modelValue && modelValue != "") {
                                currentIndex = find(modelValue)
                            }
                        }
                        function setTextToDatamodel(index) {
                            var row = styleData.row;
                            if (dataModel.count <= row) return;
                            var obj = dataModel.get(row);
                            if (!obj) return;
                            var str = JSON.stringify(obj)
                            obj = JSON.parse(str);
                            obj["maintain"] = textAt(index) ? textAt(index) : "";
                            dataModel.set(row, obj);
                        }
                        onPressedChanged: {
                            if (pressed) {
                                isUserClicked = true;
                                tableView.currentColumn = styleData.column;
                            }
                        }
                    }
                    TextInput {
                        id: defaultTextInput
                        anchors.left: defaultCheckBox.right
                        anchors.right: parent.right
                        anchors.rightMargin: 1
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 1
                        anchors.bottomMargin: 1
                        visible: !parent.isMaintain
                        text: {
                            var obj = dataModel.get(styleData.row);
                            if (obj && obj[styleData.role])
                                return obj[styleData.role]
                            return ""
                        }
                        activeFocusOnPress: true
                        selectByMouse: true
                        selectionColor: "#4283aa"
                        selectedTextColor: "#ffffff"
                        color: parent.isSelected ? "#ededed" : "#272727"
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        property bool isUserClicked: false                        
                        onEditingFinished: {
                            if (styleData.row >= 0 && styleData.value !== text) {
                                tableView.recordModifyData(styleData.row, styleData.role, styleData.value, text ? text : "")
                                dataModel.setProperty(styleData.row, styleData.role, text ? text : "");
                                tableView.updateDatas();
                            }
                        }
                        MouseArea {
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
                                if (pressed) {
                                    defaultTextInput.isUserClicked = true;
                                    tableView.currentColumn = styleData.column;
                                    parent.forceActiveFocus();
                                }
                                mouse.accepted = false;
                            }
                            onReleased: { mouse.accepted = false; }
                        }
                    }
                }
            }
        }
    }

    QC14.TableView {
        id: tableView
        anchors.fill: parent
        anchors.topMargin: 6

        visible: parent.visible
        frameVisible: false
        alternatingRowColors: true
        backgroundVisible : true

        //点击过cell后，记录cell的column
        property int currentColumn: -1

        //头，中，下的delegate
        headerDelegate: headerDelegate
        rowDelegate: rowDelegate
        itemDelegate: itemDelegate

        model: root.dataModel
        onModelChanged: {
            updateDatas();
        }

        //加载完成时，刷新table的头部
        Component.onCompleted: loadHeader()
        function loadHeader() {
            //循环清空tavleview
            while (tableView.columnCount > 0) {
                tableView.removeColumn(0)
            }
            updateDatas();

                //添加一列 字节号, json文件中没有
                var orderTab = columnComponent.createObject(tableView)
                orderTab.title = qsTr("序号")
                orderTab.role = "order"
                orderTab.width = 50
                tableView.addColumn(orderTab)

            for (var i = 0; i < headerModel.length; ++i) {
                var tab = columnComponent.createObject(tableView)
                var name = headerModel[i]
                tab.title = name
                tab.role = name
                if (name === "description")
                    tab.width = 300
                else if (name === "default")
                    tab.width = 160;
                tableView.addColumn(tab)
            }
        }
        function updateDatas() {
            //if (root.tableType !== "week") {
                var order = 1;
                var bits = 0;
                for (var i = 0; i < dataModel.count; ++i) {
                    var obj = dataModel.get(i);
                    //var num = obj["bits"];
                    //order += parseInt(bits / 8);
                    //bits = bits % 8 + num;
                    dataModel.setProperty(i, "order", order)
                }
            //}
        }

        readonly property var thisdayRow : {"事件": "","优先级":"1","标签":0,"description": ""}
        readonly property var thismweekRow : {"事件": "","优先级":"1", "日期": 1, "description": ""}
        readonly property var thismonthRow : {"事件": "","优先级":"1", "日期": 1, "结束日期": 1, "description": ""}

        function addRowsAbove(count, needRecord) {
            var item = thismweekRow;
            if (root.tableType === "today" )
                item = thisdayRow;
            else if (root.tableType === "week")
                item = thismonthRow;
            var index = tableView.currentRow;
            if (tableView.rowCount <= 0 || index < 0)
                index = 0;
            for (var i = 0; i < count; ++i) {
                dataModel.insert(index, item);
            }
            if (needRecord) {
                //record
                var oldData = [];
                for (var i = 0; i < count; ++i) {
                    if (index + i >= dataModel.count)
                        break;
                    oldData.push(dataModel.get(index + i));
                }

                var recordObj = Object.create(null);
                recordObj["type"] = OperationRecorder.Add;
                recordObj["index"] = index;
                recordObj["count"] = count;
                recordObj["data"] = oldData;
                recorder.record(JSON.stringify(recordObj));
            }
            updateDatas();
        }
        function addRowsBelow(count, needRecord) {
            var item = thismweekRow;
            if (root.tableType === "today" )
                item = thisdayRow;
            else if (root.tableType === "week")
                item = thismonthRow;
            var index = tableView.currentRow + 1;
            if (tableView.rowCount <= 0 || index < 0)
                index = 0;
            for (var i = 0; i < count; ++i) {
                dataModel.insert(index, item);
            }
            if (needRecord) {
                //record
                var oldData = [];
                for (var i = 0; i < count; ++i) {
                    if (index + i >= dataModel.count)
                        break;
                    oldData.push(dataModel.get(index + i));
                }
                var recordObj = Object.create(null);
                recordObj["type"] = OperationRecorder.Add;
                recordObj["index"] = index;
                recordObj["count"] = count;
                recordObj["data"] = oldData;
                recorder.record(JSON.stringify(recordObj));
            }
            updateDatas();
        }
        function addRowsTail(count, needRecord) {
            var item = thismweekRow;
            if (root.tableType === "today" )
                item = thisdayRow;
            else if (root.tableType === "week")
                item = thismonthRow;
            for (var i = 0; i < count; ++i) {
                dataModel.append(item);
            }
            if (needRecord) {
                //record
                var oldData = [];
                for (var i = count; i > 0; --i) {
                    oldData.push(dataModel.get(dataModel.count - i));
                }
                var recordObj = Object.create(null);
                recordObj["type"] = OperationRecorder.Add;
                recordObj["index"] = dataModel.count - count;
                recordObj["count"] = count;
                recordObj["data"] = oldData;
                recorder.record(JSON.stringify(recordObj));
            }
            updateDatas();
        }
        function removeRowsFromIndex(index, count, needRecord) {
            if (tableView.rowCount <= 0 || index < 0 || count <= 0) return;
            if (needRecord) {
                //record
                var oldData = [];
                for (var i = 0; i < count; ++i) {
                    if (index + i >= dataModel.count)
                        break;
                    oldData.push(dataModel.get(index + i));
                }
                var recordObj = Object.create(null);
                recordObj["type"] = OperationRecorder.Delete;
                recordObj["index"] = index;
                recordObj["count"] = count;
                recordObj["data"] = oldData;
                recorder.record(JSON.stringify(recordObj));
            }
            //remove
            for (var i = 0; i < count; ++i) {
                if (index >= dataModel.count )
                    break;
                dataModel.remove(index);
            }
            //update
            updateDatas();
        }
        function clear(needRecord) {
            if (needRecord) {
                var datas = [];
                for (var i = 0; i < dataModel.count; ++i) {
                    datas.push(dataModel.get(i));
                }
                //record
                var recordObj = Object.create(null);
                recordObj["type"] = OperationRecorder.Clear;
                recordObj["data"] = datas;
                recorder.record(JSON.stringify(recordObj));
            }
            dataModel.clear();
        }
        function recordModifyData (row, role, oldData, newData) {
            //record
            var recordObj = Object.create(null);
            recordObj["type"] = OperationRecorder.Modify;
            recordObj["row"] = row;
            recordObj["role"] = role;
            recordObj["data"] = oldData;
            recordObj["dataNew"] = newData;
            recorder.record(JSON.stringify(recordObj));
        }

        function checkNames() {
            var info = "";
            //检查 名字冲突
            var names = [];
            for (var i = 0; i < dataModel.count; ++i) {
                var obj = dataModel.get(i);
                if (obj && obj["thing"]) {
                    var thing = obj["thing"];
                    if (names.indexOf(thing) >= 0) {
                        info += "名字冲突: " + thing + "<br>";
                        break;
                    } else {
                        names.push(thing);
                    }
                }
            }
            var array = root.fixedNames;
            //检查 固定名称
            if (array.length > 0) {
                for (var i = 0; i < dataModel.count; ++i) {
                    var obj = dataModel.get(i);
                    if (obj && obj["thing"]) {
                        var index = array.indexOf(obj["thing"]);
                        if (index >= 0) {
                            array.splice(index, 1);
                        }
                    }
                }
            }

            if (array.length > 0 && array[0] !== "") {
                info += "操作成功";
                for (var i = 0; i < array.length; ++i) {
                    if (i % 4 == 0)
                        info += "<br> ";
                    info += " " + array[i];
                }
                info += "<br>";
                return info;
            }
            return info;
        }

        //查找
        function find(text) {
            var result = []
            var key = text.toLowerCase();
            for (var i = 0; i < dataModel.count; ++i) {
                var obj = dataModel.get(i);
                var str = JSON.stringify(obj).toLowerCase();
                if ( str.indexOf(key) >= 0) {
                    result.push(i);
                }
            }
            if (result.length > 0) {
                root.findResult = result;
                root.currentFindIndex = 0;
                currentRow = root.findResult[root.currentFindIndex];
                positionViewAtRow(root.findResult[root.currentFindIndex], ListView.Beginning);
            }
        }
    }
}
