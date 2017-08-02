@echo off
setlocal
rem Name of the log file, i.e. name/directory of the batch script, but with .log extension
set log="%~dpn0.log"

goto start

rem Functions block
:logError
rem Remove miliseconds
set formTime=%time:~0,8%
rem Change hour space padding (OMG) to zero padding
set formTime=%formTime: =0%
set fullErrMsg=Fatal error: %errMsg%
echo %fullErrMsg%
echo [%date% %formTime%] %fullErrMsg% >> %log%
goto end

rem Main part
:start

rem Removing two lines below will make it a bit faster (for me 0.5s), but if Exiftool will be missing. 9009 is command not found.
exiftool -ver > nul 2>&1
if %errorlevel% equ 9009 set errMsg=Exiftool is not installed or it's not within system path && goto logError

if not exist %1 set errMsg=File %1 can't be found && goto logError

rem Output directory
set outDir=%TMP%\exifInfo.%random%

rem Mute mkdir, as there's own error handling
mkdir %outDir% > nul 2>&1
if %errorlevel% neq 0 set errMsg=Can't create temporary directory - %outDir% && goto logError

rem It will copy all exifInfo* files from script directory, so if you need something more, just name your file with "exifInfo" on the beggining
copy "%~dp0exifInfo.*" %outDir% > nul

rem That's the name of the output file
set tmpName=%outDir%\exifInfo.html

rem HTML title tag
set htmlTitle=%~nx1 - metadata

rem HTML itself. Remember about escaping < and > with ^ before it
echo ^<!DOCTYPE html^>^<html lang="en"^>^<head^>^<meta charset="utf-8"^>^<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"^>^<meta name="viewport" content="width=device-width, initial-scale=1"^>^<link id="mainCSS" rel="stylesheet" href="exifInfo.css"^> >> %tmpName%
echo ^<title^>%htmlTitle%^</title^>^</head^>^<body^> >> %tmpName%

rem The only error here I can think of is when you want to generate HTML from non-supported or not existing/borken file
exiftool -m -htmlFormat -g0 %1 >> %tmpName%
if %errorlevel% neq 0 set errMsg=Exiftool processing error - check if you've selected correct file && goto logError
echo ^<script src="exifInfo.jQuery.js"^>^</script^>^<script src="exifInfo.js"^>^</script^>^</body^>^</html^> >> %tmpName%

rem Run file in default browser
start %tmpName%

rem This is the end, beautiful friend
:end
rem This is the end, my only friend, the end
endlocal