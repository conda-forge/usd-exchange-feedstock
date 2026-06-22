#!/usr/bin/env bash
set -euxo pipefail

cp "${RECIPE_DIR}/cxx/CMakeLists.txt" "${SRC_DIR}/CMakeLists.txt"
cp -r "${RECIPE_DIR}/cxx/cmake" "${SRC_DIR}/cmake"

# The upstream C++ doctest suite does not compile against OpenUSD >=26 (26.x's
# new VtValueRef hijacks operator<< during doctest stringification of USD schema
# objects). Detect the OpenUSD major version from its header and only build/run
# the tests for OpenUSD <26.
PXR_MAJOR=$(sed -n 's/^#define PXR_MAJOR_VERSION \([0-9]*\).*/\1/p' "${PREFIX}/include/pxr/pxr.h")
echo "Detected OpenUSD major version: '${PXR_MAJOR}'"
if [[ -n "${PXR_MAJOR}" && "${PXR_MAJOR}" -lt 26 ]]; then
    BUILD_TESTING=ON
else
    BUILD_TESTING=OFF
fi

cmake -S "${SRC_DIR}" -B build -G Ninja \
  ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DUSDEX_VERSION="${PKG_VERSION}" \
  -DUSDEX_BUILD_STRING="${PKG_VERSION}" \
  -DBUILD_TESTING="${BUILD_TESTING}"

cmake --build build -j"${CPU_COUNT}"

if [[ "${BUILD_TESTING}" == "ON" ]]; then
    if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
        ctest --test-dir build --output-on-failure
    fi
fi

cmake --install build
