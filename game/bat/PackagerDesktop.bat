@echo off

if "%TARGET%"=="bundle" goto bundle-config
if "%TARGET%"=="air" goto air-config
if "%TARGET%"=="exe" goto exe-config
goto start

:bundle-config
set EXT=
set TARGET=bundle
goto start

:air-config
set EXT=.air
set TARGET=native
goto start

:exe-config
set EXT=.exe
set TARGET=native
goto start


:start
if not exist "%CERT_FILE%" goto certificate
:: Output file
set ICONS=%AND_ICONS%
set FILE_OR_DIR=%FILE_OR_DIR% -C "%ICONS%" .
if not exist %AIR_PATH% md %AIR_PATH%
set OUTPUT=%AIR_PATH%\%AIR_NAME%%EXT%
:: Package
echo Packaging: %OUTPUT%
echo.
echo using certificate: %CERT_FILE%...
echo.
call adt -package -tsa none %SIGNING_OPTIONS% -target %TARGET% %OUTPUT% %APP_XML_D% %FILE_OR_DIR% -extdir ext/
echo.
if errorlevel 1 goto failed
goto end


:certificate
echo.
echo Certificate not found: %CERT_FILE%
echo.
echo Troubleshooting: 
echo - generate a default certificate using 'bat\CreateCertificate.bat'
echo.
if %PAUSE_ERRORS%==1 pause
exit

:failed
echo AIR setup creation FAILED.
echo.
echo Troubleshooting: 
echo - did you build your project in FlashDevelop?
echo - verify AIR SDK target version in %APP_XML_D%
echo.
if %PAUSE_ERRORS%==1 pause
exit

:end
echo.
