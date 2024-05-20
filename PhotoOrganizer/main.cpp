#include <QGuiApplication>

#include "photoorganizermanager.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);


    PhotoOrganizerManager l_appManager;
    QObject::connect(&l_appManager, SIGNAL(appQuit()), &app, SLOT(quit()));


    return app.exec();
}
