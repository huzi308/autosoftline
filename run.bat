
@echo off

cd %~dp0

call ant clean

call ant app

cd output

call mvn spring-boot:run
