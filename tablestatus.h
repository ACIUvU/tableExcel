#ifndef TABLESTATUS_H
#define TABLESTATUS_H

#include <QDir>
#include <QObject>
#include <QQmlEngine>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QCoreApplication>
//用到的一些字符串，写成全局只读变量
const QString SIGNALS_STR = "signals";
const QString SPECIAL_SIGNALS_STR = "specialSignals";
const QString COMMANDS_STR = "commands";
const QString NAME_STR = "name";
const QString BITS_STR = "bits";

//这个类用来记录表格的一些状态
class TableStatus : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool hasSaved READ hasSaved WRITE setHasSaved NOTIFY hasSavedChanged)
    Q_PROPERTY(bool saveWithIndented READ saveWithIndented WRITE setSaveWithIndented NOTIFY saveWithIndentedChanged)
    Q_PROPERTY(QString sourceJsonFilePath READ sourceJsonFilePath WRITE setSourceJsonFilePath NOTIFY sourceJsonFilePathChanged)


    Q_PROPERTY(QStringList signalNames READ signalNames WRITE setSignalNames NOTIFY signalNamesChanged)

    Q_PROPERTY(QStringList specialSignalNames READ specialSignalNames WRITE setSpecialSignalNames NOTIFY specialSignalNamesChanged)

    Q_PROPERTY(QStringList commandNames READ commandNames WRITE setCommandNames NOTIFY commandNamesChanged)

    Q_PROPERTY(QStringList modelNames READ modelNames WRITE setModelNames NOTIFY modelNamesChanged)
    //临时工程目录
    Q_PROPERTY(QString tempFilePath READ tempFilePath NOTIFY tempFilePathChanged)
public:
    explicit TableStatus(QObject *parent = 0);
    bool hasSaved() const;
    bool saveWithIndented() const;

    const QString &sourceJsonFilePath() const;


    Q_INVOKABLE int getSignalBitByName(const QString &name);

    Q_INVOKABLE int getSpecialSignalBitByName(const QString &name);

    Q_INVOKABLE int getCommandBitByName(const QString &name);

    Q_INVOKABLE void setmodelKey(const QString &autoCompleterKey);

    const QStringList &signalNames() const;

    const QStringList &specialSignalNames() const;

    const QStringList &commandNames() const;

    const QStringList &modelNames() const;

    QString tempFilePath() const;


    Q_INVOKABLE void setMcuData(const QString &mcuData);

    Q_INVOKABLE QString loadTemplateFile(const QString &filePath);

public slots:
    void setHasSaved(bool hasSaved);

    void setSaveWithIndented(bool saveWithIndented);

    void setSourceJsonFilePath(const QString &sourceJsonFilePath);

    void setSignalNames(const QStringList &signalNames);

    void setSpecialSignalNames(const QStringList &specialSignalNames);

    void setCommandNames(const QStringList &commandNames);

    void setModelNames(const QStringList &modelNames);

signals:
    void hasSavedChanged(bool hasSaved);

    void saveWithIndentedChanged(bool saveWithIndented);

    void sourceJsonFilePathChanged(const QString &sourceJsonFilePath);

    void signalNamesChanged(const QStringList &signalNames);

    void specialSignalNamesChanged(const QStringList &specialSignalNames);

    void commandNamesChanged(const QStringList &commandNames);

    void modelNamesChanged(const QStringList &modelNames);

    void tempFilePathChanged();
private:
    QStringList frameNames(const QString &frame);
    int frameBits(const QString &frame, const QString &name);

    bool mHasSaved = true;
    bool mSaveWithIndented = true;
    QString mSourceJsonFilePath;
    QJsonDocument mMcuData;
    QStringList mSignalNames;
    QStringList mSpecialSignalNames;
    QStringList mCommandNames;
    QStringList mMcuSignalNames;
    QStringList mModelNames;
};

#endif // TABLESTATUS_H
