@echo off

call maven-build.cmd x

call x-docker-build.cmd
