@echo off
pushd %~dp0\..\
set mode=%1
call cmake --build build --config %mode% >> scripts/build.log
popd
PAUSE