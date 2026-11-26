# Dependencies imported during CMake discovery can leave unowned Python caches.
# Do not package those caches as SDK files. Rattler-build compiles the output's
# own .py files after selection, so SDK Python bytecode is still provided.
file(TO_CMAKE_PATH "$ENV{SP_DIR}" site_packages)
if(NOT IS_DIRECTORY "${site_packages}")
    message(FATAL_ERROR "SP_DIR must point at the build's site-packages directory")
endif()
file(GLOB_RECURSE bytecode LIST_DIRECTORIES FALSE
    "${site_packages}/*.pyc" "${site_packages}/*.pyo")
if(bytecode)
    file(REMOVE ${bytecode})
endif()
