@echo off

if not exist "target\dependency" mkdir "target\dependency"
cd "target\dependency"

if not exist ..\..\target\spring-boot-hot-reload-0.0.1-SNAPSHOT.jar exit

jar -xf ..\..\target\spring-boot-hot-reload-0.0.1-SNAPSHOT.jar
cd ..\..
docker build -t spring-boot-hot-reload .
docker stop spring-boot-hot-reload
docker run --publish=8080:8080 --rm=true --name=spring-boot-hot-reload spring-boot-hot-reload
pause
docker stop spring-boot-hot-reload
