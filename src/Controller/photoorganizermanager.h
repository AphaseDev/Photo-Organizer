/**
 * @file photoorganizermanager.h
 * @class PhotoOrganizerManager
 * @author Benoît MOUFLIN
 * @date 2024-05-21
 *
 * @brief The PhotoOrganizerManager class
 *
 * @module Photo Organizer
 * @note This class is the main class for initializing Photo Organizer.
 *
 * Copyright (c) 2024 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
#ifndef PHOTOORGANIZERMANAGER_H
#define PHOTOORGANIZERMANAGER_H

#include <QObject>

class POModelManager;
class POWindowsController;
class QGuiApplication;
class QQmlApplicationEngine;

class PhotoOrganizerManager : public QObject
{
    Q_OBJECT

    public:
        explicit PhotoOrganizerManager(QObject *p_parent = nullptr);
        ~PhotoOrganizerManager();

        Q_DISABLE_COPY(PhotoOrganizerManager)

        // === Launching application ===
        bool launchApplication(QGuiApplication *p_app, QStringList p_arguments);

        // --- Prepare Application ---
        void setupApplication();
        void initApplication();                                     ///< App will finish launching

    signals:
        void appFinishLaunching();
        void appIsAboutToTerminate();

    public slots:
        virtual void onAppIsAboutToTerminate();                     ///< App will terminate

    private slots:
        void onAppFinishLaunching();

    private:
        void initializeModelManager();
        void initializeControllers();

        QQmlApplicationEngine*      m_engine=nullptr;
        POModelManager*             m_modelManager=nullptr;
        POWindowsController*        m_windowsController=nullptr;    ///< A reference to the shared windows controller.

};


#endif // PHOTOORGANIZERMANAGER_H
