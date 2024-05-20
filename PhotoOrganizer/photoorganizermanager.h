#ifndef PHOTOORGANIZERMANAGER_H
#define PHOTOORGANIZERMANAGER_H

#include <QObject>
#include <QCoreApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "photoorganizermodelmanager.h"


class PhotoOrganizerManager : public QObject
{
    Q_OBJECT

    public:
        explicit PhotoOrganizerManager(QObject *parent = 0);
        ~PhotoOrganizerManager();

    signals:
        void appQuit();

    public slots:

    private:
        void initializeApplication();
        void initializePhotoOrganizerModelManager();
        void initializeView();

        QQmlApplicationEngine*      m_engine;
        PhotoOrganizerModelManager* m_modelManager;

};


#endif // PHOTOORGANIZERMANAGER_H
