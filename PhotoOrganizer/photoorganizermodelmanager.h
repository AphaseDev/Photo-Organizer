#ifndef PHOTOORGANIZERMODELMANAGER_H
#define PHOTOORGANIZERMODELMANAGER_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QDebug>


class PhotoOrganizerModelManager : public QObject
{
    Q_OBJECT

    public:
        explicit PhotoOrganizerModelManager(QObject *parent = 0);

        Q_INVOKABLE void renameFile(const QString &p_filePath, const QString &p_oldFileName, const QString &p_fileName);
        Q_INVOKABLE void createFolder(const QString& p_dirPath, const QString& p_dirName);
        Q_INVOKABLE void moveFileToFolder(const QString& p_filePath, const QString &p_fileName, const QString& p_dirName);

    signals:

    public slots:

    private:

};

#endif // PHOTOORGANIZERMODELMANAGER_H
