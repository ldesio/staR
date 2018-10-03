@echo off
SET "R_EXPECTED_DIR=C:\Program Files\R\R-3.5.0"
REM *** then replace with R-3.5.0

IF "%R_HOME%" == "" (
	SET "RUNDIR=%R_EXPECTED_DIR%\bin"
) else (
	SET "RUNDIR=%R_HOME%\bin"
)

echo %RUNDIR%

IF NOT EXIST "%RUNDIR%\" (
	echo Cannot find R, as %RUNDIR%\ does not exist. Please edit R_EXPECTED_DIR in staR.bat, line 2, to match your R installation directory.
	pause
	exit /B
) 
	
cd ../app
start /B "installing required R packages" "%RUNDIR%\Rscript.exe" _setup.R







