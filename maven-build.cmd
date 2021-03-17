@echo off

call mvnw -Dexclude.devtools=false clean package
call x-maven-build.cmd %1
