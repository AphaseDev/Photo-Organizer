/**
 * @file photoorganizermanager.cpp
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
#include "photoorganizermanager.h"

#include "pomodelmanager.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>


PhotoOrganizerManager::PhotoOrganizerManager(QObject *p_parent) :
    QObject(p_parent)
{
    connect(qApp, &QGuiApplication::aboutToQuit,              this, &PhotoOrganizerManager::onAppIsAboutToTerminate);
    connect(this, &PhotoOrganizerManager::appFinishLaunching, this, &PhotoOrganizerManager::onAppFinishLaunching);

}

PhotoOrganizerManager::~PhotoOrganizerManager()
{

}


bool PhotoOrganizerManager::launchApplication(QGuiApplication *p_app, QStringList p_arguments)
{
// #ifdef Q_OS_WIN
//     p_app->setWindowIcon(QIcon(QLatin1String(":/Icons/nemo-icon-windows.ico")));   ///< Set the icon for each window of this application (by default with the .rc file, the icon only appears for the MainWindow).
// #endif

    // Setup the application's name and version (needed for QStandardPaths::AppDataLocation and QSettings)
    this->setupApplication();

    // Initialize the application
    this->initApplication();

    return true;
}


// --- Setup Application ---

#define STR_EXPAND(tok) #tok
#define STR(tok) STR_EXPAND(tok)

void PhotoOrganizerManager::setupApplication()
{
    QCoreApplication::setOrganizationName(QStringLiteral("Aphase"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("Aphase.com"));
    QCoreApplication::setApplicationVersion(QStringLiteral(STR(APP_VERSION)));
    QCoreApplication::setApplicationName(QStringLiteral("Photo-Organizer"));

    QGuiApplication::setApplicationDisplayName(QStringLiteral(STR(APP_NAME)) + QChar::Space + QCoreApplication::applicationVersion());
}

void PhotoOrganizerManager::initApplication()
{
    this->initializeModelManager();
    this->initializeControllers();

    emit appFinishLaunching();
}

void PhotoOrganizerManager::onAppFinishLaunching()
{

}



void PhotoOrganizerManager::initializeModelManager()
{
    m_modelManager = new POModelManager(this);


}

void PhotoOrganizerManager::initializeControllers()
{
    QQuickStyle::setStyle(QStringLiteral("Material"));

    m_engine = new QQmlApplicationEngine(this);
    connect(m_engine, &QQmlApplicationEngine::quit, qApp, &QCoreApplication::quit, Qt::QueuedConnection);

    QQmlContext* l_context = m_engine->rootContext();

    // l_context->setContextProperty("modelManager", m_modelManager);



    m_engine->load(QStringLiteral("qrc:/src/Main.qml"));
}




void PhotoOrganizerManager::onAppIsAboutToTerminate()
{
    emit appIsAboutToTerminate();

#ifdef QT_DEBUG
    qWarning("# --- App is about to terminate ---");
#endif

    // Delete controllers

}
