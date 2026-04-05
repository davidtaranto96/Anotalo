@echo off
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot
set PATH=%JAVA_HOME%\bin;%PATH%
set ANDROID_HOME=C:\Users\DavidSebastianTarant\AppData\Local\Android\Sdk
set PATH=%ANDROID_HOME%\platform-tools;%PATH%
set TEMP=C:\tmp
set TMP=C:\tmp
cd /d "C:\Users\DavidSebastianTarant\Claude\arquitectura-enfoque-flutter"
echo === Dispositivos ADB conectados ===
adb devices
echo.
echo === Instalando APK ===
adb install -r "build\app\outputs\apk\debug\app-debug.apk"
echo.
echo Listo! Busca "arquitectura_enfoque" en el telefono.
pause
