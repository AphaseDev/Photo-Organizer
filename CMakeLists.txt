# Minimum CMake version recommended by Qt
cmake_minimum_required(VERSION 3.16)

# Sets a project name and the default project version. The LANGUAGES argument tells CMake that the program is written in C++
project("Photo Organizer" VERSION 1.0.2 DESCRIPTION "View and sort your picture files in one area with one click." LANGUAGES CXX)
message(STATUS "Project: ${PROJECT_NAME} ${PROJECT_VERSION}")
add_definitions(
    -DAPP_NAME=${PROJECT_NAME}
    -DAPP_VERSION=${PROJECT_VERSION}
)

# Options
option(PHOTOORGANIZER_ENABLE_TESTS "Build Photo Organizer tests" OFF)

add_compile_definitions(
    QT_STRICT_ITERATORS
    QT_NO_CAST_TO_ASCII
    QT_NO_CAST_FROM_ASCII
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# This tells CMake to look up Qt 6, and import the Core module. There is no point in continuing if CMake cannot locate
# the module, so we do set the REQUIRED flag to let CMake abort in this case.
# find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 QuickTemplates2)
find_package(Qt6 REQUIRED COMPONENTS Core Quick Widgets QuickControls2 QuickTemplates2)

# Note that this command sets the CMAKE_AUTOMOC variable to ON, which instructs CMake to automatically set up rules so that
# Qt's Meta-Object Compiler (moc) is called transparently, when required.
qt_standard_project_setup()

# Tells CMake that we want to build an executable (so not a library) called "Photo-Organizer" as a target
qt_add_executable(Photo-Organizer
    src/main.cpp
    src/Controller/photoorganizermanager.cpp
    src/Controller/photoorganizermanager.h
    src/Controller/pomodelmanager.cpp
    src/Controller/pomodelmanager.h
    src/Controller/poutils.h
    src/Controller/poutils.cpp
)

# Thanks to RCC, it will automatically creates a views.qrc file
qt_add_resources(Photo-Organizer "views"
    PREFIX "/"
    FILES
        src/View/MainWindow.qml
        src/View/Home.qml
        src/View/Organizer.qml
        src/View/Settings.qml
        qtquickcontrols2.conf
        src/View/Controls/POTextField.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(Photo-Organizer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPhoto-Organizer # FIXME
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(Photo-Organizer PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::QuickControls2
)
# target_link_libraries(ThermostatApp PRIVATE
#     Qt6::Core
#     Qt6::Gui
#     Qt6::Quick
#     Qt6::Qml
#     Qt6::Svg
#     Qt6::Charts
#     Qt6::QuickControls2
# )

include(GNUInstallDirs)
install(TARGETS Photo-Organizer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


if(PHOTOORGANIZER_ENABLE_TESTS)
    message(STATUS "Building Photo Organizer tests")
    enable_testing()
    add_subdirectory(tests)
endif()

