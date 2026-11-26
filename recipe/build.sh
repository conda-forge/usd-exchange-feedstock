#!/usr/bin/env bash
set -euxo pipefail

cmake -S "${SRC_DIR}" -B build -G Ninja \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSDEX_BUILD_PYTHON_BINDINGS=ON \
    -DUSDEX_BUILD_TESTS=ON \
    -DUSDEX_PYTHON_VERSION="${PY_VER}" \
    -DPython3_EXECUTABLE="${PYTHON}" \
    -DUSDEX_INSTALL_PYTHONDIR="${SP_DIR}"
cmake --build build -j"${CPU_COUNT}"
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" != "1" || -n "${CROSSCOMPILING_EMULATOR:-}" ]]; then
    ctest --test-dir build --output-on-failure --no-tests=error
fi
cmake --install build
