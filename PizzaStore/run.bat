@echo off
echo ================================================
echo PizzaStore - Java Web Application Build Script
echo ================================================

echo.
echo Cleaning previous builds...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist

echo.
echo Creating build directories...
mkdir build\classes
mkdir dist

echo.
echo Compiling Java source files...
javac -cp "WebContent\WEB-INF\lib\*;%CATALINA_HOME%\lib\servlet-api.jar;%CATALINA_HOME%\lib\jsp-api.jar" -d build\classes src\controller\*.java src\model\*.java src\dao\*.java src\utils\*.java

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Compilation failed!
    echo Please check:
    echo 1. CATALINA_HOME environment variable is set
    echo 2. SQL Server JDBC driver is in WebContent\WEB-INF\lib\
    echo 3. Java source files have no syntax errors
    pause
    exit /b 1
)

echo.
echo Creating WAR file...
cd WebContent
jar -cvf ..\dist\PizzaStore.war *
cd ..
jar -uf dist\PizzaStore.war -C build\classes .

echo.
echo Build completed successfully!
echo.
echo WAR file created: dist\PizzaStore.war
echo.
echo To deploy:
echo 1. Copy dist\PizzaStore.war to %CATALINA_HOME%\webapps\
echo 2. Start Tomcat server
echo 3. Access http://localhost:8080/PizzaStore
echo.
echo Note: Make sure to run database.sql script first!
echo.
pause