cmake_minimum_required(VERSION 3.26)

project(simplePlayer
    VERSION 1.0.0
    DESCRIPTION "simplePlayer"
    LANGUAGES CXX
)

# ─── Global CMake / Qt settings ───────────────────────────────────────────────

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# AUTOMOC is ON — required by qt_add_qml_module metatype generation.
# We mark every .cppm file as SKIP_AUTOMOC individually below.
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC OFF)
set(CMAKE_AUTOUIC OFF)

# ─── Dependencies ─────────────────────────────────────────────────────────────

find_package(Qt6 6.6 REQUIRED COMPONENTS
    Gui
    GuiPrivate
    Qml
    Quick
    QuickControls2
    Multimedia
    ShaderTools
)

# ─── Targets ──────────────────────────────────────────────────────────────────

qt_add_executable(simplePlayer
    src/main.cpp
)

target_compile_definitions(simplePlayer PRIVATE QT_QML_DEBUG)

# ── QML module — receives the JSON files so it can build metatypes ──────────
qt_add_qml_module(simplePlayer
    URI simplePlayer
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/ControlBar.qml
)

# ── Links ───────────────────────────────────────────────────────────────────
target_include_directories(simplePlayer PRIVATE 
    src/
    )

target_link_libraries(simplePlayer PRIVATE
    Qt6::Gui
    Qt6::GuiPrivate
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Multimedia
    Qt6::ShaderTools
)

set_target_properties(simplePlayer PROPERTIES
    CXX_SCAN_FOR_MODULES ON
    # Ensures a clean .exe on Windows with no extra console window
    WIN32_EXECUTABLE $<NOT:$<CONFIG:Debug>>
    MACOSX_BUNDLE TRUE
)

# ─── Deployment (DLL / framework bundling) ────────────────────────────────────

# qt_generate_deploy_qml_app_script is the canonical Qt 6.5+ way to deploy
# a QML application. It calls windeployqt / macdeployqt / linuxdeployqt
# under the hood and correctly resolves QML module dependencies.
install(TARGETS simplePlayer
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET      simplePlayer
    OUTPUT_SCRIPT QML_DEPLOY_SCRIPT
    # Copies all required Qt DLLs / plugins  / QML modules next to the exe.
    NO_UNSUPPORTED_PLATFORM_ERROR
    NO_TRANSLATIONS               # remove if you ship Qt translations
)
install(SCRIPT ${QML_DEPLOY_SCRIPT})

# ─── Tests ────────────────────────────────────────────────────────────────────

include(CTest)
enable_testing()