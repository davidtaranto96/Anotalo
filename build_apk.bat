@echo off
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot
set PATH=%JAVA_HOME%\bin;%PATH%
set TEMP=C:\tmp
set TMP=C:\tmp
set JAVA_TOOL_OPTIONS=-Djava.io.tmpdir=C:\tmp -Djdk.net.unixDomain.tempDir=C:\tmp -Djava.net.preferIPv4Stack=true
set GRADLE_OPTS=-Xmx4G -XX:MaxMetaspaceSize=2G -Djava.io.tmpdir=C:\tmp -Djdk.net.unixDomain.tempDir=C:\tmp -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true
cd /d "C:\Users\DavidSebastianTarant\Claude\arquitectura-enfoque-flutter"
echo Java: %JAVA_HOME%
java -version
echo.
echo Running flutter build apk...
"C:\flutter\flutter_windows_3.41.6-stable\flutter\bin\flutter.bat" build apk --debug
