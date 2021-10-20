@echo off
setlocal EnableDelayedExpansion

echo [7m Hello. This is the RemoveDocxImages CMD script. It will remove most images from your DOCX files.[0m
echo [7m Please do not hesitate to close this window if you think that something is going wrong.[0m
echo [7m Drag and drop your DOCX file on this file icon to strip it from most images.[0m

if not exist "%1" goto error_file_not_exist
if not exist "%~dp0\imagenone.jpg" goto error_images_not_exist
if not exist "%~dp0\imagenone.png" goto error_images_not_exist
if not exist "%~dp0\imagenone.emf" goto error_images_not_exist

if "%~x1"==".docx" goto filename_okay
if "%~x1"==".DOCX" goto filename_okay
goto error_bad_filename

:filename_okay

set seven_zip_exe=
echo [7m Looking for the 7-Zip executable on drive C, please wait...[0m
for /f "tokens=* usebackq" %%f in (`where /r c:\ 7z.exe`) do (set "seven_zip_exe=%%f" & goto :next)
:next

if "%seven_zip_exe%"=="" goto error_no_sevenzip
echo [7m 7-Zip found at "%seven_zip_exe%"[0m

set random_dir="%tmp%\!RANDOM!"
md %random_dir%
cd %random_dir%

"%seven_zip_exe%" x -r %1
if errorlevel 1 goto sevenzip_error
cd word\media

for %%f in (*.*) do (
 if "%%~xf"==".jpeg" copy /y "%~dp0\imagenone.jpg" %%f
 if "%%~xf"==".jpg" copy /y "%~dp0\imagenone.jpg" %%f
 if "%%~xf"==".JPG" copy /y "%~dp0\imagenone.jpg" %%f
 if "%%~xf"==".png" copy /y "%~dp0\imagenone.png" %%f
 if "%%~xf"==".PNG" copy /y "%~dp0\imagenone.png" %%f
 if "%%~xf"==".emf" copy /y "%~dp0\imagenone.emf" %%f
 if "%%~xf"==".EMF" copy /y "%~dp0\imagenone.emf" %%f
)

cd ..\..

set newname="!RANDOM!"
"%seven_zip_exe%" a %newname%.zip .
if errorlevel 1 goto sevenzip_error
ren "%newname%.zip" "%~nx1_%newname%.docx"

if not exist "%~nx1_%newname%.docx" goto error_file_not_created

move "%~nx1_%newname%.docx" "%~dp1"
if errorlevel 1 goto error_move

echo [7m This script has terminated successfully. You must have a new file in the same folder as the original one.[0m
goto exit

:error_no_sevenzip
echo [91m No 7-zip found on C: drive. Please install 7-Zip.[0m
goto exit

:error_file_not_exist
echo [91m Error: file "%1" does not exist.[0m
goto exit

:error_file_not_created
echo [91m Error: for some reason, the output file was not created. [0m
goto exit

:error_bad_filename
echo [91m Error: the input file does not have a DOCX/docx extension. [0m
goto exit

:error_images_not_exist
echo [91m Please download this script again together with all the necessary images.[0m
goto exit

:sevenzip_error
echo [91m Error while running 7-Zip. The original file could be unsuitable for this processing.[0m
goto exit

:error_move
echo [91m Error while running MOVE. The original file could be unsuitable for this processing.[0m

:exit
pause
