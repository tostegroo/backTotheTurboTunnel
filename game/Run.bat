@echo off
set PAUSE_ERRORS=1
call bat\SetupSDK.bat
call bat\SetupApplication.bat

:target
goto desktop
::goto android-debug
::goto android-test
::goto ios-debug
::goto ios-test


:desktop
:: http://help.adobe.com/en_US/air/build/WSfffb011ac560372f-6fa6d7e0128cca93d31-8000.html

::set SCREEN_SIZE=NexusOne
::set SCREEN_SIZE=iPhone
::set SCREEN_SIZE=1080x1920:1080x1920
::set SCREEN_SIZE=1242x2168:1242x2208
set SCREEN_SIZE=720x1280:720x1280

adl -screensize %SCREEN_SIZE% "%APP_XML%" "%APP_DIR%" -extdir lib/

::adl "%APP_XML_D%" "%APP_DIR%" -extdir lib/

if errorlevel 1 goto error
goto end

echo.
echo Package for target

echo  [1] 480                 720 x 480              720 x 480                
echo  [2] 720                1280 x 720             1280 x 720               
echo  [3] 1080               1920 x 1080            1920 x 1080              
echo  [4] Droid               480 x 816              480 x 854                
echo  [5] FWQVGA              240 x 432              240 x 432                
echo  [6] FWVGA               480 x 854              480 x 854                
echo  [7] HVGA                320 x 480              320 x 480                
echo  [8] iPad                768 x 1004             768 x 1024
echo  [9] iPadRetina         1536 x 2008            1536 x 2048
echo  [10] iPhone             320 x 460              320 x 480                
echo  [11] iPhoneRetina       640 x 920              640 x 960                 
echo  [12] iPod               320 x 460              320 x 480                
echo  [13] NexusOne           480 x 762              480 x 800                
echo  [14] QVGA               240 x 320              240 x 320                
echo  [15] SamsungGalaxyS     480 x 762              480 x 800                
echo  [16] SamsungGalaxyTab   600 x 986              600 x 1024               
echo  [17] WQVGA              240 x 400              240 x 400                
echo  [18] WVGA               480 x 800              480 x 800
echo  [19] ?????              480 x 640              480 x 640
echo  [20] iPhone5       	  640 x 1096             640 x 1136
echo  [21] iPhone6       	  750 x 1294             750 x 1334
echo  [22] iPhone6 plus      1242 x 2168            1242 x 2208
echo.

:desktop-run
::-extdir lib/

set /P C=[Choice]: 
echo.
if "%c%"=="1" set SCREEN_SIZE=480x720:480x720 
if "%c%"=="2" set SCREEN_SIZE=720x1280:720x1280
if "%c%"=="3" set SCREEN_SIZE=1080x1920:1080x1920
if "%c%"=="4" set SCREEN_SIZE=Droid
if "%c%"=="5" set SCREEN_SIZE=FWQVGA
if "%c%"=="6" set SCREEN_SIZE=FWVGA
if "%c%"=="7" set SCREEN_SIZE=HVGA
if "%c%"=="8" set SCREEN_SIZE=iPad
if "%c%"=="9" set SCREEN_SIZE=iPadRetina
if "%c%"=="10" set SCREEN_SIZE=iPhone
if "%c%"=="11" set SCREEN_SIZE=iPhoneRetina
if "%c%"=="12" set SCREEN_SIZE=iPod
if "%c%"=="13" set SCREEN_SIZE=NexusOne
if "%c%"=="14" set SCREEN_SIZE=QVGA
if "%c%"=="15" set SCREEN_SIZE=SamsungGalaxyS
if "%c%"=="16" set SCREEN_SIZE=SamsungGalaxyTab
if "%c%"=="17" set SCREEN_SIZE=WQVGA
if "%c%"=="18" set SCREEN_SIZE=WVGA
if "%c%"=="19" set SCREEN_SIZE=480x640:480x640
if "%c%"=="20" set SCREEN_SIZE=640x1096:640x1136
if "%c%"=="21" set SCREEN_SIZE=750x1294:750x1334
if "%c%"=="22" set SCREEN_SIZE=1242x2168:1242x2208
echo.
echo Starting AIR Debug Launcher with screen size '%SCREEN_SIZE%'
echo.
echo (hint: edit 'Run.bat' to test on device or change screen size)
echo.
adl -screensize %SCREEN_SIZE% "%APP_XML%" "%APP_DIR%" -extdir lib/
if errorlevel 1 goto error
goto end


:ios-debug
echo.
echo Packaging application for debugging on iOS
echo.
set TARGET=-debug-interpreter
set OPTIONS=-connect %DEBUG_IP%
goto ios-package

:ios-test
echo.
echo Packaging application for testing on iOS
echo.
set TARGET=-test-interpreter
set OPTIONS=
goto ios-package

:ios-package
set PLATFORM=ios
call bat\Packager.bat

echo Now manually install and start application on device
echo.
goto error


:android-debug
echo.
echo Packaging and installing application for debugging on Android (%DEBUG_IP%)
echo.
set TARGET=-debug
set OPTIONS=-connect %DEBUG_IP%
goto android-package

:android-test
echo.
echo Packaging and Installing application for testing on Android (%DEBUG_IP%)
echo.
set TARGET=
set OPTIONS=
goto android-package

:android-package
set PLATFORM=android
call bat\Packager.bat

adb devices
echo.
echo Installing %OUTPUT% on the device...
echo.
adb -d install -r "%OUTPUT%"
if errorlevel 1 goto installfail

echo.
echo Starting application on the device for debugging...
echo.
adb shell am start -n air.%APP_ID%/.AppEntry
exit

:installfail
echo.
echo Installing the app on the device failed

:error
pause