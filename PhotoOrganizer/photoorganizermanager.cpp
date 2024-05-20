#include "photoorganizermanager.h"

PhotoOrganizerManager::PhotoOrganizerManager(QObject *parent) :
    QObject(parent)
{
    this->initializeApplication();
    this->initializePhotoOrganizerModelManager();
    this->initializeView();
}

PhotoOrganizerManager::~PhotoOrganizerManager()
{

}


void PhotoOrganizerManager::initializeApplication()
{
    QCoreApplication::setOrganizationName(QString::fromLatin1("Aphase"));
    QCoreApplication::setOrganizationDomain(QString::fromLatin1("aphase.com"));
    QCoreApplication::setApplicationVersion(QString::fromLatin1("%1").arg(APP_VERSION));
    QCoreApplication::setApplicationName(QString::fromLatin1("Photo Organizer %1").arg(APP_VERSION));
}

void PhotoOrganizerManager::initializePhotoOrganizerModelManager()
{
    m_modelManager = new PhotoOrganizerModelManager(this);


}

void PhotoOrganizerManager::initializeView()
{
    m_engine = new QQmlApplicationEngine(this);
    connect(m_engine, SIGNAL(quit()), this, SIGNAL(appQuit()));

    QQmlContext* l_context = m_engine->rootContext();

    l_context->setContextProperty("modelManager", m_modelManager);



    m_engine->load(QUrl(QLatin1String("qrc:/main.qml")));
}




