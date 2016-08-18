SET OUTPATH=%~dp0\bld
SET SRCPATH=%~dp0\src
SET LLVMTOOLSPATH=%~dp0\tools\LLVM
SET FINDBUGSPATH=%~dp0\tools\findbugs-3.0.1\bin
SET CONVERTTOSARIFPATH=%~dp0\tools\ConvertToSarif
SET LLVMPATH=C:\Program Files\LLVM

IF '%APPVEYOR_PROJECT_NAME%' EQU '' (
  SET PROJECTNAME=project
) ELSE (
  SET PROJECTNAME=%APPVEYOR_PROJECT_NAME%
)

IF EXIST %OUTPATH% RMDIR /Q /S %OUTPATH%
MKDIR %OUTPATH%

ECHO Fix LLVM
IF NOT EXIST "%LLVMPATH%\bin\scan-build" (
  COPY /Y "%LLVMTOOLSPATH%\bin\*.*" "%LLVMPATH%\bin"
)

ECHO Start compile
PUSHD %SRCPATH%
  CALL scan-build mingw32-make 
POPD

ECHO Start conversion
REM CALL %CONVERTTOSARIFPATH%\ConvertToSarif.exe -t FindBugs -o bld\%PROJECTNAME%.findbugs.converted.sarif -p -f bld\%PROJECTNAME%.findbugs.xml
