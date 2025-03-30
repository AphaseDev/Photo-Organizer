/**
 * @file pomodelmanager.h
 * @class POModelManager
 * @author Benoît MOUFLIN
 * @date 2024-05-21
 *
 * @brief The POModelManager class
 *
 * @module Photo Organizer
 * @note This class is respondible for managing model (file management and so on...).
 *
 * Copyright (c) 2024 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
#ifndef POMODELMANAGER_H
#define POMODELMANAGER_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QDebug>


class POModelManager : public QObject
{
    Q_OBJECT

    public:
        explicit POModelManager(QObject *p_parent=nullptr);

        Q_INVOKABLE void renameFile(const QString &p_filePath, const QString &p_oldFileName, const QString &p_fileName);
        Q_INVOKABLE void createFolder(const QString& p_dirPath, const QString& p_dirName);
        Q_INVOKABLE void moveFileToFolder(const QString& p_filePath, const QString &p_fileName, const QString& p_dirName);

    signals:

    public slots:

    private:

};

#endif // POMODELMANAGER_H
