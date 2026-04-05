@echo off
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot
set PATH=%JAVA_HOME%\bin;%PATH%
set ANDROID_HOME=C:\Users\DavidSebastianTarant\AppData\Local\Android\Sdk
set JAVA_TOOL_OPTIONS=-Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.WindowsSelectorProvider
set GRADLE_OPTS=-Xmx4G -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.WindowsSelectorProvider
cd /d "C:\Users\DavidSebastianTarant\Claude\arquitectura-enfoque-flutter\android"
echo JAVA_HOME: %JAVA_HOME%
java -version
echo.
echo Running gradlew assembleDebug --stacktrace --no-daemon...
call gradlew.bat assembleDebug --stacktrace --no-daemon
