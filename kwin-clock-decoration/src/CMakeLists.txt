set(DECORATION_PLUGIN_ID "kwin-clock-decoration")
set(DECORATION_JSON "${CMAKE_CURRENT_SOURCE_DIR}/metadata.json")

ecm_qt_declare_logging_category(
    DECORATION_LOG_SRCS
    HEADER clockdecoration_logging.h
    IDENTIFIER CLOCK_DECORATION
    CATEGORY_NAME org.kde.kwin.clockdecoration
    DEFAULT_SEVERITY Info
)

kcoreaddons_add_plugin(
    ${DECORATION_PLUGIN_ID}
    SOURCES
        ${DECORATION_LOG_SRCS}
        clockdecoration.cpp
        clockdecoration.h
        clockbutton.cpp
        clockbutton.h
        plugin.cpp
    INSTALL_NAMESPACE "org.kde.kdecoration3"
)

target_link_libraries(${DECORATION_PLUGIN_ID}
    PRIVATE
        Qt6::Core
        Qt6::Gui
        KF6::CoreAddons
        KF6::I18n
        KF6::GuiAddons
        KDecoration3::KDecoration
)

install(FILES ${DECORATION_JSON} DESTINATION ${KDE_INSTALL_DATADIR}/kwin/decorations/${DECORATION_PLUGIN_ID})
