@echo off

call maven-build-prod.cmd x

call x-docker-build.cmd
