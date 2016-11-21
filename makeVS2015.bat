@echo off
@cls

SET generator="Visual Studio 14 2015"
SET curdir=%~dp0

IF EXIST %curdir%\build\NUL GOTO GETINBUILDDIR
mkdir %curdir%\build

:GETINBUILDDIR
cd %curdir%\build

:CALLCMAKE
cmake -G %generator% -DCMAKE_GENERATOR_PLATFORM=x64 ..
IF %ERRORLEVEL% NEQ 0 GOTO CMAKEERROR

:STARTVS
start sdlSnake.sln
GOTO END

:CMAKEERROR
echo "There was an error running CMake"
pause

:END
cd %curdir%
