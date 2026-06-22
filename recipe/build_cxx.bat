@echo on

copy /Y "%RECIPE_DIR%\cxx\CMakeLists.txt" "%SRC_DIR%\CMakeLists.txt"
if errorlevel 1 exit /b 1

if exist "%SRC_DIR%\cmake" rmdir /S /Q "%SRC_DIR%\cmake"
if errorlevel 1 exit /b 1
xcopy "%RECIPE_DIR%\cxx\cmake" "%SRC_DIR%\cmake\" /E /I /Y
if errorlevel 1 exit /b 1

REM The upstream C++ doctest suite does not compile against OpenUSD >=26 (26.x's
REM new VtValueRef hijacks operator<< during doctest stringification of USD
REM schema objects). Detect the OpenUSD major version from its header and only
REM build/run the tests for OpenUSD <26.
set "PXR_MAJOR="
for /f "tokens=3" %%i in ('findstr /c:"#define PXR_MAJOR_VERSION " "%LIBRARY_PREFIX%\include\pxr\pxr.h"') do set "PXR_MAJOR=%%i"
echo Detected OpenUSD major version: '%PXR_MAJOR%'
set "USDEX_BUILD_TESTING=OFF"
if defined PXR_MAJOR if %PXR_MAJOR% LSS 26 set "USDEX_BUILD_TESTING=ON"

cmake -S "%SRC_DIR%" -B build -G Ninja ^
  %CMAKE_ARGS% ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DUSDEX_VERSION="%PKG_VERSION%" ^
  -DUSDEX_BUILD_STRING="%PKG_VERSION%" ^
  -DBUILD_TESTING=%USDEX_BUILD_TESTING%
if errorlevel 1 exit /b 1

cmake --build build -j%CPU_COUNT%
if errorlevel 1 exit /b 1

if "%USDEX_BUILD_TESTING%"=="ON" (
    if not "%CONDA_BUILD_CROSS_COMPILATION%"=="1" (
        ctest --test-dir build --output-on-failure
        if errorlevel 1 exit /b 1
    )
)

cmake --install build
if errorlevel 1 exit /b 1
