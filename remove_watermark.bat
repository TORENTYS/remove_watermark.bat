@echo off
chcp 1251 > nul
title Удаление водяного знака Windows
color 0A


net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Нужны права Администратора!
    echo [!] Запускаю снова с повышенными правами...
    
    :: Пытаемся перезапустить от админа
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    timeout /t 2 >nul
    exit
)


echo [1/3] Запускаем PowerShell с командами...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"& { ^
    Write-Host 'Работаем в PowerShell...' -ForegroundColor Cyan; ^
    ^
    Write-Host '1. Меняем реестр...' -ForegroundColor Yellow; ^
    reg add 'HKCU\Control Panel\Desktop' /v PaintDesktopVersion /t REG_DWORD /d 0 /f; ^
    ^
    Write-Host '2. Перезапускаем Проводник...' -ForegroundColor Yellow; ^
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue; ^
    Start-Sleep -Seconds 2; ^
    Start-Process explorer.exe -WindowStyle Hidden; ^
    ^
    Write-Host '3. Готово!' -ForegroundColor Green; ^
    Write-Host 'Надпись должна исчезнуть.' -ForegroundColor Green; ^
    Write-Host 'Если нет - перезагрузите компьютер.' -ForegroundColor Yellow; ^
}"

echo.
echo [2/3] Проверяем результат...
timeout /t 3 >nul

echo [3/3] Создаем ярлык для быстрого запуска...
echo Нажмите 1 - Создать ярлык на рабочий стол
echo Нажмите 2 - Пропустить
choice /c 12 /n /m "Выберите: "
if %errorLevel% equ 1 (
    powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\Убрать надпись.lnk');$s.TargetPath='%~f0';$s.Save()"
    echo [✓] Ярлык создан на рабочем столе
)

echo.
echo ============================================
echo    ВСЁ ГОТОВО!
echo    Если надпись осталась - ПЕРЕЗАГРУЗИТЕ ПК
echo ============================================
echo.
pause