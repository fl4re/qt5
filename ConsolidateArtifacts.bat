setlocal EnableDelayedExpansion

echo off

set destination=artifacts
set dynamicConfig=dynamic
set platform=x64
set msvcVersion=msvc2015
set lib_path=Qt\%platform%-%msvcVersion%
set shared_lib_path=%lib_path%\qtbase\bin\%platform%-%msvcVersion%

if exist "%destination%" rmdir "%destination%" /s/q

del Qt\x64-msvc2015\qtbase\lib\qtpcre.lib
del Qt\x64-msvc2015\qtbase\lib\qtpcred.lib
del Qt\x64-msvc2015\qtbase\lib\qtharfbuzzng.lib
del Qt\x64-msvc2015\qtbase\lib\qtharfbuzzngd.lib

echo "Packaging library"
xcopy "%shared_lib_path%\include"  "%destination%\include" /y/s/q/i
if !errorlevel! neq 0 exit /b !errorlevel!
xcopy "%shared_lib_path%\lib"  "%destination%\lib" /y/s/q/i
if !errorlevel! neq 0 exit /b !errorlevel!
xcopy "%shared_lib_path%\bin"  "%destination%\bin" /y/s/q/i
if !errorlevel! neq 0 exit /b !errorlevel!
xcopy "%shared_lib_path%\plugins"  "%destination%\plugins" /y/s/q/i
if !errorlevel! neq 0 exit /b !errorlevel!

pushd "%destination%"
rmdir "lib\cmake" /s /q
if !errorlevel! neq 0 exit /b !errorlevel!
del *.prl /s /q /f
if !errorlevel! neq 0 exit /b !errorlevel!

pushd bin
REM delete all applications except for necessary ones.
for %%i in (*.exe) do if not "%%i"=="moc.exe" if not "%%i"=="rcc.exe" if not "%%i"=="uic.exe" del /q /f "%%i" "%%~ni.pdb"

del *.pl
if !errorlevel! neq 0 exit /b !errorlevel!

exit /b 0
