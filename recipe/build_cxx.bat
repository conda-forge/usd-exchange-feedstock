@echo on

copy /Y "%RECIPE_DIR%\cxx\CMakeLists.txt" "%SRC_DIR%\CMakeLists.txt"
if errorlevel 1 exit /b 1

if exist "%SRC_DIR%\cmake" rmdir /S /Q "%SRC_DIR%\cmake"
if errorlevel 1 exit /b 1
xcopy "%RECIPE_DIR%\cxx\cmake" "%SRC_DIR%\cmake\" /E /I /Y
if errorlevel 1 exit /b 1

REM The upstream C++ doctest suite does not compile against OpenUSD >=26 (26.x's
REM new VtValueRef hijacks operator<< during doctest stringification of USD
REM schema objects). Gate the tests on PXR_VERSION from its header: OpenUSD keeps
REM PXR_MAJOR_VERSION at 0 and encodes the marketing version in PXR_VERSION, so
REM "25.11" is 2511 and "26.03" is 2603. Only build/run the tests for <26 (<2600).
set "PXR_VERSION="
for /f "tokens=3" %%i in ('findstr /c:"#define PXR_VERSION " "%LIBRARY_PREFIX%\include\pxr\pxr.h"') do set "PXR_VERSION=%%i"
echo Detected OpenUSD PXR_VERSION: '%PXR_VERSION%'
set "USDEX_BUILD_TESTING=OFF"
if defined PXR_VERSION if %PXR_VERSION% LSS 2600 set "USDEX_BUILD_TESTING=ON"

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
