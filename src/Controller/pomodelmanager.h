/**
 * @file pomodelmanager.h
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
#ifndef POMODELMANAGER_H
#define POMODELMANAGER_H

#include <QObject>
#include <QColor>
#include <QVariant>

/**
 * @brief Represents a destination folder for a photo.
 */
struct POFolderOutput {
    Q_PROPERTY(QString labelTitle MEMBER labelTitle)
    Q_PROPERTY(QString folderPath MEMBER folderPath)
    Q_PROPERTY(QColor buttonColor MEMBER buttonColor)

public:
    QString labelTitle;
    QString folderPath;
    QColor  buttonColor;

    Q_GADGET
};
Q_DECLARE_METATYPE(POFolderOutput)


class POModelManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString folderPath READ getFolderPath WRITE setFolderPath NOTIFY folderPathChanged FINAL)
    Q_PROPERTY(QVariantList outputFoldersLeft  READ getOutputFoldersLeftQml CONSTANT)
    Q_PROPERTY(QVariantList outputFoldersRight READ getOutputFoldersRightQml CONSTANT)

    public:
        explicit POModelManager(QObject *p_parent=nullptr);
        virtual ~POModelManager() { }

        const QString& getFolderPath() const { return m_folderPath; }
        void setFolderPath(QString p_folderPath);

        void setDefaultOutputFolders();

        QVariantList getOutputFoldersLeftQml() const;
        QVariantList getOutputFoldersRightQml() const;

        Q_INVOKABLE void renameFile(const QString &p_filePath, const QString &p_oldFileName, const QString &p_fileName);
        Q_INVOKABLE void createFolder(const QString& p_dirPath, const QString& p_dirName);
        Q_INVOKABLE void moveFileToFolder(const QString& p_filePath, const QString &p_fileName, const QString& p_dirName);

    signals:
        void folderPathChanged();
        void raiseAlert(QString l_message);

    public slots:

    private:
        bool checkFolderPath(const QString &p_folderPath);

        QString m_folderPath;       ///< The path to the folder containing the files needs to be sorted.

        QList<POFolderOutput> m_outputFoldersLeft;      ///< The output destinations folders (default or set by user) at screen's left side.
        QList<POFolderOutput> m_outputFoldersRight;     ///< The output destinations folders (default or set by user) at screen's right side.

        bool m_testMode=true;       ///< Wether the app is in testing mode or not.

};

#endif // POMODELMANAGER_H

