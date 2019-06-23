# tableExcel

APP描述：事程规划应用




历时三日完成（为期一周的实训开发两度转换项目）：

用户以日，周，月为单位归纳整理事件；

事件的property包括：优先级，标签，日期，截止日期，备注；

每一个类型的时间单位有着不同的科学规划的列表栏；

支持导入文件，保存，另存为以及事件的增 删 改 撤销 恢复 清空等基础功能；

还加入了强大的查找功能  查找处高亮  Find next 或 Find previous；

此外还加入了模板库：用户可以按自己的习惯和喜好固定下来一套方案，比如 工作期间 或 假期；





遗憾：

1.移动平台Ui相对简陋，且出现了部分文字缺失的现象；

2.为了后续增加一些难度更大，更有挑战性的功能，预留了一些变量和函数，看起来没那么精简（临近deadline 迫不得已）；






/*项目期间经验：
 * 1.MSVC2015不支持WebEngine， 构建时要选MSVC2017，并且要在pro文件中加入QT += webengine
 * 2.运行时上一个程序未关闭会有写入问题   Qt的Bug
 * 3.两个项目使用同一个构建套件 其中一个会出现Cannot retrieve debugging output
 * 4.资源文件过大是要在pro文件加入CONFIG += resources_big
 * 5.把所有图片拼接在一张图片，需要哪部分，裁剪哪部分是比较良好的方案
 * 6.使用QJsonDocument转换，规避windows和Linux平台 不一致
 * 例如：auto json = QJsonDocument::fromJson(data.toUtf8());auto data  = json.toJson();
 */
 
 
 
组长：wcy   学号：072
组员：sh    学号：064
     zzh    学号：065
