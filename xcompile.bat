@echo off

if exist ..\bin rd /s /q ..\bin
mkdir ..\bin\win64
mkdir ..\bin\linux64
mkdir ..\bin\darwin64

SET GOOS=windows
SET GOARCH=amd64
go build -o ..\bin\win64\gost.exe main.go
echo "Built application for Windows/amd64"
copy ..\config.yaml ..\bin\win64\config.yaml

SET GOOS=linux
SET GOARCH=amd64
go build -o ..\bin\linux64\gost main.go
echo "Built application for Linux/amd64"
copy ..\config.yaml ..\bin\linux64\config.yaml

SET GOOS=darwin
SET GOARCH=amd64
go build -o ..\bin\darwin64\gost main.go
echo "Built application for Darwin/amd64"
copy ..\config.yaml ..\bin\darwin64\config.yaml
pause
