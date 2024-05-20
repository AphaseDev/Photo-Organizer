#include "photoorganizermodelmanager.h"

PhotoOrganizerModelManager::PhotoOrganizerModelManager(QObject *parent) : QObject(parent)
{

}

void PhotoOrganizerModelManager::renameFile(const QString& p_filePath, const QString& p_oldFileName, const QString& p_fileName)
{
    QFile l_file(p_filePath);
    QString l_fileDirPath = p_filePath.mid(0, p_filePath.length() - p_oldFileName.length());

    qDebug() << "RENAME: " << l_fileDirPath << p_fileName;

    l_file.rename(l_fileDirPath + p_fileName);
}


void PhotoOrganizerModelManager::createFolder(const QString& p_dirPath, const QString& p_dirName)
{
    QString l_dirPath = p_dirPath;
    if(l_dirPath.startsWith("file:///"))
        l_dirPath = l_dirPath.mid(8, l_dirPath.length());

    QDir l_dir;
    l_dir.setPath(l_dirPath);
    l_dir.mkdir(p_dirName);
}


void PhotoOrganizerModelManager::moveFileToFolder(const QString& p_filePath, const QString& p_fileName, const QString& p_dirName)
{
    QString l_filePath = p_filePath;
    if(l_filePath.startsWith("file:///"))
        l_filePath = l_filePath.mid(8, l_filePath.length());

    QFile l_file(l_filePath);

    l_filePath = l_filePath.mid(0, p_filePath.length() - p_fileName.length()); // dirPath

    QDir l_dir;
    l_dir.setPath(l_filePath);
    l_dir.mkdir(p_dirName);
    l_dir.cd(p_dirName);

    qDebug() << "EXISTS: " << l_filePath << l_dir.absolutePath() + QDir::separator() + p_fileName;
    l_file.rename(l_dir.absolutePath() + QDir::separator() + p_fileName);

}
