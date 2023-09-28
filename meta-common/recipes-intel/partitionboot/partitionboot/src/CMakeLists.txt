cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# Set project name here
project(partitionboot)

option(BUILD_STANDALONE "Use outside of YOCTO depedencies system" OFF)

# set(BUILD_SHARED_LIBRARIES ON)
# option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} \
    -Werror \
    -Wall \
    -Wextra \
    -Wshadow \
    -Wnon-virtual-dtor \
    -Wold-style-cast \
    -Wcast-align \
    -Wunused \
    -Woverloaded-virtual \
    -Wpedantic \
    -Wconversion \
    -Wnull-dereference \
    -Wdouble-promotion \
    -Wformat=2 \
")

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  set(CMAKE_CXX_FLAGS
      "${CMAKE_CXX_FLAGS} \
        -Wuseless-cast \
        -Wduplicated-cond \
        -Wduplicated-branches \
        -Wlogical-op \
    ")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set(CMAKE_CXX_FLAGS
      "${CMAKE_CXX_FLAGS} \
        -Wno-c++20-designator \
        -Wno-c99-extensions \
        -Wno-gnu-zero-variadic-macro-arguments \
    ")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

# Add header and sources here
set(SRC_FILES
   ${PROJECT_SOURCE_DIR}/main.cpp)

find_package (PkgConfig REQUIRED)
pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemdsystemunitdir)

set(SERVICE_FILES
    ${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.service)

find_package(Boost 1.71 REQUIRED)

add_executable(${PROJECT_NAME} ${SRC_FILES} )
target_include_directories(${PROJECT_NAME} PUBLIC
                           "${PROJECT_BINARY_DIR}"

                           )
target_link_libraries(
  ${PROJECT_NAME}
  sdbusplus
  systemd
  pthread
  phosphor_dbus
  udev
  boost_coroutine
  )
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
install(FILES ${SERVICE_FILES} DESTINATION "${SYSTEMD_SYSTEM_UNIT_DIR}")


