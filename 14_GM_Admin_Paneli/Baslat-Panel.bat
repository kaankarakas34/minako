@echo off
title Knight Online GM Admin Paneli
cd /d "%~dp0"
echo ========================================================
echo  Knight Online Local GM Admin Paneli Baslatiliyor...
echo  Tarayici Adresi: http://localhost:8080
echo ========================================================
start http://localhost:8080
python backend.py
pause
