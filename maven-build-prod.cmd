@echo off

call mvnw clean package
call x-maven-build.cmd %1
