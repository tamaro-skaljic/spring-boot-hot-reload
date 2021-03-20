@echo off

set "name=spring-boot-hot-reload"

:: START SECTION
:start
if /I "%1%2"==""             goto jarDev

if /I "%1%2"=="dev"          goto jarDev
if /I "%1%2"=="prod"         goto jarProd

if /I "%1%2"=="jar"          goto jarDev
if /I "%1%2"=="docker"       goto dockerDev

if /I "%1 %2"=="jar dev"     goto jarDev
if /I "%1 %2"=="docker dev"  goto dockerDev

if /I "%1 %2"=="jar prod"    goto jarProd
if /I "%1 %2"=="docker prod" goto dockerProd

if /I "%1 %2"=="--help "     goto usage
goto notACommand


:: SCRIPT CONFIGURATION SECTION
:jarDev
set "env=JAR"
set "mode=DEV"
goto build

:jarProd
set "env=JAR"
set "mode=PROD"
goto build

:dockerDev
set "env=DOCKER"
set "mode=DEV"
goto build

:dockerProd
set "env=DOCKER"
set "mode=PROD"
goto build


:: BUILD SECTION
:build
echo Mode: %env% %mode%

if /I "%mode%"=="DEV"  call mvnw -Dexclude.devtools=false clean package
if /I "%mode%"=="PROD" call mvnw clean package

if /I "%env%"=="JAR" goto startJar
goto buildDocker

:buildDocker
if not exist "target\dependency" mkdir "target\dependency"
cd "target\dependency"
if not exist ..\..\target\%name%-0.0.1-SNAPSHOT.jar exit
jar -xf ..\..\target\%name%-0.0.1-SNAPSHOT.jar
cd ..\..
docker build -t %name% .
goto startDocker


:: START SECTION
:startJar
if /I "%mode%"=="DEV"  java -Dspring.profiles.active=dev -jar target\%name%-0.0.1-SNAPSHOT.jar
if /I "%mode%"=="PROD" java -jar target\%name%-0.0.1-SNAPSHOT.jar
pause
goto end

:startDocker
FOR /F "tokens=* USEBACKQ" %%F IN (`docker ps --filter "name=%name%" --format "{{.Names}}"`) DO (if "%%F"=="%name%" docker stop -t 10 %name% > nul)
if /I "%mode%"=="DEV"  docker run --publish=8080:8080 --rm=true --name=%name% -e "SPRING_PROFILES_ACTIVE=dev" %name%
if /I "%mode%"=="PROD" docker run --publish=8080:8080 --rm=true --name=%name% %name%
FOR /F "tokens=* USEBACKQ" %%F IN (`docker ps --filter "name=%name%" --format "{{.Names}}"`) DO (if "%%F"=="%name%" docker stop -t 10 %name% > nul)
goto end


:: USAGE SECTION
:usage
echo.
echo Usage: %0 [{jar}^|docker^] [{dev}^|prod]
echo.
echo Build the application as jar or docker container and run it in development or production mode.
goto end


:: NOT A COMMAND SECTION
:notACommand
setlocal enabledelayedexpansion
set "notACommand=%0: '"
for %%x in (%*) do (
    set /A i +=1
    if "!i!"=="1"     SET "notACommand=!notACommand!%%~x"
    if not "!i!"=="1" SET "notACommand=!notACommand! %%~x"
)
set "notACommand=%notACommand%' is not a %0 command."
echo %notACommand%
echo See '%0 --help'
endlocal
goto end


:: END SECTION
:end
