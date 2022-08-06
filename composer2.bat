@echo off
set "PATH=%~dp0;%PATH%"
set "composerFile=%~dp02.2.X-LTS\composer.phar"
set "PHPBin=D:\Workroot\phpStudy\php74n\php.exe"
"%PHPBin%" "%composerFile%" %* 