@echo off
setlocal enabledelayedexpansion

if not exist "./Results" mkdir "./Results"

for %%f in (*.robot) do (
    set SUITE_NAME=%%~nf
    robot --output ./Results/!SUITE_NAME!-output.xml --report ./Results/!SUITE_NAME!-report.html --log ./Results/!SUITE_NAME!-log.html %%f
)

endlocal