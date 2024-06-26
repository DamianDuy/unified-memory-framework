# Copyright (C) 2024 Intel Corporation
# Under the Apache License v2.0 with LLVM Exceptions. See LICENSE.TXT.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

if(UMF_BUILD_LIBUMF_POOL_SCALABLE)
    set(EXAMPLE_NAME umf_example_basic)

    add_umf_executable(
        NAME ${EXAMPLE_NAME}
        SRCS basic/basic.c
        LIBS umf scalable_pool)

    target_include_directories(
        ${EXAMPLE_NAME} PRIVATE ${UMF_CMAKE_SOURCE_DIR}/src/utils
                                ${UMF_CMAKE_SOURCE_DIR}/include)

    target_link_directories(${EXAMPLE_NAME} PRIVATE ${LIBHWLOC_LIBRARY_DIRS})

    add_test(
        NAME ${EXAMPLE_NAME}
        COMMAND ${EXAMPLE_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

    set_tests_properties(${EXAMPLE_NAME} PROPERTIES LABELS "example")

    if(WINDOWS)
        # append PATH to DLLs
        set_property(TEST ${EXAMPLE_NAME} PROPERTY ENVIRONMENT_MODIFICATION
                                                   "${DLL_PATH_LIST}")
    endif()
else()
    message(
        STATUS
            "Basic example requires UMF_BUILD_LIBUMF_POOL_SCALABLE to be turned ON - skipping"
    )
endif()

if(UMF_BUILD_GPU_EXAMPLES
   AND UMF_BUILD_LIBUMF_POOL_DISJOINT
   AND UMF_BUILD_LEVEL_ZERO_PROVIDER
   AND LINUX)
    set(EXAMPLE_NAME umf_example_gpu_shared_memory)

    add_umf_executable(
        NAME ${EXAMPLE_NAME}
        SRCS basic/gpu_shared_memory.c
        LIBS umf disjoint_pool ze_loader)

    target_include_directories(
        ${EXAMPLE_NAME}
        PRIVATE ${LEVEL_ZERO_INCLUDE_DIRS} ${UMF_CMAKE_SOURCE_DIR}/src/utils
                ${UMF_CMAKE_SOURCE_DIR}/include)

    target_link_directories(${EXAMPLE_NAME} PRIVATE ${LIBHWLOC_LIBRARY_DIRS})

    add_test(
        NAME ${EXAMPLE_NAME}
        COMMAND ${EXAMPLE_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

    set_tests_properties(${EXAMPLE_NAME} PROPERTIES LABELS "example")

    if(WINDOWS)
        # append PATH to DLLs
        set_property(TEST ${EXAMPLE_NAME} PROPERTY ENVIRONMENT_MODIFICATION
                                                   "${DLL_PATH_LIST}")
    endif()
else()
    message(
        STATUS
            "GPU shared memory example requires UMF_BUILD_GPU_EXAMPLES, "
            "UMF_BUILD_LEVEL_ZERO_PROVIDER and UMF_BUILD_LIBUMF_POOL_DISJOINT "
            "to be turned ON - skipping")
endif()

if(UMF_BUILD_GPU_EXAMPLES
   AND UMF_BUILD_LIBUMF_POOL_DISJOINT
   AND UMF_BUILD_LEVEL_ZERO_PROVIDER)
    set(EXAMPLE_NAME umf_example_ipc_level_zero)

    add_umf_executable(
        NAME ${EXAMPLE_NAME}
        SRCS basic/ipc_level_zero.c
        LIBS umf disjoint_pool ze_loader)

    target_include_directories(
        ${EXAMPLE_NAME}
        PRIVATE ${LEVEL_ZERO_INCLUDE_DIRS} ${UMF_CMAKE_SOURCE_DIR}/src/utils
                ${UMF_CMAKE_SOURCE_DIR}/include)

    target_link_directories(${EXAMPLE_NAME} PRIVATE ${LIBHWLOC_LIBRARY_DIRS})

    add_test(
        NAME ${EXAMPLE_NAME}
        COMMAND ${EXAMPLE_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

    set_tests_properties(${EXAMPLE_NAME} PROPERTIES LABELS "example")

    if(WINDOWS)
        # append PATH to DLLs
        set_property(TEST ${EXAMPLE_NAME} PROPERTY ENVIRONMENT_MODIFICATION
                                                   "${DLL_PATH_LIST}")
    endif()
else()
    message(
        STATUS
            "IPC Level 0 example requires UMF_BUILD_GPU_EXAMPLES, UMF_BUILD_LEVEL_ZERO_PROVIDER and UMF_BUILD_LIBUMF_POOL_DISJOINT to be turned ON - skipping"
    )
endif()

if(LINUX AND UMF_BUILD_LIBUMF_POOL_SCALABLE)
    set(BASE_NAME ipc_shm_ipcapi)
    set(EXAMPLE_NAME umf_example_${BASE_NAME})

    foreach(loop_var IN ITEMS "producer" "consumer")
        set(EX_NAME ${EXAMPLE_NAME}_${loop_var})
        add_umf_executable(
            NAME ${EX_NAME}
            SRCS basic/${BASE_NAME}_${loop_var}.c
            LIBS umf scalable_pool)

        target_include_directories(
            ${EX_NAME} PRIVATE ${UMF_CMAKE_SOURCE_DIR}/src/utils
                               ${UMF_CMAKE_SOURCE_DIR}/include)

        target_link_directories(${EX_NAME} PRIVATE ${LIBHWLOC_LIBRARY_DIRS})
    endforeach(loop_var)

    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/basic/${BASE_NAME}.sh
         DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

    add_test(
        NAME ${EXAMPLE_NAME}
        COMMAND ${BASE_NAME}.sh
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

    set_tests_properties(${EXAMPLE_NAME} PROPERTIES LABELS "example")
else()
    message(
        STATUS
            "IPC shared memory example with UMF pool API is supported on Linux only - skipping"
    )
endif()
