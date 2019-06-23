//组长：wcy  学号：2017051604072
//组员：sh   学号：2017051604064
//    zzh   学号：2017051604065
//APP描述：事程规划应用
//方便用户以日，周，月为单位归纳整理事件
//每一个类型的时间单位有着不同的科学规划的列表栏
//支持事件的增 删 改 撤销 恢复 清空等基础功能
//还加入了强大的查找功能  查找处高亮  Find next 或 Find previous
//此外还加入了模板库：用户可以按自己的习惯和喜好固定下来一套方案，比如 工作期间 或 假期

//遗憾：
//1.移动平台Ui相对简陋，
//2.为了后续增加一些难度更大，更有挑战性的功能，预留了一些变量和函数，看起来没那么精简

/*项目期间经验：
 *1.MSVC2015不支持WebEngine， 构建时要选MSVC2017，并且要在pro文件中加入QT += webengine

 * 2.运行时上一个程序未关闭会有写入问题   Qt的Bug

 * 3.两个项目使用同一个构建套件 其中一个会出现Cannot retrieve debugging output

 * 4.资源文件过大是要在pro文件加入CONFIG += resources_big
 *
 * 5.把所有图片拼接在一张图片，需要哪部分，裁剪哪部分是比较良好的方案
 *
 * 6.使用QJsonDocument转换，规避windows和Linux平台 不一致
 * 例如：auto json = QJsonDocument::fromJson(data.toUtf8());auto data  = json.toJson();

 */

#include <QApplication>
#include <FelgoApplication>

#include <QQmlApplicationEngine>

#include <QQmlEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QGuiApplication>

#include "fileio.h"
#include "fileinfo.h"
#include "tablestatus.h"
#include "operationrecorder.h"

// uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
//#include <FelgoLiveClient>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    FelgoApplication felgo;

    // Use platform-specific fonts instead of Felgo's default font
    felgo.setPreservePlatformFonts(true);

    QQmlApplicationEngine engine;
    felgo.initialize(&engine);

    // Set an optional license key from project file
    // This does not work if using Felgo Live, only for Felgo Cloud Builds and local builds
    felgo.setLicenseKey(PRODUCT_LICENSE_KEY);

    // use this during development
    // for PUBLISHING, use the entry point below
    felgo.setMainQmlFileName(QStringLiteral("qml/Main.qml"));

    // use this instead of the above call to avoid deployment of the qml files and compile them into the binary with qt's resource system qrc
    // this is the preferred deployment option for publishing games to the app stores, because then your qml files and js files are protected
    // to avoid deployment of your qml files and images, also comment the DEPLOYMENTFOLDERS command in the .pro file
    // also see the .pro file for more details
    // felgo.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml"));

    //C++注册到Qml
    qmlRegisterType<FileIO>("Tools", 1, 0, "FileIO");
    qmlRegisterType<FileInfo>("Tools", 1, 0, "FileInfo");
    qmlRegisterType<OperationRecorder>("Tools", 1, 0, "OperationRecorder");
    qmlRegisterType<TableStatus>("Tools", 1, 0, "TableStatus");

    //TableStatus tableStatus;
    //QQuickView view;
    //view.engine()->rootContext()->setContextProperty("TableStatus", &tableStatus);
    //view.setSource(QUrl("qrc:/qml/Main.qml"));
    //view.setSource(QUrlfelgo.mainQmlFileName());
    //view.show();

    engine.load(QUrl(felgo.mainQmlFileName()));

    // to start your project as Live Client, comment (remove) the lines "felgo.setMainQmlFileName ..." & "engine.load ...",
    // and uncomment the line below
    //FelgoLiveClient client (&engine);

    return app.exec();
}
