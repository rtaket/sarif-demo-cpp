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
IF NOT EXIST "%LLVMPATH%\bin" (
  COPY /Y "%LLVMTOOLSPATH%\bin\scan-build" "%LLVMPATH%\bin"
)

ECHO Start compile
PUSHD %SRCPATH%
  CALL scan-build gcc -c *.cpp
  REM CALL javac.exe -g -verbose -d %OUTPATH% %SRCPATH%\*.java
POPD

ECHO Start analysis
REM CALL %FINDBUGSPATH%\findbugs.bat -textui -effort:max -low -xml:withMessages -output %OUTPATH%\%PROJECTNAME%.findbugs.xml "%OUTPATH%" 

ECHO Start conversion
REM CALL %CONVERTTOSARIFPATH%\ConvertToSarif.exe -t FindBugs -o bld\%PROJECTNAME%.findbugs.converted.sarif -p -f bld\%PROJECTNAME%.findbugs.xml
