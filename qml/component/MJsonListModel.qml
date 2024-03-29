import QtQuick 2.7
import "JsonPath.js" as JsonPath
import Tools 1.0
Item {
    id: jsonListModel

    signal parseStart()
    signal parseEnd()

    //用以错误提示
    property string error: ""

    property ListModel thisday: ListModel {
        //动态角色，参考QML文档

        id: thisdayListModel; dynamicRoles: true
    }
    property ListModel thisweek: ListModel {
        id: thisweekListModel; dynamicRoles: true
    }
    property ListModel thismonth: ListModel {
        id: thismonthListModel; dynamicRoles: true
    }

    //查询
    property string thisdayQuery: ""
    property string thisweekQuery: ""
    property string thismonthQuery: ""


    property string jsonStr: ""

    //当请求查询的时候
    onThisdayQueryChanged: {
        queryToModel(thisdayListModel, thisdayQuery, null);
    }    
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
    //获取和简要处理数据文件
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
                return value;
            }, 4);
        } else {
            str = JSON.stringify(obj, function (key, value) {
                if (value === undefined || value === null || value === "")
                    return undefined;

                if (key === "order" )
                    return undefined;
                return value;
            });
        }
        return str;
    }
    //update
    function updateDatas() {
        queryToModel(thisdayListModel, thisdayQuery, null);
        queryToModel(thisweekListModel, thisweekQuery, null);
        queryToModel(thismonthListModel, thismonthQuery, null);
    }
    //使用JsonPath查询数据
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
            /*
            if (obj["invalid"]) {
                obj["invalid"] = stringToHex(obj["invalid"])
            }
            */
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
