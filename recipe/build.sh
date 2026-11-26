#!/usr/bin/env bash
set -euxo pipefail

if [[ "${target_platform}" == linux-* ]]; then
    # Keep GCC 15's Boost.Python extraction diagnostic visible despite -Werror.
    export CXXFLAGS="${CXXFLAGS} -Wno-error=maybe-uninitialized"
fi

cmake -S "${SRC_DIR}" -B build -G Ninja \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSDEX_BUILD_PYTHON_BINDINGS=ON \
    -DUSDEX_BUILD_TESTS=OFF \
    -DUSDEX_PYTHON_VERSION="${PY_VER}" \
    -DPython3_EXECUTABLE="${PYTHON}" \
    -DUSDEX_INSTALL_PYTHONDIR="${SP_DIR}"
cmake --build build -j"${CPU_COUNT}"
cmake --install build
