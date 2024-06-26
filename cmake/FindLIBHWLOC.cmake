# Copyright (C) 2024 Intel Corporation
# Under the Apache License v2.0 with LLVM Exceptions. See LICENSE.TXT.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

message(STATUS "Checking for module 'libhwloc' using find_library()")

find_library(LIBHWLOC_LIBRARY NAMES libhwloc hwloc)
set(LIBHWLOC_LIBRARIES ${LIBHWLOC_LIBRARY})

get_filename_component(LIBHWLOC_LIB_DIR ${LIBHWLOC_LIBRARIES} DIRECTORY)
set(LIBHWLOC_LIBRARY_DIRS ${LIBHWLOC_LIB_DIR})

find_file(LIBHWLOC_HEADER NAMES hwloc.h)
get_filename_component(LIBHWLOC_INCLUDE_DIR ${LIBHWLOC_HEADER} DIRECTORY)
set(LIBHWLOC_INCLUDE_DIRS ${LIBHWLOC_INCLUDE_DIR})

if(LIBHWLOC_INCLUDE_DIR)
    if(EXISTS "${LIBHWLOC_INCLUDE_DIR}/hwloc/autogen/config.h")
        file(
            STRINGS "${LIBHWLOC_INCLUDE_DIR}/hwloc/autogen/config.h"
            LIBHWLOC_VERSION
            REGEX
                "#define[ \t]HWLOC_VERSION[ \t]\"([0-9]+.[0-9]+.[0-9]+(rc[0-9])?)(-git)?\""
        )
        string(
            REGEX
            REPLACE
                "#define[ \t]HWLOC_VERSION[ \t]\"([0-9]+.[0-9]+.[0-9]+(rc[0-9])?)(-git)?\""
                "\\1"
                LIBHWLOC_VERSION
                "${LIBHWLOC_VERSION}")
    else()
        message(
            WARNING
                "LIBHWLOC_INCLUDE_DIR found, but header with version info is missing"
        )
    endif()
endif()

if(WINDOWS)
    find_file(LIBHWLOC_DLL NAMES "bin/hwloc-15.dll" "bin/libhwloc-15.dll")
    get_filename_component(LIBHWLOC_DLL_DIR ${LIBHWLOC_DLL} DIRECTORY)
    set(LIBHWLOC_DLL_DIRS ${LIBHWLOC_DLL_DIR})
endif()

if(LIBHWLOC_LIBRARY)
    message(STATUS "  Found libhwloc using find_library()")
    message(STATUS "    LIBHWLOC_LIBRARIES = ${LIBHWLOC_LIBRARIES}")
    message(STATUS "    LIBHWLOC_INCLUDE_DIRS = ${LIBHWLOC_INCLUDE_DIRS}")
    message(STATUS "    LIBHWLOC_LIBRARY_DIRS = ${LIBHWLOC_LIBRARY_DIRS}")
    message(STATUS "    LIBHWLOC_VERSION = ${LIBHWLOC_VERSION}")
    if(WINDOWS)
        message(STATUS "    LIBHWLOC_DLL_DIRS = ${LIBHWLOC_DLL_DIRS}")
    endif()

    if(LIBHWLOC_FIND_VERSION)
        if(NOT LIBHWLOC_VERSION)
            message(FATAL_ERROR "Failed to retrieve libhwloc version")
        elseif(NOT LIBHWLOC_VERSION VERSION_GREATER_EQUAL LIBHWLOC_FIND_VERSION)
            message(
                FATAL_ERROR
                    "    Required version: ${LIBHWLOC_FIND_VERSION}, found ${LIBHWLOC_VERSION}"
            )
        endif()
    endif()
else()
    set(MSG_NOT_FOUND
        "libhwloc NOT found (set CMAKE_PREFIX_PATH to point the location)")
    if(LIBHWLOC_FIND_REQUIRED)
        message(FATAL_ERROR ${MSG_NOT_FOUND})
    else()
        message(WARNING ${MSG_NOT_FOUND})
    endif()
endif()
