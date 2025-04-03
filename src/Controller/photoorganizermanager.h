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
class QGuiApplication;
class QQmlApplicationEngine;
class QQuickWindow;

class PhotoOrganizerManager : public QObject
{
    Q_OBJECT

    public:
        explicit PhotoOrganizerManager(QObject *p_parent = nullptr);
        virtual ~PhotoOrganizerManager() override;

        Q_DISABLE_COPY(PhotoOrganizerManager)

        // === Launching application ===
        bool launchApplication(QGuiApplication *p_app, QStringList p_arguments);

        // --- Prepare Application ---
        void setupApplication();
        void initApplication();                                 ///< App will finish launching

        QRectF getDefaultWindowFrame() const;
        bool isWindowVisible() const;

    signals:
        void appFinishLaunching();
        void closed();
        void appIsAboutToTerminate();

    public slots:
        void onAppIsAboutToTerminate();                         ///< App will terminate

    private slots:
        void onAppFinishLaunching();

        void onWindowCreated(QObject *p_object, const QUrl &p_url);
        void onWindowDestroyed();

    private:
        void initializeTypes();
        void initializeModelManager();
        void initializeControllers();

        QQmlApplicationEngine*      m_engine=nullptr;
        QQuickWindow*               m_window=nullptr;           ///< The root window object.

        POModelManager*             m_modelManager=nullptr;

};


#endif // PHOTOORGANIZERMANAGER_H
