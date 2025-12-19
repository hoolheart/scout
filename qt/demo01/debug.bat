@echo off
echo Building Qt Demo 01 in Debug mode...
echo.

REM Create build directory if it doesn't exist
if not exist build mkdir build
cd build

REM Configure with CMake for Debug
echo Configuring with CMake for Debug...
cmake .. -G "Visual Studio 17 2022" -A x64

REM Build the project in Debug mode
echo.
echo Building the project in Debug mode...
cmake --build . --config Debug

echo.
echo Debug build completed!
echo Executable location: %CD%\Debug\QtDemo01.exe
echo.
echo To debug with Visual Studio:
echo 1. Open %CD%\QtDemo01.sln in Visual Studio
echo 2. Set QtDemo01 as startup project
echo 3. Press F5 to start debugging
cd ..
