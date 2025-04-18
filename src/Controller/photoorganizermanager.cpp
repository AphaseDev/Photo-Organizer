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
#include "poutils.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QMessageBox>


PhotoOrganizerManager::PhotoOrganizerManager(QObject *p_parent) :
    QObject(p_parent)
{
    connect(this, &PhotoOrganizerManager::closed,             qApp, &QCoreApplication::quit, Qt::QueuedConnection);
    connect(this, &PhotoOrganizerManager::appFinishLaunching, this, &PhotoOrganizerManager::onAppFinishLaunching);
    connect(qApp, &QGuiApplication::aboutToQuit,              this, &PhotoOrganizerManager::onAppIsAboutToTerminate);

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
    this->initializeTypes();
    this->initializeModelManager();
    this->initializeControllers();

    emit appFinishLaunching();
}

void PhotoOrganizerManager::onAppFinishLaunching()
{

}


void PhotoOrganizerManager::initializeTypes()
{
    qmlRegisterUncreatableMetaObject(POUtils::staticMetaObject, "POModel.ui", 1, 0, "POUtils", QStringLiteral("Error: access to enums and flags only.") );

    qRegisterMetaType<POFolderOutput>("POFolderOutput");

}

void PhotoOrganizerManager::initializeModelManager()
{
    m_modelManager = new POModelManager(this);


}

void PhotoOrganizerManager::initializeControllers()
{
    // Initialize engine
    m_engine = new QQmlApplicationEngine(this);
    // Handle the created event
    connect(m_engine, &QQmlApplicationEngine::objectCreated, this, &PhotoOrganizerManager::onWindowCreated, Qt::QueuedConnection);
    // Handle the close event when calling Qt.quit() from QML
    // connect(m_engine, &QQmlApplicationEngine::quit, qApp, &QCoreApplication::quit, Qt::QueuedConnection);

    QVariantMap l_initialProperties;
    // Get the other initial properties to pass on to the window at creation time
    const QRectF l_windowFrame = this->getDefaultWindowFrame();
    l_initialProperties.insert({
        { QStringLiteral("width"), l_windowFrame.width() },
        { QStringLiteral("height"), l_windowFrame.height() }
    });

    // Expose main controller to QML
    l_initialProperties.insert({
        { QStringLiteral("modelManager"), QVariant::fromValue(m_modelManager) }
    });

    // Pass initial properties to the engine so it is set as initial property of the created window
    m_engine->setInitialProperties(l_initialProperties);
    // Show window
    m_engine->load(QStringLiteral("qrc:/src/View/MainWindow.qml"));
}

QRectF PhotoOrganizerManager::getDefaultWindowFrame() const
{
    QSizeF l_windowSize;
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    l_windowSize = QSizeF(800.0, 600.0);
#else
    l_windowSize = QSizeF(1280.0, 800.0);
#endif

    QRectF l_windowFrame;
    l_windowFrame.setSize(l_windowSize);
    return l_windowFrame;
}

/**
 * @private slot
 * @param p_object
 * @param p_url
 */
void PhotoOrganizerManager::onWindowCreated(QObject *p_object, const QUrl &p_url)
{
    Q_UNUSED(p_url)
    // qDebug() << "Object created:" << p_object << p_url;
    if (p_object) {
        m_window = qobject_cast<QQuickWindow*>(p_object);
        connect(m_window, &QQuickWindow::destroyed,      this, &PhotoOrganizerManager::onWindowDestroyed);

        // Update window title bar
        // this->updateNativeTitleBar();

    } else {
        // Error
        // L_ERROR_Obj(QStringLiteral("Error on loading window: the window %1 has not been created.").arg(p_url.fileName()));
    }

    if (!this->isWindowVisible()) {
        // Error
        // L_ERROR_Obj(QStringLiteral("Error on loading window: %1 \nThe window is not visible.").arg(p_url.toString()));

        QMessageBox l_message;
        l_message.setText(QStringLiteral("Error on loading window: %1. \nPlease verify that the application has been correctly installed.").arg(p_url.fileName()));
        l_message.exec();
        return;
    }
}

void PhotoOrganizerManager::onWindowDestroyed()
{
    m_window = nullptr;
    emit closed();
}

bool PhotoOrganizerManager::isWindowVisible() const
{
    return m_window ? m_window->property("visible").toBool() : false;
}



void PhotoOrganizerManager::onAppIsAboutToTerminate()
{
    emit appIsAboutToTerminate();

#ifdef QT_DEBUG
    qWarning("# --- App is about to terminate ---");
#endif

    // Delete controllers

}
