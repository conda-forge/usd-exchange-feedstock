@echo on

copy /Y "%RECIPE_DIR%\cxx\CMakeLists.txt" "%SRC_DIR%\CMakeLists.txt"
if errorlevel 1 exit /b 1

if exist "%SRC_DIR%\cmake" rmdir /S /Q "%SRC_DIR%\cmake"
if errorlevel 1 exit /b 1
xcopy "%RECIPE_DIR%\cxx\cmake" "%SRC_DIR%\cmake\" /E /I /Y
if errorlevel 1 exit /b 1

cmake -S "%SRC_DIR%" -B build -G Ninja ^
  %CMAKE_ARGS% ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DUSDEX_VERSION="%PKG_VERSION%" ^
  -DUSDEX_BUILD_STRING="%PKG_VERSION%" ^
  -DBUILD_TESTING=ON
if errorlevel 1 exit /b 1

cmake --build build -j%CPU_COUNT%
if errorlevel 1 exit /b 1

REM The C++ doctest suite is only built against OpenUSD <26 (see cxx/CMakeLists.txt;
REM it does not compile against 26.x). On OpenUSD >=26 no tests are registered, so
REM --no-tests=ignore lets ctest succeed instead of erroring on "no tests found".
if not "%CONDA_BUILD_CROSS_COMPILATION%"=="1" (
    ctest --test-dir build --output-on-failure --no-tests=ignore
    if errorlevel 1 exit /b 1
)

cmake --install build
if errorlevel 1 exit /b 1
