/**
 * @file main.cpp
 * @class main
 * @author Benoît MOUFLIN
 * @date 2024-05-21
 *
 * @brief The main function
 *
 * @module Photo Organizer
 * @note
 *
 * Copyright (c) 2024 AphaseDev. All rights reserved.
 * https://github.com/AphaseDev
 */
#include <QGuiApplication>

#include "Controller/photoorganizermanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // App Manager
    PhotoOrganizerManager l_appManager;

    if (!l_appManager.launchApplication(&app, app.arguments())) {
        return 0;
    }

    return app.exec();
}
