@echo off
set "PATH=%~dp0;%PATH%"
set "composerFile=%~dp02.2.X-LTS\composer.phar"
php.exe "%composerFile%" %* 