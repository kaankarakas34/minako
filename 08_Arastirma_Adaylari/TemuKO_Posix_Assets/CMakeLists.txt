cmake_minimum_required(VERSION 3.10)
project(KnightOnlineServer CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Definiciones multiplataforma (Compatibilidad hacia atrás para Windows si se compila allí)
if(WIN32)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS -DWIN32_LEAN_AND_MEAN -DNOMINMAX)
else()
    # Flags para Linux/macOS
    add_compile_options(-Wno-multichar -Wno-narrowing -Wno-format)
endif()

# Dependencias Multiplataforma
find_package(Threads REQUIRED)

add_subdirectory(scripting)
add_subdirectory(shared)
add_subdirectory(LogInServer)
add_subdirectory(GameServer)
