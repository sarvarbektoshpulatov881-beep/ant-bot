@echo off
rem ANT tashrif boti - avtomatik ishga tushirish
rem Oyna kichraytirilgan holda ochiladi
if not "%~1"=="min" start "ANT tashrif boti" /min "%~f0" min & exit /b

title ANT tashrif boti - YOPMANG
cd /d C:\ant_bot\ant_bot

:loop
echo.
echo [%date% %time%] Bot ishga tushmoqda...
python bot.py
echo [%date% %time%] Bot to'xtadi. 10 soniyadan keyin qayta ishga tushadi...
timeout /t 10 /nobreak >nul
goto loop
