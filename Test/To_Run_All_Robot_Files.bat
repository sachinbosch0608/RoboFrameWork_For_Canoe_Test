@echo off
for %%f in (./path/to/directory/*.robot) do (
    set SUITE_NAME=%%~nf
    robot --output ./output/%SUITE_NAME%-output.xml --report ./output/%SUITE_NAME%-report.html --log ./output/%SUITE_NAME%-log.html %%f
)
