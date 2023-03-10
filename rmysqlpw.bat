@echo off
title Remove MySQL Root Password
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
 
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Dang lay quyen Admin....
    goto UACPrompt
) else ( goto gotAdmin )
 
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
 
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
 
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
:HomeScreen
cls
echo Cong cu reset password Root MySQL - Code by Nguyen Anh Kiet
echo Khong dung cong cu nay de thuc thi hanh vi TRAI PHAP LUAT
echo Ten dich vu MySQL cua ban la doan ki tu sau tu SERVICE_NAME
sc queryex type=service state=all | find /i "MySQL" | find /i "SERVICE_NAME"
set /p sname="Nhap lai chinh xac ten dich vu MySQL vao day: "
set /p npass="Nhap password moi cua User root: "
del C:\Users\%username%\Desktop\mysql-init.txt
echo ALTER USER 'root'@'localhost' IDENTIFIED BY '%npass%'; > "C:\Users\%username%\Desktop\mysql-init.txt"
echo Dang dung dich vu MySQL
net stop %sname%
echo Dang Reset Pass. Neu doi qua lau (Tren 10 giay) thi bam Ctrl + C sau do bam N roi Enter
C:
cd "C:\Program Files\MySQL\MySQL Server 8.0\bin"
mysqld.exe --defaults-file="C:\ProgramData\MySQL\MySQL Server 8.0\my.ini" --init-file="C:\Users\%username%\Desktop\mysql-init.txt"
echo Dang khoi chay lai dich vu MySQL.
net start %sname%
pause