@ECHO OFF
@For /f "tokens=*" %%a in ('date /t') do (set date=%%a)
@For /f "tokens=*" %%a in ('time /t') do (set time=%%a)

ECHO Start to generate Change Log ...
ECHO.
ECHO Step1. Check all necessary files or directories whether is existing ...

SET WorkingTree=%*
SET ReleaseDir=%WorkingTree%Release
SET AuxiliaryDir=%WorkingTree%Auxiliary
SET GitExe=%ProgramW6432%\Git\mingw64\bin\git.exe
SET FcivExe=%AuxiliaryDir%\fciv.exe
SET ChangeLog="%ReleaseDir%\ChangeLog.txt"
ECHO Working Tree:     %WorkingTree%
IF NOT EXIST "%WorkingTree%" (
	ECHO Error! The specified working tree doesn't exist  - '%WorkingTree%'
	EXIT /B 1
)

ECHO Release Dir:      %ReleaseDir%
IF NOT EXIST "%ReleaseDir%" (
	ECHO Error! The Release Directory doesn't exist  - '%ReleaseDir%'
	EXIT /B 1
)

ECHO Auxiliary Dir:    %AuxiliaryDir%
IF NOT EXIST "%AuxiliaryDir%" (
	ECHO Error! The Auxiliary Directory is doesn't exist  - '%AuxiliaryDir%'
	EXIT /B 1
)

ECHO git.exe:          %GitExe%
IF NOT EXIST "%GitExe%" (
	ECHO Error! Couldn't find the executable - '%GitExe%'
	EXIT /B 1
)

ECHO fciv.exe:         %FcivExe%
IF NOT EXIST "%FcivExe%" (
	ECHO Error! Couldn't find the executable - '%FcivExe%'
	EXIT /B 1
)

ECHO ChangeLog.txt:  %ChangeLog%
IF EXIST %ChangeLog% (
	ECHO Attempt to delete the file - %ChangeLog% ... 
	DEL /F %ChangeLog%
)
ECHO.

ECHO.
ECHO Step2. Check the working tree whether has been changed ...
SET  RESPONSE=
SET  GIT_STATUS_CMD="%GitExe%" status --porcelain
ECHO To do the command - '%GIT_STATUS_CMD%' ...
FOR /F "tokens=*" %%i IN ('%GIT_STATUS_CMD%') do set RESPONSE=%%i
ECHO ---- Output: %RESPONSE%
ECHO.

IF NOT "%RESPONSE%" == "" (
    ECHO Warning! The working tree has been changed. Please check the the working tree!
	EXIT /B 1
)

ECHO.
ECHO Step3. Attempt to calculate files checksum into ChangeLog.txt
ECHO ---- Build Timestamp: %date% %time% >> %ChangeLog%
ECHO ---- Executables Checksum ---- >> %ChangeLog%
SET FCIV_CMD="%FcivExe%" -sha1 -add "%ReleaseDir%" -bp "%ReleaseDir%" -type *.exe -type *.dll
ECHO To do the command - '%FCIV_CMD%' ...
%FCIV_CMD% >> %ChangeLog%
IF EXIST "%WorkingTree%\fciv.err" (
	DEL /F "%WorkingTree%\fciv.err"
)
ECHO ---- End of Executables Checksum ---- >> %ChangeLog%
ECHO. >> %ChangeLog%
ECHO. >> %ChangeLog%
ECHO.

ECHO.
ECHO Step4. Attempt to dump recently commits into ChangeLog.txt
ECHO ---- Change List ---- >> %ChangeLog%
SET  GIT_LOG_CMD="%GitExe%" log -n20 --decorate --
ECHO To do the command - '%GIT_LOG_CMD%' ...
%GIT_LOG_CMD% >> %ChangeLog%
ECHO ---- End of Change List ---- >> %ChangeLog%
ECHO. >> %ChangeLog%
ECHO. >> %ChangeLog%
ECHO.
::TYPE %ChangeLog%