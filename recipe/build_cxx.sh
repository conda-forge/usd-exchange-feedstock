#!/usr/bin/env bash
set -euxo pipefail

cp "${RECIPE_DIR}/cxx/CMakeLists.txt" "${SRC_DIR}/CMakeLists.txt"
cp -r "${RECIPE_DIR}/cxx/cmake" "${SRC_DIR}/cmake"

cmake -S "${SRC_DIR}" -B build -G Ninja \
  ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DUSDEX_VERSION="${PKG_VERSION}" \
  -DUSDEX_BUILD_STRING="${PKG_VERSION}" \
  -DBUILD_TESTING=OFF

# The upstream C++ doctest tests do not compile against OpenUSD >=26.03: the new
# VtValueRef implicit constructor hijacks operator<< when doctest stringifies a
# USD schema object in CHECK(...), forcing an operator== the schema lacks. The
# library itself builds fine; coverage is retained via the Python unittests and
# cmake-package-check in the recipe test section, so BUILD_TESTING is off here.
cmake --build build -j"${CPU_COUNT}"

cmake --install build
