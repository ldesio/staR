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
start "staR local server" "%RUNDIR%\Rscript.exe" staR_plumber.R

echo "Waiting 10 seconds for R server to start..."
timeout /t 10 /nobreak
start http://localhost:8000/




