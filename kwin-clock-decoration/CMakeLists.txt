cmake_minimum_required(VERSION 3.22)

project(kwin-clock-decoration VERSION 0.2.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM 5.249 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMQtDeclareLoggingCategory)

# Ensure plugins go to the user Qt6 plugin path (needed so KWin finds them without QT_PLUGIN_PATH)
set(KDE_INSTALL_PLUGINDIR "${CMAKE_INSTALL_PREFIX}/lib/qt6/plugins" CACHE PATH "Qt plugin install dir" FORCE)

find_package(Qt6 REQUIRED COMPONENTS Core Gui)
find_package(KF6 REQUIRED COMPONENTS CoreAddons GuiAddons I18n Config)

# KDecoration3 (Plasma 6) provides the decoration API
find_package(KDecoration3 CONFIG REQUIRED)

add_subdirectory(src)
