@echo off

if /I "%1"=="" java -jar target\spring-boot-hot-reload-0.0.1-SNAPSHOT.jar && pause
