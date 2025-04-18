/**
 * @file pomodelmanager.cpp
 * @class POModelManager
 * @author Benoît MOUFLIN
 * @date 2024-05-21
 *
 * @brief The POModelManager class
 *
 * @module Photo Organizer
 * @note This class is responsible for managing model (file management and so on...).
 *
 * Copyright (c) 2024 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
#include "pomodelmanager.h"
#include "poutils.h"

#include <QFile>
#include <QDir>
#include <QDebug>

POModelManager::POModelManager(QObject *p_parent) :
    QObject(p_parent)
{
}


void POModelManager::setFolderPath(QString p_folderPath)
{
    if (m_folderPath != p_folderPath) {
        // Remove potential qml file prefix
        POUtils::formatQmlUrlString(p_folderPath);

        if (this->checkFolderPath(p_folderPath)) {
            m_folderPath = p_folderPath;

            if (m_outputFoldersLeft.isEmpty() && m_outputFoldersRight.isEmpty()) {
                this->setDefaultOutputFolders();
            }
        }
        // Emitting here allows to go back to the previous value of folderPath in UI
        emit folderPathChanged();
    }
}

void POModelManager::setDefaultOutputFolders()
{
    auto l_folderPath = m_folderPath;
    if (!l_folderPath.endsWith(QLatin1Char('/'))) {
        l_folderPath.append(QLatin1Char('/'));
    }

    const int l_currentYear         = QDate::currentDate().year();
    static const QString g_trip     = tr("Trip %1").arg(l_currentYear);
    static const QString g_concert  = tr("Concert %1").arg(l_currentYear);
    static const QString g_family   = tr("Family %1").arg(l_currentYear);
    static const QString g_others   = tr("Others");

    m_outputFoldersLeft  = {
        { g_trip,   l_folderPath + g_trip, QColor() },
        { g_concert, l_folderPath + g_concert, QColor() }
    };
    m_outputFoldersRight  = {
        { g_family, l_folderPath + g_family, QColor() },
        { g_others, l_folderPath + g_others, QColor() }
    };
}

QVariantList POModelManager::getOutputFoldersLeftQml() const
{
    QVariantList l_newList;
    l_newList.reserve(m_outputFoldersLeft.size());
    for (const POFolderOutput &l_item : m_outputFoldersLeft) {
        l_newList << QVariant::fromValue(l_item);
    }
    return l_newList;
}

QVariantList POModelManager::getOutputFoldersRightQml() const
{
    QVariantList l_newList;
    l_newList.reserve(m_outputFoldersRight.size());
    for (const POFolderOutput &l_item : m_outputFoldersRight) {
        l_newList << QVariant::fromValue(l_item);
    }
    return l_newList;
}

/**
 * @private
 * @brief Checks wether the given path is valid. An alert message is emitted otherwize.
 * @param p_folderPath
 * @return true if the folder path is valid, false otherwize.
 */
bool POModelManager::checkFolderPath(const QString& p_folderPath)
{
    if (p_folderPath.size() > 0 && !QFileInfo::exists(p_folderPath)) {
        // Display error
        emit raiseAlert(tr("The folder does not exist, please select a valid path."));
        return false;
    }
    return true;
}


void POModelManager::renameFile(const QString& p_filePath, const QString& p_oldFileName, const QString& p_fileName)
{
    const QString l_fileDirPath = p_filePath.mid(0, p_filePath.length() - p_oldFileName.length());
    // qDebug() << "RENAME: " << l_fileDirPath << p_fileName;

    if (QFile l_file(p_filePath); !l_file.rename(l_fileDirPath + p_fileName)) {
        // Display error
        emit raiseAlert(tr("An error occured while renaming: %1.").arg(l_file.errorString()));
    }
}


void POModelManager::createFolder(const QString& p_dirPath, const QString& p_dirName)
{
    QString l_dirPath = p_dirPath;
    if (l_dirPath.startsWith(QLatin1String("file:///"))) {
        l_dirPath = l_dirPath.mid(8, l_dirPath.length());
    }
    QDir l_dir;
    l_dir.setPath(l_dirPath);
    l_dir.mkdir(p_dirName);
}


void POModelManager::moveFileToFolder(const QString& p_filePath, const QString& p_fileName, const QString& p_dirName)
{
    QString l_filePath = p_filePath;
    if (l_filePath.startsWith(QLatin1String("file:///"))) {
        l_filePath = l_filePath.mid(8, l_filePath.length());
    }
    QFile l_file(l_filePath);

    l_filePath = l_filePath.mid(0, p_filePath.length() - p_fileName.length()); // dirPath

    QDir l_dir;
    l_dir.setPath(l_filePath);
    l_dir.mkdir(p_dirName);
    l_dir.cd(p_dirName);

    qDebug() << "EXISTS: " << l_filePath << l_dir.absolutePath() + QDir::separator() + p_fileName;
    l_file.rename(l_dir.absolutePath() + QDir::separator() + p_fileName);

}

