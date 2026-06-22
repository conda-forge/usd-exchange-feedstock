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
  -DBUILD_TESTING=OFF
if errorlevel 1 exit /b 1

REM The upstream C++ doctest tests do not compile against OpenUSD >=26.03: the
REM new VtValueRef implicit constructor hijacks operator<< when doctest
REM stringifies a USD schema object in CHECK(...), forcing an operator== the
REM schema lacks. The library itself builds fine; coverage is retained via the
REM Python unittests and cmake-package-check, so BUILD_TESTING is off here.
cmake --build build -j%CPU_COUNT%
if errorlevel 1 exit /b 1

cmake --install build
if errorlevel 1 exit /b 1
