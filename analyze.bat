@echo off
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot
set PATH=%JAVA_HOME%\bin;%PATH%
set TEMP=C:\tmp
set TMP=C:\tmp
cd /d "C:\Users\DavidSebastianTarant\Claude\arquitectura-enfoque-flutter"
echo === flutter analyze ===
"C:\flutter\flutter_windows_3.41.6-stable\flutter\bin\flutter.bat" analyze
