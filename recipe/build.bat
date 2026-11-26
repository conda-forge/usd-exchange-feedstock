@echo on
cmake -S "%SRC_DIR%" -B build -G Ninja ^
    %CMAKE_ARGS% ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DUSDEX_BUILD_PYTHON_BINDINGS=ON ^
    -DUSDEX_BUILD_TESTS=OFF ^
    -DUSDEX_PYTHON_VERSION="%PY_VER%" ^
    -DUSDEX_PYTHON_ROOT="%PREFIX%" ^
    -DPython3_EXECUTABLE="%PYTHON%" ^
    -DUSDEX_INSTALL_PYTHONDIR="%SP_DIR%"
if errorlevel 1 exit /b 1
cmake --build build -j%CPU_COUNT%
if errorlevel 1 exit /b 1
cmake --install build
if errorlevel 1 exit /b 1
