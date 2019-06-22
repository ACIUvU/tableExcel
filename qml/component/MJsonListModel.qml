import QtQuick 2.7
import "JsonPath.js" as JsonPath
import Tools 1.0
Item {
    id: jsonListModel

    signal parseStart()
    signal parseEnd()

    property string error: ""

    //默认1000
    //property int heartBeatInterval: 1000
    //property string mcuVersion: ""
    /*
    property ListModel signalsModel: ListModel {
        id: signalsListModel; dynamicRoles: true
    }
    property ListModel specialthisday: ListModel {
        id: specialsignalsListModel; dynamicRoles: true
    }
    property ListModel commandsModel: ListModel {
        id: commandsModelListModel; dynamicRoles: true
    }
    */
    property ListModel thisday: ListModel {
        //动态角色

        id: thisdayListModel; dynamicRoles: true
    }
    property ListModel thisweek: ListModel {
        id: thisweekListModel; dynamicRoles: true
    }
    property ListModel thismonth: ListModel {
        id: thismonthListModel; dynamicRoles: true
    }
    //property string heartBeatIntervalQuery: ""
    //property string mcuVersionQuery: ""
    /*
    property string signalsQuery: ""
    property string specialSignalsQuery: ""
    property string commandsQuery: ""
    */
    //查询
    property string thisdayQuery: ""
    property string thisweekQuery: ""
    property string thismonthQuery: ""
    /*
    readonly property var specialSignalsHeader: [
        "type", "name", "description"
    ]
    */

    property string jsonStr: ""

    /*
    onHeartBeatIntervalQueryChanged: {
        var retArray = queryFromJsonToArray(heartBeatIntervalQuery);
        var val = parseInt(retArray);
        if (val) {
            heartBeatInterval = val;
        } else {
            heartBeatInterval = 1000;
        }
    }
    onMcuVersionQueryChanged: {
        var retArray = queryFromJsonToArray(mcuVersionQuery);
        if (retArray) {
            var str = retArray.toString();
            mcuVersion = str;
        }
    }
    */
    /*
    onSignalsQueryChanged: {
        queryToModel(thisdayListModel, thisdayQuery, null);
    }
    onSpecialSignalsQueryChanged: {
        queryToModel(thisweekListModel, thisweekQuery, specialSignalsHeader);
    }
    onCommandsQueryChanged: {
        queryToModel(thismonthListModel, thismonthQuery, null);
    }
    */
    onThisdayQueryChanged: {
        queryToModel(thisdayListModel, thisdayQuery, null);
    }
    /*
    onThisweekQueryChanged: {
        queryToModel(thisweekListModel, thisweekQuery, specialSignalsHeader);
    }
    */
    onThisweekQueryChanged: {
        queryToModel(thisweekListModel, thisweekQuery, null);
    }
    onThismonthQueryChanged: {
        queryToModel(thismonthListModel, thismonthQuery, null);
    }

    //加载源文件
    function loadFromSource(source) {
        jsonListModel.parseStart();
        var ret = fileIO.readFile(source);
        if (ret === "") {
            error = fileIO.getErrorString();
            //error = fileIO.errorString()
        } else {
            error = "";
            jsonStr = ret;
        }
        updateDatas();
        jsonListModel.parseEnd();
    }
    //保存models数据到文件
    function saveModelsToFile(filePath, isIndented) {
        var str = getModelData(isIndented);
        //write to file
        if (!fileIO.writeFile(filePath, str)) {
            var err = fileIO.getErrorString();
            return err;
        } else {
            return "";
        }
    }
    function getModelData(isIndented) {
        var thisdayArray = getObjectsToArray(thisday);
        var thisweekArray = getObjectsToArray(thisweek);
        var thismonthArray = getObjectsToArray(thismonth);

        var obj = Object.create(null);
        //filte default and maintain in month
        for (var i = 0; i < thismonthArray.length; ++i) {
            var commandObj = thismonthArray[i];
            if (commandObj["maintain"] !== undefined) {
                var newObj = new Object;
                var filterName = "default";
                if (commandObj["maintain"] === "") {
                    //delete maintain
                    filterName = "maintain";
                }
                var keys = Object.keys(commandObj);
                for (var index in keys) {
                    var key = keys[index];
                    if (key !== filterName) {
                        newObj[key] = commandObj[key];
                    }
                }
                thismonthArray[i] = newObj;
            }
        }
        //obj.version = mcuVersion;
        //obj.heartBeatInterval = (heartBeatInterval === 0 ? 1000 : heartBeatInterval);
        obj.today =  thisdayArray;
        obj.week = thisweekArray;
        obj.month = thismonthArray;
        var str = "";
        if (isIndented) {
            str = JSON.stringify(obj, function (key, value) {
                if (value === undefined || value === null || value === "")
                    return undefined;
                if (key === "order" )
                    return undefined;
                if ( key === "default") {
                    if (Number(value) != undefined)
                        return Number(value);
                    else
                        return undefined;
                }
                return value;
            }, 4);
        } else {
            str = JSON.stringify(obj, function (key, value) {
                if (value === undefined || value === null || value === "")
                    return undefined;
                //if (key === "order" || key === "objectName" || key === "logicMax")
                if (key === "order" )
                    return undefined;
                if (key === "default") {
                    if (Number(value) != undefined)
                        return Number(value);
                    else
                        return undefined;
                }
                return value;
            });
        }
        return str;
    }
    //update
    function updateDatas() {
        //var retArray = queryFromJsonToArray(heartBeatIntervalQuery);
        //var val = parseInt(retArray);
        /*
        if (val) {
            heartBeatInterval = val;
        } else {
            heartBeatInterval = 1000;
        }

        retArray = queryFromJsonToArray(mcuVersionQuery)
        if (retArray) {
            var str = retArray.toString();
            mcuVersion = str;
        }
        */

        queryToModel(thisdayListModel, thisdayQuery, null);
        //queryToModel(thisweekListModel, thisweekQuery, specialSignalsHeader);
        queryToModel(thisweekListModel, thisweekQuery, null);
        queryToModel(thismonthListModel, thismonthQuery, null);
    }
    //使用JsonPath查询数据, 不影响model
    function queryFromJsonToArray(query) {
        if (jsonStr === "" || query === "")
            return [];
        var objectArray;
        try {
            objectArray = JSON.parse(jsonStr);
        } catch (err) {
            error = String(err)
        }
        objectArray = JsonPath.jsonPath(objectArray, query);
        return objectArray;
    }

    //从Json查询数据，并添加到model
    function queryToModel (model, query, fliter) {
        if (jsonStr === "" || query === "") {
            return;
        }
        var objectArray;
        try {
            objectArray = JSON.parse(jsonStr);
        } catch (err) {
            error = String(err)
        }
        model.clear();
        objectArray = JsonPath.jsonPath(objectArray, query);
        for (var key in objectArray) {
            var obj = objectArray[key];

            //invalid convert to Hex
            if (obj["invalid"]) {
                obj["invalid"] = stringToHex(obj["invalid"])
            }
            //fliter no need key and value
            if (fliter && fliter.length > 0) {
                var newObj = Object.create(null);
                var fliterKeys = Object.keys(obj);
                for (var i = 0; i < fliterKeys.length; ++i) {
                    var fliterKey = fliterKeys[i];
                    if (fliter.indexOf(fliterKey) >= 0) {
                        newObj[fliterKey] = obj[fliterKey];
                    }
                }
                model.append(newObj);
            } else {
                model.append(obj);
            }
        }
    }
    function stringToHex(str) {
        var ret = "";
        var list = String(str).split(',');
        for (var i = 0; i < list.length; ++i) {
            var s = list[i]
            if (i === 0) {
                ret += "0x" + parseInt(s).toString(16)
            } else {
                ret += ",0x" + parseInt(s).toString(16)
            }
        }
        return ret;
    }
    function getObjectsToArray(model) {
        var array = []
        for (var i = 0; i < model.count; ++i) {
            array.push(model.get(i))
        }
        return array
    }
    FileIO {
        id: fileIO
    }
}
